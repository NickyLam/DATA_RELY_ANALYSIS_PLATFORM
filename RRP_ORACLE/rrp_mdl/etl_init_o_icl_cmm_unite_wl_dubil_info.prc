CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_UNITE_WL_DUBIL_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_UNITE_WL_DUBIL_INFO
  *  功能描述：联合网贷借据信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_UNITE_WL_DUBIL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_UNITE_WL_DUBIL_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_LAST_YEAR DATE;          -- 上年末日期
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_LAST_YEAR := TRUNC(TO_DATE(I_P_DATE,'YYYY-MM-DD'),'YYYY') -1;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_UNITE_WL_DUBIL_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_UNITE_WL_DUBIL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-联合网贷借据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,DUBIL_ID  --借据编号
      ,STD_PROD_ID  --标准产品编号
      ,PROD_ID  --产品编号
      ,CUST_ID  --客户编号
      ,SUBJ_ID  --科目编号
      ,ACCTNT_CATE_CD  --会计类别代码
      ,ENTER_ACCT_ACCT_NUM  --入账账号
      ,REPAY_NUM  --还款账号
      ,RELA_AGT_ID  --关联协议编号
      ,RELA_APPL_FLOW_NUM  --关联申请流水号
      ,CURR_CD  --币种代码
      ,BUS_BREED_ID  --业务品种编号
      ,LOAN_TYPE_CD  --贷款类型代码
      ,ASSET_THD_CLS_CD  --资产三分类代码
      ,DUBIL_STATUS_CD  --借据状态代码
      ,LOAN_USAGE_CD  --贷款用途代码
      ,DIR_INDUS_CD  --投向行业代码
      ,CONT_STATUS_CD  --合同状态代码
      ,LOAN_LEVEL4_CLS_CD  --贷款四级分类代码
      ,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
      ,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
      ,LOAN_LEVEL12_CLS_CD  --贷款十二级分类代码
      ,ACRU_NON_ACRU_CD  --应计非应计代码
      ,REPAY_WAY_CD  --还款方式代码
      ,INT_SET_WAY_CD  --结息方式代码
      ,INT_ACCR_WAY_CD  --计息方式代码
      ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
      ,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
      ,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
      ,INT_RAT_BASE_TYPE_CD  --利率基准类型代码
      ,INT_RAT_FLOAT_WAY_CD  --利率浮动方式代码
      ,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
      ,INT_RAT_FLO_VAL  --利率浮动值
      ,PRIC_REPAY_FREQ_CD  --本金还款频率代码
      ,INT_REPAY_FREQ_CD  --利息还款频率代码
      ,GUAR_WAY_CD  --担保方式代码
      ,ENTER_ACCT_ACCT_NUM_TYPE  --入账账号类型
      ,REPAY_NUM_TYPE  --还款账号类型
      ,INTNAL_CARR_FLG  --内部结转标志
      ,DOM_OVERS_FLG  --境内外标志
      ,INT_ACCR_FLG  --计息标志
      ,COMP_INT_FLG  --复息标志
      ,OVDUE_FLG  --逾期标志
      ,WRT_OFF_FLG  --核销标志
      ,OPEN_ACCT_DT  --开户日期
      ,DISTR_DT  --放款日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,PAYOFF_DT  --结清日期
      ,LAST_REPAY_DT  --上次还款日期
      ,NEXT_REPAY_DT  --下次还款日期
      ,CURR_INT_RAT_EFFECT_DT  --当前利率生效日期
      ,NEXT_INT_RAT_ADJ_DT  --下次利率调整日期
      ,CUST_MGR_ID  --客户经理编号
      ,OPEN_ACCT_ORG_ID  --开户机构编号
      ,MGMT_ORG_ID  --管理机构编号
      ,ACCT_INSTIT_ID  --账务机构编号
      ,TOT_PERDS  --总期数
      ,CURR_ISSUE_PERDS  --本期期数
      ,SURP_PERDS  --剩余期数
      ,OVDUE_PERDS  --逾期期数
      ,PRIC_OVDUE_FLG  --本金逾期标志
      ,INT_OVDUE_FLG  --利息逾期标志
      ,PRIC_OVDUE_DAYS  --本金逾期天数
      ,INT_OVDUE_DAYS  --利息逾期天数
      ,GRACE_PERIOD_DAYS  --宽限期天数
      ,INST_COMM_FEE_RAT  --分期手续费费率
      ,BASE_RAT  --基准利率
      ,EXEC_INT_RAT  --执行利率
      ,OVDUE_INT_RAT  --逾期利率
      ,DAILY_EXEC_INT_RAT  --每日执行利率
      ,CONT_AMT  --合同金额
      ,DUBIL_AMT  --借据金额
      ,DISTR_AMT  --放款金额
      ,BANK_CONTRI_RATIO  --银行出资比例
      ,TD_ACRU_INT  --当日应计利息
      ,CURRT_ACRU_INT  --当期应计利息
      ,NOMAL_PRIC  --正常本金
      ,OVDUE_PRIC  --逾期本金
      ,IDLE_PRIC  --呆滞本金
      ,BAD_DEBT_PRIC  --呆账本金
      ,WRT_OFF_PRIC  --核销本金
      ,NOMAL_INT  --正常利息
      ,OVDUE_INT  --逾期利息
      ,WRT_OFF_INT  --核销利息
      ,OVDUE_PRIC_PNLT  --逾期本金罚息
      ,OVDUE_INT_PNLT  --逾期利息罚息
      ,RECVBL_OVER_INT  --应收欠息
      ,RECVBL_ACRU_PNLT  --应收应计罚息
      ,RECVBL_PNLT  --应收罚息
      ,RECVBL_FEE  --应收费用
      ,IN_BS_OVER_INT_BAL  --表内欠息余额
      ,OFF_BS_OVER_INT_BAL  --表外欠息余额
      ,IN_BS_INT  --表内利息
      ,OFF_BS_INT  --表外利息
      ,ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
      ,REPAID_NOMAL_PRIC  --已偿还正常本金
      ,REPAID_OVDUE_PRIC  --已偿还逾期本金
      ,REPAID_NOMAL_INT  --已偿还正常利息
      ,REPAID_OVDUE_INT  --已偿还逾期利息
      ,REPAID_OVDUE_PRIC_PNLT  --已偿还逾期本金罚息
      ,REPAID_OVDUE_INT_PNLT  --已偿还逾期利息罚息
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
      ,INIT_TOT_PERDS  --原始总期数
      ,WHITE_LIST_CUST_FLG  --白户标志
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT+1  --数据日期
      ,LP_ID  --法人编号
      ,DUBIL_ID  --借据编号
      ,CASE WHEN STD_PROD_ID = '202010401' THEN '202010100004'
        WHEN STD_PROD_ID = '202010101' THEN '202010100006'
        WHEN STD_PROD_ID = '202020101' THEN '202020100001'
        WHEN STD_PROD_ID = '202029904' THEN '202020200004'
        WHEN STD_PROD_ID = '202010301' THEN '202010100003'
        WHEN STD_PROD_ID = '202010201' THEN '202010100001'
        WHEN STD_PROD_ID = '202010202' THEN '202010100002' ELSE PROD_ID
        END
        --标准产品编号
      ,CASE WHEN STD_PROD_ID = '202010401' THEN '202010100004'
        WHEN STD_PROD_ID = '202010101' THEN '202010100006'
        WHEN STD_PROD_ID = '202020101' THEN '202020100001'
        WHEN STD_PROD_ID = '202029904' THEN '202020200004'
        WHEN STD_PROD_ID = '202010301' THEN '202010100003'
        WHEN STD_PROD_ID = '202010201' THEN '202010100001'
        WHEN STD_PROD_ID = '202010202' THEN '202010100002' ELSE PROD_ID
        END--产品编号
      ,CUST_ID  --客户编号
      ,SUBJ_ID  --科目编号
      ,ACCTNT_CATE_CD  --会计类别代码
      ,ENTER_ACCT_ACCT_NUM  --入账账号
      ,REPAY_NUM  --还款账号
      ,RELA_AGT_ID  --关联协议编号
      ,RELA_APPL_FLOW_NUM  --关联申请流水号
      ,CURR_CD  --币种代码
      ,BUS_BREED_ID  --业务品种编号
      ,LOAN_TYPE_CD  --贷款类型代码
      ,ASSET_THD_CLS_CD  --资产三分类代码
      ,DUBIL_STATUS_CD  --借据状态代码
      ,LOAN_USAGE_CD  --贷款用途代码
      ,DIR_INDUS_CD  --投向行业代码
      ,CONT_STATUS_CD  --合同状态代码
      ,LOAN_LEVEL4_CLS_CD  --贷款四级分类代码
      ,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
      ,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
      ,LOAN_LEVEL12_CLS_CD  --贷款十二级分类代码
      ,ACRU_NON_ACRU_CD  --应计非应计代码
      ,REPAY_WAY_CD  --还款方式代码
      ,INT_SET_WAY_CD  --结息方式代码
      ,INT_ACCR_WAY_CD  --计息方式代码
      ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
      ,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
      ,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
      ,INT_RAT_BASE_TYPE_CD  --利率基准类型代码
      ,INT_RAT_FLOAT_WAY_CD  --利率浮动方式代码
      ,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
      ,INT_RAT_FLO_VAL  --利率浮动值
      ,PRIC_REPAY_FREQ_CD  --本金还款频率代码
      ,INT_REPAY_FREQ_CD  --利息还款频率代码
      ,GUAR_WAY_CD  --担保方式代码
      ,ENTER_ACCT_ACCT_NUM_TYPE  --入账账号类型
      ,REPAY_NUM_TYPE  --还款账号类型
      ,INTNAL_CARR_FLG  --内部结转标志
      ,DOM_OVERS_FLG  --境内外标志
      ,INT_ACCR_FLG  --计息标志
      ,COMP_INT_FLG  --复息标志
      ,OVDUE_FLG  --逾期标志
      ,WRT_OFF_FLG  --核销标志
      ,OPEN_ACCT_DT  --开户日期
      ,DISTR_DT  --放款日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,PAYOFF_DT  --结清日期
      ,LAST_REPAY_DT  --上次还款日期
      ,NEXT_REPAY_DT  --下次还款日期
      ,CURR_INT_RAT_EFFECT_DT  --当前利率生效日期
      ,NEXT_INT_RAT_ADJ_DT  --下次利率调整日期
      ,CUST_MGR_ID  --客户经理编号
      ,OPEN_ACCT_ORG_ID  --开户机构编号
      ,MGMT_ORG_ID  --管理机构编号
      ,ACCT_INSTIT_ID  --账务机构编号
      ,TOT_PERDS  --总期数
      ,CURR_ISSUE_PERDS  --本期期数
      ,SURP_PERDS  --剩余期数
      ,OVDUE_PERDS  --逾期期数
      ,PRIC_OVDUE_FLG  --本金逾期标志
      ,INT_OVDUE_FLG  --利息逾期标志
      ,PRIC_OVDUE_DAYS  --本金逾期天数
      ,INT_OVDUE_DAYS  --利息逾期天数
      ,GRACE_PERIOD_DAYS  --宽限期天数
      ,INST_COMM_FEE_RAT  --分期手续费费率
      ,BASE_RAT  --基准利率
      ,EXEC_INT_RAT  --执行利率
      ,OVDUE_INT_RAT  --逾期利率
      ,DAILY_EXEC_INT_RAT  --每日执行利率
      ,CONT_AMT  --合同金额
      ,DUBIL_AMT  --借据金额
      ,DISTR_AMT  --放款金额
      ,BANK_CONTRI_RATIO  --银行出资比例
      ,TD_ACRU_INT  --当日应计利息
      ,CURRT_ACRU_INT  --当期应计利息
      ,NOMAL_PRIC  --正常本金
      ,OVDUE_PRIC  --逾期本金
      ,IDLE_PRIC  --呆滞本金
      ,BAD_DEBT_PRIC  --呆账本金
      ,WRT_OFF_PRIC  --核销本金
      ,NOMAL_INT  --正常利息
      ,OVDUE_INT  --逾期利息
      ,WRT_OFF_INT  --核销利息
      ,OVDUE_PRIC_PNLT  --逾期本金罚息
      ,OVDUE_INT_PNLT  --逾期利息罚息
      ,RECVBL_OVER_INT  --应收欠息
      ,RECVBL_ACRU_PNLT  --应收应计罚息
      ,RECVBL_PNLT  --应收罚息
      ,RECVBL_FEE  --应收费用
      ,IN_BS_OVER_INT_BAL  --表内欠息余额
      ,OFF_BS_OVER_INT_BAL  --表外欠息余额
      ,IN_BS_INT  --表内利息
      ,OFF_BS_INT  --表外利息
      ,ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
      ,REPAID_NOMAL_PRIC  --已偿还正常本金
      ,REPAID_OVDUE_PRIC  --已偿还逾期本金
      ,REPAID_NOMAL_INT  --已偿还正常利息
      ,REPAID_OVDUE_INT  --已偿还逾期利息
      ,REPAID_OVDUE_PRIC_PNLT  --已偿还逾期本金罚息
      ,REPAID_OVDUE_INT_PNLT  --已偿还逾期利息罚息
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
      ,INIT_TOT_PERDS  --原始总期数
      ,WHITE_LIST_CUST_FLG  --白户标志
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_UNITE_WL_DUBIL_INFO  --视图-联合网贷借据信息
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')-1
    OR ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-2
