CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_CORP_LOAN_ACCT_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_CORP_LOAN_ACCT_INFO
  *  功能描述：对公贷款账户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CORP_LOAN_ACCT_INFO
  *  目标表： O_ICL_CMM_CORP_LOAN_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_CORP_LOAN_ACCT_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_CORP_LOAN_ACCT_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_CORP_LOAN_ACCT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公贷款账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO
  (   			ETL_DT  --数据日期
			,LP_ID  --法人编号
			,ACCT_ID  --账户编号
			,ACCT_NAME  --账户名称
			,CUST_ID  --客户编号
			,CONT_ID  --合同编号
			,DUBIL_NUM  --借据号
			,LOAN_NUM  --贷款号
			,LOAN_DISTR_ACCT_NUM  --贷款放款账号
			,LOAN_REPAY_NUM  --贷款还款账号
			,INT_SUB_PS_STL_ACCT_NUM  --贴息人结算账号
			,ENTR_DEP_ACCT_NUM  --委托存款账号
			,CSNER_DEP_ACCT_NUM  --委托人存款账号
			,DISTR_FLOW_NUM  --放款流水号
			,INPWN_ACCT_NUM_ID  --质押账号ID
			,OUT_ACCT_NUM  --出账号
			,RELA_BILL_ID  --关联票证编号
			,STD_PROD_ID  --标准产品编号
			,PROD_ID  --产品编号
			,SUBJ_ID  --科目编号
			,INIT_PRIC_SUBJ_ID  --原本金科目编号
			,INT_SUBJ_ID  --表内利息科目编号
			,RECVBL_UNCOL_INT_SUBJ_ID  --应收未收利息科目编号
			,RECVBL_INT_PAYBL_ADJ_SUBJ_ID  --应收应付利息调整科目编号
			,OFF_BS_INT_SUBJ_ID  --表外利息科目编号
			,ACRU_ALDY_IMPAM_INT_SUBJ_ID  --应计已减值利息科目编号
			,INT_INCOME_SUBJ_ID  --利息收入科目编号
			,INT_INCOME_ADJ_SUBJ_ID  --利息收入调整科目编号
			,LOAN_ACCT_STATUS_CD  --贷款账户状态代码
			,LOAN_TENOR  --贷款期限
			,LOAN_TENOR_TYPE_CD  --贷款期限类型代码
			,LOAN_CATE_CD  --贷款类别代码
			,ASSET_THD_CLS_CD  --资产三分类代码
			,BELONG_BUS_STRIP_LINE_CD  --所属业务条线代码
			,GUAR_WAY_CD  --担保方式代码
			,LOAN_USAGE_DESCB  --贷款用途描述
			,ACRU_NON_ACRU_CD  --应计非应计代码
			,TURN_NON_ACRU_LOAN_DT  --转非应计贷款日期
			,CUST_MGR_ID  --客户经理编号
			,OPEN_ACCT_ORG_ID  --开户机构编号
			,MGMT_ORG_ID  --管理机构编号
			,ACCT_INSTIT_ID  --账务机构编号
			,OPEN_ACCT_DT  --开户日期
			,DISTR_DT  --放款日期
			,VALUE_DT  --起息日期
			,STOP_ACCR_INT_DT  --停息日期
			,EXP_DT  --到期日期
			,CLOS_ACCT_DT  --销户日期
			,INT_SUB_FLG  --贴息标志
			,INT_SUB_RATIO  --贴息比例
			,INT_SUB_EXP_DAY  --贴息到期日
			,ENTR_LOAN_COMM_FEE_COLL_WAY  --委托贷款手续费收取方式
			,ENTR_LOAN_COMM_FEE_COLL_RATIO  --委托贷款手续费收取比例
			,ENTR_LOAN_COMM_FEE  --委托贷款手续费
			,INT_ACCR_FLG  --计息标志
			,STOP_ACCR_INT_FLG  --停息标志
			,IMPAM_FLG  --减值标志
			,CRDT_DISTR_REPAY_PLAN_FLG  --信贷发放还款计划标志
			,FINC_PROD_FLG  --理财产品标志
			,PREPAY_INT_AMORT_FLG  --预付利息摊销标志
			,PRIC_AUTO_DEDUCT_FLG  --本金自动扣收标志
			,INT_AUTO_DEDUCT_FLG  --利息自动扣收标志
			,ACPT_FLG  --承兑标志
			,GOVER_FIN_PLAT_LOAN_FLG  --政府融资平台贷款标志
			,TAX_FLG  --扣税标志
			,WRT_OFF_FLG  --核销标志
			,RENEW_FLG  --展期标志
			,RENEW_CNT  --展期次数
			,RENEW_EXP_DAY  --展期到期日
			,ALLOW_ADV_REPAY_FLG  --允许提前还款标志
			,REPAY_SEQ_NO_CD  --还款次序代码
			,ADV_REPAY_WAY_CD  --提前还款方式代码
			,MARGIN_CURR_CD  --保证金币种代码
			,INT_RAT_BASE_TYPE_CD  --利率基准类型代码
			,INT_RAT_CURVE_TYPE_CD  --利率曲线类型代码
			,BASE_RAT  --基准利率
			,EXEC_INT_RAT  --执行利率
			,REVAL_WAY_CD  --重定价方式代码
			,COMN_LOAN_INT_SET_WAY_CD  --普通贷款结息方式代码
			,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
			,INT_RAT_FLOAT_WAY_CD  --利率浮动方式代码
			,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
			,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
			,INT_RAT_FLO_VAL  --利率浮动值
			,CURR_INT_RAT_EFFECT_DT  --当前利率生效日期
			,NEXT_INT_RAT_ADJ_DT  --下次利率调整日期
			,COMP_INT_FLG  --复息标志
			,INT_SET_WAY_CD  --结息方式代码
			,INT_ACCR_WAY_CD  --计息方式代码
			,REPAY_WAY_CD  --还款方式代码
			,REPAY_PED_CORP_CD  --还款周期单位代码
			,REPAY_PED  --还款周期
			,MONEY_USE_TYPE  --款项使用类型
			,LMT_TYPE  --额度类型
			,ASSET_TRAN_STATUS_CD  --资产转让状态代码
			,ASSET_TRAN_DT  --资产转让日期
			,TRAN_BF_INT_RECVBL  --转让前应收利息
			,OVDUE_FLG  --逾期标志
			,PRIC_OVDUE_FLG  --本金逾期标志
			,INT_OVDUE_FLG  --利息逾期标志
			,CURR_OVDUE_PERDS  --当前逾期期数
			,PRIC_OVDUE_DAYS  --本金逾期天数
			,INT_OVDUE_DAYS  --利息逾期天数
			,OVDUE_PRIC_BAL  --逾期本金余额
			,OVDUE_INT_AMT  --逾期利息金额
			,OVDUE_COMP_INT_AMT  --逾期复利金额
			,FIR_OVDUE_DT  --首次逾期日期
			,PRIC_OVDUE_DT  --本金逾期日期
			,INT_OVDUE_DT  --利息逾期日期
			,OVDUE_INT_RAT  --逾期利率
			,OVDUE_INT_RAT_FLO_VAL  --逾期利率浮动值
			,TOT_PERDS  --总期数
			,CURR_ISSUE_PERDS  --本期期数
			,LAST_REPAY_DT  --上次还款日期
			,NEXT_REPAY_DT  --下次还款日期
			,CURR_CD  --币种代码
			,NEXT_RPP_AMT  --下次还本金额
			,NEXT_REPAY_INT_AMT  --下次还息金额
			,TD_ACRU_INT  --当日应计利息
			,CURRT_ACRU_INT  --当期应计利息
			,TD_INT_INCOME  --当日利息收入
			,TD_INT_INCOME_ADJ  --当日利息收入调整
			,CONT_AMT  --合同金额
			,DUBIL_AMT  --借据金额
			,DISTR_AMT  --放款金额
			,NOMAL_PRIC  --正常本金
			,OVDUE_PRIC  --逾期本金
			,IDLE_PRIC  --呆滞本金
			,BAD_DEBT_PRIC  --呆账本金
			,RECVBL_OVER_INT  --应收欠息
			,RECVBL_ACRU_PNLT  --应收应计罚息
			,RECVBL_PNLT  --应收罚息
			,ACRU_COMP_INT  --应计复息
			,RECVBL_COMP_INT  --应收复息_计量后
			,RECVBL_FEE  --应收费用
			,WRT_OFF_PRIC  --核销本金
			,WRT_OFF_INT  --核销利息
			,IN_BS_OVER_INT_BAL  --表内欠息余额
			,OFF_BS_OVER_INT_BAL  --表外欠息余额
			,IN_BS_INT  --表内利息
			,OFF_BS_INT  --表外利息
			,ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
			,RECVBL_UNCOL_INT  --应收未收利息_计量后
			,INT_RECVBL  --应收利息
			,NON_ACRU_INT_RECVBL  --非应计应收利息_计量后
			,ACRU_ALDY_IMPAM_INT  --应计已减值利息
			,REPAID_PRIC  --已偿还本金
			,REPAID_INT  --已偿还利息
			,REPAID_PNLT  --已偿还罚息
			,REPAID_COMP_INT  --已偿还复利
			,REPAID_FEE  --已偿还费用
			,PRIC_BAL  --本金余额
			,CURRT_BAL  --当期余额
			,CL_CURR_CURRT_BAL  --折本币当期余额
			,EAR_D_BAL  --日初余额
			,EAR_M_BAL  --月初余额
			,EAR_S_BAL  --季初余额
			,EAR_Y_BAL  --年初余额
			,Y_ACM_BAL  --年累计余额
			,S_ACM_BAL  --季累计余额
			,M_ACM_BAL  --月累计余额
			,CL_CURR_EAR_D_BAL  --折本币日初余额
			,CL_CURR_EAR_M_BAL  --折本币月初余额
			,CL_CURR_EAR_S_BAL  --折本币季初余额
			,CL_CURR_EAR_Y_BAL  --折本币年初余额
			,CL_CURR_Y_ACM_BAL  --折本币年累计余额
			,CL_CURR_EAR_D_Y_ACM_BAL  --折本币日初年累计余额
			,CL_CURR_EAR_M_Y_ACM_BAL  --折本币月初年累计余额
			,CL_CURR_EAR_S_Y_ACM_BAL  --折本币季初年累计余额
			,CL_CURR_EAR_Y_Y_ACM_BAL  --折本币年初年累计余额
			,CL_CURR_S_ACM_BAL  --折本币季累计余额
			,CL_CURR_EAR_D_S_ACM_BAL  --折本币日初季累计余额
			,CL_CURR_EAR_S_S_ACM_BAL  --折本币季初季累计余额
			,CL_CURR_EAR_Y_S_ACM_BAL  --折本币年初季累计余额
			,CL_CURR_M_ACM_BAL  --折本币月累计余额
			,CL_CURR_EAR_D_M_ACM_BAL  --折本币日初月累计余额
			,CL_CURR_EAR_M_M_ACM_BAL  --折本币月初月累计余额
			,CL_CURR_EAR_Y_M_ACM_BAL  --折本币年初月累计余额
			,Y_AVG_BAL  --年日均余额
			,Q_AVG_BAL  --季日均余额
			,M_AVG_BAL  --月日均余额
			,CL_CURR_Y_AVG_BAL  --折本币年日均余额
			,CL_CURR_Q_AVG_BAL  --折本币季日均余额
			,CL_CURR_M_AVG_BAL  --折本币月日均余额
			,JOB_CD  --任务代码
			,ETL_TIMESTAMP  --数据处理时间
			,GRACE_PERIOD_PRIC  --宽限期本金
			,TRADE_FIN_INT_ADJ  --贸易融资利息调整
			,LOAN_MODAL_CD  --贷款形态代码

    )
    SELECT
			ETL_DT  --数据日期
			,LP_ID  --法人编号
			,ACCT_ID  --账户编号
			,ACCT_NAME  --账户名称
			,CUST_ID  --客户编号
			,CONT_ID  --合同编号
			,DUBIL_NUM  --借据号
			,LOAN_NUM  --贷款号
			,LOAN_DISTR_ACCT_NUM  --贷款放款账号
			,LOAN_REPAY_NUM  --贷款还款账号
			,INT_SUB_PS_STL_ACCT_NUM  --贴息人结算账号
			,ENTR_DEP_ACCT_NUM  --委托存款账号
			,CSNER_DEP_ACCT_NUM  --委托人存款账号
			,DISTR_FLOW_NUM  --放款流水号
			,INPWN_ACCT_NUM_ID  --质押账号ID
			,OUT_ACCT_NUM  --出账号
			,RELA_BILL_ID  --关联票证编号
			,STD_PROD_ID  --标准产品编号
			,PROD_ID  --产品编号
			,SUBJ_ID  --科目编号
			,INIT_PRIC_SUBJ_ID  --原本金科目编号
			,INT_SUBJ_ID  --表内利息科目编号
			,RECVBL_UNCOL_INT_SUBJ_ID  --应收未收利息科目编号
			,RECVBL_INT_PAYBL_ADJ_SUBJ_ID  --应收应付利息调整科目编号
			,OFF_BS_INT_SUBJ_ID  --表外利息科目编号
			,ACRU_ALDY_IMPAM_INT_SUBJ_ID  --应计已减值利息科目编号
			,INT_INCOME_SUBJ_ID  --利息收入科目编号
			,INT_INCOME_ADJ_SUBJ_ID  --利息收入调整科目编号
			,CASE WHEN LOAN_ACCT_STATUS_CD='12' THEN 'C'
            WHEN LOAN_ACCT_STATUS_CD='02' THEN 'A'
            WHEN LOAN_ACCT_STATUS_CD='10' THEN 'P'
            ELSE LOAN_ACCT_STATUS_CD END --贷款账户状态代码
			,LOAN_TENOR  --贷款期限
			,LOAN_TENOR_TYPE_CD  --贷款期限类型代码
			,LOAN_CATE_CD  --贷款类别代码
			,ASSET_THD_CLS_CD  --资产三分类代码
			,BELONG_BUS_STRIP_LINE_CD  --所属业务条线代码
			,GUAR_WAY_CD  --担保方式代码
			,LOAN_USAGE_DESCB  --贷款用途描述
			,ACRU_NON_ACRU_CD  --应计非应计代码
			,TURN_NON_ACRU_LOAN_DT  --转非应计贷款日期
			,CUST_MGR_ID  --客户经理编号
			,OPEN_ACCT_ORG_ID  --开户机构编号
			,MGMT_ORG_ID  --管理机构编号
			,ACCT_INSTIT_ID  --账务机构编号
			,OPEN_ACCT_DT  --开户日期
			,DISTR_DT  --放款日期
			,VALUE_DT  --起息日期
			,STOP_ACCR_INT_DT  --停息日期
			,EXP_DT  --到期日期
			,CLOS_ACCT_DT  --销户日期
			,INT_SUB_FLG  --贴息标志
			,INT_SUB_RATIO  --贴息比例
			,INT_SUB_EXP_DAY  --贴息到期日
			,ENTR_LOAN_COMM_FEE_COLL_WAY  --委托贷款手续费收取方式
			,ENTR_LOAN_COMM_FEE_COLL_RATIO  --委托贷款手续费收取比例
			,ENTR_LOAN_COMM_FEE  --委托贷款手续费
			,INT_ACCR_FLG  --计息标志
			,STOP_ACCR_INT_FLG  --停息标志
			,IMPAM_FLG  --减值标志
			,CRDT_DISTR_REPAY_PLAN_FLG  --信贷发放还款计划标志
			,FINC_PROD_FLG  --理财产品标志
			,PREPAY_INT_AMORT_FLG  --预付利息摊销标志
			,PRIC_AUTO_DEDUCT_FLG  --本金自动扣收标志
			,INT_AUTO_DEDUCT_FLG  --利息自动扣收标志
			,ACPT_FLG  --承兑标志
			,GOVER_FIN_PLAT_LOAN_FLG  --政府融资平台贷款标志
			,TAX_FLG  --扣税标志
			,WRT_OFF_FLG  --核销标志
			,RENEW_FLG  --展期标志
			,RENEW_CNT  --展期次数
			,RENEW_EXP_DAY  --展期到期日
			,ALLOW_ADV_REPAY_FLG  --允许提前还款标志
			,REPAY_SEQ_NO_CD  --还款次序代码
			,ADV_REPAY_WAY_CD  --提前还款方式代码
			,MARGIN_CURR_CD  --保证金币种代码
			,INT_RAT_BASE_TYPE_CD  --利率基准类型代码
			,INT_RAT_CURVE_TYPE_CD  --利率曲线类型代码
			,BASE_RAT  --基准利率
			,EXEC_INT_RAT  --执行利率
			,REVAL_WAY_CD  --重定价方式代码
			,COMN_LOAN_INT_SET_WAY_CD  --普通贷款结息方式代码
			,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
			,INT_RAT_FLOAT_WAY_CD  --利率浮动方式代码
			,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
			,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
			,INT_RAT_FLO_VAL  --利率浮动值
			,CURR_INT_RAT_EFFECT_DT  --当前利率生效日期
			,NEXT_INT_RAT_ADJ_DT  --下次利率调整日期
			,COMP_INT_FLG  --复息标志
			,INT_SET_WAY_CD  --结息方式代码
			,CASE WHEN INT_ACCR_WAY_CD='02' THEN 'EB'
            ELSE INT_ACCR_WAY_CD END --计息方式代码
			,REPAY_WAY_CD  --还款方式代码
			,REPAY_PED_CORP_CD  --还款周期单位代码
			,REPAY_PED  --还款周期
			,MONEY_USE_TYPE  --款项使用类型
			,LMT_TYPE  --额度类型
			,ASSET_TRAN_STATUS_CD  --资产转让状态代码
			,ASSET_TRAN_DT  --资产转让日期
			,TRAN_BF_INT_RECVBL  --转让前应收利息
			,OVDUE_FLG  --逾期标志
			,PRIC_OVDUE_FLG  --本金逾期标志
			,INT_OVDUE_FLG  --利息逾期标志
			,CURR_OVDUE_PERDS  --当前逾期期数
			,PRIC_OVDUE_DAYS  --本金逾期天数
			,INT_OVDUE_DAYS  --利息逾期天数
			,OVDUE_PRIC_BAL  --逾期本金余额
			,OVDUE_INT_AMT  --逾期利息金额
			,OVDUE_COMP_INT_AMT  --逾期复利金额
			,FIR_OVDUE_DT  --首次逾期日期
			,PRIC_OVDUE_DT  --本金逾期日期
			,INT_OVDUE_DT  --利息逾期日期
			,OVDUE_INT_RAT  --逾期利率
			,OVDUE_INT_RAT_FLO_VAL  --逾期利率浮动值
			,TOT_PERDS  --总期数
			,CURR_ISSUE_PERDS  --本期期数
			,LAST_REPAY_DT  --上次还款日期
			,NEXT_REPAY_DT  --下次还款日期
			,CURR_CD  --币种代码
			,NEXT_RPP_AMT  --下次还本金额
			,NEXT_REPAY_INT_AMT  --下次还息金额
			,TD_ACRU_INT  --当日应计利息
			,CURRT_ACRU_INT  --当期应计利息
			,TD_INT_INCOME  --当日利息收入
			,TD_INT_INCOME_ADJ  --当日利息收入调整
			,CONT_AMT  --合同金额
			,DUBIL_AMT  --借据金额
			,DISTR_AMT  --放款金额
			,NOMAL_PRIC  --正常本金
			,OVDUE_PRIC  --逾期本金
			,IDLE_PRIC  --呆滞本金
			,BAD_DEBT_PRIC  --呆账本金
			,RECVBL_OVER_INT  --应收欠息
			,RECVBL_ACRU_PNLT  --应收应计罚息
			,RECVBL_PNLT  --应收罚息
			,ACRU_COMP_INT  --应计复息
			,RECVBL_COMP_INT  --应收复息_计量后
			,RECVBL_FEE  --应收费用
			,WRT_OFF_PRIC  --核销本金
			,WRT_OFF_INT  --核销利息
			,IN_BS_OVER_INT_BAL  --表内欠息余额
			,OFF_BS_OVER_INT_BAL  --表外欠息余额
			,IN_BS_INT  --表内利息
			,OFF_BS_INT  --表外利息
			,ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
			,RECVBL_UNCOL_INT  --应收未收利息_计量后
			,INT_RECVBL  --应收利息
			,NON_ACRU_INT_RECVBL  --非应计应收利息_计量后
			,ACRU_ALDY_IMPAM_INT  --应计已减值利息
			,REPAID_PRIC  --已偿还本金
			,REPAID_INT  --已偿还利息
			,REPAID_PNLT  --已偿还罚息
			,REPAID_COMP_INT  --已偿还复利
			,REPAID_FEE  --已偿还费用
			,PRIC_BAL  --本金余额
			,CURRT_BAL  --当期余额
			,CL_CURR_CURRT_BAL  --折本币当期余额
			,EAR_D_BAL  --日初余额
			,EAR_M_BAL  --月初余额
			,EAR_S_BAL  --季初余额
			,EAR_Y_BAL  --年初余额
			,Y_ACM_BAL  --年累计余额
			,S_ACM_BAL  --季累计余额
			,M_ACM_BAL  --月累计余额
			,CL_CURR_EAR_D_BAL  --折本币日初余额
			,CL_CURR_EAR_M_BAL  --折本币月初余额
			,CL_CURR_EAR_S_BAL  --折本币季初余额
			,CL_CURR_EAR_Y_BAL  --折本币年初余额
			,CL_CURR_Y_ACM_BAL  --折本币年累计余额
			,CL_CURR_EAR_D_Y_ACM_BAL  --折本币日初年累计余额
			,CL_CURR_EAR_M_Y_ACM_BAL  --折本币月初年累计余额
			,CL_CURR_EAR_S_Y_ACM_BAL  --折本币季初年累计余额
			,CL_CURR_EAR_Y_Y_ACM_BAL  --折本币年初年累计余额
			,CL_CURR_S_ACM_BAL  --折本币季累计余额
			,CL_CURR_EAR_D_S_ACM_BAL  --折本币日初季累计余额
			,CL_CURR_EAR_S_S_ACM_BAL  --折本币季初季累计余额
			,CL_CURR_EAR_Y_S_ACM_BAL  --折本币年初季累计余额
			,CL_CURR_M_ACM_BAL  --折本币月累计余额
			,CL_CURR_EAR_D_M_ACM_BAL  --折本币日初月累计余额
			,CL_CURR_EAR_M_M_ACM_BAL  --折本币月初月累计余额
			,CL_CURR_EAR_Y_M_ACM_BAL  --折本币年初月累计余额
			,Y_AVG_BAL  --年日均余额
			,Q_AVG_BAL  --季日均余额
			,M_AVG_BAL  --月日均余额
			,CL_CURR_Y_AVG_BAL  --折本币年日均余额
			,CL_CURR_Q_AVG_BAL  --折本币季日均余额
			,CL_CURR_M_AVG_BAL  --折本币月日均余额
			,JOB_CD  --任务代码
			,ETL_TIMESTAMP  --数据处理时间
			,GRACE_PERIOD_PRIC  --宽限期本金
			,TRADE_FIN_INT_ADJ  --贸易融资利息调整
			,LOAN_MODAL_CD  --贷款形态代码
    FROM ICL.V_CMM_CORP_LOAN_ACCT_INFO  --视图-对公贷款账户信息
      WHERE ETL_DT BETWEEN TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1--上月末
        AND TO_DATE(V_P_DATE,'YYYYMMDD') --跑批日
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

  END ETL_INIT_O_ICL_CMM_CORP_LOAN_ACCT_INFO;
/

