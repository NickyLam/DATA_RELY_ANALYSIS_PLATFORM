CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_TRF_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_TRF_INFO
  *  功能描述：业务范围包含直接转让债权、信贷资产证券化、信贷资产收益权转让、通过其他方式转让等，以及对应的信贷资产转入业务，相关业务定义参照1104报表《信贷资产转让情况统计表》。
  *  行内机构间的转让需报送。票据的买卖、买入返售、卖出回购不在本表填报。含已核销贷款，本金按实际填写0即可。
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_LGLC_INFO --信贷资产转让信息
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_TRF_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_TRF_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

   -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入信贷资产转让信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO
  (
      DATA_DT  --数据日期
      ,LGL_REP_ID  --法人编号
      ,TRF_CONT_ID  --转让合同号
      ,ORG_ID  --机构编号
      ,CNTPR_NM  --交易对手名称
      ,CRDT_CNTPR_TYP  --信贷交易对手类型
      ,CUR  --币种
      ,TRF_PRIN_TOT_AMT  --转让贷款本金总额
      ,TRF_INT_TOT_AMT  --转让贷款利息总额
      ,TRF_TOT_PRC  --转让总价
      ,TRF_CNCL_AMT  --转让核销金额
      ,TRF_RETRV_CASH_AMT  --转让收回现金金额
      ,NOT_TRF_SLF_HOLD_AMT  --未转让自持金额
      ,LOSS_AMT  --损失金额
      ,TRF_RETRV_OTH_AMT  --转让收回其他对价
      ,TRF_CONT_START_DT  --转让合同起始日期
      ,TRF_CONT_EXP_DT  --转让合同到期日期
      ,TRF_ETR_ACC  --转让价款入账账号
      ,TRF_ENTR_ACC_NM  --转让价款入账账户名称
      ,CNTPR_TRF_ACC  --交易对手转账账号
      ,CNTPR_TRF_ACC_NM  --交易对手转账账号户名
      ,CNTPR_TRF_DT  --交易对手转账日期
      ,CNTPR_ALDY_PAY_AMT  --交易对手已支付金额
      ,MRGN_PCT  --保证金比例
      ,MRGN_CUR  --保证金币种
      ,MRGN  --保证金
      ,AST_TRF_MODE  --资产转让方式
      ,TRA_PLTF  --交易平台
      ,YD_CNTR_REGD_AMT  --银登中心登记金额
      ,BANK_TRF_FLG  --行内转让标志
      ,BATCH_TRF_FLG  --批量转让标志
      ,TRF_DRC  --转让方向
      ,TRF_CONT_STAT  --转让合同状态
      ,DEPT_LINE  --部门条线
      ,DATA_SRC  --数据来源
      ,TRF_SLF_HOLD_AMT --转让自持金额
      ,ASSET_TRAN_DT     --最后转让日期

      )
      SELECT   DISTINCT
       V_P_DATE    DATA_DT --数据日期
      , MAX(A.LP_ID)  AS LGL_REP_ID --法人编号
          ,A.CONT_ID AS TRF_CONT_ID --转让合同号
          ,MAX(A.ACCT_INSTIT_ID) AS ORG_ID--机构编号
          ,MAX(A.CNTPTY_NAME) AS CNTPR_NM --交易对手名称
          ,NULL AS CRDT_CNTPR_TYP --信贷交易对手类型
          ,MAX(A.CURR_CD) AS CUR--币种
          ,SUM(A.ISSUE_TOT_AMT) AS TRF_PRIN_TOT_AMT --转让贷款本金总额
          ,MAX(B.TRAN_LOAN_INT_TOT) AS TRF_INT_TOT_AMT --转让贷款利息总额
          ,SUM(A.ASSET_TRAN_CONSIDERATION_AMT) AS TRF_TOT_PRC --转让总价
          ,0 AS TRF_CNCL_AMT --转让核销金额
          ,0 AS TRF_RETRV_CASH_AMT--转让收回现金金额
          ,0 AS NOT_TRF_SLF_HOLD_AMT--未转让自持金额
          ,0 AS LOSS_AMT--损失金额
          ,0 AS TRF_RETRV_OTH_AMT --转让收回其他对价
          ,TO_CHAR(MIN(A.BEGIN_DT), 'YYYYMMDD') AS TRF_CONT_START_DT  --转让合同起始日期
          ,TO_CHAR(MAX(A.EXP_DT), 'YYYYMMDD') AS TRF_CONT_EXP_DT --转让合同到期日期
          ,MAX(B.RECVBL_ACCT_ID) AS TRF_ETR_ACC --转让价款入账账号
          ,MAX(B.RECVBL_ACCT_NAME)  AS TRF_ENTR_ACC_NM --转让价款入账账户名称
          ,MAX(A.CNTPTY_ACCT_NUM) AS CNTPR_TRF_ACC --交易对手转账账号
          ,MAX(A.CNTPTY_OPEN_BANK_NAME) AS CNTPR_TRF_ACC_NM--交易对手转账账号户名
          ,TO_CHAR(MAX(A.CNTPTY_TRAN_DT),'YYYYMMDD') AS CNTPR_TRF_DT --交易对手转账日期
          ,SUM(A.CNTPTY_PAY_AMT) AS CNTPR_ALDY_PAY_AMT --交易对手已支付金额
          ,0 AS MRGN_PCT --保证金比例
          ,NULL AS MRGN_CUR--保证金币种
          ,NULL AS MRGN --保证金
          ,'03' AS AST_TRF_MODE --资产转让方式  --资产证券化贷款转让
          ,CASE WHEN MAX(A.TRAN_PLAT_NAME) = 'YDZX' THEN '01'
           WHEN MAX(A.TRAN_PLAT_NAME) IN ('XLON','NASDAQ','XNYS','XSES','BJZJ','XSHG','XSHE','HKEX') THEN '02'
           WHEN MAX(A.TRAN_PLAT_NAME) = 'X_CNBD'  THEN '03'ELSE '99' END AS TRA_PLTF --交易平台
          ,SUM(A.BANK_RGST_CENTER_AMT) AS YD_CNTR_REGD_AMT --银登中心登记金额
          ,NULL AS BANK_TRF_FLG --行内转让标志
          ,NULL AS BATCH_TRF_FLG --批量转让标志
          ,'02' AS TRF_DRC --转让方向
          ,CASE WHEN MAX(A.PROD_STATUS_CD) IN ('01','11','31','00') THEN '01'
           WHEN MAX(A.PROD_STATUS_CD) IN ('21','41','71') THEN '02'
           WHEN MAX(A.PROD_STATUS_CD) IN ('51') THEN '06'
           WHEN  MAX(A.PROD_STATUS_CD) IN ('61') THEN '07'END AS TRF_CONT_STAT --转让合同状态
          ,'800919' /*风险管理部*/ AS DEPT_LINE --部门条线
          ,'资产证券化' AS DATA_SRC --数据来源
          ,SUM(A.PROD_SELF_HOLD_AMT)  AS TRF_SLF_HOLD_AMT --转让自持金额
          ,NVL(TO_CHAR(MAX(T3.ASSET_TRAN_DT),'YYYYMMDD'),TO_CHAR(MAX(T4.ASSET_TRAN_DT),'YYYYMMDD'))
                                      AS ASSET_TRAN_DT     --最后转让日期
      FROM RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO A --资产证券化转让合同信息
      LEFT JOIN (SELECT CONT_ID,
                        MAX(RECVBL_ACCT_ID) AS RECVBL_ACCT_ID,
                        MAX(RECVBL_ACCT_NAME) AS RECVBL_ACCT_NAME,
                        SUM(TRAN_LOAN_INT_TOT) AS TRAN_LOAN_INT_TOT
                   FROM RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO T1
                  GROUP BY CONT_ID) B --资产证券化基础资产信息
        ON A.CONT_ID = B.CONT_ID
     /* LEFT JOIN ORG_CONFIG C
       ON NVL(A.ACCT_INSTIT_ID, A.RGST_ORG_ID) = C.ORG_ID*/
     LEFT JOIN O_ICL_CMM_CORP_LOAN_ACCT_INFO T3
          ON A.CONT_ID = T3.CONT_ID
          AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN O_ICL_CMM_RETL_LOAN_ACCT_INFO T4
          ON T4.CONT_ID =  A.CONT_ID
          AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     GROUP BY A.CONT_ID;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


 -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, TRF_CONT_ID,COUNT(1)
      FROM M_LOAN_TRF_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, TRF_CONT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_LOAN_TRF_INFO;
/

