CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_TRD_FNC_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_TRD_FNC_SUB
  *  功能描述：贸易融资贷款子表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_TRD_FNC_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20221114  HULJ      增加数据重复校验
  *             3    20250612  LIP       增加兴链贷的产品映射及其他相关字段取数口径,贸易融资品种从配置表出数
  *             4    20250814  LIP       203020700001进口代付的还款对象名称取对应的客户名
  *             5    20251113  LIP       销货方名称取数逻辑优化
  *             6    20260316  LIP       根据一表通取数调整购货方名称取数
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;           --处理步骤
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);          --分区名
  V_STEP_DESC VARCHAR2(200);          --任务名称
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_TRD_FNC_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_TRD_FNC_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贸易融资贷款子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRD_FNC_SUB
    (DATA_DT      --数据日期
    ,LGL_REP_ID   --法人编号
    ,CONT_ID      --合同编号
    ,RCPT_ID      --借据编号
    ,CUST_ID      --客户编号
    ,TRA_FNC_VRTY --贸易融资品种
    ,CUR          --币种
    ,COMM_AMT     --手续费金额
    ,ISU_BANK_NM  --开证行名称
    ,COMM_CUR     --手续费币种
    ,TRA_CONTENT  --贸易交易内容
    ,BUY_SIDE_NM  --购货方名称
    ,SELL_SIDE_NM --销货方名称
    ,PAY_OBJ_NM   --支付对象名称
    ,REPY_OBJ_NM  --还款对象名称
    ,DEPT_LINE    --部门条线
    ,DATA_SRC     --数据来源
    )
  SELECT  V_P_DATE                                       AS DATA_DT      --数据日期
         ,A.LP_ID                                        AS DATA_DT      --法人编号
         ,NVL(B.CONT_ID,A.CONT_ID)                       AS CONT_ID      --合同编号
         ,A.DUBIL_ID                                     AS RCPT_ID      --借据编号
         ,A.CUST_ID                                      AS CUST_ID      --客户编号
         ,NVL(TB.TAR_VALUE_CODE,'99')                    AS TRA_FNC_VRTY --贸易融资品种 --MOD BY LIP 20250613 调整为模型出数
         ,A.CURR_CD                                      AS CUR          --币种
         ,0                                              AS COMM_AMT     --手续费金额
         ,C.ISSUE_BANK_NAME                              AS ISU_BANK_NM  --开证行名称
         ,A.CURR_CD                                      AS COMM_CUR     --手续费币种
         ,E.TRADE_TRAN_CONTENT                           AS TRA_CONTENT  --贸易交易内容
         --MOD BY LIP 20230731 0818需求二级福费廷购货方名称取信用证开证人信息
         ,CASE WHEN A.STD_PROD_ID IN ('203030600002','203020300002')
               THEN TRIM(HH.LC_ISSUER)
               --ELSE TRIM(E.BUYER_NAME)
               --MOD BY LIP 20260316 根据一表通取数调整购货方名称取数
               WHEN TRIM(E.BUYER_NAME) IS NOT NULL THEN TRIM(E.BUYER_NAME)
               ELSE TRIM(TC.TRDPTY_CUST_NAME1)
           END                                           AS BUY_SIDE_NM  --购货方名称
         --,E.SELLER_NAME                                  AS SELL_SIDE_NM --销货方名称
         --MOD BY 20240204 二级福费廷销货方名称取信用证收益人名称
         ,CASE WHEN A.STD_PROD_ID IN ('203030600002','203020300002') THEN TRIM(HH.LC_BENEFC_NAME)
               WHEN TRIM(E.SELLER_NAME) IS NOT NULL THEN TRIM(E.SELLER_NAME)
               ELSE NVL(F.CUST_NAME,I.CUST_NAME) --MOD BY LIP 2025113 兴链贷业务，信贷系统业务合同详情页面无销货方名称,建议取业务合同客户名称
           END                                           AS SELL_SIDE_NM --销货方名称
         ,NVL(F.CUST_NAME,I.CUST_NAME)                   AS PAY_OBJ_NM   --支付对象名称
         ,CASE WHEN A.STD_PROD_ID IN ('203010100004','203030500015','203030500014','203020100001','203020100003',
                                      '203030500001','203020700001') --MOD BY LIP 20250612 新增产品203030500001 203020700001
               THEN J.CUST_NAME --国内保理,进口T/T项下押汇,出口T/T项下押汇,货到付款押汇 进口代付
               WHEN A.STD_PROD_ID IN ('203030600001','203020300001','203030600002','203020300002','203020100001')
                AND TRIM(K.ISSUE_BANK_CN_NAME) IS NOT NULL THEN K.ISSUE_BANK_CN_NAME --福费廷
               --MOD BY 20240312 二级福费廷的还款对象取开证行
               WHEN A.STD_PROD_ID IN ('203020300002','203030600002')
                AND TRIM(HH.EXP_LC_ISSUE_BANK_NAME) IS NOT NULL THEN TA.BKNAME --福费廷
               ELSE TRIM(C.ISSUE_BANK_NAME)
           END                                           AS REPY_OBJ_NM  --还款对象名称 --20230112 LHQ 参考就EAST5.0 逻辑调整
         ,NULL                                           AS DEPT_LINE    --部门条线
         ,'贸易融资'                                     AS DATA_SRC     --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
   INNER JOIN RRP_MDL.CODE_MAP TTA --码值映射表(贷款类型) --MODIFY BY TANGAN AT 20221201
      ON TTA.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
      ON B.DUBIL_NUM = A.DUBIL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户基本信息
      ON F.CUST_ID = A.CUST_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LC_ACCT_INFO C --信用证账户信息
      ON C.LC_ID = A.BILL_NUM
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO E --对公贷款业务合同补充信息
      ON E.CONT_ID = A.CONT_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H H --公司贷款出账申请
      ON H.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
     AND H.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND H.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO I --对公客户基本信息
      ON I.CUST_ID = H.CUST_ID
     AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO J --对公客户基本信息
      ON J.CUST_ID = NVL(B.CUST_ID,A.CUST_ID)
     AND J.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT LC_ACCT_ID
                      ,MX_LC_FLG
                      ,ISSUE_BANK_CN_NAME
                      ,MIN(ACPT_DT) AS ACPT_DT
                      ,MAX(PAY_DT) AS PAY_DT
                 FROM RRP_MDL.O_ICL_CMM_LC_DOC_INFO
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY LC_ACCT_ID,MX_LC_FLG,ISSUE_BANK_CN_NAME) K --信用证单据信息
      ON K.LC_ACCT_ID = C.ACCT_ID
     AND K.MX_LC_FLG = C.MX_LC_FLG
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H HH --贷款出账对公贷款附属信息历史 ADD BY LIP 20230731
      ON HH.OUT_ACCT_FLOW_NUM = A.OUT_ACCT_FLOW_NUM
     AND HH.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND HH.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO TA --中台机构信息表
      ON TA.BKCD = HH.EXP_LC_ISSUE_BANK_NAME
     AND TA.ID_MARK <> 'D'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TB --MOD BY LIP 20250613 将贸易融资品种映射改成配置表出数
      ON TB.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TB.SRC_CLASS_CODE = 'STD0002'
     AND TB.TAR_CLASS_CODE = 'T0006'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO TC --对公贷款合同信息 --ADD BY LIP 20260316 根据一表通调整
      ON TC.CONT_ID = A.CONT_ID
     AND TRIM(TC.TRDPTY_CUST_NAME1) IS NOT NULL
     AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE (TTA.TAR_VALUE_CODE LIKE '0204%' OR TTA.TAR_VALUE_CODE = '0399') --贸易融资 --MODIFY BY TANGAN AT 20221201
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.M_LOAN_TRD_FNC_SUB T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(I_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_TRD_FNC_SUB;
/

