CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_RETL_LOAN_ACCT_INFO(I_P_DATE IN INTEGER,
                                                              O_ERRCODE OUT VARCHAR2
                                                              )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_RETL_LOAN_ACCT_INFO
  *  功能描述：零售贷款账户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_RETL_LOAN_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1    20220525  梅炜     首次创建
  *            2    20230901  胡丽娟   增加资产证券化标志、资产转让标志字段
  *            3    20231108  hulj     优化O层
  *            4    20231207  hulj     增加原始到期日期字段
  ***************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(200);              --分区名
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100):= 'O_ICL_CMM_RETL_LOAN_ACCT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_RETL_LOAN_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-零售贷款账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO
    (ETL_DT                            --数据日期
    ,LP_ID                             --法人编号
    ,ACCT_ID                           --账户编号
    ,ACCT_NAME                         --账户名称
    ,CUST_ID                           --客户编号
    ,CONT_ID                           --合同编号
    ,DUBIL_NUM                         --借据号
    ,LOAN_NUM                          --贷款号
    ,LOAN_DISTR_ACCT_NUM               --贷款放款账号
    ,LOAN_REPAY_NUM                    --贷款还款账号
    ,STD_PROD_ID                       --标准产品编号
    ,PROD_ID                           --产品编号
    ,SUBJ_ID                           --科目编号
    ,INIT_PRIC_SUBJ_ID                 --原本金科目编号
    ,IN_BS_INT_SUBJ_ID                 --表内利息科目编号
    ,RECVBL_UNCOL_INT_SUBJ_ID          --应收未收利息科目编号
    ,RECVBL_INT_PAYBL_ADJ_SUBJ_ID      --应收应付利息调整科目编号
    ,OFF_BS_INT_SUBJ_ID                --表外利息科目编号
    ,ACRU_ALDY_IMPAM_INT_SUBJ_ID       --应计已减值利息科目编号
    ,INT_INCOME_SUBJ_ID                --利息收入科目编号
    ,INT_INCOME_ADJ_SUBJ_ID            --利息收入调整科目编号
    ,ACCTNT_CATE_CD                    --会计类别代码
    ,BUS_BREED_ID                      --业务品种编号
    ,ASSET_THD_CLS_CD                  --资产三分类代码
    ,LOAN_MODAL_CD                     --贷款形态代码
    ,LOAN_ACCT_STATUS_CD               --贷款账户状态代码
    ,UNITE_LOAN_CD                     --联合贷款代码
    ,PRIV_LOAN_FLG                     --对私贷款标志
    ,PROMIS_LOAN_FLG                   --承诺贷款标志
    ,CIRCL_LOAN_FLG                    --循环贷款标志
    ,DERIV_LOAN_FLG                    --衍生贷款标志
    ,AGENT_LOAN_FLG                    --代理贷款标志
    ,OOTS_ACCTI_FLG                    --按一逾两呆核算标志
    ,LOAN_MODAL_DG_SUBJ_ACCTI_FLG      --贷款形态分科目核算标志
    ,LOAN_TENOR                        --贷款期限
    ,LOAN_TENOR_TYPE_CD                --贷款期限类型代码
    ,ACRU_NON_ACRU_CD                  --应计非应计代码
    ,FINAL_FIN_DT                      --最后财务日期
    ,OPEN_ACCT_TELLER_ID               --开户柜员编号
    ,CLOS_ACCT_TELLER_ID               --销户柜员编号
    ,OPEN_ACCT_ORG_ID                  --开户机构编号
    ,MGMT_ORG_ID                       --管理机构编号
    ,ACCT_INSTIT_ID                    --账务机构编号
    ,OPEN_ACCT_DT                      --开户日期
    ,DISTR_DT                          --放款日期
    ,VALUE_DT                          --起息日期
    ,EXP_DT                            --到期日期
    ,CLOS_ACCT_DT                      --销户日期
    ,INT_SUB_FLG                       --贴息标志
    ,RENEW_FLG                         --展期标志
    ,RENEW_CNT                         --展期次数
    ,RENEW_EXP_DT                      --展期到期日期
    ,INT_ACCR_RULE                     --计息规则
    ,INT_ACCR_FLG                      --计息标志
    ,COMP_INT_FLG                      --复息标志
    ,PRE_RECV_INT_WAY                  --预收息方式
    ,INT_RAT_ADJ_WAY_CD                --利率调整方式代码
    ,INT_RAT_BASE_TYPE_CD              --利率基准类型代码
    ,BASE_RAT_ID                       --基准利率编号
    ,BASE_RAT                          --基准利率
    ,EXEC_INT_RAT                      --执行利率
    ,INT_RAT_FLOAT_WAY_CD              --利率浮动方式代码
    ,INT_RAT_ADJ_PED_CORP_CD           --利率调整周期单位代码
    ,INT_RAT_ADJ_PED_FREQ              --利率调整周期频率
    ,INT_RAT_FLO_VAL                   --利率浮动值
    ,CURR_INT_RAT_EFFECT_DT            --当前利率生效日期
    ,NEXT_INT_RAT_ADJ_DT               --下次利率调整日期
    ,INT_SET_WAY_CD                    --结息方式代码
    ,INT_ACCR_WAY_CD                   --计息方式代码
    ,PED_DISTR_FLG                     --周期性放款标志
    ,DISTR_WAY_CD                      --放款方式代码
    ,REPAY_WAY_CD                      --还款方式代码
    ,IRR_REPAY_WAY_CD                  --不规则还款方式代码
    ,REPAY_PED_CORP_CD                 --还款周期单位代码
    ,REPAY_PED                         --还款周期
    ,ALLOW_ADV_REPAY_FLG               --允许提前还款标志
    ,WRT_OFF_FLG                       --核销标志
    ,ASSET_TRAN_STATUS_CD              --资产转让状态代码
    ,ASSET_TRAN_DT                     --资产转让日期
    ,TRAN_BF_INT_RECVBL                --转让前应收利息
    ,OVDUE_FLG                         --逾期标志
    ,OVDUE_INT_ACCR_WAY_CD             --逾期计息方式代码
    ,OVDUE_PNLT_FLOAT_WAY_CD           --逾期罚息浮动方式代码
    ,PRIC_OVDUE_FLG                    --本金逾期标志
    ,INT_OVDUE_FLG                     --利息逾期标志
    ,CURR_OVDUE_PERDS                  --当前逾期期数
    ,PRIC_OVDUE_DAYS                   --本金逾期天数
    ,INT_OVDUE_DAYS                    --利息逾期天数
    ,OVDUE_PRIC_BAL                    --逾期本金余额
    ,OVDUE_INT_AMT                     --逾期利息金额
    ,OVDUE_COMP_INT_AMT                --逾期复利金额
    ,FIR_OVDUE_DT                      --首次逾期日期
    ,PRIC_OVDUE_DT                     --本金逾期日期
    ,INT_OVDUE_DT                      --利息逾期日期
    ,OVDUE_INT_RAT                     --逾期利率
    ,OVDUE_INT_RAT_FLO_VAL             --逾期利率浮动值
    ,TOT_PERDS                         --总期数
    ,CURR_ISSUE_PERDS                  --本期期数
    ,LAST_REPAY_DT                     --上次还款日期
    ,CURR_CD                           --币种代码
    ,NEXT_REPAY_DT                     --下次还款日期
    ,NEXT_RPP_AMT                      --下次还本金额
    ,NEXT_REPAY_INT_AMT                --下次还息金额
    ,CONT_AMT                          --合同金额
    ,DUBIL_AMT                         --借据金额
    ,DISTR_AMT                         --放款金额
    ,FROZ_DISTRD_AMT                   --冻结可发放金额
    ,DISTRD_AMT                        --可发放金额
    ,TD_ACRU_INT                       --当日应计利息
    ,TD_INT_INCOME                     --当日利息收入
    ,TD_INT_INCOME_ADJ                 --当日利息收入调整
    ,CURRT_ACRU_INT                    --当期应计利息
    ,NOMAL_PRIC                        --正常本金
    ,OVDUE_PRIC                        --逾期本金
    ,IDLE_PRIC                         --呆滞本金
    ,BAD_DEBT_PRIC                     --呆账本金
    ,LOAN_FUND                         --贷款基金
    ,RECVBL_ACRU_INT                   --应收应计利息
    ,COLL_ACRU_INT                     --催收应计利息
    ,RECVBL_ACRU_PNLT                  --应收应计罚息
    ,COLL_ACRU_PNLT                    --催收应计罚息
    ,RECVBL_PNLT                       --应收罚息
    ,COLL_PNLT                         --催收罚息
    ,ACRU_COMP_INT                     --应计复息
    ,RECVBL_COMP_INT                   --应收复息_计量后
    ,ACRU_INT_SUB                      --应计贴息
    ,RECVBL_INT_SUB                    --应收贴息
    ,AMORTED_INT                       --待摊利息
    ,WRT_OFF_PRIC                      --核销本金
    ,WRT_OFF_INT                       --核销利息
    ,INT_INCOME                        --利息收入
    ,WRT_OFF_ADVC_FEE_BAL              --核销垫付费余额
    ,WRT_OFF_ADVC_FEE_AMT              --核销垫付费金额
    ,RECVBL_FINE                       --应收罚金
    ,FINE_INCO                         --罚金收入
    ,RESV                              --准备金
    ,RECVBL_OVER_INT                   --应收欠息
    ,COLL_OVER_INT                     --催收欠息
    ,IN_BS_INT                         --表内利息
    ,OFF_BS_INT                        --表外利息
    ,ACM_RECVBL_UNCOL_INT_AMT          --累计应收未收利息金额
    ,RECVBL_UNCOL_INT                  --应收未收利息_计量后
    ,INT_RECVBL                        --应收利息
    ,NON_ACRU_INT_RECVBL               --非应计应收利息_计量后
    ,ACRU_ALDY_IMPAM_INT               --应计已减值利息
    ,REPAID_PRIC                       --已偿还本金
    ,REPAID_INT                        --已偿还利息
    ,REPAID_PNLT                       --已偿还罚息
    ,REPAID_COMP_INT                   --已偿还复利
    ,REPAID_FEE                        --已偿还费用
    ,PRIC_BAL                          --本金余额
    ,CURRT_BAL                         --当期余额
    ,CL_CURR_CURRT_BAL                 --折本币当期余额
    ,EAR_D_BAL                         --日初余额
    ,EAR_M_BAL                         --月初余额
    ,EAR_S_BAL                         --季初余额
    ,EAR_Y_BAL                         --年初余额
    ,Y_ACM_BAL                         --年累计余额
    ,S_ACM_BAL                         --季累计余额
    ,M_ACM_BAL                         --月累计余额
    ,CL_CURR_EAR_D_BAL                 --折本币日初余额
    ,CL_CURR_EAR_M_BAL                 --折本币月初余额
    ,CL_CURR_EAR_S_BAL                 --折本币季初余额
    ,CL_CURR_EAR_Y_BAL                 --折本币年初余额
    ,CL_CURR_Y_ACM_BAL                 --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL           --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL           --折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL           --折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL           --折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL                 --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL           --折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL           --折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL           --折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL                 --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL           --折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL           --折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL           --折本币年初月累计余额
    ,Y_AVG_BAL                         --年日均余额
    ,Q_AVG_BAL                         --季日均余额
    ,M_AVG_BAL                         --月日均余额
    ,CL_CURR_Y_AVG_BAL                 --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL                 --折本币季日均余额
    ,CL_CURR_M_AVG_BAL                 --折本币月日均余额
    ,JOB_CD                            --任务代码
    ,ETL_TIMESTAMP                     --数据处理时间
    ,GRACE_PERIOD_PRIC                 --宽限期本金
    ,ABS_FLG                           --资产证券化标志
    ,ASSET_TRAN_FLG	                   --资产转让标志
    ,INIT_EXP_DT                       --原始到期日期
    )
  SELECT 
     TO_DATE(V_P_DATE,'YYYYMMDD') AS ETL_DT                            --数据日期
    ,LP_ID                             --法人编号
    ,ACCT_ID                           --账户编号
    ,ACCT_NAME                         --账户名称
    ,CUST_ID                           --客户编号
    ,CONT_ID                           --合同编号
    ,DUBIL_NUM                         --借据号
    ,LOAN_NUM                          --贷款号
    ,LOAN_DISTR_ACCT_NUM               --贷款放款账号
    ,LOAN_REPAY_NUM                    --贷款还款账号
    ,STD_PROD_ID                       --标准产品编号
    ,PROD_ID                           --产品编号
    ,SUBJ_ID                           --科目编号
    ,INIT_PRIC_SUBJ_ID                 --原本金科目编号
    ,IN_BS_INT_SUBJ_ID                 --表内利息科目编号
    ,RECVBL_UNCOL_INT_SUBJ_ID          --应收未收利息科目编号
    ,RECVBL_INT_PAYBL_ADJ_SUBJ_ID      --应收应付利息调整科目编号
    ,OFF_BS_INT_SUBJ_ID                --表外利息科目编号
    ,ACRU_ALDY_IMPAM_INT_SUBJ_ID       --应计已减值利息科目编号
    ,INT_INCOME_SUBJ_ID                --利息收入科目编号
    ,INT_INCOME_ADJ_SUBJ_ID            --利息收入调整科目编号
    ,ACCTNT_CATE_CD                    --会计类别代码
    ,BUS_BREED_ID                      --业务品种编号
    ,ASSET_THD_CLS_CD                  --资产三分类代码
    ,LOAN_MODAL_CD                     --贷款形态代码
    ,LOAN_ACCT_STATUS_CD               --贷款账户状态代码
    ,UNITE_LOAN_CD                     --联合贷款代码
    ,PRIV_LOAN_FLG                     --对私贷款标志
    ,PROMIS_LOAN_FLG                   --承诺贷款标志
    ,CIRCL_LOAN_FLG                    --循环贷款标志
    ,DERIV_LOAN_FLG                    --衍生贷款标志
    ,AGENT_LOAN_FLG                    --代理贷款标志
    ,OOTS_ACCTI_FLG                    --按一逾两呆核算标志
    ,LOAN_MODAL_DG_SUBJ_ACCTI_FLG      --贷款形态分科目核算标志
    ,LOAN_TENOR                        --贷款期限
    ,LOAN_TENOR_TYPE_CD                --贷款期限类型代码
    ,ACRU_NON_ACRU_CD                  --应计非应计代码
    ,FINAL_FIN_DT                      --最后财务日期
    ,OPEN_ACCT_TELLER_ID               --开户柜员编号
    ,CLOS_ACCT_TELLER_ID               --销户柜员编号
    ,OPEN_ACCT_ORG_ID                  --开户机构编号
    ,MGMT_ORG_ID                       --管理机构编号
    ,ACCT_INSTIT_ID                    --账务机构编号
    ,OPEN_ACCT_DT                      --开户日期
    ,DISTR_DT                          --放款日期
    ,VALUE_DT                          --起息日期
    ,EXP_DT                            --到期日期
    ,CLOS_ACCT_DT                      --销户日期
    ,INT_SUB_FLG                       --贴息标志
    ,RENEW_FLG                         --展期标志
    ,RENEW_CNT                         --展期次数
    ,RENEW_EXP_DT                      --展期到期日期
    ,INT_ACCR_RULE                     --计息规则
    ,INT_ACCR_FLG                      --计息标志
    ,COMP_INT_FLG                      --复息标志
    ,PRE_RECV_INT_WAY                  --预收息方式
    ,INT_RAT_ADJ_WAY_CD                --利率调整方式代码
    ,INT_RAT_BASE_TYPE_CD              --利率基准类型代码
    ,BASE_RAT_ID                       --基准利率编号
    ,BASE_RAT                          --基准利率
    ,EXEC_INT_RAT                      --执行利率
    ,INT_RAT_FLOAT_WAY_CD              --利率浮动方式代码
    ,INT_RAT_ADJ_PED_CORP_CD           --利率调整周期单位代码
    ,INT_RAT_ADJ_PED_FREQ              --利率调整周期频率
    ,INT_RAT_FLO_VAL                   --利率浮动值
    ,CURR_INT_RAT_EFFECT_DT            --当前利率生效日期
    ,NEXT_INT_RAT_ADJ_DT               --下次利率调整日期
    ,INT_SET_WAY_CD                    --结息方式代码
    ,INT_ACCR_WAY_CD                   --计息方式代码
    ,PED_DISTR_FLG                     --周期性放款标志
    ,DISTR_WAY_CD                      --放款方式代码
    ,REPAY_WAY_CD                      --还款方式代码
    ,IRR_REPAY_WAY_CD                  --不规则还款方式代码
    ,REPAY_PED_CORP_CD                 --还款周期单位代码
    ,REPAY_PED                         --还款周期
    ,ALLOW_ADV_REPAY_FLG               --允许提前还款标志
    ,WRT_OFF_FLG                       --核销标志
    ,ASSET_TRAN_STATUS_CD              --资产转让状态代码
    ,ASSET_TRAN_DT                     --资产转让日期
    ,TRAN_BF_INT_RECVBL                --转让前应收利息
    ,OVDUE_FLG                         --逾期标志
    ,OVDUE_INT_ACCR_WAY_CD             --逾期计息方式代码
    ,OVDUE_PNLT_FLOAT_WAY_CD           --逾期罚息浮动方式代码
    ,PRIC_OVDUE_FLG                    --本金逾期标志
    ,INT_OVDUE_FLG                     --利息逾期标志
    ,CURR_OVDUE_PERDS                  --当前逾期期数
    ,PRIC_OVDUE_DAYS                   --本金逾期天数
    ,INT_OVDUE_DAYS                    --利息逾期天数
    ,OVDUE_PRIC_BAL                    --逾期本金余额
    ,OVDUE_INT_AMT                     --逾期利息金额
    ,OVDUE_COMP_INT_AMT                --逾期复利金额
    ,FIR_OVDUE_DT                      --首次逾期日期
    ,PRIC_OVDUE_DT                     --本金逾期日期
    ,INT_OVDUE_DT                      --利息逾期日期
    ,OVDUE_INT_RAT                     --逾期利率
    ,OVDUE_INT_RAT_FLO_VAL             --逾期利率浮动值
    ,TOT_PERDS                         --总期数
    ,CURR_ISSUE_PERDS                  --本期期数
    ,LAST_REPAY_DT                     --上次还款日期
    ,CURR_CD                           --币种代码
    ,NEXT_REPAY_DT                     --下次还款日期
    ,NEXT_RPP_AMT                      --下次还本金额
    ,NEXT_REPAY_INT_AMT                --下次还息金额
    ,CONT_AMT                          --合同金额
    ,DUBIL_AMT                         --借据金额
    ,DISTR_AMT                         --放款金额
    ,FROZ_DISTRD_AMT                   --冻结可发放金额
    ,DISTRD_AMT                        --可发放金额
    ,TD_ACRU_INT                       --当日应计利息
    ,TD_INT_INCOME                     --当日利息收入
    ,TD_INT_INCOME_ADJ                 --当日利息收入调整
    ,CURRT_ACRU_INT                    --当期应计利息
    ,NOMAL_PRIC                        --正常本金
    ,OVDUE_PRIC                        --逾期本金
    ,IDLE_PRIC                         --呆滞本金
    ,BAD_DEBT_PRIC                     --呆账本金
    ,LOAN_FUND                         --贷款基金
    ,RECVBL_ACRU_INT                   --应收应计利息
    ,COLL_ACRU_INT                     --催收应计利息
    ,RECVBL_ACRU_PNLT                  --应收应计罚息
    ,COLL_ACRU_PNLT                    --催收应计罚息
    ,RECVBL_PNLT                       --应收罚息
    ,COLL_PNLT                         --催收罚息
    ,ACRU_COMP_INT                     --应计复息
    ,RECVBL_COMP_INT                   --应收复息_计量后
    ,ACRU_INT_SUB                      --应计贴息
    ,RECVBL_INT_SUB                    --应收贴息
    ,AMORTED_INT                       --待摊利息
    ,WRT_OFF_PRIC                      --核销本金
    ,WRT_OFF_INT                       --核销利息
    ,INT_INCOME                        --利息收入
    ,WRT_OFF_ADVC_FEE_BAL              --核销垫付费余额
    ,WRT_OFF_ADVC_FEE_AMT              --核销垫付费金额
    ,RECVBL_FINE                       --应收罚金
    ,FINE_INCO                         --罚金收入
    ,RESV                              --准备金
    ,RECVBL_OVER_INT                   --应收欠息
    ,COLL_OVER_INT                     --催收欠息
    ,IN_BS_INT                         --表内利息
    ,OFF_BS_INT                        --表外利息
    ,ACM_RECVBL_UNCOL_INT_AMT          --累计应收未收利息金额
    ,RECVBL_UNCOL_INT                  --应收未收利息_计量后
    ,INT_RECVBL                        --应收利息
    ,NON_ACRU_INT_RECVBL               --非应计应收利息_计量后
    ,ACRU_ALDY_IMPAM_INT               --应计已减值利息
    ,REPAID_PRIC                       --已偿还本金
    ,REPAID_INT                        --已偿还利息
    ,REPAID_PNLT                       --已偿还罚息
    ,REPAID_COMP_INT                   --已偿还复利
    ,REPAID_FEE                        --已偿还费用
    ,PRIC_BAL                          --本金余额
    ,CURRT_BAL                         --当期余额
    ,CL_CURR_CURRT_BAL                 --折本币当期余额
    ,EAR_D_BAL                         --日初余额
    ,EAR_M_BAL                         --月初余额
    ,EAR_S_BAL                         --季初余额
    ,EAR_Y_BAL                         --年初余额
    ,Y_ACM_BAL                         --年累计余额
    ,S_ACM_BAL                         --季累计余额
    ,M_ACM_BAL                         --月累计余额
    ,CL_CURR_EAR_D_BAL                 --折本币日初余额
    ,CL_CURR_EAR_M_BAL                 --折本币月初余额
    ,CL_CURR_EAR_S_BAL                 --折本币季初余额
    ,CL_CURR_EAR_Y_BAL                 --折本币年初余额
    ,CL_CURR_Y_ACM_BAL                 --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL           --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL           --折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL           --折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL           --折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL                 --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL           --折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL           --折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL           --折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL                 --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL           --折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL           --折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL           --折本币年初月累计余额
    ,Y_AVG_BAL                         --年日均余额
    ,Q_AVG_BAL                         --季日均余额
    ,M_AVG_BAL                         --月日均余额
    ,CL_CURR_Y_AVG_BAL                 --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL                 --折本币季日均余额
    ,CL_CURR_M_AVG_BAL                 --折本币月日均余额
    ,JOB_CD                            --任务代码
    ,ETL_TIMESTAMP                     --数据处理时间
    ,GRACE_PERIOD_PRIC                 --宽限期本金
    ,ABS_FLG                           --资产证券化标志
    ,ASSET_TRAN_FLG	                   --资产转让标志
    ,INIT_EXP_DT                       --原始到期日期
    FROM ICL.V_CMM_RETL_LOAN_ACCT_INFO@DB_SIT1  --视图-零售贷款账户信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_ICL_CMM_RETL_LOAN_ACCT_INFO;
/

