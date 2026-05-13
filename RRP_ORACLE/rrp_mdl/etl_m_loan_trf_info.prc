CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_TRF_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_TRF_INFO
  *  功能描述：业务范围包含直接转让债权、信贷资产证券化、信贷资产收益权转让、通过其他方式转让等，以及对应的信贷资产转入业务，相关业务定义参照1104报表《信贷资产转让情况统计表》。
  *  行内机构间的转让需报送。票据的买卖、买入返售、卖出回购不在本表填报。含已核销贷款，本金按实际填写0即可。
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_LGLC_INFO --信贷资产转让信息
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20221114  HULJ      增加数据重复校验
  *             3    20230906  LIP       增加单笔、批量转让的数据
  *             4    20231229  HYF       修改END_DT 过滤条件
  *             5    20250415  XZY       新增登记柜员编号
  *             6    20250821  LIP       其他交易平台描述增加正常的平台描述映射兜底逻辑
  *             7    20250822  LIP       一表通增加交易对手转账账号开户行行号字段，并调整资产证券化部分行名的取数逻辑
  *             8    20250912  LIP       一表通增加资产转让的审批人信息
  *             9    20251114  HYF       调整资产证券化部分逻辑，调整转让贷款本金总额，补充差额核销金额等
  *            10    20251117  LIP       增加对公贷款资产保全的数据
  *            11    20251122  LIP       修改对公贷款资产保全的币种取值
  *            12    20251202  LIP       剔除转让收益权卖断的借据，增加交易对手证件取数，调整资产证券化的利息取数
  *            13    20251211  LIP       增加M_LOAN_TRF_INFO_CT表，对转让合同进行整合，不对原表进行处理，方便1104取数
  *            14    20251216  LIP       增加客户名称字段，部分对公单笔单批的转让合同默认最终交易对手支付日期
  *            15    20260115  LIP       将对公提供的需补录信息改成实体表存储数据，并调整交易对手最终支付日期和状态的取数
  *************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;        --处理步骤
  V_P_DATE    VARCHAR2(8);         --跑批数据日期
  V_STARTTIME DATE;                --处理开始时间
  V_ENDTIME   DATE;                --处理结束时间
  V_SQLCOUNT  INTEGER := 0;        --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);       --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);       --任务名称
  V_PART_NAME VARCHAR2(100);       --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_TRF_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_TRF_INFO'; --程序名称
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
  ETL_PARTITION_ADD(V_P_DATE,'M_LOAN_TRF_INFO_CT', '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME); --分区表的重跑处理
  EXECUTE IMMEDIATE ('ALTER TABLE RRP_MDL.M_LOAN_TRF_INFO_CT TRUNCATE PARTITION '||V_PART_NAME); --分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20250912 增加资产转让的审批人员取数
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资产转让审批员工信息表--信贷系统';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_TRF_INFO_TEMP01';
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO_TEMP01
    (OBJECTNO            --方案编号
    ,OBJECTTYPE          --对象类型
    ,OPER_USER_ID        --经办员工ID
    ,CHECK_USER_ID       --审查员工ID
    ,LAST_CHECK_USER_ID  --审批员工ID
    )
    WITH TMP1 AS (
  SELECT OBJECTNO,OBJECTTYPE,PHASETYPE,USERID,USERNAME,SERIALNO,RELATIVESERIALNO,
         ROW_NUMBER() OVER(PARTITION BY OBJECTNO,PHASETYPE ORDER BY ENDTIME DESC) RN
    FROM RRP_MDL.O_IOL_ICMS_FLOW_TASK T
   WHERE OBJECTTYPE IN ('AssetsSchemeApply_retail','AssetsSchemeApply')
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.OBJECTNO         AS OBJECTNO,           --方案编号
         T.OBJECTTYPE       AS OBJECTTYPE,         --对象类型
         TRIM(T.USERID)     AS OPER_USER_ID,       --经办员工ID
         TRIM(TC.USERID)    AS CHECK_USER_ID,      --审查员工ID
         TRIM(TB.USERID)    AS LAST_CHECK_USER_ID  --审批员工ID
    FROM TMP1 T
    LEFT JOIN TMP1 TA ON TA.OBJECTNO = T.OBJECTNO AND TA.PHASETYPE = '1040' AND TA.RN = 1 --审批通过 基本都是system,改成取上一层的员工ID
    LEFT JOIN TMP1 TB ON TB.SERIALNO = TA.RELATIVESERIALNO
    LEFT JOIN TMP1 TC ON TC.SERIALNO = TB.RELATIVESERIALNO
   WHERE T.PHASETYPE = '1010' AND T.RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资产转让审批员工信息表--资产证券化系统';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO_TEMP01
    (OBJECTNO            --方案编号
    ,OBJECTTYPE          --对象类型
    ,OPER_USER_ID        --经办员工ID
    ,CHECK_USER_ID       --审查员工ID
    ,LAST_CHECK_USER_ID  --审批员工ID
    )
    WITH TMP1 AS (
  SELECT T1.RELATIVEOBJECTNO,T.OBJECTNO,T.OBJECTTYPE,
         CASE WHEN T.PHASENO IN ('8000', '1000') THEN '8000' ELSE T.PHASENO END PHASENO,
         T.USERID,T.USERNAME,T.SERIALNO,T.RELATIVESERIALNO,
         ROW_NUMBER() OVER(PARTITION BY T.OBJECTNO,T.PHASETYPE ORDER BY T.ENDTIME DESC) RN
    FROM RRP_MDL.O_IOL_ABSS_FLOW_TASK T
   INNER JOIN RRP_MDL.O_IOL_ABSS_ABS_TRANSACTION T1
      ON T1.SERIALNO = T.OBJECTNO
     AND T1.RELATIVEOBJECTTYPE = 'jbo.abs.ABS_ASSET_POOL'
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.OBJECTTYPE = 'jbo.abs.ABS_TRANSACTION'
     AND T.FLOWNO = 'ABS_TransferFlow'
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.RELATIVEOBJECTNO AS OBJECTNO,           --方案编号
         T.OBJECTTYPE       AS OBJECTTYPE,         --对象类型
         TRIM(T.USERID)     AS OPER_USER_ID,       --经办员工ID
         TRIM(TC.USERID)    AS CHECK_USER_ID,      --审查员工ID
         TRIM(TB.USERID)    AS LAST_CHECK_USER_ID  --审批员工ID
    FROM TMP1 T
    LEFT JOIN TMP1 TA ON TA.OBJECTNO = T.OBJECTNO AND TA.PHASENO = '8000' AND TA.RN = 1 --审批通过 基本都是system,改成取上一层的员工ID
    LEFT JOIN TMP1 TB ON TB.SERIALNO = TA.RELATIVESERIALNO
    LEFT JOIN TMP1 TC ON TC.SERIALNO = TB.RELATIVESERIALNO
   WHERE T.PHASENO = '0010' AND T.RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20251027 增加资产保全的流程审批人员信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资产转让审批员工信息表--资产保全';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO_TEMP01
    (OBJECTNO            --方案编号
    ,OBJECTTYPE          --对象类型
    ,OPER_USER_ID        --经办员工ID
    ,CHECK_USER_ID       --审查员工ID
    ,LAST_CHECK_USER_ID  --审批员工ID
    )
    WITH TMP1 AS (
  SELECT OBJECTNO,OBJECTTYPE,PHASETYPE,USERID,USERNAME,SERIALNO,RELATIVESERIALNO,
         ROW_NUMBER() OVER(PARTITION BY OBJECTNO,PHASETYPE ORDER BY ENDTIME DESC) RN
    FROM RRP_MDL.O_IOL_ICMS_FLOW_TASK T
   WHERE OBJECTTYPE IN ('BadLoansTransferApply')
     AND T.ID_MARK <> 'D'
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.OBJECTNO         AS OBJECTNO,           --方案编号
         T.OBJECTTYPE       AS OBJECTTYPE,         --对象类型
         TRIM(T.USERID)     AS OPER_USER_ID,       --经办员工ID
         TRIM(TC.USERID)    AS CHECK_USER_ID,      --审查员工ID
         TRIM(TB.USERID)    AS LAST_CHECK_USER_ID  --审批员工ID
    FROM TMP1 T
    LEFT JOIN TMP1 TA ON TA.OBJECTNO = T.OBJECTNO AND TA.PHASETYPE = '1040' AND TA.RN = 1 --审批通过 基本都是system,改成取上一层的员工ID
    LEFT JOIN TMP1 TB ON TB.SERIALNO = TA.RELATIVESERIALNO
    LEFT JOIN TMP1 TC ON TC.SERIALNO = TB.RELATIVESERIALNO
   WHERE T.PHASETYPE = '1010' AND T.RN = 1;

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
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_TRF_INFO_TEMP02';
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO_TEMP02
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
  V_STEP_DESC := '插入信贷资产转让信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRF_CONT_ID           --转让合同号
    ,ORG_ID                --机构编号
    ,CNTPR_NM              --交易对手名称
    ,CRDT_CNTPR_TYP        --信贷交易对手类型
    ,CUR                   --币种
    ,TRF_PRIN_TOT_AMT      --转让贷款本金总额
    ,TRF_INT_TOT_AMT       --转让贷款利息总额
    ,TRF_TOT_PRC           --转让总价
    ,TRF_CNCL_AMT          --转让核销金额
    ,TRF_RETRV_CASH_AMT    --转让收回现金金额
    ,NOT_TRF_SLF_HOLD_AMT  --未转让自持金额
    ,LOSS_AMT              --损失金额
    ,TRF_RETRV_OTH_AMT     --转让收回其他对价
    ,TRF_CONT_START_DT     --转让合同起始日期
    ,TRF_CONT_EXP_DT       --转让合同到期日期
    ,TRF_ETR_ACC           --转让价款入账账号
    ,TRF_ENTR_ACC_NM       --转让价款入账账户名称
    ,CNTPR_TRF_ACC         --交易对手转账账号
    ,CNTPR_TRF_ACC_NM      --交易对手转账账号开户行行名
    ,CNTPR_TRF_DT          --交易对手转账日期
    ,CNTPR_ALDY_PAY_AMT    --交易对手已支付金额
    ,MRGN_PCT              --保证金比例
    ,MRGN_CUR              --保证金币种
    ,MRGN                  --保证金
    ,AST_TRF_MODE          --资产转让方式
    ,TRA_PLTF              --交易平台
    ,YD_CNTR_REGD_AMT      --银登中心登记金额
    ,BANK_TRF_FLG          --行内转让标志
    ,BATCH_TRF_FLG         --批量转让标志
    ,TRF_DRC               --转让方向
    ,TRF_CONT_STAT         --转让合同状态
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,TRF_SLF_HOLD_AMT      --转让自持金额
    ,ASSET_TRAN_DT         --最后转让日期
    ,OTH_TRA_PLTF          --其他交易平台描述
    ,CNTPR_TRF_END_DT      --最终交易对手支付日期
    ,LOAN_BIZ_TYP          --信贷资产类型 --ADD 20240204
    ,RGST_TELLER_ID        --登记柜员编号 ADD BY XZY 20250415
    ,CNTPR_TRF_ACC_BANK_NO --交易对手转账账号开户行行号 --ADD BY LIP 20250822
    ,OPER_USER_ID          --经办员工ID --ADD BY LIP 20250912
    ,CHECK_USER_ID         --审查员工ID --ADD BY LIP 20250912
    ,LAST_CHECK_USER_ID    --审批员工ID --ADD BY LIP 20250912
    ,CNTPR_TRF_CERT_TYPE_CD--对手方证件类型代码 ADD BY LIP 20251202
    ,CNTPR_TRF_CERT_NO     --对手方证件号码 ADD BY LIP 20251202
    ,PROP_ID               --方案编号 --ADD BY 20251216 方便核数
    )
  SELECT V_P_DATE                                            AS DATA_DT                         --数据日期
        ,MAX(A.LP_ID)                                        AS LGL_REP_ID                      --法人编号
        ,A.CONT_ID                                           AS TRF_CONT_ID                     --转让合同号
        ,MAX(A.ACCT_INSTIT_ID)                               AS ORG_ID                          --机构编号
        ,MAX(A.CNTPTY_NAME)                                  AS CNTPR_NM                        --交易对手名称
        --,NULL                                                AS CRDT_CNTPR_TYP                  --信贷交易对手类型
        ,MAX(A.CNTPTY_ORG_TYPE_CD)                           AS CRDT_CNTPR_TYP                  --信贷交易对手类型
        ,MAX(A.CURR_CD)                                      AS CUR                             --币种
        --,SUM(B.TRAN_COSDETN)                                 AS TRF_PRIN_TOT_AMT                --转让贷款本金总额 MOD BY 20251114
        --,SUM(B.PKG_ASSET_BAL)                                AS TRF_PRIN_TOT_AMT                --转让贷款本金总额 MOD BY 20251114
        --,SUM(B.TRAN_LOAN_INT_TOT)                            AS TRF_INT_TOT_AMT                 --转让贷款利息总额
        --,SUM(B.PKG_POST_INT_RECVBL_TOT)                      AS TRF_INT_TOT_AMT                 --转让贷款利息总额
        --MOD BY LIP 20251202 根据核心提供的提数单脚本取本金和利息金额
        ,CASE WHEN MAX(T7.RCPT_ID) IS NOT NULL THEN SUM(T7.TRF_LOAN_PRIN)
              WHEN MAX(T8.TRF_CONT_ID) IS NOT NULL THEN MAX(T8.TRF_PRIN_TOT_AMT)
              ELSE SUM(B.PKG_ASSET_BAL)
          END                                                AS TRF_PRIN_TOT_AMT                --转让贷款本金总额
        ,CASE WHEN MAX(T7.RCPT_ID) IS NOT NULL THEN SUM(T7.TRF_LOAN_INT)
              WHEN MAX(T8.TRF_CONT_ID) IS NOT NULL THEN MAX(T8.TRF_INT_TOT_AMT)
              ELSE SUM(B.PKG_POST_INT_RECVBL_TOT)
          END                                                AS TRF_INT_TOT_AMT                 --转让贷款利息总额
        --,SUM(B.PKG_ASSET_BAL)                                AS TRF_TOT_PRC                     --转让总价
        ,SUM(B.TRAN_COSDETN)                                 AS TRF_TOT_PRC                     --转让总价 
        ,SUM(B.PKG_ASSET_BAL)-SUM(B.TRAN_COSDETN)            AS TRF_CNCL_AMT                    --转让核销金额 MOD BY 20251114
        ,0                                                   AS TRF_RETRV_CASH_AMT              --转让收回现金金额
        ,0                                                   AS NOT_TRF_SLF_HOLD_AMT            --未转让自持金额
        ,0                                                   AS LOSS_AMT                        --损失金额
        ,0                                                   AS TRF_RETRV_OTH_AMT               --转让收回其他对价
        ,TO_CHAR(MIN(A.BEGIN_DT), 'YYYYMMDD')                AS TRF_CONT_START_DT               --转让合同起始日期
        ,TO_CHAR(MAX(A.EXP_DT), 'YYYYMMDD')                  AS TRF_CONT_EXP_DT                 --转让合同到期日期
        ,MAX(B.RECVBL_ACCT_ID)                               AS TRF_ETR_ACC                     --转让价款入账账号
        ,MAX(B.RECVBL_ACCT_NAME)                             AS TRF_ENTR_ACC_NM                 --转让价款入账账户名称
        ,MAX(A.CNTPTY_ACCT_NUM)                              AS CNTPR_TRF_ACC                   --交易对手转账账号
        --,MAX(A.CNTPTY_OPEN_BANK_NAME)                        AS CNTPR_TRF_ACC_NM                --交易对手转账账号开户行行名
        ,MAX(T5.BKNAME)                                        AS CNTPR_TRF_ACC_NM                --交易对手转账账号开户行行名 --MOD BY LIP 20250822
        ,TO_CHAR(MAX(A.CNTPTY_TRAN_DT),'YYYYMMDD')           AS CNTPR_TRF_DT                    --交易对手转账日期
        --,SUM(A.CNTPTY_PAY_AMT)                               AS CNTPR_ALDY_PAY_AMT              --交易对手已支付金额
        ,MAX(A.CNTPTY_PAY_AMT)                               AS CNTPR_ALDY_PAY_AMT              --交易对手已支付金额 --MOD BY LIP 20260121
        ,0                                                   AS MRGN_PCT                        --保证金比例
        ,NULL                                                AS MRGN_CUR                        --保证金币种
        ,NULL                                                AS MRGN                            --保证金
        ,'03'                                                AS AST_TRF_MODE                    --资产转让方式  --资产证券化贷款转让
        ,CASE WHEN MAX(A.TRAN_PLAT_NAME) = 'YDZX' THEN '01'
              WHEN MAX(A.TRAN_PLAT_NAME) IN ('XLON','NASDAQ','XNYS','XSES','BJZJ','XSHG','XSHE','HKEX','ZQJYS') THEN '02'
              WHEN MAX(A.TRAN_PLAT_NAME) = 'X_CNBD' THEN '03'
              ELSE '99'
          END                                                AS TRA_PLTF                        --交易平台
        --,SUM(A.BANK_RGST_CENTER_AMT)                         AS YD_CNTR_REGD_AMT                --银登中心登记金额
        ,MAX(A.BANK_RGST_CENTER_AMT)                         AS YD_CNTR_REGD_AMT                --银登中心登记金额 --MOD BY LIP 20260121
        ,NULL                                                AS BANK_TRF_FLG                    --行内转让标志
        ,NULL                                                AS BATCH_TRF_FLG                   --批量转让标志
        ,'02'                                                AS TRF_DRC                         --转让方向
        ,CASE WHEN MAX(A.PROD_STATUS_CD) IN ('01','11','31','00') THEN '01'
              WHEN MAX(A.PROD_STATUS_CD) IN ('21','41','71') THEN '02'
              WHEN MAX(A.PROD_STATUS_CD) IN ('51') THEN '06'
              WHEN MAX(A.PROD_STATUS_CD) IN ('61') THEN '07'
          END                                                AS TRF_CONT_STAT                   --转让合同状态
        ,'800919'                                            AS DEPT_LINE                       --部门条线/*风险管理部*/
        ,'资产证券化'                                        AS DATA_SRC                        --数据来源
        ,0                                                   AS TRF_SLF_HOLD_AMT                --转让自持金额
        --,COALESCE(TO_CHAR(MAX(T3.ASSET_TRAN_DT),'YYYYMMDD'),TO_CHAR(MAX(T4.ASSET_TRAN_DT),'YYYYMMDD'),'99991231')
        ,TO_CHAR(MAX(A.BEGIN_DT),'YYYYMMDD')                 AS ASSET_TRAN_DT                   --最后转让日期 --MOD BY 20251114
        ,MAX(T2.CD_DESCB)                                    AS OTH_TRA_PLTF                    --其他交易平台描述
        ,COALESCE(TO_CHAR(MAX(T3.ASSET_TRAN_DT),'YYYYMMDD'),TO_CHAR(MAX(T4.ASSET_TRAN_DT),'YYYYMMDD'),'99991231') 
                                                             AS CNTPR_TRF_END_DT                --最终交易对手支付日期
        ,MIN(A.ASSET_POOL_TYPE_CD)                           AS LOAN_BIZ_TYP                    --信贷资产类型 --ADD 20240204
        ,MIN(A.RGST_TELLER_ID)                               AS RGST_TELLER_ID                  --登记柜员编号 ADD BY XZY 20250415
        ,MAX(A.CNTPTY_OPEN_BANK_NAME)                        AS CNTPR_TRF_ACC_BANK_NO           --交易对手转账账号开户行行号 --ADD BY LIP 20250822
        ,MAX(T6.OPER_USER_ID)                                AS OPER_USER_ID                    --经办员工ID --ADD BY LIP 20250912
        ,MAX(T6.CHECK_USER_ID)                               AS CHECK_USER_ID                   --审查员工ID --ADD BY LIP 20250912
        ,MAX(T6.LAST_CHECK_USER_ID)                          AS LAST_CHECK_USER_ID              --审批员工ID --ADD BY LIP 20250912
        ,MAX(TRIM(A.CNTPTY_CERT_TYPE))                       AS CNTPR_TRF_CERT_TYPE_CD          --对手方证件类型代码 ADD BY LIP 20251202
        ,MAX(TRIM(A.CNTPTY_CERT_NO))                         AS CNTPR_TRF_CERT_NO               --对手方证件号码 ADD BY LIP 20251202
        ,MAX(TRIM(A.ASSET_POOL_ID))                          AS PROP_ID                         --方案编号 --ADD BY 20251216 方便核数
   FROM RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO A --资产证券化转让合同信息
   /*LEFT JOIN (SELECT CONT_ID
                    ,MAX(RECVBL_ACCT_ID) AS RECVBL_ACCT_ID
                    ,MAX(RECVBL_ACCT_NAME) AS RECVBL_ACCT_NAME
                    ,SUM(TRAN_LOAN_INT_TOT) AS TRAN_LOAN_INT_TOT
               FROM RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO T1
              GROUP BY CONT_ID) B --资产证券化基础资产信息
     ON B.CONT_ID = A.CONT_ID*/
   INNER JOIN RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO B --资产证券化基础资产信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')     
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T3
      ON T3.DUBIL_NUM = B.DUBIL_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T4
      ON T4.DUBIL_NUM = B.DUBIL_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD T2
      ON T2.CD_VAL = A.TRAN_PLAT_NAME
     AND T2.CD_ID = 'CD1936'
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO T5 --中台机构信息表 --ADD BY LIP 20250822 模型中的交易对手开户行名称是行号，需进行转换
      ON T5.BKCD = A.CNTPTY_OPEN_BANK_NAME
     AND T5.ID_MARK <> 'D'
     AND T5.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T5.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO_TEMP01 T6 --ADD BY LIP 20250912 增加审批人员的取数
      --ON T6.OBJECTNO = A.CONT_ID
      ON T6.OBJECTNO = A.ASSET_POOL_ID --MOD BY LIP 20251216
     AND T6.OBJECTTYPE = 'jbo.abs.ABS_TRANSACTION'
    LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO_TEMP02 T7 --当天转让的本金和利息 --ADD BY LIP 20251202
      ON T7.RCPT_ID = B.DUBIL_ID
    LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO T8 --前一天的资产证券化的数据 --ADD BY LIP 20251202
      ON T8.TRF_CONT_ID = A.CONT_ID
     AND T8.DATA_SRC = '资产证券化'
     AND T8.DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD')
    --增加过滤资产证券化标志,无需剔除卖断 MOD BY 20251124
   WHERE B.ASSET_STATUS_CD = '70' --资产状态代码:70 已转让已记账 
     AND (NVL(TRIM(T3.ABS_FLG),'0') = '1' --资产证券化标志
          OR NVL(TRIM(T4.ABS_FLG),'0') = '1' --资产证券化标志
          ) --ASSET_TRAN_FLG = 1 表示卖断 MOD BY 20251124
     AND A.ASSET_POOL_STATUS_CD <> '100' --资产池状态代码(剔除 100 已终结) ADD BY 20251114
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  GROUP BY A.CONT_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20230906 增加单笔/批量转让的数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入信贷资产转让信息-单笔转让';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRF_CONT_ID           --转让合同号
    ,ORG_ID                --机构编号
    ,CNTPR_NM              --交易对手名称
    ,CRDT_CNTPR_TYP        --信贷交易对手类型
    ,CUR                   --币种
    ,TRF_PRIN_TOT_AMT      --转让贷款本金总额
    ,TRF_INT_TOT_AMT       --转让贷款利息总额
    ,TRF_TOT_PRC           --转让总价
    ,TRF_CNCL_AMT          --转让核销金额
    ,TRF_RETRV_CASH_AMT    --转让收回现金金额
    ,NOT_TRF_SLF_HOLD_AMT  --未转让自持金额
    ,LOSS_AMT              --损失金额
    ,TRF_RETRV_OTH_AMT     --转让收回其他对价
    ,TRF_CONT_START_DT     --转让合同起始日期
    ,TRF_CONT_EXP_DT       --转让合同到期日期
    ,TRF_ETR_ACC           --转让价款入账账号
    ,TRF_ENTR_ACC_NM       --转让价款入账账户名称
    ,CNTPR_TRF_ACC         --交易对手转账账号
    ,CNTPR_TRF_ACC_NM      --交易对手转账账号开户行行名
    ,CNTPR_TRF_DT          --交易对手转账日期
    ,CNTPR_ALDY_PAY_AMT    --交易对手已支付金额
    ,MRGN_PCT              --保证金比例
    ,MRGN_CUR              --保证金币种
    ,MRGN                  --保证金
    ,AST_TRF_MODE          --资产转让方式
    ,TRA_PLTF              --交易平台
    ,YD_CNTR_REGD_AMT      --银登中心登记金额
    ,BANK_TRF_FLG          --行内转让标志
    ,BATCH_TRF_FLG         --批量转让标志
    ,TRF_DRC               --转让方向
    ,TRF_CONT_STAT         --转让合同状态
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,TRF_SLF_HOLD_AMT      --转让自持金额
    ,ASSET_TRAN_DT         --最后转让日期
    ,ADVC_SUIT_FEE         --代垫诉讼费
    ,TRA_SEQ_NO            --核心交易流水号
    ,CNTPR_TRF_END_DT      --最终交易对手支付日期
    ,OTH_TRA_PLTF          --其他交易平台描述
    ,PROP_ID               --方案编号 --ADD BY 20231109 方便核数
    ,LOAN_BIZ_TYP          --信贷资产类型 --ADD 20240204
    ,RGST_TELLER_ID        --登记柜员编号 ADD BY XZY 20250415
    ,CNTPR_TRF_ACC_BANK_NO --交易对手转账账号开户行行号 --ADD BY LIP 20250822
    ,OPER_USER_ID          --经办员工ID --ADD BY LIP 20250912
    ,CHECK_USER_ID         --审查员工ID --ADD BY LIP 20250912
    ,LAST_CHECK_USER_ID    --审批员工ID --ADD BY LIP 20250912
    ,TRF_CONT_SIGN_DT      --转让合同签约日期 ADD BY LIP 20251219
    ,CNTPR_TRF_CERT_TYPE_CD--对手方证件类型代码 ADD BY LIP 20251202
    ,CNTPR_TRF_CERT_NO     --对手方证件号码 ADD BY LIP 20251202
    ,CUST_NAME             --客户名称 --ADD BY LIP 20251216
    )
    WITH CL_RECEIPT AS (
  SELECT /*+MATERIALIZE*/TB.ETL_DT,T1.CMISLOAN_NO,TB.TRAN_REF_NO AS REFERENCE,TB.LOAN_NUM,T1.INTERNAL_KEY,
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
     AND T1.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')),
  AGT_AP_REGISTER_SUB_INFO_H AS (
  SELECT /*+MATERIALIZE*/PROP_ID,MAX(CNTPTY_TRAN_ACCT_DT) CNTPTY_TRAN_ACCT_DT,SUM(PAY_AMT) PAY_AMT
    FROM RRP_MDL.O_IML_AGT_AP_REGISTER_SUB_INFO_H
   WHERE PROP_ID NOT IN ('2023062900000006','2023062900000007','2023062900000009','2023062900000011','2023062900000012','2023092500000001',
         '2023110900000001','2023110900000003','2023110900000002') --根据詹宏真口径，这些方案的一次性结清了，程序按默认取数
     AND ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY PROP_ID
   UNION ALL --ADD BY LIP 20251216 根据詹宏真口径，这些方案的一次性结清了，程序按默认取数
  SELECT '2023062900000007' PROP_ID,TO_DATE('20230629','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,68000000 PAY_AMT FROM DUAL UNION ALL
  SELECT '2023062900000006' PROP_ID,TO_DATE('20230629','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,181240000 PAY_AMT FROM DUAL UNION ALL
  SELECT '2023062900000009' PROP_ID,TO_DATE('20230629','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,59099145.83 PAY_AMT FROM DUAL UNION ALL
  SELECT '2023062900000011' PROP_ID,TO_DATE('20230629','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,59100000 PAY_AMT FROM DUAL UNION ALL
  SELECT '2023062900000012' PROP_ID,TO_DATE('20230629','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,13450929.17 PAY_AMT FROM DUAL UNION ALL
  SELECT '2023092500000001' PROP_ID,TO_DATE('20230925','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,221000000 PAY_AMT FROM DUAL UNION ALL
  SELECT '2023110900000001' PROP_ID,TO_DATE('20231109','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,76000000 PAY_AMT FROM DUAL UNION ALL
  SELECT '2023110900000003' PROP_ID,TO_DATE('20231109','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,38800000 PAY_AMT FROM DUAL UNION ALL
  SELECT '2023110900000002' PROP_ID,TO_DATE('20241231','YYYYMMDD') CNTPTY_TRAN_ACCT_DT,76980000 PAY_AMT FROM DUAL)/*,
  TRAN_CONT_ID_INFO_GD AS ( --MOD BY LIP 20251218 詹宏真提供的需要默认的字段
  SELECT \*+MATERIALIZE*\'2023081400000001' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'' CNTPR_TRF_ACC,'兴业银行股份有限公司深圳和平支行' CNTPR_TRF_ACC_NM,
         '20230829' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'309584008070' CNTPR_TRF_ACC_BANK_NO,'20230626' TRF_CONT_SIGN_DT,'2313' CNTPR_TRF_CERT_TYPE_CD,
         '914403000878551150' CNTPR_TRF_CERT_NO,'2023081400000001' PROP_ID
  FROM DUAL UNION ALL
  SELECT '2023122600000011' TRF_CONT_ID,'广州粤沁贸易有限公司' CNTPR_NM,'20231225' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'210000570551' CNTPR_TRF_ACC,
         '广东华兴银行股份有限公司广州分行' CNTPR_TRF_ACC_NM,'' CNTPR_TRF_DT,\*120500000*\120000000 CNTPR_ALDY_PAY_AMT,'313581092013' CNTPR_TRF_ACC_BANK_NO,
         '20231225' TRF_CONT_SIGN_DT,'2313' CNTPR_TRF_CERT_TYPE_CD,'91440106MAD3DRR77A' CNTPR_TRF_CERT_NO,'2023122600000011' PROP_ID
  FROM DUAL UNION ALL
  SELECT '2023122800000010' TRF_CONT_ID,'深圳绿色家园装饰工程有限公司' CNTPR_NM,'20231227' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'650945117700015' CNTPR_TRF_ACC,
         '深圳福田银座村镇银行股份有限公司横岗支行' CNTPR_TRF_ACC_NM,'' CNTPR_TRF_DT,105000000 CNTPR_ALDY_PAY_AMT,'320584002027' CNTPR_TRF_ACC_BANK_NO,
         '20231227' TRF_CONT_SIGN_DT,'2313' CNTPR_TRF_CERT_TYPE_CD,'91440300MA5DQWUK16' CNTPR_TRF_CERT_NO,'2023122800000010' PROP_ID
  FROM DUAL UNION ALL
  SELECT '20241211资产转让001' TRF_CONT_ID,'' CNTPR_NM,'20241217' TRF_CONT_START_DT,'20251130' TRF_CONT_EXP_DT,'6230583000000638017' CNTPR_TRF_ACC,
         '平安银行股份有限公司广州番禺支行' CNTPR_TRF_ACC_NM,'20241219' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'307581008980' CNTPR_TRF_ACC_BANK_NO,
         '20241217' TRF_CONT_SIGN_DT,'1010' CNTPR_TRF_CERT_TYPE_CD,'440126196810315724' CNTPR_TRF_CERT_NO,'' PROP_ID
  FROM DUAL UNION ALL
  SELECT '20241224001' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'' CNTPR_TRF_ACC,
         '' CNTPR_TRF_ACC_NM,'20241231' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'' CNTPR_TRF_ACC_BANK_NO,
         '' TRF_CONT_SIGN_DT,'' CNTPR_TRF_CERT_TYPE_CD,'' CNTPR_TRF_CERT_NO,'' PROP_ID
  FROM DUAL UNION ALL
  SELECT 'HXGF20250103001' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'' CNTPR_TRF_ACC,
         '' CNTPR_TRF_ACC_NM,'20250103' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'' CNTPR_TRF_ACC_BANK_NO,
         '' TRF_CONT_SIGN_DT,'' CNTPR_TRF_CERT_TYPE_CD,'' CNTPR_TRF_CERT_NO,'' PROP_ID
  FROM DUAL UNION ALL
  SELECT 'HXZS202411CDSY' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'7332810182600065003' CNTPR_TRF_ACC,
         '中信银行杭州湖墅支行' CNTPR_TRF_ACC_NM,'' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'302331033284' CNTPR_TRF_ACC_BANK_NO,
         '' TRF_CONT_SIGN_DT,'' CNTPR_TRF_CERT_TYPE_CD,'' CNTPR_TRF_CERT_NO,'' PROP_ID
  FROM DUAL)*/
  SELECT V_P_DATE                                            AS DATA_DT                   --数据日期
        ,MAX(TA.LP_ID)                                       AS LGL_REP_ID                --法人编号
        --,MAX(NVL(TRIM(TA.TRAN_CONT_ID),TA.PROP_ID))          AS TRF_CONT_ID              --转让合同号 --MOD BY LIP 20231107 因字段为主键，不能为空，若历史数据未补录合同信息，则继续用方案编号
        ,NVL(TRIM(TA.TRAN_CONT_ID),TA.PROP_ID)               AS TRF_CONT_ID               --转让合同号
        ,MAX(NVL(TF.ACCT_INSTIT_ID,TG.ACCT_INSTIT_ID))       AS ORG_ID                    --机构编号
        --,MAX(TRIM(TA.CNTPTY_ACCT_NAME))                      AS CNTPR_NM                  --交易对手名称 --MOD BY LIP 20231107
        ,MAX(NVL(T8.CNTPR_NM,TRIM(TA.CNTPTY_ACCT_NAME)))     AS CNTPR_NM                  --交易对手名称 --MOD BY LIP 20251219
        ,MAX(TRIM(TA.CNTPTY_TYPE_CD))                        AS CRDT_CNTPR_TYP            --信贷交易对手类型 --MOD BY LIP 20231107 CD2115
        ,MAX(NVL(TF.CURR_CD,TG.CURR_CD))                     AS CUR                       --币种
        /*--MOD BY 20240119  单笔转让的，对于转让前整笔核销了的，转让贷款本金和转让贷款利息字段的取数；
           转让贷款本金：0，转让贷款利息：核销时的利息*/
        ,SUM(CASE WHEN TJ.ACCT_ID IS NOT NULL AND TJ.FIR_WRT_OFF_DT <= TC.ZRRQ THEN 0
              ELSE NVL(TB.LOAN_BAL,0)
          END)                                               AS TRF_PRIN_TOT_AMT          --转让贷款本金
        ,SUM(CASE WHEN TJ.ACCT_ID IS NOT NULL AND TJ.FIR_WRT_OFF_DT <= TC.ZRRQ
              THEN NVL(TJ.ACTL_WRTOFF_IN_BS_INT,0) + NVL(TJ.ACTL_WRTOFF_OFF_BS_INT,0)
              ELSE NVL(TC.INT_AMT,0)+NVL(TC.OD_INT_AMT,0)+NVL(TC.WV_INT_AMT,0)
          END)                                               AS TRF_INT_TOT_AMT           --转让贷款利息
        ,MAX(NVL(TA.TRAN_AMT,0)+NVL(TA.ADVC_SUIT_FEE,0))     AS TRF_TOT_PRC               --转让总价
        ,SUM(NVL(TD.TRANAM,0))                               AS TRF_CNCL_AMT              --转让核销金额
        ,0                                                   AS TRF_RETRV_CASH_AMT        --转让收回现金金额
        ,0                                                   AS NOT_TRF_SLF_HOLD_AMT      --未转让自持金额
        ,0                                                   AS LOSS_AMT                  --损失金额
        ,0                                                   AS TRF_RETRV_OTH_AMT         --转让收回其他对价
        ,MAX(CASE WHEN T8.TRF_CONT_START_DT IS NOT NULL THEN T8.TRF_CONT_START_DT --MOD BY LIP 20251219
                  WHEN TA.TRAN_CONT_BEGIN_DT NOT IN (TO_DATE('00010101','YYYYMMDD'),TO_DATE('20991231','YYYYMMDD'))
                  THEN TO_CHAR(TA.TRAN_CONT_BEGIN_DT,'YYYYMMDD')
                  ELSE '99991231'
          END)                                               AS TRF_CONT_START_DT         --转让合同起始日期 --MOD BY LIP 20231107
        ,MAX(CASE WHEN T8.TRF_CONT_EXP_DT IS NOT NULL THEN T8.TRF_CONT_EXP_DT --MOD BY LIP 20251219
                  WHEN TA.TRAN_CONT_EXP_DT NOT IN (TO_DATE('00010101','YYYYMMDD'),TO_DATE('20991231','YYYYMMDD'))
                  THEN TO_CHAR(TA.TRAN_CONT_EXP_DT,'YYYYMMDD')
                  ELSE '99991231'
          END)                                               AS TRF_CONT_EXP_DT           --转让合同到期日期 --MOD BY LIP 20231107
        ,MAX(TB.STL_ACCT_ID)                                 AS TRF_ETR_ACC               --转让价款入账账号
        ,MAX(TH.CUST_ACCT_NAME)                              AS TRF_ENTR_ACC_NM           --转让价款入账账户名称
        --,MAX(TRIM(TA.CNTPTY_ACCT_ID))                        AS CNTPR_TRF_ACC             --交易对手转账账号--MOD BY LIP 20231107
        --,MAX(TRIM(TA.CNTPTY_OPEN_BANK_NAME))                 AS CNTPR_TRF_ACC_NM          --交易对手转账账号开户行行名--MOD BY LIP 20231107
        ,MAX(NVL(T8.CNTPR_TRF_ACC,TRIM(TA.CNTPTY_ACCT_ID)))  AS CNTPR_TRF_ACC             --交易对手转账账号 --MOD BY LIP 20251219
        ,MAX(NVL(T8.CNTPR_TRF_ACC_NM,TRIM(TA.CNTPTY_OPEN_BANK_NAME))) AS CNTPR_TRF_ACC_NM --交易对手转账账号开户行行名--MOD BY LIP 20251219
        ,MIN(CASE WHEN T8.CNTPR_TRF_DT IS NOT NULL THEN T8.CNTPR_TRF_DT --MOD BY LIP 20251219
                  WHEN TA.CNTPTY_TRAN_ACCT_DT NOT IN (TO_DATE('00010101','YYYYMMDD'),TO_DATE('20991231','YYYYMMDD'))
                  THEN TO_CHAR(TA.CNTPTY_TRAN_ACCT_DT,'YYYYMMDD')
                  ELSE '99991231'
              END)                                           AS CNTPR_TRF_DT              --交易对手转账日期 --MOD BY LIP 20231107 如果有多次转账的，填报首笔转让价款转入日期，非定金日期。
        --,MAX(TA.FIRST_PAY_AMT)                               AS CNTPR_ALDY_PAY_AMT        --交易对手已支付金额 --MOD BY LIP 20231107
        ,MAX(CASE WHEN T8.CNTPR_ALDY_PAY_AMT IS NOT NULL THEN T8.CNTPR_ALDY_PAY_AMT --MOD BY LIP 20251219
                  WHEN TI.PAY_AMT IS NOT NULL THEN NVL(TI.PAY_AMT,0)
                  WHEN TI.PAY_AMT IS NULL THEN NVL(TA.FIRST_PAY_AMT,0)
              END)                                           AS CNTPR_ALDY_PAY_AMT        --交易对手已支付金额
        ,0                                                   AS MRGN_PCT                  --保证金比例
        ,MAX(NVL(TF.CURR_CD,TG.CURR_CD))                     AS MRGN_CUR                  --保证金币种
        --MOD BY 20231214 根据与张家伟确认的口径修改
        ,0                                                   AS MRGN                      --保证金
        ,'01'                                                AS AST_TRF_MODE              --资产转让方式 --直接转让
        ,MAX(CASE WHEN TA.TRAN_TRAN_PLAT IN ('YDZX') THEN '01' --银登中心
                  WHEN TA.TRAN_TRAN_PLAT IN ('XLON','NASDAQ','XNYS','XSES','BJZJ','XSHG','XSHE','HKEX','ZQJYS') THEN '02' --证券交易所
                  WHEN TA.TRAN_TRAN_PLAT IN ('X_CNBD','YHJSC') THEN '03' --银行间市场 --MOD BY LIP 20250821 增加YHJSC 银行间市场
                  ELSE '99'
          END)                                               AS TRA_PLTF                  --交易平台 --MOD BY LIP 20231107
        ,0                                                   AS YD_CNTR_REGD_AMT          --银登中心登记金额
        ,NULL                                                AS BANK_TRF_FLG              --行内转让标志
        ,NULL                                                AS BATCH_TRF_FLG             --批量转让标志
        ,'02'                                                AS TRF_DRC                   --转让方向
        ,MAX(CASE WHEN TI.PAY_AMT IS NOT NULL AND NVL(TI.PAY_AMT,0) = NVL(TA.TRAN_AMT,0)
                  THEN '07'
                  WHEN T8.TRF_CONT_ID IS NOT NULL AND NVL(T8.CNTPR_ALDY_PAY_AMT,0) = NVL(TA.TRAN_AMT,0) AND T8.CNTPR_TRF_END_DT IS NOT NULL
                  THEN '07' --MOD BY LIP 20260115
                  WHEN TI.PAY_AMT IS NULL AND NVL(TA.FIRST_PAY_AMT,0) = NVL(TA.TRAN_AMT,0)
                  THEN '07'
                  ELSE '02'
          END)                                               AS TRF_CONT_STAT             --转让合同状态 --MOD BY LIP 20231107
        ,'800919'                                            AS DEPT_LINE                 --部门条线/*风险管理部*/
        ,CASE WHEN MAX(TF.DUBIL_NUM) IS NOT NULL THEN '零售贷款单笔转让'
              WHEN MAX(TG.DUBIL_NUM) IS NOT NULL THEN '对公贷款单笔转让'
          END                                                AS DATA_SRC                  --数据来源
        ,NULL                                                AS TRF_SLF_HOLD_AMT          --转让自持金额
        ,MAX(TO_CHAR(TC.ZRRQ,'YYYYMMDD'))                    AS ASSET_TRAN_DT             --最后转让日期
        ,MAX(NVL(TA.ADVC_SUIT_FEE,0))                        AS ADVC_SUIT_FEE             --代垫诉讼费
        ,MAX(TC.REFERENCE)                                   AS TRA_SEQ_NO                --核心交易流水号
        ,MAX(CASE WHEN TI.PAY_AMT IS NOT NULL AND NVL(TI.PAY_AMT,0) = NVL(TA.TRAN_AMT,0)
                  THEN TO_CHAR(TI.CNTPTY_TRAN_ACCT_DT,'YYYYMMDD')
                  WHEN T8.TRF_CONT_ID IS NOT NULL AND NVL(T8.CNTPR_ALDY_PAY_AMT,0) = NVL(TA.TRAN_AMT,0) AND T8.CNTPR_TRF_END_DT IS NOT NULL
                  THEN T8.CNTPR_TRF_END_DT --MOD BY LIP 20260115
                  WHEN TI.PAY_AMT IS NULL AND NVL(TA.FIRST_PAY_AMT,0) = NVL(TA.TRAN_AMT,0)
                  THEN TO_CHAR(TA.CNTPTY_TRAN_ACCT_DT,'YYYYMMDD')
                  ELSE '99991231'
          END)                                               AS CNTPR_TRF_END_DT          --最终交易对手支付日期
        ,MAX(CASE WHEN TRIM(TA.TRAN_TRAN_PLAT_DESCB) IS NOT NULL THEN TRIM(TA.TRAN_TRAN_PLAT_DESCB)
                  WHEN TRIM(T2.CD_DESCB) IS NOT NULL THEN TRIM(T2.CD_DESCB)
                  --ADD BY LIP 20250821 对信贷的码值进行转码，1104需要给业务展示该字段，不能为空
                  WHEN TA.TRAN_TRAN_PLAT = 'YHJSC' THEN '银行间市场'
                  WHEN TA.TRAN_TRAN_PLAT = 'ZQJYS' THEN '证券交易所'
                  WHEN TA.TRAN_TRAN_PLAT = 'YDZX' THEN '银登中心'
                  WHEN TA.TRAN_TRAN_PLAT = 'QT' THEN '其他'
          END)                                               AS OTH_TRA_PLTF              --其他交易平台描述
        ,MAX(TA.PROP_ID)                                     AS PROP_ID                   --方案编号 --ADD BY 20231109 方便核数
        ,MIN(CASE WHEN TF.DUBIL_NUM IS NOT NULL THEN '001' --个人贷款
                  WHEN TG.DUBIL_NUM IS NOT NULL THEN '002' --对公贷款
          END)                                               AS LOAN_BIZ_TYP              --信贷资产类型 --ADD 20240204
        ,MIN(TA.RGST_TELLER_ID)                              AS RGST_TELLER_ID            --登记柜员编号 ADD BY XZY 20250415
        --,MAX(TRIM(TA.CNTPTY_OPEN_BANK_NUM))                  AS CNTPR_TRF_ACC_BANK_NO     --交易对手转账账号开户行行号 --ADD BY LIP 20250822
        ,MAX(NVL(T8.CNTPR_TRF_ACC_BANK_NO,TRIM(TA.CNTPTY_OPEN_BANK_NUM))) AS CNTPR_TRF_ACC_BANK_NO     --交易对手转账账号开户行行号 --MOD BY LIP 20251219
        ,MAX(T6.OPER_USER_ID)                                AS OPER_USER_ID              --经办员工ID --ADD BY LIP 20250912
        ,MAX(T6.CHECK_USER_ID)                               AS CHECK_USER_ID             --审查员工ID --ADD BY LIP 20250912
        ,MAX(T6.LAST_CHECK_USER_ID)                          AS LAST_CHECK_USER_ID        --审批员工ID --ADD BY LIP 20250912
        ,MAX(T8.TRF_CONT_SIGN_DT)                            AS TRF_CONT_SIGN_DT          --转让合同签约日期 ADD BY LIP 20251219
        ,MAX(NVL(T8.CNTPR_TRF_CERT_TYPE_CD,TRIM(T7.COUNTERPARTYACCTCERTTYPE))) AS CNTPR_TRF_CERT_TYPE_CD    --对手方证件类型代码 ADD BY LIP 20251202
        ,MAX(NVL(T8.CNTPR_TRF_CERT_NO,TRIM(T7.COUNTERPARTYACCTCERTID))) AS CNTPR_TRF_CERT_NO         --对手方证件号码 ADD BY LIP 20251202
        ,MAX(TRIM(TA.CUST_NAME))                             AS CUST_NAME                 --客户名称 --ADD BY LIP 20251216
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
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO TH
      ON TH.CUST_ACCT_ID = TB.STL_ACCT_ID
     AND TH.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN AGT_AP_REGISTER_SUB_INFO_H TI
      ON TI.PROP_ID = TA.PROP_ID
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD T2
      ON T2.CD_VAL = TA.TRAN_TRAN_PLAT
     AND T2.CD_ID = 'CD1936'
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO TJ --贷款核销信息 --ADD BY 20240119
      ON TJ.ACCT_ID = TC.INTERNAL_KEY
     AND TJ.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO_TEMP01 T6 --ADD BY LIP 20250912 增加审批人员的取数
      ON T6.OBJECTNO = TA.PROP_ID
     AND T6.OBJECTTYPE NOT IN ('BadLoansTransferApply')
    LEFT JOIN RRP_MDL.O_IOL_ICMS_AP_REGISTER_PROGRAM T7 --单户资产登记方案表 -ADD BY LIP 20251202 --取交易对手证件信息
      ON T7.SERIALNO = TA.FLOW_NUM
     AND T7.PROGRAMNO = TA.PROP_ID
     AND T7.ID_MARK <> 'D'
     AND T7.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T7.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    --LEFT JOIN TRAN_CONT_ID_INFO_GD T8 --ADD BY LIP 20251219 詹宏真提供的需写死的字段
    LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO_TEMP03 T8 --MOD BY LIP 20260115 将数据存入到实体表中
      ON T8.PROP_ID = TA.PROP_ID
     AND T8.PROP_ID IS NOT NULL
   WHERE TA.EXEC_STATUS_CD = '1'
     --AND COALESCE(TF.ASSET_TRAN_FLG,TG.ASSET_TRAN_FLG,'0') <> '1' --剔除转让收益权卖断的借据 ADD BY LIP 20251202
     AND COALESCE(TF.ABS_FLG,TG.ABS_FLG,'0') <> '1' --剔除转让收益权卖断的借据 ADD BY LIP 20251202
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY NVL(TRIM(TA.TRAN_CONT_ID),TA.PROP_ID);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20251117 增加对公贷款资产保全的数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入信贷资产转让信息-对公贷款资产保全';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,TRF_CONT_ID           --转让合同号
    ,ORG_ID                --机构编号
    ,CNTPR_NM              --交易对手名称
    ,CRDT_CNTPR_TYP        --信贷交易对手类型
    ,CUR                   --币种
    ,TRF_PRIN_TOT_AMT      --转让贷款本金总额
    ,TRF_INT_TOT_AMT       --转让贷款利息总额
    ,TRF_TOT_PRC           --转让总价
    ,TRF_CNCL_AMT          --转让核销金额
    ,TRF_RETRV_CASH_AMT    --转让收回现金金额
    ,NOT_TRF_SLF_HOLD_AMT  --未转让自持金额
    ,LOSS_AMT              --损失金额
    ,TRF_RETRV_OTH_AMT     --转让收回其他对价
    ,TRF_CONT_START_DT     --转让合同起始日期
    ,TRF_CONT_EXP_DT       --转让合同到期日期
    ,TRF_ETR_ACC           --转让价款入账账号
    ,TRF_ENTR_ACC_NM       --转让价款入账账户名称
    ,CNTPR_TRF_ACC         --交易对手转账账号
    ,CNTPR_TRF_ACC_NM      --交易对手转账账号开户行行名
    ,CNTPR_TRF_DT          --交易对手转账日期
    ,CNTPR_ALDY_PAY_AMT    --交易对手已支付金额
    ,MRGN_PCT              --保证金比例
    ,MRGN_CUR              --保证金币种
    ,MRGN                  --保证金
    ,AST_TRF_MODE          --资产转让方式
    ,TRA_PLTF              --交易平台
    ,YD_CNTR_REGD_AMT      --银登中心登记金额
    ,BANK_TRF_FLG          --行内转让标志
    ,BATCH_TRF_FLG         --批量转让标志
    ,TRF_DRC               --转让方向
    ,TRF_CONT_STAT         --转让合同状态
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,TRF_SLF_HOLD_AMT      --转让自持金额
    ,ASSET_TRAN_DT         --资产转让日期
    ,ADVC_SUIT_FEE         --代垫诉讼费
    ,TRA_SEQ_NO            --核心交易流水号
    ,CNTPR_TRF_END_DT      --最终交易对手支付日期
    ,OTH_TRA_PLTF          --其他交易平台描述
    ,PROP_ID               --方案编号 --ADD BY 20231109 方便核数
    ,LOAN_BIZ_TYP          --信贷资产类型 --ADD 20240204
    ,RGST_TELLER_ID        --登记柜员编号 ADD BY XZY 20250415
    ,CNTPR_TRF_ACC_BANK_NO --交易对手转账账号开户行行号 --ADD BY LIP 20250822
    ,OPER_USER_ID          --经办员工ID --ADD BY LIP 20250912
    ,CHECK_USER_ID         --审查员工ID --ADD BY LIP 20250912
    ,LAST_CHECK_USER_ID    --审批员工ID --ADD BY LIP 20250912
    ,TRF_CONT_SIGN_DT      --转让合同签约日期 ADD BY LIP 20251117
    ,CNTPR_TRF_CERT_TYPE_CD--对手方证件类型代码 ADD BY LIP 20251117
    ,CNTPR_TRF_CERT_NO     --对手方证件号码 ADD BY LIP 20251117
    ,CUST_NAME             --客户名称 --ADD BY LIP 20251216
    )
    WITH RETRUN_INFO AS (--回款数据
  SELECT RELA_FLOW_NUM                  AS RELA_FLOW_NUM,
         SUM(THS_TM_RETURN_AMT)         AS RETURN_AMT,
         MAX(TRUNC(TRANE_TRAN_ACCT_DT)) AS TRANE_TRAN_ACCT_DT,
         MAX(TRUNC(RGST_DT))            AS RGST_DT
    FROM RRP_MDL.O_IML_AGT_ASTCONSV_APPL_INFO_H T1
   WHERE T1.OBJ_TYPE_CD = 'InstRepaymentApply'
     AND T1.APV_STATUS_CD = 'Finished'
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY RELA_FLOW_NUM)/*,
  TRAN_CONT_ID_INFO_GD AS ( --MOD BY LIP 20251218 詹宏真提供的需要默认的字段
  SELECT '2023081400000001' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'' CNTPR_TRF_ACC,'兴业银行股份有限公司深圳和平支行' CNTPR_TRF_ACC_NM,
         '20230829' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'309584008070' CNTPR_TRF_ACC_BANK_NO,'20230626' TRF_CONT_SIGN_DT,'2313' CNTPR_TRF_CERT_TYPE_CD,
         '914403000878551150' CNTPR_TRF_CERT_NO,'2023081400000001' PROP_ID,'' CNTPR_TRF_END_DT
  FROM DUAL UNION ALL
  SELECT '2023122600000011' TRF_CONT_ID,'广州粤沁贸易有限公司' CNTPR_NM,'20231225' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'210000570551' CNTPR_TRF_ACC,
         '广东华兴银行股份有限公司广州分行' CNTPR_TRF_ACC_NM,'' CNTPR_TRF_DT,\*120500000*\120000000 CNTPR_ALDY_PAY_AMT,'313581092013' CNTPR_TRF_ACC_BANK_NO,
         '20231225' TRF_CONT_SIGN_DT,'2313' CNTPR_TRF_CERT_TYPE_CD,'91440106MAD3DRR77A' CNTPR_TRF_CERT_NO,'2023122600000011' PROP_ID,'' CNTPR_TRF_END_DT
  FROM DUAL UNION ALL
  SELECT '2023122800000010' TRF_CONT_ID,'深圳绿色家园装饰工程有限公司' CNTPR_NM,'20231227' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'650945117700015' CNTPR_TRF_ACC,
         '深圳福田银座村镇银行股份有限公司横岗支行' CNTPR_TRF_ACC_NM,'' CNTPR_TRF_DT,105000000 CNTPR_ALDY_PAY_AMT,'320584002027' CNTPR_TRF_ACC_BANK_NO,
         '20231227' TRF_CONT_SIGN_DT,'2313' CNTPR_TRF_CERT_TYPE_CD,'91440300MA5DQWUK16' CNTPR_TRF_CERT_NO,'2023122800000010' PROP_ID,'' CNTPR_TRF_END_DT
  FROM DUAL UNION ALL
  SELECT '20241211资产转让001' TRF_CONT_ID,'' CNTPR_NM,'20241217' TRF_CONT_START_DT,'20251130' TRF_CONT_EXP_DT,'6230583000000638017' CNTPR_TRF_ACC,
         '平安银行股份有限公司广州番禺支行' CNTPR_TRF_ACC_NM,'20241219' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'307581008980' CNTPR_TRF_ACC_BANK_NO,
         '20241217' TRF_CONT_SIGN_DT,'1010' CNTPR_TRF_CERT_TYPE_CD,'440126196810315724' CNTPR_TRF_CERT_NO,'' PROP_ID,'' CNTPR_TRF_END_DT
  FROM DUAL UNION ALL
  SELECT '20241224001' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'' CNTPR_TRF_ACC,
         '' CNTPR_TRF_ACC_NM,'20241231' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'' CNTPR_TRF_ACC_BANK_NO,
         '' TRF_CONT_SIGN_DT,'' CNTPR_TRF_CERT_TYPE_CD,'' CNTPR_TRF_CERT_NO,'' PROP_ID,'' CNTPR_TRF_END_DT
  FROM DUAL UNION ALL
  SELECT 'HXGF20250103001' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'' CNTPR_TRF_ACC,
         '' CNTPR_TRF_ACC_NM,'20250103' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'' CNTPR_TRF_ACC_BANK_NO,
         '' TRF_CONT_SIGN_DT,'' CNTPR_TRF_CERT_TYPE_CD,'' CNTPR_TRF_CERT_NO,'' PROP_ID,'' CNTPR_TRF_END_DT
  FROM DUAL UNION ALL
  SELECT 'HXZS202411CDSY' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'7332810182600065003' CNTPR_TRF_ACC,
         '中信银行杭州湖墅支行' CNTPR_TRF_ACC_NM,'' CNTPR_TRF_DT,NULL CNTPR_ALDY_PAY_AMT,'302331033284' CNTPR_TRF_ACC_BANK_NO,
         '' TRF_CONT_SIGN_DT,'' CNTPR_TRF_CERT_TYPE_CD,'' CNTPR_TRF_CERT_NO,'' PROP_ID,'' CNTPR_TRF_END_DT
  FROM DUAL UNION ALL
  SELECT 'ZZ20241212001' TRF_CONT_ID,'' CNTPR_NM,'' TRF_CONT_START_DT,'' TRF_CONT_EXP_DT,'' CNTPR_TRF_ACC,
         '' CNTPR_TRF_ACC_NM,'' CNTPR_TRF_DT,1000000 CNTPR_ALDY_PAY_AMT,'' CNTPR_TRF_ACC_BANK_NO,
         '' TRF_CONT_SIGN_DT,'' CNTPR_TRF_CERT_TYPE_CD,'' CNTPR_TRF_CERT_NO,'' PROP_ID,'20250714' CNTPR_TRF_END_DT
  FROM DUAL)*/
  SELECT V_P_DATE                                            AS DATA_DT                   --数据日期
        ,MAX(T1.LP_ID)                                       AS LGL_REP_ID                --法人编号
        ,NVL(TRIM(T1.TRAN_CONT_ID),TRIM(T1.APPL_FLOW_NUM))   AS TRF_CONT_ID               --转让合同号
        ,MAX(T1.RGST_BELONG_ORG_ID)                          AS ORG_ID                    --机构编号
        --,MAX(TRIM(T1.CNTPTY_ID))                             AS CNTPR_NM                  --交易对手名称
        ,MAX(NVL(T12.CNTPR_NM,TRIM(T1.CNTPTY_ID)))           AS CNTPR_NM                  --交易对手名称 --MOD BY LIP 20251219
        ,MAX(CASE WHEN T12.CNTPR_TRF_CERT_NO LIKE '1%' THEN '30' --MOD BY LIP 20251219
                  WHEN T1.TRANE_CERT_TYPE_CD LIKE '1%' THEN '30'
             END)                                            AS CRDT_CNTPR_TYP            --信贷交易对手类型 --CD2115 --源系统暂时没有这个字段
        --,MAX(NVL(TRIM(T1.AGT_CURR_CD),T3.CURR_CD))           AS CUR                       --币种
        --,MAX(T3.CURR_CD)                                     AS CUR                       --币种  --MOD BY 20251122
        ,MAX(NVL(TRIM(REPLACE(T1.AGT_CURR_CD,'-')),T3.CURR_CD)) AS CUR                       --币种  --MOD BY 20251209
        --,MAX(NVL(T1.THS_TM_TRAN_PRIC_SUM,0))                 AS TRF_PRIN_TOT_AMT          --转让贷款本金
        --,SUM(NVL(T2.DERATE_PROVI_COMP_INT,0)+NVL(T2.DERATE_PROVI_INT,0)+NVL(T2.DERATE_PROVI_PNLT,0)) AS TRF_INT_TOT_AMT --转让贷款利息
        /*--MOD BY LIP 20251203 根据詹宏真口径：取借据层的：
        转让本金总额：正常本金+逾期本金
        转让利息总额：计提利息+实欠利息+计提罚息+实欠罚息+计提付息+实欠复息
        DERATE_PROVI_INT +DERATE_ACTL_OWE_INT+DERATE_PROVI_PNLT+DERATE_ACTL_OWE_PNLT+DERATE_PROVI_COMP_INT+DERATE_ACTL_OWE_COMP_INT*/
        ,SUM(NVL(T2.DERATE_PRIC,0)+NVL(T2.DERATE_OVDUE_PRIC,0)) AS TRF_PRIN_TOT_AMT          --转让贷款本金
        ,SUM(NVL(T2.DERATE_PROVI_INT,0)+NVL(T2.DERATE_ACTL_OWE_INT,0)+NVL(T2.DERATE_PROVI_PNLT,0)+NVL(T2.DERATE_ACTL_OWE_PNLT,0)+
             NVL(T2.DERATE_PROVI_COMP_INT,0)+NVL(T2.DERATE_ACTL_OWE_COMP_INT,0)) AS TRF_INT_TOT_AMT --转让贷款利息
        ,MAX(T1.TRAN_PRICE)                                  AS TRF_TOT_PRC               --转让总价
        ,0                                                   AS TRF_CNCL_AMT              --转让核销金额
        ,0                                                   AS TRF_RETRV_CASH_AMT        --转让收回现金金额
        ,0                                                   AS NOT_TRF_SLF_HOLD_AMT      --未转让自持金额
        ,0                                                   AS LOSS_AMT                  --损失金额
        ,0                                                   AS TRF_RETRV_OTH_AMT         --转让收回其他对价
        ,MAX(CASE WHEN T12.TRF_CONT_START_DT IS NOT NULL THEN T12.TRF_CONT_START_DT --MOD BY LIP 20251219
                  WHEN TO_CHAR(T1.EFFECT_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T1.EFFECT_DT,'YYYYMMDD')
                  ELSE NULL
              END)                                           AS TRF_CONT_START_DT         --转让合同起始日期
        ,MAX(CASE WHEN T12.TRF_CONT_EXP_DT IS NOT NULL THEN T12.TRF_CONT_EXP_DT --MOD BY LIP 20251219
                  ELSE NULL
              END)                                           AS TRF_CONT_EXP_DT           --转让合同到期日期 --一表通NULL
        ,MAX(TRIM(T1.TRAN_RETURN_ACCT_ID))                   AS TRF_ETR_ACC               --转让价款入账账号
        ,MAX(T4.CUST_ACCT_NAME)                              AS TRF_ENTR_ACC_NM           --转让价款入账账户名称
        --,MAX(TRIM(T1.TRANE_ACCT_ID))                         AS CNTPR_TRF_ACC             --交易对手转账账号
        --,MAX(T7.BKNAME)                                      AS CNTPR_TRF_ACC_NM          --交易对手转账账号开户行行名
        ,MAX(NVL(T12.CNTPR_TRF_ACC,TRIM(T1.TRANE_ACCT_ID)))  AS CNTPR_TRF_ACC             --交易对手转账账号 --MOD BY LIP 20251219
        ,MAX(NVL(T12.CNTPR_TRF_ACC_NM,T7.BKNAME))            AS CNTPR_TRF_ACC_NM          --交易对手转账账号开户行行名 --MOD BY LIP 20251219
        ,MAX(CASE WHEN T12.CNTPR_TRF_DT IS NOT NULL THEN T12.CNTPR_TRF_DT --MOD BY LIP 20251219
                  WHEN TO_CHAR(T1.TRANE_TRAN_ACCT_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T1.TRANE_TRAN_ACCT_DT,'YYYYMMDD')
                  ELSE '99991231'
              END)                                           AS CNTPR_TRF_DT              --交易对手转账日期 --如果有多次转账的，填报首笔转让价款转入日期，非定金日期。
        --,MAX(NVL(T1.FST_RETURN_AMT,0)+NVL(T8.RETURN_AMT,0))  AS CNTPR_ALDY_PAY_AMT        --交易对手已支付金额
        ,MAX(CASE WHEN T12.TRF_CONT_ID IS NOT NULL AND T12.CNTPR_ALDY_PAY_AMT IS NOT NULL
                  THEN T12.CNTPR_ALDY_PAY_AMT
                  ELSE NVL(T1.FST_RETURN_AMT,0)+NVL(T8.RETURN_AMT,0)
              END)                                           AS CNTPR_ALDY_PAY_AMT        --交易对手已支付金额 --MOD BY LIP 20260115
        ,MAX(NVL(T1.MARGIN_RATIO,0))                         AS MRGN_PCT                  --保证金比例
        --,MAX(TRIM(T1.MARGIN_CURR_CD))                        AS MRGN_CUR                  --保证金币种
        --,MAX(T3.CURR_CD)                                     AS MRGN_CUR                  --保证金币种
        ,MAX(NVL(TRIM(REPLACE(T1.MARGIN_CURR_CD,'-')),T3.CURR_CD)) AS MRGN_CUR            --保证金币种
        ,MAX(NVL(T1.MARGIN_AMT,0))                           AS MRGN                      --保证金
        ,'01'                                                AS AST_TRF_MODE              --资产转让方式 --直接转让
        ,MAX(CASE WHEN T1.TRAN_PLAT_CD IN ('03') THEN '01' --银登中心
                  WHEN T1.TRAN_PLAT_CD IN ('01') THEN '02' --证券交易所
                  WHEN T1.TRAN_PLAT_CD IN ('02') THEN '03' --银行间市场
                  ELSE '99'
              END)                                           AS TRA_PLTF                  --交易平台 CD3118
        ,0                                                   AS YD_CNTR_REGD_AMT          --银登中心登记金额
        ,NULL                                                AS BANK_TRF_FLG              --行内转让标志
        ,NULL                                                AS BATCH_TRF_FLG             --批量转让标志
        ,'02'                                                AS TRF_DRC                   --转让方向
        ,MAX(CASE WHEN NVL(T1.FST_RETURN_AMT,0)+NVL(T8.RETURN_AMT,0) >= T1.TRAN_PRICE THEN '07'
                  WHEN T12.TRF_CONT_ID IS NOT NULL AND NVL(T12.CNTPR_ALDY_PAY_AMT,0) = NVL(T1.TRAN_PRICE,0)
                       AND T12.CNTPR_TRF_END_DT IS NOT NULL
                  THEN '07' --MOD BY LIP 20260115
                  ELSE '02'
              END)                                           AS TRF_CONT_STAT             --转让合同状态
        ,'800919'                                            AS DEPT_LINE                 --部门条线/*风险管理部*/
        ,MAX(CASE WHEN T3.DUBIL_ID IS NOT NULL THEN '对公贷款资产保全' END) AS DATA_SRC   --数据来源
        ,NULL                                                AS TRF_SLF_HOLD_AMT          --转让自持金额
        /*,MAX(CASE WHEN TO_CHAR(T1.RGST_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T1.RGST_DT,'YYYYMMDD')
              END)                                           AS ASSET_TRAN_DT             --资产转让日期*/
        --MOD BY LIP 20251218 转让日期改成取核心的账务处理日期
        ,MAX(CASE WHEN NVL(TO_CHAR(T11.CLOS_ACCT_DT,'YYYYMMDD'),'20991231') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T11.CLOS_ACCT_DT,'YYYYMMDD')
                  WHEN  NVL(TO_CHAR(T11.ASSET_TRAN_DT,'YYYYMMDD'),'20991231') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T11.ASSET_TRAN_DT,'YYYYMMDD')
                  WHEN  NVL(TO_CHAR(T1.RGST_DT,'YYYYMMDD'),'20991231') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T1.RGST_DT,'YYYYMMDD')
              END)                                           AS ASSET_TRAN_DT             --资产转让日期
        ,NULL                                                AS ADVC_SUIT_FEE             --代垫诉讼费
        ,MAX(TRIM(T2.CORE_RETURN_REST))                      AS TRA_SEQ_NO                --核心交易流水号
        ,MAX(CASE WHEN T1.TRAN_PRICE = T1.FST_RETURN_AMT AND TO_CHAR(T1.TRANE_TRAN_ACCT_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T1.TRANE_TRAN_ACCT_DT,'YYYYMMDD')
                  WHEN T12.TRF_CONT_ID IS NOT NULL AND NVL(T12.CNTPR_ALDY_PAY_AMT,0) = NVL(T1.TRAN_PRICE,0)
                       AND T12.CNTPR_TRF_END_DT IS NOT NULL
                  THEN T12.CNTPR_TRF_END_DT --MOD BY LIP 20260115
                  WHEN T1.TRAN_PRICE = NVL(T1.FST_RETURN_AMT,0)+NVL(T8.RETURN_AMT,0)
                       AND TO_CHAR(T8.RGST_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T8.RGST_DT,'YYYYMMDD')
                  ELSE '99991231'
              END)                                           AS CNTPR_TRF_END_DT          --最终交易对手支付日期
        ,MAX(T5.CD_DESCB)                                    AS OTH_TRA_PLTF              --其他交易平台描述
        ,MAX(TRIM(T1.PROP_ID))                               AS PROP_ID                   --方案编号
        ,MIN(CASE WHEN T3.DUBIL_ID IS NOT NULL THEN '002' --对公贷款
             END)                                            AS LOAN_BIZ_TYP              --信贷资产类型
        ,MIN(T1.RGST_TELLER_ID)                              AS RGST_TELLER_ID            --登记柜员编号
        --,MAX(TRIM(T1.TRANE_BANK_NO))                         AS CNTPR_TRF_ACC_BANK_NO     --交易对手转账账号开户行行号
        ,MAX(NVL(T12.CNTPR_TRF_ACC_BANK_NO,TRIM(T1.TRANE_BANK_NO))) AS CNTPR_TRF_ACC_BANK_NO     --交易对手转账账号开户行行号 --MOD BY LIP 20251219
        ,MAX(T1.OPER_TELLER_ID)                              AS OPER_USER_ID              --经办员工ID
        ,MAX(T6.CHECK_USER_ID)                               AS CHECK_USER_ID             --审查员工ID
        --,MAX(T6.LAST_CHECK_USER_ID)                          AS LAST_CHECK_USER_ID        --审批员工ID
        --MOD BY LIP 20251204 根据詹宏真口径，审批人员ID取总行行长员工ID
        ,MAX(CASE WHEN T10.LAST_CHECK_USER_ID IS NOT NULL THEN T10.LAST_CHECK_USER_ID
                  ELSE T9.CLERK_ID
              END)                                           AS LAST_CHECK_USER_ID        --审批员工ID
        ,MAX(CASE WHEN T12.TRF_CONT_SIGN_DT IS NOT NULL THEN T12.TRF_CONT_SIGN_DT --MOD BY LIP 20251219
                  WHEN TO_CHAR(T1.SIGN_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
                  THEN TO_CHAR(T1.SIGN_DT,'YYYYMMDD')
                  ELSE NULL
              END)                                           AS TRF_CONT_SIGN_DT          --转让合同签约日期
        --,MAX(TRIM(T1.TRANE_CERT_TYPE_CD))                    AS CNTPR_TRF_CERT_TYPE_CD    --对手方证件类型代码 ADD BY LIP 20251117
        --,MAX(TRIM(T1.TRANE_CERT_NO))                         AS CNTPR_TRF_CERT_NO         --对手方证件号码 ADD BY LIP 20251117
        ,MAX(NVL(T12.CNTPR_TRF_CERT_TYPE_CD,TRIM(T1.TRANE_CERT_TYPE_CD))) AS CNTPR_TRF_CERT_TYPE_CD    --对手方证件类型代码 ADD BY LIP 20251219
        ,MAX(NVL(T12.CNTPR_TRF_CERT_NO,TRIM(T1.TRANE_CERT_NO))) AS CNTPR_TRF_CERT_NO         --对手方证件号码 ADD BY LIP 20251219
        ,MAX(TRIM(T1.CUST_NAME))                             AS CUST_NAME                 --客户名称 --ADD BY LIP 20251216
    FROM RRP_MDL.O_IML_AGT_ASTCONSV_APPL_INFO_H T1 --资产保全申请信息历史 PRDICMS.ASSET_PRESERVATION_APPLY
   INNER JOIN RRP_MDL.O_IML_AGT_ASTCONSV_DUBIL_RELA_H T2 --资产保全（贷后）关联表 PRDICMS.AP_AFTERLOAN_RELATIVE
      ON T2.FLOW_NUM = T1.APPL_FLOW_NUM
     AND T2.BUS_TYPE_CD IN ('BadLoansTransferApply')
     AND TRIM(T2.CORE_RETURN_REST) IS NOT NULL --交易流水号不为空
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO T3
      ON T3.DUBIL_ID = T2.RELA_FLOW_NUM
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO T4
      ON T4.CUST_ACCT_ID = TRIM(T1.TRAN_RETURN_ACCT_ID)
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD T5
      ON T5.CD_VAL = T1.TRAN_PLAT_CD
     AND T5.CD_ID = 'CD3118'
     --AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --MOD BY LIP 20250105
    LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO_TEMP01 T6 --ADD BY LIP 20250912 增加审批人员的取数
      ON T6.OBJECTNO = T1.APPL_FLOW_NUM
     AND T6.OBJECTTYPE IN ('BadLoansTransferApply')
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO T7 --中台机构信息表 --ADD BY LIP 20250822 模型中的交易对手开户行名称是行号，需进行转换
      ON T7.BKCD = TRIM(T1.TRANE_BANK_NO)
     AND T7.ID_MARK <> 'D'
     AND T7.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T7.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RETRUN_INFO T8 --回款金额数据
      ON T8.RELA_FLOW_NUM = TRIM(T1.APPL_FLOW_NUM)
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO T9 --行员信息表 --ADD BY LIP 20251204 根据业务口径，审批人员ID取总行行长员工ID
      ON T9.POST_CD = 'HXGJ001' --总行行长
     AND T9.EMPLY_STATUS_CD = '1' --在职
     AND T9.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO T10 --因行长会变化，所以审批人员优先取上一天的审批人员ID
      ON T10.TRF_CONT_ID = NVL(TRIM(T1.TRAN_CONT_ID),TRIM(T1.APPL_FLOW_NUM))
     AND T10.DATA_SRC = '对公贷款资产保全'
     AND T10.DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T11 --对公贷款账户信息 --ADD BY LIP 20251218
      ON T11.DUBIL_NUM = T2.RELA_FLOW_NUM
     AND T11.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --LEFT JOIN TRAN_CONT_ID_INFO_GD T12 --ADD BY LIP 20251219 詹宏真提供的需写死的字段
    LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO_TEMP03 T12  --MOD BY LIP 20260115 将数据存入到实体表中
      ON T12.TRF_CONT_ID = NVL(TRIM(T1.TRAN_CONT_ID),TRIM(T1.APPL_FLOW_NUM))
     AND T12.TRF_CONT_ID IS NOT NULL
   WHERE T1.APV_STATUS_CD = 'Finished'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY NVL(TRIM(T1.TRAN_CONT_ID),TRIM(T1.APPL_FLOW_NUM));
   
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20251209 对资产转让合同的信息进行汇总
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入信贷资产转让信息_合同汇总维度信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_TRF_INFO_CT
    (DATA_DT                   --数据日期
    ,LGL_REP_ID                --法人编号
    ,TRF_CONT_ID               --转让合同号
    ,ORG_ID                    --机构编号
    ,CNTPR_NM                  --交易对手名称
    ,CRDT_CNTPR_TYP            --信贷交易对手类型
    ,CUR                       --币种
    ,TRF_PRIN_TOT_AMT          --转让贷款本金总额
    ,TRF_INT_TOT_AMT           --转让贷款利息总额
    ,TRF_TOT_PRC               --转让总价
    ,TRF_CNCL_AMT              --转让核销金额
    ,TRF_RETRV_CASH_AMT        --转让收回现金金额
    ,NOT_TRF_SLF_HOLD_AMT      --未转让自持金额
    ,LOSS_AMT                  --损失金额
    ,TRF_RETRV_OTH_AMT         --转让收回其他对价
    ,TRF_CONT_START_DT         --转让合同起始日期
    ,TRF_CONT_EXP_DT           --转让合同到期日期
    ,TRF_ETR_ACC               --转让价款入账账号
    ,TRF_ENTR_ACC_NM           --转让价款入账账户名称
    ,CNTPR_TRF_ACC             --交易对手转账账号
    ,CNTPR_TRF_ACC_NM          --交易对手转账账号开户行行名
    ,CNTPR_TRF_DT              --交易对手转账日期
    ,CNTPR_ALDY_PAY_AMT        --交易对手已支付金额
    ,MRGN_PCT                  --保证金比例
    ,MRGN_CUR                  --保证金币种
    ,MRGN                      --保证金
    ,AST_TRF_MODE              --资产转让方式
    ,TRA_PLTF                  --交易平台
    ,YD_CNTR_REGD_AMT          --银登中心登记金额
    ,BANK_TRF_FLG              --行内转让标志
    ,BATCH_TRF_FLG             --批量转让标志
    ,TRF_DRC                   --转让方向
    ,TRF_CONT_STAT             --转让合同状态
    ,DEPT_LINE                 --部门条线
    ,DATA_SRC                  --数据来源
    ,TRF_LVL5_CL               --转让时五级分类
    ,BGN_YEAR_LOAN_LVL5_CL     --年初五级分类
    ,LOAN_TRF_CHAR             --信贷资产转让性质
    ,TRF_SLF_HOLD_AMT          --转让自持金额
    ,ASSET_POOL_ID             --资产池编号
    ,ASSET_TRAN_DT             --转让日期
    ,ADVC_SUIT_FEE             --代垫诉讼费
    ,TRA_SEQ_NO                --核心交易流水号
    ,CNTPR_TRF_END_DT          --最终交易对手支付日期
    ,OTH_TRA_PLTF              --其他交易平台描述
    ,PROP_ID                   --方案编号
    ,LOAN_BIZ_TYP              --信贷资产类型
    ,RGST_TELLER_ID            --登记柜员编号
    ,CNTPR_TRF_ACC_BANK_NO     --交易对手转账账号开户行行号
    ,OPER_USER_ID              --经办员工ID
    ,CHECK_USER_ID             --审查员工ID
    ,LAST_CHECK_USER_ID        --审批员工ID
    ,TRF_CONT_SIGN_DT          --转让合同签约日期
    ,CNTPR_TRF_CERT_TYPE_CD    --对手方证件类型代码
    ,CNTPR_TRF_CERT_NO         --对手方证件号码
    ,CUST_NAME                 --客户名称 --ADD BY LIP 20251216
    )
    WITH LOAN_TRF_INFO_TMP AS (
  SELECT V_P_DATE                                            AS DATA_DT                   --数据日期
        ,T1.LGL_REP_ID                                       AS LGL_REP_ID                --法人编号
        ,REGEXP_REPLACE(T1.TRF_CONT_ID,'[[:space:]]')        AS TRF_CONT_ID               --转让合同号
        ,TRIM(T1.ORG_ID)                                     AS ORG_ID                    --机构编号
        ,TRIM(T1.CNTPR_NM)                                   AS CNTPR_NM                  --交易对手名称
        ,TRIM(T1.CRDT_CNTPR_TYP)                             AS CRDT_CNTPR_TYP            --信贷交易对手类型
        ,TRIM(T1.CUR)                                        AS CUR                       --币种
        ,SUM(NVL(T1.TRF_PRIN_TOT_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)     AS TRF_PRIN_TOT_AMT          --转让贷款本金总额
        ,SUM(NVL(T1.TRF_INT_TOT_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)      AS TRF_INT_TOT_AMT           --转让贷款利息总额
        ,SUM(NVL(T1.TRF_TOT_PRC,0)) OVER(PARTITION BY T1.TRF_CONT_ID)          AS TRF_TOT_PRC               --转让总价
        ,SUM(NVL(T1.TRF_CNCL_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)         AS TRF_CNCL_AMT              --转让核销金额
        ,SUM(NVL(T1.TRF_RETRV_CASH_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)   AS TRF_RETRV_CASH_AMT        --转让收回现金金额
        ,SUM(NVL(T1.NOT_TRF_SLF_HOLD_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID) AS NOT_TRF_SLF_HOLD_AMT      --未转让自持金额
        ,SUM(NVL(T1.LOSS_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)             AS LOSS_AMT                  --损失金额
        ,SUM(NVL(T1.TRF_RETRV_OTH_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)    AS TRF_RETRV_OTH_AMT         --转让收回其他对价
        ,TRIM(T1.TRF_CONT_START_DT)                          AS TRF_CONT_START_DT         --转让合同起始日期
        ,TRIM(T1.TRF_CONT_EXP_DT)                            AS TRF_CONT_EXP_DT           --转让合同到期日期
        ,TRIM(T1.TRF_ETR_ACC)                                AS TRF_ETR_ACC               --转让价款入账账号
        ,TRIM(T1.TRF_ENTR_ACC_NM)                            AS TRF_ENTR_ACC_NM           --转让价款入账账户名称
        ,TRIM(T1.CNTPR_TRF_ACC)                              AS CNTPR_TRF_ACC             --交易对手转账账号
        ,TRIM(T1.CNTPR_TRF_ACC_NM)                           AS CNTPR_TRF_ACC_NM          --交易对手转账账号开户行行名
        ,TRIM(T1.CNTPR_TRF_DT)                               AS CNTPR_TRF_DT              --交易对手转账日期
        ,SUM(NVL(T1.CNTPR_ALDY_PAY_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)   AS CNTPR_ALDY_PAY_AMT        --交易对手已支付金额
        ,NVL(T1.MRGN_PCT,0)                                  AS MRGN_PCT                  --保证金比例
        ,TRIM(T1.MRGN_CUR)                                   AS MRGN_CUR                  --保证金币种
        ,NVL(T1.MRGN,0)                                      AS MRGN                      --保证金
        ,TRIM(T1.AST_TRF_MODE)                               AS AST_TRF_MODE              --资产转让方式
        ,TRIM(T1.TRA_PLTF)                                   AS TRA_PLTF                  --交易平台
        ,SUM(NVL(T1.YD_CNTR_REGD_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)     AS YD_CNTR_REGD_AMT          --银登中心登记金额
        ,TRIM(T1.BANK_TRF_FLG)                               AS BANK_TRF_FLG              --行内转让标志
        ,TRIM(T1.BATCH_TRF_FLG)                              AS BATCH_TRF_FLG             --批量转让标志
        ,TRIM(T1.TRF_DRC)                                    AS TRF_DRC                   --转让方向
        ,TRIM(T1.TRF_CONT_STAT)                              AS TRF_CONT_STAT             --转让合同状态
        ,TRIM(T1.DEPT_LINE)                                  AS DEPT_LINE                 --部门条线
        ,TRIM(T1.DATA_SRC)                                   AS DATA_SRC                  --数据来源
        ,TRIM(T1.TRF_LVL5_CL)                                AS TRF_LVL5_CL               --转让时五级分类
        ,TRIM(T1.BGN_YEAR_LOAN_LVL5_CL)                      AS BGN_YEAR_LOAN_LVL5_CL     --年初五级分类
        ,TRIM(T1.LOAN_TRF_CHAR)                              AS LOAN_TRF_CHAR             --信贷资产转让性质
        ,SUM(NVL(T1.TRF_SLF_HOLD_AMT,0)) OVER(PARTITION BY T1.TRF_CONT_ID)     AS TRF_SLF_HOLD_AMT          --转让自持金额
        ,TRIM(T1.ASSET_POOL_ID)                              AS ASSET_POOL_ID             --资产池编号
        ,TRIM(T1.ASSET_TRAN_DT)                              AS ASSET_TRAN_DT             --转让日期
        ,SUM(NVL(T1.ADVC_SUIT_FEE,0)) OVER(PARTITION BY T1.TRF_CONT_ID)        AS ADVC_SUIT_FEE             --代垫诉讼费
        ,TRIM(T1.TRA_SEQ_NO)                                 AS TRA_SEQ_NO                --核心交易流水号
        ,TRIM(T1.CNTPR_TRF_END_DT)                           AS CNTPR_TRF_END_DT          --最终交易对手支付日期
        ,TRIM(T1.OTH_TRA_PLTF)                               AS OTH_TRA_PLTF              --其他交易平台描述
        ,TRIM(T1.PROP_ID)                                    AS PROP_ID                   --方案编号
        ,TRIM(T1.LOAN_BIZ_TYP)                               AS LOAN_BIZ_TYP              --信贷资产类型
        ,TRIM(T1.RGST_TELLER_ID)                             AS RGST_TELLER_ID            --登记柜员编号
        ,TRIM(T1.CNTPR_TRF_ACC_BANK_NO)                      AS CNTPR_TRF_ACC_BANK_NO     --交易对手转账账号开户行行号
        ,TRIM(T1.OPER_USER_ID)                               AS OPER_USER_ID              --经办员工ID
        ,TRIM(T1.CHECK_USER_ID)                              AS CHECK_USER_ID             --审查员工ID
        ,TRIM(T1.LAST_CHECK_USER_ID)                         AS LAST_CHECK_USER_ID        --审批员工ID
        ,TRIM(T1.TRF_CONT_SIGN_DT)                           AS TRF_CONT_SIGN_DT          --转让合同签约日期
        ,TRIM(T1.CNTPR_TRF_CERT_TYPE_CD)                     AS CNTPR_TRF_CERT_TYPE_CD    --对手方证件类型代码
        ,TRIM(T1.CNTPR_TRF_CERT_NO)                          AS CNTPR_TRF_CERT_NO         --对手方证件号码
        ,TRIM(T1.CUST_NAME)                                  AS CUST_NAME                 --客户名称 --ADD BY LIP 20251216
        ,ROW_NUMBER() OVER(PARTITION BY REGEXP_REPLACE(T1.TRF_CONT_ID,'[[:space:]]') ORDER BY CASE WHEN T1.DATA_SRC = '对公贷款资产保全' THEN 1 ELSE 2 END) RN
    FROM RRP_MDL.M_LOAN_TRF_INFO T1
   WHERE T1.DATA_DT = V_P_DATE)
  SELECT V_P_DATE                                            AS DATA_DT                   --数据日期
        ,T1.LGL_REP_ID                                       AS LGL_REP_ID                --法人编号
        ,T1.TRF_CONT_ID                                      AS TRF_CONT_ID               --转让合同号
        ,NVL(T1.ORG_ID,T2.ORG_ID)                            AS ORG_ID                    --机构编号
        ,NVL(T1.CNTPR_NM,T2.CNTPR_NM)                        AS CNTPR_NM                  --交易对手名称
        ,NVL(T1.CRDT_CNTPR_TYP,T2.CRDT_CNTPR_TYP)            AS CRDT_CNTPR_TYP            --信贷交易对手类型
        ,NVL(T1.CUR,T2.CUR)                                  AS CUR                       --币种
        ,NVL(T1.TRF_PRIN_TOT_AMT,0)                          AS TRF_PRIN_TOT_AMT          --转让贷款本金总额
        ,NVL(T1.TRF_INT_TOT_AMT,0)                           AS TRF_INT_TOT_AMT           --转让贷款利息总额
        ,NVL(T1.TRF_TOT_PRC,0)                               AS TRF_TOT_PRC               --转让总价
        ,NVL(T1.TRF_CNCL_AMT,0)                              AS TRF_CNCL_AMT              --转让核销金额
        ,NVL(T1.TRF_RETRV_CASH_AMT,0)                        AS TRF_RETRV_CASH_AMT        --转让收回现金金额
        ,NVL(T1.NOT_TRF_SLF_HOLD_AMT,0)                      AS NOT_TRF_SLF_HOLD_AMT      --未转让自持金额
        ,NVL(T1.LOSS_AMT,0)                                  AS LOSS_AMT                  --损失金额
        ,NVL(T1.TRF_RETRV_OTH_AMT,0)                         AS TRF_RETRV_OTH_AMT         --转让收回其他对价
        ,NVL(T1.TRF_CONT_START_DT,T2.TRF_CONT_START_DT)      AS TRF_CONT_START_DT         --转让合同起始日期
        ,NVL(T1.TRF_CONT_EXP_DT,T2.TRF_CONT_EXP_DT)          AS TRF_CONT_EXP_DT           --转让合同到期日期
        ,NVL(T1.TRF_ETR_ACC,T2.TRF_ETR_ACC)                  AS TRF_ETR_ACC               --转让价款入账账号
        ,NVL(T1.TRF_ENTR_ACC_NM,T2.TRF_ENTR_ACC_NM)          AS TRF_ENTR_ACC_NM           --转让价款入账账户名称
        ,NVL(T1.CNTPR_TRF_ACC,T2.CNTPR_TRF_ACC)              AS CNTPR_TRF_ACC             --交易对手转账账号
        ,NVL(T1.CNTPR_TRF_ACC_NM,T2.CNTPR_TRF_ACC_NM)        AS CNTPR_TRF_ACC_NM          --交易对手转账账号开户行行名
        ,CASE WHEN NVL(T1.CNTPR_TRF_DT,'99991231') NOT IN ('99991231')
              THEN T1.CNTPR_TRF_DT
              ELSE NVL(T2.CNTPR_TRF_DT,'99991231')
          END                                                AS CNTPR_TRF_DT              --交易对手转账日期
        ,NVL(T1.CNTPR_ALDY_PAY_AMT,0)                        AS CNTPR_ALDY_PAY_AMT        --交易对手已支付金额
        ,CASE WHEN T1.MRGN_PCT <> 0 THEN T1.MRGN_PCT
              ELSE NVL(T2.MRGN_PCT,0)
          END                                                AS MRGN_PCT                  --保证金比例
        ,NVL(T1.MRGN_CUR,T2.MRGN_CUR)                        AS MRGN_CUR                  --保证金币种
        ,CASE WHEN T1.MRGN <> 0 THEN T1.MRGN
              ELSE NVL(T2.MRGN,0)
          END                                                AS MRGN                      --保证金
        ,NVL(T1.AST_TRF_MODE,T2.AST_TRF_MODE)                AS AST_TRF_MODE              --资产转让方式
        ,NVL(T1.TRA_PLTF,T2.TRA_PLTF)                        AS TRA_PLTF                  --交易平台
        ,NVL(T1.YD_CNTR_REGD_AMT,0)                          AS YD_CNTR_REGD_AMT          --银登中心登记金额
        ,NVL(T1.BANK_TRF_FLG,T2.BANK_TRF_FLG)                AS BANK_TRF_FLG              --行内转让标志
        ,NVL(T1.BATCH_TRF_FLG,T2.BATCH_TRF_FLG)              AS BATCH_TRF_FLG             --批量转让标志
        ,NVL(T1.TRF_DRC,T2.TRF_DRC)                          AS TRF_DRC                   --转让方向
        ,CASE WHEN T1.TRF_CONT_STAT <> '07' THEN T1.TRF_CONT_STAT --零售或者对公中有一个没有终结，就按有效的报送
              WHEN T2.TRF_CONT_STAT <> '07' THEN T2.TRF_CONT_STAT
              ELSE NVL(T1.TRF_CONT_STAT,T2.TRF_CONT_STAT)
          END                                                AS TRF_CONT_STAT             --转让合同状态
        ,NVL(T1.DEPT_LINE,T2.DEPT_LINE)                      AS DEPT_LINE                 --部门条线
        ,NVL(T1.DATA_SRC,T2.DATA_SRC)                        AS DATA_SRC                  --数据来源
        ,NVL(T1.TRF_LVL5_CL,T2.TRF_LVL5_CL)                  AS TRF_LVL5_CL               --转让时五级分类
        ,NVL(T1.BGN_YEAR_LOAN_LVL5_CL,T2.BGN_YEAR_LOAN_LVL5_CL) AS BGN_YEAR_LOAN_LVL5_CL     --年初五级分类
        ,NVL(T1.LOAN_TRF_CHAR,T2.LOAN_TRF_CHAR)              AS LOAN_TRF_CHAR             --信贷资产转让性质
        ,NVL(T1.TRF_SLF_HOLD_AMT,0)                          AS TRF_SLF_HOLD_AMT          --转让自持金额
        ,NVL(T1.ASSET_POOL_ID,T2.ASSET_POOL_ID)              AS ASSET_POOL_ID             --资产池编号
        ,NVL(T1.ASSET_TRAN_DT,T2.ASSET_TRAN_DT)              AS ASSET_TRAN_DT             --转让日期
        ,NVL(T1.ADVC_SUIT_FEE,0)                             AS ADVC_SUIT_FEE             --代垫诉讼费
        ,NVL(T1.TRA_SEQ_NO,T2.TRA_SEQ_NO)                    AS TRA_SEQ_NO                --核心交易流水号
        ,CASE WHEN NVL(T1.CNTPR_TRF_END_DT,'99991231') IN ('00010101','99991231') THEN '99991231' --零售或者对公中有一个没有终结，就按有效的报送
              WHEN NVL(T2.CNTPR_TRF_END_DT,'99991231') IN ('00010101','99991231') AND T2.TRF_CONT_ID IS NOT NULL THEN '99991231'
              ELSE GREATEST(T1.CNTPR_TRF_END_DT,NVL(T2.CNTPR_TRF_END_DT,T1.CNTPR_TRF_END_DT))
          END                                                AS CNTPR_TRF_END_DT          --最终交易对手支付日期
        ,NVL(T1.OTH_TRA_PLTF,T2.OTH_TRA_PLTF)                AS OTH_TRA_PLTF              --其他交易平台描述
        ,NVL(T1.PROP_ID,T2.PROP_ID)                          AS PROP_ID                   --方案编号
        ,NVL(T1.LOAN_BIZ_TYP,T2.LOAN_BIZ_TYP)                AS LOAN_BIZ_TYP              --信贷资产类型
        ,NVL(T1.RGST_TELLER_ID,T2.RGST_TELLER_ID)            AS RGST_TELLER_ID            --登记柜员编号
        ,NVL(T1.CNTPR_TRF_ACC_BANK_NO,T2.CNTPR_TRF_ACC_BANK_NO) AS CNTPR_TRF_ACC_BANK_NO     --交易对手转账账号开户行行号
        ,NVL(T1.OPER_USER_ID,T2.OPER_USER_ID)                AS OPER_USER_ID              --经办员工ID
        ,NVL(T1.CHECK_USER_ID,T2.CHECK_USER_ID)              AS CHECK_USER_ID             --审查员工ID
        ,NVL(T1.LAST_CHECK_USER_ID,T2.LAST_CHECK_USER_ID)    AS LAST_CHECK_USER_ID        --审批员工ID
        ,NVL(T1.TRF_CONT_SIGN_DT,T2.TRF_CONT_SIGN_DT)        AS TRF_CONT_SIGN_DT          --转让合同签约日期
        ,NVL(T1.CNTPR_TRF_CERT_TYPE_CD,T2.CNTPR_TRF_CERT_TYPE_CD) AS CNTPR_TRF_CERT_TYPE_CD    --对手方证件类型代码
        ,NVL(T1.CNTPR_TRF_CERT_NO,T2.CNTPR_TRF_CERT_NO)      AS CNTPR_TRF_CERT_NO         --对手方证件号码
        ,NVL(T1.CUST_NAME,T2.CUST_NAME)                      AS CUST_NAME                 --客户名称 --ADD BY LIP 20251216
    FROM LOAN_TRF_INFO_TMP T1
    LEFT JOIN LOAN_TRF_INFO_TMP T2
      ON T2.TRF_CONT_ID = T1.TRF_CONT_ID
     AND T2.RN = 2
   WHERE T1.RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,TRF_CONT_ID,PROP_ID,COUNT(1)
    FROM RRP_MDL.M_LOAN_TRF_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRF_CONT_ID,PROP_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_SQLMSG  := 'M_LOAN_TRF_INFO数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析
  ETL_DBMS_STATS(V_P_DATE, 'M_LOAN_TRF_INFO_CT', V_PART_NAME, O_ERRCODE); --表分析

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

END ETL_M_LOAN_TRF_INFO;
/

