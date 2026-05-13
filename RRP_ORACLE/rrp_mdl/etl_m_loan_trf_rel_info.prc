CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_TRF_REL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_TRF_REL_INFO
  *  功能描述：信贷资产转让关系信息
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_LGLC_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20221114  HULJ      增加数据重复校验
  *             3    20230906  LIP       增加单笔、批量转让的数据
  *             4    20230925  LIP       增加网商贷债权转入的数据
  *             5    20231229  hyf       修改END_DT 过滤条件
  *             6    20251114  HYF       修改资产证券化部分逻辑，补充差额核销贷款本金总额
  *             7    20251117  LIP       增加对公贷款资产保全的数据
  *             8    20251202  LIP       剔除转让收益权卖断的借据，调整资产证券化的利息取数
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;       --处理步骤
  V_P_DATE    VARCHAR2(8);        --跑批数据日期
  V_STARTTIME DATE;               --处理开始时间
  V_ENDTIME   DATE;               --处理结束时间
  V_SQLCOUNT  INTEGER := 0;       --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);      --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);      --任务名称
  V_PART_NAME VARCHAR2(100);      --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_TRF_REL_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_TRF_REL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20251202 增加资产证券化部分转让本金和转让利息的取数（只取当天发生的转让借据数据）；资产证券化登记的利息是转让前一天的金额
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资产证券化部分转让本金和转让利息数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_TRF_REL_INFO_TEMP01';
  INSERT INTO RRP_MDL.M_LOAN_TRF_REL_INFO_TEMP01
    (RCPT_ID            --借据编号
    ,ASSET_TRAN_DT      --转让日期
    ,TRF_LOAN_PRIN      --转让贷款本金
    ,TRF_LOAN_INT       --转让贷款利息
    )
    WITH DUBIL_AMT_BAL AS (
  SELECT ACCT_ID,REPAY_AMT_TYPE_CD AS AMT_TYPE,CURR_DOC_BAL AS AMT
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_PLAN --零售贷款还款计划 到还款日后没还款的金额余额
   WHERE CURR_DOC_BAL > 0
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT ACCT_ID,REPAY_AMT_TYPE_CD AS AMT_TYPE,CURR_ISSUE_RECVBL_AMT AS AMT
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_PLAN --零售贷款还款计划 还没到还款日期的本金
   WHERE REPAY_AMT_TYPE_CD = 'PRI'
     AND CURR_ISSUE_RECVBL_AMT <> 0
     AND REPAYBL_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT ACCT_ID,REPAY_AMT_TYPE_CD AS AMT_TYPE,CURR_DOC_BAL AS AMT
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN --对公贷款还款计划 到还款日后没还款的金额余额
   WHERE CURR_DOC_BAL > 0
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT ACCT_ID,REPAY_AMT_TYPE_CD AS AMT_TYPE,CURR_ISSUE_RECVBL_AMT AS AMT
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN --对公贷款还款计划 还没到还款日期的本金
   WHERE REPAY_AMT_TYPE_CD = 'PRI'
     AND CURR_ISSUE_RECVBL_AMT <> 0
     AND REPAYBL_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT ACCT_ID AS ACCT_ID,AMT_TYPE_CD AS AMT_TYPE,DOC_BAL AS AMT
    FROM RRP_MDL.O_IML_EVT_PNLT_COMP_INT_NOMAL_REPAY_DTL --罚息复利正常还款明细
   WHERE DOC_BAL > 0
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT TO_CHAR(INTERNAL_KEY) AS ACCT_ID,INT_CLASS AS AMT_TYPE,NVL(INT_ACCRUED, 0) + NVL(INT_ADJ, 0) AS AMT
    FROM RRP_MDL.O_IOL_NCBS_CL_ACCT_ODP_DETAIL --罚息计息表
   WHERE NVL(INT_ACCRUED, 0) + NVL(INT_ADJ, 0) > 0
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT TO_CHAR(INTERNAL_KEY) AS ACCT_ID,INT_CLASS AS AMT_TYPE,NVL(INT_ACCRUED, 0) + NVL(INT_ADJ, 0) AS AMT
    FROM RRP_MDL.O_IOL_NCBS_CL_ACCT_ODI_DETAIL --复利计息表
   WHERE NVL(INT_ACCRUED, 0) + NVL(INT_ADJ, 0) > 0
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
    LOAN_ACCT_INFO AS (
  SELECT ACCT_ID,DUBIL_NUM,ASSET_TRAN_DT
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO --零售贷款账户信息
   WHERE ASSET_TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   UNION ALL
  SELECT ACCT_ID,DUBIL_NUM,ASSET_TRAN_DT
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO --零售贷款账户信息
   WHERE ASSET_TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.DUBIL_NUM,
         --T.ACCT_ID,
         TO_CHAR(T.ASSET_TRAN_DT,'YYYYMMDD') AS ASSET_TRAN_DT,
         SUM(CASE WHEN TA.AMT_TYPE = 'PRI' THEN NVL(TA.AMT,0) ELSE 0 END) AS TRF_LOAN_PRIN,
         SUM(CASE WHEN TA.AMT_TYPE <> 'PRI' THEN NVL(TA.AMT,0) ELSE 0 END) AS TRF_LOAN_INT
    FROM LOAN_ACCT_INFO T
   INNER JOIN DUBIL_AMT_BAL TA
      ON TA.ACCT_ID = T.ACCT_ID
   GROUP BY T.DUBIL_NUM,/*T.ACCT_ID,*/TO_CHAR(T.ASSET_TRAN_DT,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入信贷资产转让关系信息_资产证券化';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_REL_INFO
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,TRF_CONT_ID         --转让合同号
    ,RCPT_ID             --借据编号
    ,ASSET_POOL_ID       --资产池编号
    ,TRF_LOAN_PRIN       --转让贷款本金
    ,TRF_LOAN_INT        --转让贷款利息
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    ,LOAN_BIZ_TYP        --业务类别
    ,ASSET_TRAN_DT       --转让日期
    ,LOAN_PRIN           --贷款本金总额 ADD BY 20251114
    ,CNCL_LOAN_PRIN      --差额核销贷款本金总额 ADD BY 20251114
    )
  SELECT V_P_DATE                               AS DATA_DT          --数据日期
        ,T1.LP_ID                               AS LGL_REP_ID       --法人编号
        ,T1.ACCT_INSTIT_ID                      AS ORG_ID           --机构编号
        ,T1.CONT_ID                             AS TRF_CONT_ID      --转让合同号
        ,T2.DUBIL_ID                            AS RCPT_ID          --借据编号
        ,T1.ASSET_POOL_ID                       AS ASSET_POOL_ID    --资产池编号
        /*,T2.PKG_ASSET_BAL                       AS TRF_LOAN_PRIN    --转让贷款本金
        --,T2.PKG_BELONG_HXB_INT                  AS TRF_LOAN_INT     --转让贷款利息
        ,T2.PKG_POST_INT_RECVBL_TOT             AS TRF_LOAN_INT     --转让贷款利息*/
        --MOD BY LIP 20251202 根据核心提供的提数单脚本取本金和利息金额
        ,CASE WHEN T5.RCPT_ID IS NOT NULL THEN T5.TRF_LOAN_PRIN
              WHEN T6.RCPT_ID IS NOT NULL THEN T6.TRF_LOAN_PRIN
              ELSE T2.PKG_ASSET_BAL
          END                                   AS TRF_LOAN_PRIN    --转让贷款本金
        ,CASE WHEN T5.RCPT_ID IS NOT NULL THEN T5.TRF_LOAN_INT
              WHEN T6.RCPT_ID IS NOT NULL THEN T6.TRF_LOAN_INT
              ELSE T2.PKG_POST_INT_RECVBL_TOT
          END                                   AS TRF_LOAN_INT     --转让贷款利息
        ,NULL                                   AS DEPT_LINE        --部门条线
        ,'资产证券化'                           AS DATA_SRC         --数据来源
        ,T1.ASSET_POOL_TYPE_CD                  AS LOAN_BIZ_TYP     --业务类别
        ,NVL(TO_CHAR(T3.ASSET_TRAN_DT,'YYYYMMDD'),TO_CHAR(T4.ASSET_TRAN_DT,'YYYYMMDD')) AS ASSET_TRAN_DT    --资产转让日期
        ,T2.LOAN_BAL                            AS LOAN_PRIN        --贷款本金总额 ADD BY 20251114
        ,NVL(T2.PKG_ASSET_BAL,0)-NVL(T2.TRAN_COSDETN,0) AS CNCL_LOAN_PRIN      --差额核销贷款本金总额 ADD BY 20251114
    FROM RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO T1 --资产证券化转让合同信息
   INNER JOIN RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO T2 --资产证券化基础资产信息
      ON T2.CONT_ID = T1.CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T3 --对公贷款账户信息
      ON T3.DUBIL_NUM = T2.DUBIL_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T4  --零售贷款账户信息
      ON T4.DUBIL_NUM = T2.DUBIL_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_TRF_REL_INFO_TEMP01 T5 --当天转让的本金和利息 --ADD BY LIP 20251202
      ON T5.RCPT_ID = T2.DUBIL_ID
    LEFT JOIN RRP_MDL.M_LOAN_TRF_REL_INFO T6 --前一天的资产证券化的数据 --ADD BY LIP 20251202
      ON T6.RCPT_ID = T2.DUBIL_ID
     AND T6.TRF_CONT_ID = T2.LOAN_CONT_ID
     AND T6.DATA_SRC = '资产证券化'
     AND T6.DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD')
   --增加过滤资产证券化标志,无需剔除卖断 MOD BY 20251124
   WHERE T2.ASSET_STATUS_CD = '70' --资产状态代码:70 已转让已记账 
     AND (NVL(TRIM(T3.ABS_FLG),'0') = '1' --资产证券化标志
          OR NVL(TRIM(T4.ABS_FLG),'0') = '1' --资产证券化标志
         )--ASSET_TRAN_FLG = 1 表示卖断  MOD BY 20251124
     AND T1.ASSET_POOL_STATUS_CD <> '100' --资产池状态代码(剔除 100 已终结) ADD BY 20251114
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230906 增加单笔/批量转让的数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入信贷资产转让关系信息_单笔转让';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_REL_INFO
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,TRF_CONT_ID         --转让合同号
    ,RCPT_ID             --借据编号
    ,ASSET_POOL_ID       --资产池编号
    ,TRF_LOAN_PRIN       --转让贷款本金
    ,TRF_LOAN_INT        --转让贷款利息
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    ,LOAN_BIZ_TYP        --业务类别
    ,ASSET_TRAN_DT       --转让日期
    ,LOAN_PRIN           --贷款本金总额
    ,CNCL_LOAN_PRIN      --差额核销贷款本金总额
    ,WV_LOAN_PRIN        --豁免贷款本金总额
    ,INT_AMT             --正常贷款利息
    ,OD_INT_AMT          --超期贷款利息
    ,WV_INT_AMT          --豁免贷款利息总额
    ,TRA_SEQ_NO          --核心交易流水号
    ,PROP_ID             --方案编号 --ADD BY 20231109 方便核数
    )
  WITH CL_RECEIPT AS (
    SELECT TB.ETL_DT,T1.CMISLOAN_NO,TB.TRAN_REF_NO AS REFERENCE,TB.LOAN_NUM,T1.INTERNAL_KEY,
           TO_DATE(REPLACE(SUBSTR(T1.TRAN_TIMESTAMP, 1, 10), '-', ''), 'YYYYMMDD') ZRRQ,
           SUM(CASE WHEN TC.AMT_TYPE_CD = 'PRI' AND TB.LOAN_REPAY_TYPE_CD = 'PO'
                    THEN NVL(TC.CALLBK_PRIC,0) ELSE 0 END) OVER(PARTITION BY T1.CMISLOAN_NO) PRI_AMT,
           SUM(CASE WHEN TC.AMT_TYPE_CD = 'INT' AND TB.LOAN_REPAY_TYPE_CD = 'PO'
                    THEN NVL(TC.CALLBK_PRIC,0) ELSE 0 END) OVER(PARTITION BY T1.CMISLOAN_NO) INT_AMT,
           SUM(CASE WHEN TC.AMT_TYPE_CD NOT IN ('PRI','INT') AND TB.LOAN_REPAY_TYPE_CD = 'PO'
                    THEN NVL(TC.CALLBK_PRIC,0) ELSE 0 END) OVER(PARTITION BY T1.CMISLOAN_NO) OD_INT_AMT,
           SUM(CASE WHEN TC.AMT_TYPE_CD = 'PRI' AND TB.LOAN_REPAY_TYPE_CD = 'WV'
                    THEN NVL(TC.CALLBK_PRIC,0) ELSE 0 END) OVER(PARTITION BY T1.CMISLOAN_NO) WV_PRI_AMT,
           SUM(CASE WHEN TC.AMT_TYPE_CD <> 'PRI' AND TB.LOAN_REPAY_TYPE_CD = 'WV'
                     THEN NVL(TC.CALLBK_PRIC,0) ELSE 0 END) OVER(PARTITION BY T1.CMISLOAN_NO) WV_INT_AMT,
           ROW_NUMBER() OVER(PARTITION BY T1.CMISLOAN_NO ORDER BY 1) RN
      FROM RRP_MDL.O_IOL_NCBS_CL_TRANSFER_DETAIL T1
     INNER JOIN IML.V_EVT_REPAY_FLOW TB --IOL.NCBS_CL_RECEIPT 因 O_IML_EVT_REPAY_FLOW 表中数据只有一天，改为取数仓视图
        ON TB.LOAN_NUM = T1.LOAN_NO
       AND TB.LOAN_REPAY_TYPE_CD IN ('PO','WV') --CD2567 结清 WV豁免
     --AND TB.ETL_DT = TO_DATE(REPLACE(SUBSTR(T1.TRAN_TIMESTAMP, 1, 10), '-', ''), 'YYYYMMDD')
     --AND TB.ETL_DT >= TO_DATE('20230502','YYYYMMDD')--新一代上线日期
     AND TB.BUS_TRAN_DT = TO_DATE(REPLACE(SUBSTR(T1.TRAN_TIMESTAMP,1,10),'-',''),'YYYYMMDD')
     AND TB.BUS_TRAN_DT >= TO_DATE('20230502','YYYYMMDD')
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --数仓调整成全量表了
      LEFT JOIN RRP_MDL.O_IML_EVT_REPAY_DTL TC
        ON TC.EVT_ID = TB.EVT_ID
     WHERE T1.ASSET_ACCT_STATUS = 'S'
       AND T1.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND T1.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD'))
  SELECT V_P_DATE                                                     AS DATA_DT          --数据日期
        ,TA.LP_ID                                                     AS LGL_REP_ID       --法人编号
        ,NVL(TF.ACCT_INSTIT_ID,TG.ACCT_INSTIT_ID)                     AS ORG_ID           --机构编号
        ,NVL(TRIM(TA.TRAN_CONT_ID),TA.PROP_ID)                        AS TRF_CONT_ID      --转让合同号 --MOD BY LIP 20231107 因字段为主键，不能为空，若历史数据未补录合同信息，则继续用方案编号
        ,TC.CMISLOAN_NO                                               AS RCPT_ID          --借据编号
        ,NULL                                                         AS ASSET_POOL_ID    --资产池编号
        /*--MOD BY 20240119 单笔转让的，对于转让前整笔核销了的，转让贷款本金和转让贷款利息字段的取数；
           转让贷款本金：0，转让贷款利息：核销时的利息*/
        ,CASE WHEN TI.ACCT_ID IS NOT NULL AND TI.FIR_WRT_OFF_DT <= TC.ZRRQ THEN 0
              ELSE NVL(TB.LOAN_BAL,0)
          END                                                         AS TRF_LOAN_PRIN    --转让贷款本金
        ,CASE WHEN TI.ACCT_ID IS NOT NULL AND TI.FIR_WRT_OFF_DT <= TC.ZRRQ
              THEN NVL(TI.ACTL_WRTOFF_IN_BS_INT,0) + NVL(TI.ACTL_WRTOFF_OFF_BS_INT,0)
              ELSE NVL(TC.INT_AMT,0)+NVL(TC.OD_INT_AMT,0)+NVL(TC.WV_INT_AMT,0)
          END                                                         AS TRF_LOAN_INT     --转让贷款利息
        ,NULL                                                         AS DEPT_LINE        --部门条线
        ,CASE WHEN TF.DUBIL_NUM IS NOT NULL THEN '零售贷款单笔转让'
              WHEN TG.DUBIL_NUM IS NOT NULL THEN '对公贷款单笔转让'
          END                                                         AS DATA_SRC         --数据来源
        ,CASE WHEN TF.DUBIL_NUM IS NOT NULL THEN '001' --个人贷款
              WHEN TG.DUBIL_NUM IS NOT NULL THEN '002' --对公贷款
          END                                                         AS LOAN_BIZ_TYP     --业务类别
        ,TO_CHAR(TC.ZRRQ,'YYYYMMDD')                                  AS ASSET_TRAN_DT    --资产转让日期
        ,NVL(TB.LOAN_BAL,0)                                           AS LOAN_PRIN        --贷款本金总额
        ,NVL(TD.TRANAM,0)                                             AS CNCL_LOAN_PRIN   --差额核销贷款本金总额
        ,NVL(TC.WV_PRI_AMT,0)                                         AS WV_LOAN_PRIN     --豁免贷款本金总额
        ,NVL(TC.INT_AMT,0)                                            AS INT_AMT          --正常贷款利息
        ,NVL(TC.OD_INT_AMT,0)                                         AS OD_INT_AMT       --超期贷款利息
        ,NVL(TC.WV_INT_AMT,0)                                         AS WV_INT_AMT       --豁免贷款利息总额
        ,TC.REFERENCE                                                 AS TRA_SEQ_NO       --核心交易流水号
        ,TA.PROP_ID                                                   AS PROP_ID          --方案编号 --ADD BY 20231109 方便核数
    FROM RRP_MDL.O_IML_AGT_AP_REGISTER_INFO_H TA --单户资产登记信息历史 PRDICMS.AP_REGISTER_PROGRAM
   INNER JOIN RRP_MDL.O_IML_AGT_AP_TRANSFER_INFO_H TB --资产转让债权信息历史 PRDICMS.AP_TRANSFER_INFO
      ON TB.DISP_PROP_ID = TA.PROP_ID
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN CL_RECEIPT TC --关联核心表取流水号
      ON TC.CMISLOAN_NO = TB.OBJ_ID
     AND TC.RN = 1
    LEFT JOIN IOL.V_TGLS_GLA_VCHR_H TD --核算中台表 --因 O_IOL_TGLS_GLA_VCHR_H 只保留一天数据，所以用数仓的视图
      ON TD.SOURSQ = TC.REFERENCE
     AND TD.STACID = 1
     AND TD.SYSTID = 'NCBS'
     AND TD.AMNTCD = 'D'
     AND TD.ITEMCD = '19020101' --有减值准备的就是差额核销的数据
     AND TD.ETL_DT = TC.ZRRQ
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO TF --零售贷款账户信息
      ON TF.ACCT_ID = TC.INTERNAL_KEY
     AND TF.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO TG --对公贷款账户信息
      ON TG.ACCT_ID = TC.INTERNAL_KEY
     AND TG.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO TI --贷款核销信息 --ADD BY 20240119
      ON TI.ACCT_ID = TC.INTERNAL_KEY
     AND TI.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TA.EXEC_STATUS_CD = '1'
     --AND COALESCE(TF.ASSET_TRAN_FLG,TG.ASSET_TRAN_FLG,'0') <> '1' --剔除转让收益权卖断的借据 ADD BY LIP 20251202
     AND COALESCE(TF.ABS_FLG,TG.ABS_FLG,'0') <> '1' --剔除转让收益权卖断的借据 ADD BY LIP 20251202
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --网商贷债权直转 --ADD BY LIP 20230925
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入网商贷债权直转转入数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_REL_INFO
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,TRF_CONT_ID         --转让合同号
    ,RCPT_ID             --借据编号
    ,ASSET_POOL_ID       --资产池编号
    ,TRF_LOAN_PRIN       --转让贷款本金
    ,TRF_LOAN_INT        --转让贷款利息
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    ,LOAN_BIZ_TYP        --业务类别
    ,ASSET_TRAN_DT       --转让日期
    )
  SELECT V_P_DATE                               AS DATA_DT          --数据日期
        ,MAX(T1.LP_ID)                          AS LGL_REP_ID       --法人编号
        ,MAX(T1.ACCT_INSTIT_ID)                 AS ORG_ID           --机构编号
        --,'8202309220493001'                     TRF_CONT_ID      --转让合同号 --MOD BY LIP 20230927 根据张家伟提供的转让信息填写
        ,CASE WHEN MIN(TRUNC(T1.DISTR_DT)) = TO_DATE('20230925','YYYYMMDD') THEN '8202309220493001'
              ELSE MIN(TO_CHAR(T1.DISTR_DT,'YYYYMMDD')) ||'网商贷债权直转'
          END                                   AS TRF_CONT_ID      --转让合同号
        ,T1.DUBIL_ID                            AS RCPT_ID          --借据编号
        ,NULL                                   AS ASSET_POOL_ID    --资产池编号
        --MOD BY LIP 20231019 网商贷转入的单位是分，需将金额转换为元
        ,SUM(NVL(T2.PRINBAL,0))/100             AS TRF_LOAN_PRIN    --转让贷款本金
        ,SUM(NVL(T2.INTBAL,0)+NVL(T2.OVDPRINPNLTBAL,0)+NVL(T2.OVDINTPNLTBAL,0))/100 AS TRF_LOAN_INT     --转让贷款利息
        ,NULL                                   AS DEPT_LINE        --部门条线
        ,'网商贷债权直转'                       AS DATA_SRC         --数据来源
        ,'001'                                  AS LOAN_BIZ_TYP     --业务类别
        ,MIN(TO_CHAR(T1.DISTR_DT,'YYYYMMDD'))   AS ASSET_TRAN_DT    --资产转让日期
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T1   --联合网贷借据信息
   INNER JOIN RRP_MDL.O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO T2 --网商贷资产转让明细文件中间表-债权直转 数据是按期次存储的，需按借据汇总
      ON T2.CONTRACTNO = T1.DUBIL_ID
     --AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.STD_PROD_ID IN ('202020100001','202020200004')
     AND SUBSTR(T1.LOAN_TYPE_CD,1,2) = '00'
     AND SUBSTR(T1.LOAN_TYPE_CD,7,1) = '1' --网商贷债权直转 
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T1.DUBIL_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --对公贷款资产保全 --ADD BY LIP 20251117
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入对公贷款资产保全数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_REL_INFO
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,TRF_CONT_ID         --转让合同号
    ,RCPT_ID             --借据编号
    ,ASSET_POOL_ID       --资产池编号
    ,TRF_LOAN_PRIN       --转让贷款本金
    ,TRF_LOAN_INT        --转让贷款利息
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    ,LOAN_BIZ_TYP        --业务类别
    ,ASSET_TRAN_DT       --转让日期
    ,LOAN_PRIN           --贷款本金总额
    ,CNCL_LOAN_PRIN      --差额核销贷款本金总额
    ,WV_LOAN_PRIN        --豁免贷款本金总额
    ,INT_AMT             --正常贷款利息
    ,OD_INT_AMT          --超期贷款利息
    ,WV_INT_AMT          --豁免贷款利息总额
    ,TRA_SEQ_NO          --核心交易流水号
    ,PROP_ID             --方案编号
    )
  SELECT V_P_DATE                                                     AS DATA_DT          --数据日期
        ,T1.LP_ID                                                     AS LGL_REP_ID       --法人编号
        ,TRIM(T1.RGST_BELONG_ORG_ID)                                  AS ORG_ID           --机构编号
        ,NVL(TRIM(T1.TRAN_CONT_ID),TRIM(T1.APPL_FLOW_NUM))            AS TRF_CONT_ID      --转让合同号 --MOD BY LIP 20231107 因字段为主键，不能为空，若历史数据未补录合同信息，则继续用方案编号
        ,T2.RELA_FLOW_NUM                                             AS RCPT_ID          --借据编号
        ,NULL                                                         AS ASSET_POOL_ID    --资产池编号
        /*,NVL(T2.DERATE_PRIC,0) + NVL(T2.DERATE_OVDUE_PRIC,0)          AS TRF_LOAN_PRIN    --转让贷款本金
        ,NVL(T2.DERATE_PROVI_COMP_INT,0) + NVL(T2.DERATE_PROVI_INT,0) + NVL(T2.DERATE_PROVI_PNLT,0) + NVL(T2.DERATE_ACTL_OWE_COMP_INT,0)
           + NVL(T2.DERATE_ACTL_OWE_INT,0) + NVL(T2.DERATE_ACTL_OWE_PNLT,0) AS TRF_LOAN_INT     --转让贷款利息*/
        /*--MOD BY LIP 20251203 根据詹宏真口径：借据层的：
        转让本金总额：正常本金+逾期本金
        转让利息总额：计提利息+实欠利息+计提罚息+实欠罚息+计提付息+实欠复息
        DERATE_PROVI_INT +DERATE_ACTL_OWE_INT+DERATE_PROVI_PNLT+DERATE_ACTL_OWE_PNLT+DERATE_PROVI_COMP_INT+DERATE_ACTL_OWE_COMP_INT*/
        ,NVL(T2.DERATE_PRIC,0)+NVL(T2.DERATE_OVDUE_PRIC,0)            AS TRF_PRIN_TOT_AMT          --转让贷款本金
        ,NVL(T2.DERATE_PROVI_INT,0)+NVL(T2.DERATE_ACTL_OWE_INT,0)+NVL(T2.DERATE_PROVI_PNLT,0)+NVL(T2.DERATE_ACTL_OWE_PNLT,0)+
             NVL(T2.DERATE_PROVI_COMP_INT,0)+NVL(T2.DERATE_ACTL_OWE_COMP_INT,0) AS TRF_INT_TOT_AMT --转让贷款利息
        ,NULL                                                         AS DEPT_LINE        --部门条线
        ,CASE WHEN T3.DUBIL_ID IS NOT NULL THEN '对公贷款资产保全'
          END                                                         AS DATA_SRC         --数据来源
        ,CASE WHEN T3.DUBIL_ID IS NOT NULL THEN '002' --对公贷款
          END                                                         AS LOAN_BIZ_TYP     --业务类别
        --,TO_CHAR(T1.RGST_DT,'YYYYMMDD')                               AS ASSET_TRAN_DT    --资产转让日期
        ,CASE WHEN NVL(TO_CHAR(T4.CLOS_ACCT_DT,'YYYYMMDD'),'20991231') NOT IN ('00010101','20991231')
              THEN TO_CHAR(T4.CLOS_ACCT_DT,'YYYYMMDD')
              WHEN NVL(TO_CHAR(T4.ASSET_TRAN_DT,'YYYYMMDD'),'20991231') NOT IN ('00010101','20991231')
              THEN TO_CHAR(T4.ASSET_TRAN_DT,'YYYYMMDD')
              WHEN NVL(TO_CHAR(T1.RGST_DT,'YYYYMMDD'),'20991231') NOT IN ('00010101','20991231')
              THEN TO_CHAR(T1.RGST_DT,'YYYYMMDD')
          END                                                         AS ASSET_TRAN_DT    --资产转让日期 --MOD BY LIP 20251218
        ,NULL                                                         AS LOAN_PRIN        --贷款本金总额
        ,NULL                                                         AS CNCL_LOAN_PRIN   --差额核销贷款本金总额
        ,NULL                                                         AS WV_LOAN_PRIN     --豁免贷款本金总额
        ,NULL                                                         AS INT_AMT          --正常贷款利息
        ,NULL                                                         AS OD_INT_AMT       --超期贷款利息
        ,NULL                                                         AS WV_INT_AMT       --豁免贷款利息总额
        ,TRIM(T2.CORE_RETURN_REST)                                    AS TRA_SEQ_NO       --核心交易流水号
        ,TRIM(T1.PROP_ID)                                             AS PROP_ID          --方案编号
    FROM RRP_MDL.O_IML_AGT_ASTCONSV_APPL_INFO_H T1 --资产保全申请信息历史 PRDICMS.ASSET_PRESERVATION_APPLY
   INNER JOIN RRP_MDL.O_IML_AGT_ASTCONSV_DUBIL_RELA_H T2 --资产保全（贷后）关联表 PRDICMS.AP_AFTERLOAN_RELATIVE
      ON T2.FLOW_NUM = T1.APPL_FLOW_NUM
     AND T2.BUS_TYPE_CD IN ('BadLoansTransferApply')
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3
      ON T3.DUBIL_ID = T2.RELA_FLOW_NUM
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T4 --对公贷款账户信息 --ADD BY LIP 20251218
      ON T4.DUBIL_NUM = T2.RELA_FLOW_NUM
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.APV_STATUS_CD = 'Finished'
     AND TRIM(T2.CORE_RETURN_REST) IS NOT NULL --交易流水号不为空
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
    SELECT DATA_DT,TRF_CONT_ID,RCPT_ID,ASSET_POOL_ID,COUNT(1)
      FROM RRP_MDL.M_LOAN_TRF_REL_INFO T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,TRF_CONT_ID,RCPT_ID,ASSET_POOL_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_TRF_REL_INFO;
/

