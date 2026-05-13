CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_SPL_CHAIN_FIN_RPT(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_SPL_CHAIN_FIN_RPT
  *  功能描述：供应链金融业务预付款融资表--手工报表专用
  *  创建日期：20221227
  *  开发人员：CYK
  *  来源表：RRP_MDL.M_MRPT_SPL_CHAIN_DTL 供应链金融业务明细表
             RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO 对公贷款借据信息
             RRP_MDL.M_CUST_CORP_INFO 对公客户信息表
             RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO 解冻保证金申请表
  *  目标表：RRP_MDL.M_MRPT_SPL_CHAIN_FIN_RPT 供应链金融业务预付款融资表
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221227  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_SPL_CHAIN_FIN_RPT'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;
  V_FREQ_FLAG   VARCHAR2(10);    --跑批频度标识

BEGIN

  O_ERRCODE := '0';
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
   --跑批频率
  V_FREQ_FLAG := FUN_FREQ(V_P_DATE, V_PROC_NAME);
  IF V_FREQ_FLAG = '1' THEN

 -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.M_MRPT_SPL_CHAIN_FIN_RPT T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入供应链金融业务预付款融资表--手工报表专用';
  D_STARTTIME := SYSDATE;

  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_SPL_CHAIN_FIN_RPT NOLOGGING
  (
			DATA_DT, 		 	   --数据日期
			CUST_ID,         --客户号
			CUST_NAME,       --客户名称
			CONT_ID,         --合同号
			DUBIL_ID,        --借据号
			ORG_FH,          --所属分行
			ORG_ZH,          --所属支行
			SPL_CHAIN_PROD,  --供应链金融业务产品
			BUS_BREED_NAME,  --业务品种
			CORP_SIZE,       --企业规模
			CORE_ENT,        --所属核心企业
			DUBIL_AMT,       --出账金额
			DISTR_DT,        --业务起始日期
			APOT_EXP_DT,     --业务终止日期
			DUBIL_BAL,       --合同余额
			MARGIN_RATIO,    --初始保证金比例
			EXCHANGEDATE,    --赎货日期
			TRANAM,          --赎货金额
			MARGIN_AMT,      --保证金余额
			ESR_BAL          --敞口余额
  )
  SELECT A.DATA_DT, --数据日期
         A.CUST_ID, --客户号
         A.CUST_NAME, --客户名称
         A.CONT_ID, --合同号
         A.DUBIL_ID, --借据号
         A.ORG_FH, --所属分行
         A.ORG_ZH, --所属支行
         A.SPL_CHAIN_PROD, --供应链金融业务产品
         A.BUS_BREED_NAME, --业务品种
         A.CORP_SIZE, --企业规模
         D.CUST_NM CORE_ENT, --所属核心企业
         A.DUBIL_AMT, --出账金额
         A.DISTR_DT, --业务起始日期
         A.APOT_EXP_DT, --业务终止日期
         A.DUBIL_BAL, --合同余额
         A.MARGIN_RATIO, --初始保证金比例
         TO_CHAR(C.EXCHANGETIME,'YYYYMMDD') EXCHANGEDATE, --赎货日期
         C.TRANAM, --赎货金额
         A.MARGIN_AMT, --保证金余额
         A.DUBIL_BAL - NVL(A.MARGIN_AMT, 0) ESR_BAL --敞口余额
    FROM RRP_MDL.M_MRPT_SPL_CHAIN_DTL A --供应链金融业务明细表
    LEFT JOIN O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON A.DUBIL_ID = B.DUBIL_ID
     AND A.CONT_ID = B.CONT_ID
     AND TO_CHAR(B.ETL_DT,'YYYYMMDD')=V_P_DATE
    LEFT JOIN (SELECT CONTRACTNO, PUTOUTNO, TRANAM, EXCHANGETIME
                 FROM RRP_MDL.O_IOL_ICMS_DEPOSIT_APPLY_INFO --解冻保证金申请表
                WHERE TO_CHAR(EXCHANGETIME,'YYYYMM') = SUBSTR(V_P_DATE, 1, 6)) C
      ON B.CONT_ID = C.CONTRACTNO
     AND B.OUT_ACCT_FLOW_NUM = C.PUTOUTNO
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息表
      ON A.O_USE_LMT_ALL_ID = D.CUST_ID
     AND D.DATA_DT = V_P_DATE
   WHERE A.SPL_CHAIN_PROD IN ('保兑仓', '预付款融资（非保兑仓模式）')
     AND A.DATA_DT = V_P_DATE;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  D_ENDTIME := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  O_ERRCODE  := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --调度依赖存储过程的状态
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  
 END IF;

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    D_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_SPL_CHAIN_FIN_RPT;
/