;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 取上年1231放款的数据
   INSERT INTO RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO
   (
							ETL_DT  --数据日期
							,LP_ID  --法人编号
							,DUBIL_ID  --借据编号
							,STD_PROD_ID  --标准产品编号
							,PROD_ID  --产品编号
							,CUST_ID  --客户编号
							,SUBJ_ID  --科目编号
							,ACCTNT_CATE_CD  --会计类别代码
							,ENTER_ACCT_ACCT_NUM  --入账账号
							,REPAY_NUM  --还款账号
							,RELA_AGT_ID  --关联协议编号
							,RELA_APPL_FLOW_NUM  --关联申请流水号
							,CURR_CD  --币种代码
							,BUS_BREED_ID  --业务品种编号
							,LOAN_TYPE_CD  --贷款类型代码
							,ASSET_THD_CLS_CD  --资产三分类代码
							,DUBIL_STATUS_CD  --借据状态代码
							,LOAN_USAGE_CD  --贷款用途代码
							,DIR_INDUS_CD  --投向行业代码
							,CONT_STATUS_CD  --合同状态代码
							,LOAN_LEVEL4_CLS_CD  --贷款四级分类代码
							,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
							,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
							,LOAN_LEVEL12_CLS_CD  --贷款十二级分类代码
							,ACRU_NON_ACRU_CD  --应计非应计代码
							,REPAY_WAY_CD  --还款方式代码
							,INT_SET_WAY_CD  --结息方式代码
							,INT_ACCR_WAY_CD  --计息方式代码
							,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
							,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
							,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
							,INT_RAT_BASE_TYPE_CD  --利率基准类型代码
							,INT_RAT_FLOAT_WAY_CD  --利率浮动方式代码
							,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
							,INT_RAT_FLO_VAL  --利率浮动值
							,PRIC_REPAY_FREQ_CD  --本金还款频率代码
							,INT_REPAY_FREQ_CD  --利息还款频率代码
							,GUAR_WAY_CD  --担保方式代码
							,CUST_CHAR_CD  --客户性质代码
							,ENTER_ACCT_ACCT_NUM_TYPE  --入账账号类型
							,REPAY_NUM_TYPE  --还款账号类型
							,INTNAL_CARR_FLG  --内部结转标志
							,DOM_OVERS_FLG  --境内外标志
							,WHITE_LIST_CUST_FLG  --白户标志
							,FARM_FLG  --农户标志
							,INT_ACCR_FLG  --计息标志
							,COMP_INT_FLG  --复息标志
							,OVDUE_FLG  --逾期标志
							,WRT_OFF_FLG  --核销标志
							,OPEN_ACCT_DT  --开户日期
							,DISTR_DT  --放款日期
							,VALUE_DT  --起息日期
							,EXP_DT  --到期日期
							,PAYOFF_DT  --结清日期
							,LAST_REPAY_DT  --上次还款日期
							,NEXT_REPAY_DT  --下次还款日期
							,CURR_INT_RAT_EFFECT_DT  --当前利率生效日期
							,NEXT_INT_RAT_ADJ_DT  --下次利率调整日期
							,CUST_MGR_ID  --客户经理编号
							,OPEN_ACCT_ORG_ID  --开户机构编号
							,MGMT_ORG_ID  --管理机构编号
							,ACCT_INSTIT_ID  --账务机构编号
							,INIT_TOT_PERDS  --原始总期数
							,TOT_PERDS  --总期数
							,CURR_ISSUE_PERDS  --本期期数
							,SURP_PERDS  --剩余期数
							,OVDUE_PERDS  --逾期期数
							,PRIC_OVDUE_FLG  --本金逾期标志
							,INT_OVDUE_FLG  --利息逾期标志
							,PRIC_OVDUE_DAYS  --本金逾期天数
							,INT_OVDUE_DAYS  --利息逾期天数
							,GRACE_PERIOD_DAYS  --宽限期天数
							,INST_COMM_FEE_RAT  --分期手续费费率
							,BASE_RAT  --基准利率
							,EXEC_INT_RAT  --执行利率
							,OVDUE_INT_RAT  --逾期利率
							,DAILY_EXEC_INT_RAT  --每日执行利率
							,CONT_AMT  --合同金额
							,DUBIL_AMT  --借据金额
							,DISTR_AMT  --放款金额
							,BANK_CONTRI_RATIO  --银行出资比例
							,TD_ACRU_INT  --当日应计利息
							,CURRT_ACRU_INT  --当期应计利息
							,NOMAL_PRIC  --正常本金
							,OVDUE_PRIC  --逾期本金
							,IDLE_PRIC  --呆滞本金
							,BAD_DEBT_PRIC  --呆账本金
							,WRT_OFF_PRIC  --核销本金
							,NOMAL_INT  --正常利息
							,OVDUE_INT  --逾期利息
							,WRT_OFF_INT  --核销利息
							,OVDUE_PRIC_PNLT  --逾期本金罚息
							,OVDUE_INT_PNLT  --逾期利息罚息
							,RECVBL_OVER_INT  --应收欠息
							,RECVBL_ACRU_PNLT  --应收应计罚息
							,RECVBL_PNLT  --应收罚息
							,RECVBL_FEE  --应收费用
							,IN_BS_OVER_INT_BAL  --表内欠息余额
							,OFF_BS_OVER_INT_BAL  --表外欠息余额
							,IN_BS_INT  --表内利息
							,OFF_BS_INT  --表外利息
							,ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
							,REPAID_NOMAL_PRIC  --已偿还正常本金
							,REPAID_OVDUE_PRIC  --已偿还逾期本金
							,REPAID_NOMAL_INT  --已偿还正常利息
							,REPAID_OVDUE_INT  --已偿还逾期利息
							,REPAID_OVDUE_PRIC_PNLT  --已偿还逾期本金罚息
							,REPAID_OVDUE_INT_PNLT  --已偿还逾期利息罚息
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

   )
   SELECT
   						TO_DATE(V_P_DATE,'YYYYMMDD')  --数据日期
							,LP_ID  --法人编号
							,DUBIL_ID  --借据编号
							,STD_PROD_ID  --标准产品编号
							,PROD_ID  --产品编号
							,CUST_ID  --客户编号
							,SUBJ_ID  --科目编号
							,ACCTNT_CATE_CD  --会计类别代码
							,ENTER_ACCT_ACCT_NUM  --入账账号
							,REPAY_NUM  --还款账号
							,RELA_AGT_ID  --关联协议编号
							,RELA_APPL_FLOW_NUM  --关联申请流水号
							,CURR_CD  --币种代码
							,BUS_BREED_ID  --业务品种编号
							,LOAN_TYPE_CD  --贷款类型代码
							,ASSET_THD_CLS_CD  --资产三分类代码
							,DUBIL_STATUS_CD  --借据状态代码
							,LOAN_USAGE_CD  --贷款用途代码
							,DIR_INDUS_CD  --投向行业代码
							,CONT_STATUS_CD  --合同状态代码
							,LOAN_LEVEL4_CLS_CD  --贷款四级分类代码
							,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
							,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
							,LOAN_LEVEL12_CLS_CD  --贷款十二级分类代码
							,ACRU_NON_ACRU_CD  --应计非应计代码
							,REPAY_WAY_CD  --还款方式代码
							,INT_SET_WAY_CD  --结息方式代码
							,INT_ACCR_WAY_CD  --计息方式代码
							,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
							,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
							,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
							,INT_RAT_BASE_TYPE_CD  --利率基准类型代码
							,INT_RAT_FLOAT_WAY_CD  --利率浮动方式代码
							,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
							,INT_RAT_FLO_VAL  --利率浮动值
							,PRIC_REPAY_FREQ_CD  --本金还款频率代码
							,INT_REPAY_FREQ_CD  --利息还款频率代码
							,GUAR_WAY_CD  --担保方式代码
							,CUST_CHAR_CD  --客户性质代码
							,ENTER_ACCT_ACCT_NUM_TYPE  --入账账号类型
							,REPAY_NUM_TYPE  --还款账号类型
							,INTNAL_CARR_FLG  --内部结转标志
							,DOM_OVERS_FLG  --境内外标志
							,WHITE_LIST_CUST_FLG  --白户标志
							,FARM_FLG  --农户标志
							,INT_ACCR_FLG  --计息标志
							,COMP_INT_FLG  --复息标志
							,OVDUE_FLG  --逾期标志
							,WRT_OFF_FLG  --核销标志
							,OPEN_ACCT_DT  --开户日期
							,DISTR_DT  --放款日期
							,VALUE_DT  --起息日期
							,EXP_DT  --到期日期
							,PAYOFF_DT  --结清日期
							,LAST_REPAY_DT  --上次还款日期
							,NEXT_REPAY_DT  --下次还款日期
							,CURR_INT_RAT_EFFECT_DT  --当前利率生效日期
							,NEXT_INT_RAT_ADJ_DT  --下次利率调整日期
							,CUST_MGR_ID  --客户经理编号
							,OPEN_ACCT_ORG_ID  --开户机构编号
							,MGMT_ORG_ID  --管理机构编号
							,ACCT_INSTIT_ID  --账务机构编号
							,INIT_TOT_PERDS  --原始总期数
							,TOT_PERDS  --总期数
							,CURR_ISSUE_PERDS  --本期期数
							,SURP_PERDS  --剩余期数
							,OVDUE_PERDS  --逾期期数
							,PRIC_OVDUE_FLG  --本金逾期标志
							,INT_OVDUE_FLG  --利息逾期标志
							,PRIC_OVDUE_DAYS  --本金逾期天数
							,INT_OVDUE_DAYS  --利息逾期天数
							,GRACE_PERIOD_DAYS  --宽限期天数
							,INST_COMM_FEE_RAT  --分期手续费费率
							,BASE_RAT  --基准利率
							,EXEC_INT_RAT  --执行利率
							,OVDUE_INT_RAT  --逾期利率
							,DAILY_EXEC_INT_RAT  --每日执行利率
							,CONT_AMT  --合同金额
							,DUBIL_AMT  --借据金额
							,DISTR_AMT  --放款金额
							,BANK_CONTRI_RATIO  --银行出资比例
							,TD_ACRU_INT  --当日应计利息
							,CURRT_ACRU_INT  --当期应计利息
							,NOMAL_PRIC  --正常本金
							,OVDUE_PRIC  --逾期本金
							,IDLE_PRIC  --呆滞本金
							,BAD_DEBT_PRIC  --呆账本金
							,WRT_OFF_PRIC  --核销本金
							,NOMAL_INT  --正常利息
							,OVDUE_INT  --逾期利息
							,WRT_OFF_INT  --核销利息
							,OVDUE_PRIC_PNLT  --逾期本金罚息
							,OVDUE_INT_PNLT  --逾期利息罚息
							,RECVBL_OVER_INT  --应收欠息
							,RECVBL_ACRU_PNLT  --应收应计罚息
							,RECVBL_PNLT  --应收罚息
							,RECVBL_FEE  --应收费用
							,IN_BS_OVER_INT_BAL  --表内欠息余额
							,OFF_BS_OVER_INT_BAL  --表外欠息余额
							,IN_BS_INT  --表内利息
							,OFF_BS_INT  --表外利息
							,ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
							,REPAID_NOMAL_PRIC  --已偿还正常本金
							,REPAID_OVDUE_PRIC  --已偿还逾期本金
							,REPAID_NOMAL_INT  --已偿还正常利息
							,REPAID_OVDUE_INT  --已偿还逾期利息
							,REPAID_OVDUE_PRIC_PNLT  --已偿还逾期本金罚息
							,REPAID_OVDUE_INT_PNLT  --已偿还逾期利息罚息
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
   FROM  ICL.V_CMM_UNITE_WL_DUBIL_INFO_CLEAR    --联合网贷借据信息-结清
   WHERE ETL_DT = V_LAST_YEAR + 10
    AND  SUBSTR(PAYOFF_DT,1,10) = V_LAST_YEAR  --MDF BY XUFEI 20221008  需要接年末1231当天结清的数据
    AND  CURRT_BAL = 0;
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

  END ETL_INIT_O_ICL_CMM_UNITE_WL_DUBIL_INFO;
/

