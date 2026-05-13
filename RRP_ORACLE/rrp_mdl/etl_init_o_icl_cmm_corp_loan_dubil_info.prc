CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_CORP_LOAN_DUBIL_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_CORP_LOAN_DUBIL_INFO
  *  功能描述：对公贷款借据信息
  *  创建日期：20231113
  *  开发人员：hulj
  *  来源表： ICL.V_CMM_CORP_LOAN_DUBIL_INFO
  *  目标表： O_ICL_CMM_CORP_LOAN_DUBIL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20231113  hulj     追数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_CORP_LOAN_DUBIL_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME  VARCHAR2(50);
  V_PART_NAME VARCHAR2(200); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_TAB_NAME := 'O_ICL_CMM_CORP_LOAN_DUBIL_INFO'; --表名

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_ICL_CMM_CORP_LOAN_DUBIL_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE O_ICL_CMM_CORP_LOAN_DUBIL_INFO';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公贷款借据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO
  (              ETL_DT  --数据日期
          ,LP_ID  --法人编号
          ,DUBIL_ID  --借据编号
          ,CONT_ID  --合同编号
          ,STD_PROD_ID  --标准产品编号
          ,OUT_ACCT_FLOW_NUM  --出账流水号
          ,RELA_DUBIL_ID  --关联借据编号
          ,INTNL_TRAD_FIN_RELA_ID_2  --国际贸易融资业务关联编号2
          ,BILL_NUM  --票据号码
          ,BILL_ID  --票据编号
          ,BILL_UNIQ_MARK_ID  --票据唯一标示编号
          ,IBANK_ASSET_UNIQ_IDF_ID  --同业资产唯一标识编号
          ,CUST_ID  --客户编号
          ,HOST_CUST_ID  --主机客户编号
          ,DISTR_ACCT_NUM  --放款账号
          ,REPAY_NUM  --还款账号
          ,SECD_REPAY_NUM  --第二还款账号
          ,STL_ACCT_NUM  --结算帐号
          ,MANU_CONT_ID  --人工合同编号
          ,CRDT_LMT_AGT_ID  --授信额度协议编号
          ,ADVC_FLG  --垫款标志
          ,PRE_RECV_INT_FLG  --预收息标志
          ,ATTACH_RGST_DUBIL_FLG  --补登借据标志
          ,MATN_FLG  --维护标志
          ,WRT_OFF_FLG  --核销标志
          ,COMP_INT_FLG  --复息标志
          ,STOP_ACCR_INT_FLG  --停息标志
          ,SIGN_CRDT_CONT_FLG  --签署授信合同标志
          ,PRIC_AUTO_RTN_FLG  --本金自动归还标志
          ,INT_AUTO_RTN_FLG  --利息自动归还标志
          ,CRDT_DISTR_REPAY_PLAN_FLG  --信贷发放还款计划标志
          ,EDU_HEA_FLG  --文教健康标志
          ,PBC_INC_LOAN_FLG  --人行普惠贷款标志
          ,FILE_INT_ACCR_FLG  --靠档计息标志
          ,OVERS_LOAN_FLG  --境外贷款标志
          ,BUS_BREED_ID  --业务品种编号
          ,DUBIL_STATUS_CD  --借据状态代码
          ,REFAC_LOAN_STATUS_CD  --支小再贷款状态代码
          ,LOAN_HAPP_TYPE_CD  --贷款发生类型代码
          ,MODE_PAY_CD  --支付方式代码
          ,CURR_CD  --币种代码
          ,INT_ACCR_WAY_CD  --计息方式代码
          ,LOAN_TYPE_CD  --贷款类型代码
          ,ASSET_THD_CLS_CD  --资产三分类代码
          ,LOAN_LEVEL4_CLS_CD  --贷款四级分类代码
          ,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
          ,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
          ,LOAN_LEVEL12_CLS_CD  --贷款十二级分类代码
          ,REPAY_WAY_CD  --还款方式代码
          ,DIR_INDUS_CD  --投向行业代码
          ,GUAR_WAY_CD  --担保方式代码
          ,LOAN_KIND_CD  --贷款种类代码
          ,WRTOFF_TYPE_CD  --注销类型代码
          ,LOAN_TENOR_TYPE_CD  --贷款期限类型代码
          ,LOAN_TENOR_SEG_CD  --贷款期限分段代码
          ,BILL_KIND_CD  --票据种类代码
          ,BILL_MED_CD  --票据介质代码
          ,DATA_SRC_FLG  --数据来源标志
          ,INT_RAT_ADJ_WAY_CD  --利率调整类型代码
          ,COL_INT_TYPE_CD  --收息类型代码
          ,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
          ,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
          ,INST_LOAN_REPAY_WAY_CD  --分期贷款还款方式代码
          ,MONEY_USE_TYPE_CD  --款项使用类型代码
          ,CRDTC_SUBM_BUS_BREED_CD  --征信报送业务品种代码
          ,CRDTC_SUBM_BUS_BREED_DESCB  --征信报送业务品种描述
          ,ORG_ID  --机构编号
          ,ACCT_INSTIT_ID  --账务机构编号
          ,OPER_ORG_ID  --经办机构编号
          ,OPER_TELLER_ID  --经办柜员编号
          ,RGST_ORG_ID  --登记机构编号
          ,RGST_TELLER_ID  --登记柜员编号
          ,ATTACH_RGST_CHECK_TELLER_ID  --补登复核柜员编号
          ,BENEFC_NAME  --受益人名称
          ,BNFT_BK_NO  --受益行行号
          ,BNFT_BK_NAME  --受益行行名
          ,ACPT_BANK_NO  --承兑行行号
          ,ACPT_BANK_NAME  --承兑行名称
          ,MARGIN_ACCT_NUM  --保证金账号
          ,MARGIN_SUB_ACCT_NUM  --保证金子户号
          ,MARGIN_CURR_CD  --保证金币种代码
          ,MARGIN_AMT  --保证金金额
          ,MARGIN_RATIO  --保证金比例
          ,REFAC_LOAN_BATCH_PKG_ID  --支小再贷款批次包编号
          ,REFAC_LOAN_BATCH_EXP_DT  --支小再贷款批次到期日期
          ,REFAC_LOAN_USE_INT_RAT  --支小再贷款使用利率
          ,DUBIL_WRTOFF_FLOW_NUM  --借据注销流水号
          ,DUBIL_OPEN_FLOW_NUM  --借据开立流水号
          ,DUBIL_OPEN_DT  --借据开立日期
          ,DISTR_DT  --放款日期
          ,APOT_EXP_DT  --约定到期日期
          ,EXEC_EXP_DT  --执行到期日期
          ,NEXT_INT_SET_DT  --下次结息日期
          ,LOAN_CLS_DT  --贷款分类日期
          ,LEVEL5_CLS_IDTFY_DT  --五级分类认定日期
          ,NEXT_TERM_RPP_DT  --下一期还本日期
          ,NEXT_TERM_REPAY_INT_DT  --下一期还息日期
          ,PAYOFF_DT  --结清日期
          ,OVDUE_DT  --逾期日期
          ,OVER_INT_DT  --欠息日期
          ,OVDUE_DAYS  --逾期天数
          ,OVER_INT_DAYS  --欠息天数
          ,LOAN_PED  --贷款周期
          ,INST_LOAN_TOT_PERDS  --分期贷款总期数
          ,SURP_PERDS  --剩余期数
          ,ACM_DEBT_PERDS  --累计欠款期数
          ,BASE_RAT  --基准利率
          ,EXEC_INT_RAT  --执行利率
          ,OVDUE_INT_RAT  --逾期利率
          ,COMM_FEE_FEE_RAT  --手续费费率
          ,NEXT_TERM_RPP_AMT  --下一期还本金额
          ,NEXT_TERM_REPAY_INT_AMT  --下一期还息金额
          ,REPAY_NUM_BAL  --还款账号余额
          ,REPAY_NUM_AVAL_BAL  --还款账号可用余额
          ,EH_ISSUE_DEDUCT_AMT  --每期扣款金额
          ,ENTR_PAY_AMT  --委托支付金额
          ,OVDUE_INT  --逾期利息
          ,DUBIL_AMT  --借据金额
          ,DUBIL_BAL  --借据余额
          ,NOMAL_PRIC  --正常本金
          ,OVDUE_PRIC  --逾期本金
          ,IDLE_PRIC  --呆滞本金
          ,BAD_DEBT_PRIC  --呆账本金
          ,IN_BS_OVER_INT_BAL  --表内欠息余额
          ,OFF_BS_OVER_INT_BAL  --表外欠息余额
          ,PRIC_PNLT  --本金罚息
          ,INT_PNLT  --利息罚息
          ,CAP_RATIO  --资本占有比例
          ,RECVBL_ACCT_NAME  --收款账户名称
          ,RECVBL_BANK_NAME  --收款银行名称
          ,JOB_CD  --任务代码
          ,ETL_TIMESTAMP  --数据处理时间
          --,COMP_AMT  --代偿金额
    )
    SELECT

               ETL_DT  --数据日期
          ,LP_ID  --法人编号
          ,DUBIL_ID  --借据编号
          ,CONT_ID  --合同编号
          ,STD_PROD_ID  --标准产品编号
          ,OUT_ACCT_FLOW_NUM  --出账流水号
          ,RELA_DUBIL_ID  --关联借据编号
          ,INTNL_TRAD_FIN_RELA_ID_2  --国际贸易融资业务关联编号2
          ,BILL_NUM  --票据号码
          ,BILL_ID  --票据编号
          ,BILL_UNIQ_MARK_ID  --票据唯一标示编号
          ,IBANK_ASSET_UNIQ_IDF_ID  --同业资产唯一标识编号
          ,CUST_ID  --客户编号
          ,HOST_CUST_ID  --主机客户编号
          ,DISTR_ACCT_NUM  --放款账号
          ,REPAY_NUM  --还款账号
          ,SECD_REPAY_NUM  --第二还款账号
          ,STL_ACCT_NUM  --结算帐号
          ,MANU_CONT_ID  --人工合同编号
          ,CRDT_LMT_AGT_ID  --授信额度协议编号
          ,ADVC_FLG  --垫款标志
          ,PRE_RECV_INT_FLG  --预收息标志
          ,ATTACH_RGST_DUBIL_FLG  --补登借据标志
          ,MATN_FLG  --维护标志
          ,WRT_OFF_FLG  --核销标志
          ,COMP_INT_FLG  --复息标志
          ,STOP_ACCR_INT_FLG  --停息标志
          ,SIGN_CRDT_CONT_FLG  --签署授信合同标志
          ,PRIC_AUTO_RTN_FLG  --本金自动归还标志
          ,INT_AUTO_RTN_FLG  --利息自动归还标志
          ,CRDT_DISTR_REPAY_PLAN_FLG  --信贷发放还款计划标志
          ,EDU_HEA_FLG  --文教健康标志
          ,PBC_INC_LOAN_FLG  --人行普惠贷款标志
          ,FILE_INT_ACCR_FLG  --靠档计息标志
          ,OVERS_LOAN_FLG  --境外贷款标志
          ,BUS_BREED_ID  --业务品种编号
          ,DUBIL_STATUS_CD  --借据状态代码
          ,REFAC_LOAN_STATUS_CD  --支小再贷款状态代码
          ,LOAN_HAPP_TYPE_CD  --贷款发生类型代码
          ,MODE_PAY_CD  --支付方式代码
          ,CURR_CD  --币种代码
          ,INT_ACCR_WAY_CD  --计息方式代码
          ,LOAN_TYPE_CD  --贷款类型代码
          ,ASSET_THD_CLS_CD  --资产三分类代码
          ,LOAN_LEVEL4_CLS_CD  --贷款四级分类代码
          ,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
          ,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
          ,LOAN_LEVEL12_CLS_CD  --贷款十二级分类代码
          ,REPAY_WAY_CD  --还款方式代码
          ,DIR_INDUS_CD  --投向行业代码
          ,GUAR_WAY_CD  --担保方式代码
          ,LOAN_KIND_CD  --贷款种类代码
          ,WRTOFF_TYPE_CD  --注销类型代码
          ,LOAN_TENOR_TYPE_CD  --贷款期限类型代码
          ,LOAN_TENOR_SEG_CD  --贷款期限分段代码
          ,BILL_KIND_CD  --票据种类代码
          ,BILL_MED_CD  --票据介质代码
          ,DATA_SRC_FLG  --数据来源标志
          ,INT_RAT_ADJ_WAY_CD  --利率调整类型代码
          ,COL_INT_TYPE_CD  --收息类型代码
          ,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
          ,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
          ,INST_LOAN_REPAY_WAY_CD  --分期贷款还款方式代码
          ,MONEY_USE_TYPE_CD  --款项使用类型代码
          ,CRDTC_SUBM_BUS_BREED_CD  --征信报送业务品种代码
          ,CRDTC_SUBM_BUS_BREED_DESCB  --征信报送业务品种描述
          ,ORG_ID  --机构编号
          ,ACCT_INSTIT_ID  --账务机构编号
          ,OPER_ORG_ID  --经办机构编号
          ,OPER_TELLER_ID  --经办柜员编号
          ,RGST_ORG_ID  --登记机构编号
          ,RGST_TELLER_ID  --登记柜员编号
          ,ATTACH_RGST_CHECK_TELLER_ID  --补登复核柜员编号
          ,BENEFC_NAME  --受益人名称
          ,BNFT_BK_NO  --受益行行号
          ,BNFT_BK_NAME  --受益行行名
          ,ACPT_BANK_NO  --承兑行行号
          ,ACPT_BANK_NAME  --承兑行名称
          ,MARGIN_ACCT_NUM  --保证金账号
          ,MARGIN_SUB_ACCT_NUM  --保证金子户号
          ,MARGIN_CURR_CD  --保证金币种代码
          ,MARGIN_AMT  --保证金金额
          ,MARGIN_RATIO  --保证金比例
          ,REFAC_LOAN_BATCH_PKG_ID  --支小再贷款批次包编号
          ,REFAC_LOAN_BATCH_EXP_DT  --支小再贷款批次到期日期
          ,REFAC_LOAN_USE_INT_RAT  --支小再贷款使用利率
          ,DUBIL_WRTOFF_FLOW_NUM  --借据注销流水号
          ,DUBIL_OPEN_FLOW_NUM  --借据开立流水号
          ,DUBIL_OPEN_DT  --借据开立日期
          ,DISTR_DT  --放款日期
          ,APOT_EXP_DT  --约定到期日期
          ,EXEC_EXP_DT  --执行到期日期
          ,NEXT_INT_SET_DT  --下次结息日期
          ,LOAN_CLS_DT  --贷款分类日期
          ,LEVEL5_CLS_IDTFY_DT  --五级分类认定日期
          ,NEXT_TERM_RPP_DT  --下一期还本日期
          ,NEXT_TERM_REPAY_INT_DT  --下一期还息日期
          ,PAYOFF_DT  --结清日期
          ,OVDUE_DT  --逾期日期
          ,OVER_INT_DT  --欠息日期
          ,OVDUE_DAYS  --逾期天数
          ,OVER_INT_DAYS  --欠息天数
          ,LOAN_PED  --贷款周期
          ,INST_LOAN_TOT_PERDS  --分期贷款总期数
          ,SURP_PERDS  --剩余期数
          ,ACM_DEBT_PERDS  --累计欠款期数
          ,BASE_RAT  --基准利率
          ,EXEC_INT_RAT  --执行利率
          ,OVDUE_INT_RAT  --逾期利率
          ,COMM_FEE_FEE_RAT  --手续费费率
          ,NEXT_TERM_RPP_AMT  --下一期还本金额
          ,NEXT_TERM_REPAY_INT_AMT  --下一期还息金额
          ,REPAY_NUM_BAL  --还款账号余额
          ,REPAY_NUM_AVAL_BAL  --还款账号可用余额
          ,EH_ISSUE_DEDUCT_AMT  --每期扣款金额
          ,ENTR_PAY_AMT  --委托支付金额
          ,OVDUE_INT  --逾期利息
          ,DUBIL_AMT  --借据金额
          ,DUBIL_BAL  --借据余额
          ,NOMAL_PRIC  --正常本金
          ,OVDUE_PRIC  --逾期本金
          ,IDLE_PRIC  --呆滞本金
          ,BAD_DEBT_PRIC  --呆账本金
          ,IN_BS_OVER_INT_BAL  --表内欠息余额
          ,OFF_BS_OVER_INT_BAL  --表外欠息余额
          ,PRIC_PNLT  --本金罚息
          ,INT_PNLT  --利息罚息
          ,CAP_RATIO  --资本占有比例
          ,RECVBL_ACCT_NAME  --收款账户名称
          ,RECVBL_BANK_NAME  --收款银行名称
          ,JOB_CD  --任务代码
          ,ETL_TIMESTAMP  --数据处理时间
          --,COMP_AMT  --代偿金额
    FROM O_ICL_CMM_CORP_LOAN_DUBIL_INFO_20231117 ---对公贷款借据信息
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
    V_STEP := 3;
    V_STEP_DESC := '-- 表分析 --';
    V_STARTTIME := SYSDATE;
    ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
    V_ENDTIME  := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_INIT_O_ICL_CMM_CORP_LOAN_DUBIL_INFO;
/

