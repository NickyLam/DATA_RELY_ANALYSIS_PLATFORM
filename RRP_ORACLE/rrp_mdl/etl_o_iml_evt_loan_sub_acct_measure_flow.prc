CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW
  *  功能描述：贷款分户计量流水
  *  创建日期：20250822
  *  开发人员：YJY
  *  来源表： IML.V_EVT_LOAN_SUB_ACCT_MEASURE_FLOW
  *  目标表： O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250822  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-贷款分户计量流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW
    (  EVT_ID                                --事件编号
      ,SOB_ID                                --账套编号
      ,SRC_SYS_CD                            --源系统代码
      ,CORE_LOAN_NUM                         --核心贷款号
      ,TRAN_DT                               --交易日期
      ,TRAN_FLOW_NUM                         --交易流水号
      ,TRAN_FLOW_SEQ_NUM                     --交易流水序号
      ,SUB_TRAN_CATE_CD                      --子交易类别代码
      ,CURR_CD                               --币种代码
      ,ORG_ID                                --机构编号
      ,DUBIL_ID                              --借据编号
      ,BUS_TYPE_CD                           --业务类型代码
      ,PROD_ID                               --产品编号
      ,CONT_ID                               --合同编号
      ,INIT_LOAN_NUM                         --原贷款号
      ,LOAN_IMPAM_RESV_LMT                   --贷款减值准备金额
      ,DISCNT_INT                            --贴现利息
      ,INT_INCOME                            --利息收入
      ,NOMAL_PRIC                            --正常本金
      ,ABS_PRIC                              --资产证券化本金
      ,OTHER_ACCT_RECVBL_IMPAM_RESV_LMT      --其他应收款减值准备金额
      ,OUTPUT_TAX_LMT                        --销项税额
      ,ADV_VAT_AMT                           --代垫增值税金额
      ,WRTN_OFF_PRIC                         --已核销本金
      ,WRTN_OFF_ADVC_MONEY                   --已核销垫付款
      ,INT_RECVBL                            --应收利息
      ,ACRU_ALDY_IMPAM_INT                   --应计已减值利息
      ,LOG_PRIC                              --保函本金
      ,NON_ACRU_INT_RECVBL                   --非应计应收利息
      ,WRTN_OFF_INT                          --已核销利息
      ,RECVBL_UNCOL_INT                      --应收未收利息
      ,INT_PAYBL                             --应付利息
      ,ACCT_STATUS_CD                        --账户状态代码
      ,OVA_FLOW_NUM                          --全局流水号
      ,INT_SUB_FLG                           --贴息标志
      ,RENEW_FLG                             --展期标志
      ,ABS_FLG                               --资产证券化标志
      ,MERGE_FLG                             --撤并标志
      ,PRE_RECV_INT_FLG                      --预收息标志
      ,CONT_EXEC_INT_RAT                     --合同执行利率
      ,NOMAL_INT_RAT_PED_CD                  --正常利率周期代码
      ,OVDUE_PRIC                            --逾期本金
      ,OVDUE_INT_RAT                         --逾期利率
      ,OVDUE_INT_RAT_PED_CD                  --逾期利率周期代码
      ,COMP_INT                              --复利
      ,CURR_EXP_COMP_INT                     --当前到期的复利
      ,COMP_INT_INT_RAT                      --复利利率
      ,COMP_INT_INT_RAT_PED_CD               --复利利率周期代码
      ,GRACE_PERIOD_INT_RAT_PED_CD           --宽限期利率周期代码
      ,INT_ACCR_FLG                          --计息标志
      ,VALUE_DT                              --起息日期
      ,NEXT_INT_SET_DT                       --下次结息日期
      ,TD_EXP_PNLT                           --当天到期的罚息
      ,PNLT                                  --罚息
      ,CUST_ID                               --客户编号
      ,CUST_NAME                             --客户名称
      ,LOAN_LEVEL5_CLS_CD                    --贷款五级分类代码
      ,LOAN_STAGE                            --贷款阶段
      ,LOAN_DISTR_DT                         --贷款放款日期
      ,LOAN_DISTR_AMT                        --贷款放款金额
      ,ACTL_DISTR_AMT                        --实际发放金额
      ,LOAN_EXP_DT                           --贷款到期日期
      ,TRAN_WAY_CD                           --转让方式代码
      ,CAP_CHAR_CD                           --资金性质代码
      ,ACRU_FLG                              --应计标志
      ,ACRU_INT                              --应计利息
      ,OFF_BS_ACRU_COMP_INT                  --表外应计复利
      ,TAXABLE_COLLED_INT                    --应税已收回利息
      ,IMPAM_FLG                             --减值标志
      ,ASSET_IMPAM_LOSS_AMT                  --资产减值损失金额
      ,ALDY_IMPAM_INT                        --已减值利息
      ,ALDY_IMPAM_INT_INCOME                 --已减值利息收入
      ,INT_RECVBL_TAXABLE                    --应收利息应税
      ,OFF_BS_INT_RECVBL                     --表外应收利息
      ,OFF_BS_RECVBL_COMP_INT                --表外应收复利
      ,OFF_BS_ACRU_INT                       --表外应计利息
      ,WRTN_OFF_BAD_DEBT_PRIC                --已核销呆账本金
      ,WRTN_OFF_BAD_DEBT_ALDY_IMPAM_INT      --已核销呆账已减值利息
      ,WRTN_OFF_BAD_DEBT_INT                 --已核销呆账利息
      ,TH_YEAR_INT_INCOME                    --本年利息收入
      ,WRTN_OFF_INT_NOT_TAX                  --已核销利息_未计税
      ,TH_YEAR_ALDY_IMPAM_INT_INCOME         --本年已减值利息收入
      ,ACM_INT_INCOME                        --累计利息收入
      ,TH_QUAR_DEGREE_VAT                    --当季度增值税
      ,INDV_BUS_FLG                          --个体工商户标志
      ,CORP_SIZE_CD                          --企业规模代码
      ,CIRCL_LON_FIR_DISTR_FLG               --循环贷首次放款标志
      ,CIRCL_LON_FLG                         --循环贷标志
      ,INDUS_TYPE_CD                         --国门经济类别代码
      ,CHN_CD                                --渠道代码
      ,AMORT_FLG                             --摊销标志
      ,AMORT_FREQ_CD                         --摊销频度代码
      ,AMORT_COST                            --摊余成本
      ,INVEST_PRFT                           --投资收益
      ,TH_YEAR_INVEST_PRFT                   --本年投资收益
      ,ACM_INVEST_PRFT                       --累计投资收益
      ,BATCH_NO                              --批次号
      ,TRAN_ORG_ID                           --交易机构编号
      ,TRAN_TYPE_CD                          --交易类型代码
      ,BUS_HAPP_DT                           --业务发生日期
      ,REVS_BUS_FLG                          --冲正业务标志
      ,BREVS_DT                              --被冲正日期
      ,BREVS_FLOW_NUM                        --被冲正流水号
      ,STDBY_AMT                             --备用金额
      ,UPDATE_ORG_ID                         --更新机构编号
      ,ETL_DT                                --ETL处理日期
      ,SRC_TABLE_NAME                        --源表名称
      ,JOB_CD                                --任务编码
      ,ETL_TIMESTAMP                         --ETL处理时间戳
    )
  SELECT 
      EVT_ID                                --事件编号
      ,SOB_ID                                --账套编号
      ,SRC_SYS_CD                            --源系统代码
      ,CORE_LOAN_NUM                         --核心贷款号
      ,TRAN_DT                               --交易日期
      ,TRAN_FLOW_NUM                         --交易流水号
      ,TRAN_FLOW_SEQ_NUM                     --交易流水序号
      ,SUB_TRAN_CATE_CD                      --子交易类别代码
      ,CURR_CD                               --币种代码
      ,ORG_ID                                --机构编号
      ,DUBIL_ID                              --借据编号
      ,BUS_TYPE_CD                           --业务类型代码
      ,PROD_ID                               --产品编号
      ,CONT_ID                               --合同编号
      ,INIT_LOAN_NUM                         --原贷款号
      ,LOAN_IMPAM_RESV_LMT                   --贷款减值准备金额
      ,DISCNT_INT                            --贴现利息
      ,INT_INCOME                            --利息收入
      ,NOMAL_PRIC                            --正常本金
      ,ABS_PRIC                              --资产证券化本金
      ,OTHER_ACCT_RECVBL_IMPAM_RESV_LMT      --其他应收款减值准备金额
      ,OUTPUT_TAX_LMT                        --销项税额
      ,ADV_VAT_AMT                           --代垫增值税金额
      ,WRTN_OFF_PRIC                         --已核销本金
      ,WRTN_OFF_ADVC_MONEY                   --已核销垫付款
      ,INT_RECVBL                            --应收利息
      ,ACRU_ALDY_IMPAM_INT                   --应计已减值利息
      ,LOG_PRIC                              --保函本金
      ,NON_ACRU_INT_RECVBL                   --非应计应收利息
      ,WRTN_OFF_INT                          --已核销利息
      ,RECVBL_UNCOL_INT                      --应收未收利息
      ,INT_PAYBL                             --应付利息
      ,ACCT_STATUS_CD                        --账户状态代码
      ,OVA_FLOW_NUM                          --全局流水号
      ,INT_SUB_FLG                           --贴息标志
      ,RENEW_FLG                             --展期标志
      ,ABS_FLG                               --资产证券化标志
      ,MERGE_FLG                             --撤并标志
      ,PRE_RECV_INT_FLG                      --预收息标志
      ,CONT_EXEC_INT_RAT                     --合同执行利率
      ,NOMAL_INT_RAT_PED_CD                  --正常利率周期代码
      ,OVDUE_PRIC                            --逾期本金
      ,OVDUE_INT_RAT                         --逾期利率
      ,OVDUE_INT_RAT_PED_CD                  --逾期利率周期代码
      ,COMP_INT                              --复利
      ,CURR_EXP_COMP_INT                     --当前到期的复利
      ,COMP_INT_INT_RAT                      --复利利率
      ,COMP_INT_INT_RAT_PED_CD               --复利利率周期代码
      ,GRACE_PERIOD_INT_RAT_PED_CD           --宽限期利率周期代码
      ,INT_ACCR_FLG                          --计息标志
      ,VALUE_DT                              --起息日期
      ,NEXT_INT_SET_DT                       --下次结息日期
      ,TD_EXP_PNLT                           --当天到期的罚息
      ,PNLT                                  --罚息
      ,CUST_ID                               --客户编号
      ,CUST_NAME                             --客户名称
      ,LOAN_LEVEL5_CLS_CD                    --贷款五级分类代码
      ,LOAN_STAGE                            --贷款阶段
      ,LOAN_DISTR_DT                         --贷款放款日期
      ,LOAN_DISTR_AMT                        --贷款放款金额
      ,ACTL_DISTR_AMT                        --实际发放金额
      ,LOAN_EXP_DT                           --贷款到期日期
      ,TRAN_WAY_CD                           --转让方式代码
      ,CAP_CHAR_CD                           --资金性质代码
      ,ACRU_FLG                              --应计标志
      ,ACRU_INT                              --应计利息
      ,OFF_BS_ACRU_COMP_INT                  --表外应计复利
      ,TAXABLE_COLLED_INT                    --应税已收回利息
      ,IMPAM_FLG                             --减值标志
      ,ASSET_IMPAM_LOSS_AMT                  --资产减值损失金额
      ,ALDY_IMPAM_INT                        --已减值利息
      ,ALDY_IMPAM_INT_INCOME                 --已减值利息收入
      ,INT_RECVBL_TAXABLE                    --应收利息应税
      ,OFF_BS_INT_RECVBL                     --表外应收利息
      ,OFF_BS_RECVBL_COMP_INT                --表外应收复利
      ,OFF_BS_ACRU_INT                       --表外应计利息
      ,WRTN_OFF_BAD_DEBT_PRIC                --已核销呆账本金
      ,WRTN_OFF_BAD_DEBT_ALDY_IMPAM_INT      --已核销呆账已减值利息
      ,WRTN_OFF_BAD_DEBT_INT                 --已核销呆账利息
      ,TH_YEAR_INT_INCOME                    --本年利息收入
      ,WRTN_OFF_INT_NOT_TAX                  --已核销利息_未计税
      ,TH_YEAR_ALDY_IMPAM_INT_INCOME         --本年已减值利息收入
      ,ACM_INT_INCOME                        --累计利息收入
      ,TH_QUAR_DEGREE_VAT                    --当季度增值税
      ,INDV_BUS_FLG                          --个体工商户标志
      ,CORP_SIZE_CD                          --企业规模代码
      ,CIRCL_LON_FIR_DISTR_FLG               --循环贷首次放款标志
      ,CIRCL_LON_FLG                         --循环贷标志
      ,INDUS_TYPE_CD                         --国门经济类别代码
      ,CHN_CD                                --渠道代码
      ,AMORT_FLG                             --摊销标志
      ,AMORT_FREQ_CD                         --摊销频度代码
      ,AMORT_COST                            --摊余成本
      ,INVEST_PRFT                           --投资收益
      ,TH_YEAR_INVEST_PRFT                   --本年投资收益
      ,ACM_INVEST_PRFT                       --累计投资收益
      ,BATCH_NO                              --批次号
      ,TRAN_ORG_ID                           --交易机构编号
      ,TRAN_TYPE_CD                          --交易类型代码
      ,BUS_HAPP_DT                           --业务发生日期
      ,REVS_BUS_FLG                          --冲正业务标志
      ,BREVS_DT                              --被冲正日期
      ,BREVS_FLOW_NUM                        --被冲正流水号
      ,STDBY_AMT                             --备用金额
      ,UPDATE_ORG_ID                         --更新机构编号
      ,ETL_DT                                --ETL处理日期
      ,SRC_TABLE_NAME                        --源表名称
      ,JOB_CD                                --任务编码
      ,ETL_TIMESTAMP                         --ETL处理时间戳
    FROM IML.V_EVT_LOAN_SUB_ACCT_MEASURE_FLOW --视图-贷款分户计量流水
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW;
/

