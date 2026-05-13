CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_CORP_LOAN_CONT_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_CORP_LOAN_CONT_INFO
  *  功能描述：对公贷款合同信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CORP_LOAN_CONT_INFO
  *  目标表： O_ICL_CMM_CORP_LOAN_CONT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20221615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_CORP_LOAN_CONT_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'O_ICL_CMM_CORP_LOAN_CONT_INFO'; --表名

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_CORP_LOAN_CONT_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_CORP_LOAN_CONT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公贷款合同信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO
  (                       ETL_DT  --数据日期
                    ,LP_ID  --法人编号
                    ,CONT_ID  --合同编号
                    ,CUST_ID  --客户编号
                    ,LMT_CONT_ID  --额度合同编号
                    ,APV_FLOW_NUM  --授信申请流水号
                    ,MANU_CONT_ID  --人工合同编号
                    ,BUS_BREED_ID  --业务品种编号
                    ,STD_PROD_ID  --标准产品编号
                    ,BUS_SUB_TYPE_CD  --业务子类型代码
                    ,LOAN_HAPP_TYPE_CD  --贷款发生类型代码
                    ,CONT_TYPE_CD  --合同类型代码
                    ,ENTR_LOAN_ESPEC_DIR_CD  --委托贷款特殊投向代码
                    ,STRTG_NEW_INDUS_TYPE_CD  --战略新兴产业类型代码
                    ,PROD_TYPE_CD  --产品类型代码
                    ,VALID_FLG_CD  --有效标志代码
                    ,DIR_INDUS_CD  --投向行业代码
                    ,SURP_INDUS_CD  --过剩行业代码
                    ,SUB_GUAR_WAY_CD  --子担保方式代码
                    ,GUAR_TYPE_CD  --担保类型代码
                    ,MAJOR_GUAR_WAY_CD  --主要担保方式代码
                    ,SECD_GUAR_WAY_CD  --第二担保方式代码
                    ,CRDT_TYPE_CD  --授信类型代码
                    ,APPL_WAY_CD  --申请方式代码
                    ,LOAN_FIN_SUPT_WAY_CD  --贷款财政扶持方式代码
                    ,INVEST_WAY_CD  --投资方式代码
                    ,MGMT_MODE_CD  --管理模式代码
                    ,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
                    ,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
                    ,TENOR_TYPE_CD  --期限类型代码
                    ,PRIC_REPAY_WAY_CD  --本金还款方式代码
                    ,INT_RAT_FLOAT_WAY_CD  --利率浮动方式代码
                    ,CHARGE_WAY_CD  --收费方式代码
                    ,DRAW_WAY_CD  --提款方式代码
                    ,CAP_SRC_CD  --资金来源代码
                    ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
                    ,CURR_CD  --币种代码
                    ,SUP_CHAIN_FIN_BUS_PROD_CLS_CD  --供应链金融业务产品分类代码
                    ,IMP_LOAN_PROJ  --重点贷款项目代码
                    ,SUP_CHAIN_FIN_BUS_FLG  --供应链金融业务标志
                    ,AGENT_PATIP_LOAN_FLG  --代理参贷标志
                    ,LMT_CIRCL_FLG  --额度循环标志
                    ,CIRCL_FLG  --循环标志
                    ,TEMP_STORE_FLG  --暂存标志
                    ,FROZ_FLG  --冻结标志
                    ,TURN_CRDT_FLG  --转授信标志
                    ,REMOTE_LOAN_FLG  --异地贷款标志
                    ,OTHER_GUAR_WAY_FLG  --其他担保方式标志
                    ,IMP_PROJ_LOAN_FLG  --重点项目贷款标志
                    ,CTY_LMT_INDUS_FLG  --国家限制行业标志
                    ,GOVER_CRDT_FLG  --政府授信标志
                    ,CDB_CRDT_FLG  --国开行授信标志
                    ,FIX_ASSET_CRDT_FLG  --固定资产授信标志
                    ,QUAL_CENTR_CNTPTY_FLG  --合格中央交易对手标志
                    ,FIN_SYS_CONT_FLG  --融资合同标志
                    ,LOW_RISK_BUS_FLG  --低风险业务标志
                    ,FILE_INT_ACCR_FLG  --靠档计息标志
                    ,HOST_BANK_NO  --主办行行号
                    ,PATIP_LOAN_BANK_NO  --参贷行行号
                    ,AGENT_BANK_NO  --代理行行号
                    ,CNTPTY_STRG  --交易对手实力
                    ,CNTPTY_CO_YEARS  --与交易对手合作年限
                    ,CNTPTY_SUCS_TRAN_CNT  --与交易对手成功交易次数
                    ,MGMT_ORG_ID  --管理机构编号
                    ,RGST_ORG_ID  --登记机构编号
                    ,OPER_ORG_ID  --经办机构编号
                    ,DISTR_ORG_ID  --放款机构编号
                    ,IBANK_TRAN_ORG_ID  --同业交易机构编号
                    ,MGMT_TELLER_ID  --管理柜员编号
                    ,OPER_TELLER_ID  --经办柜员编号
                    ,RGST_TELLER_ID  --登记柜员编号
                    ,START_DT  --起始日期
                    ,DISTR_DT  --发放日期
                    ,EXP_DT  --到期日期
                    ,OPER_DT  --经办日期
                    ,RGST_DT  --登记日期
                    ,TERMNT_DT  --终止日期
                    ,LMT_USE_LATEST_DT  --额度使用最迟日期
                    ,LMT_UNDER_BUS_LATEST_EXP_DT  --额度项下业务最迟到期日期
                    ,LOAN_USAGE_DESCB  --贷款用途描述
                    ,REPAY_SRC_DESCB  --还款来源描述
                    ,OTHER_COND_REQUEST_DESCB  --其他条件和要求描述
                    ,TRDPTY_CUST_NAME1  --第三方客户名称1
                    ,TRDPTY_CUST_NAME2  --第三方客户名称2
                    ,RELA_CONT_ID  --相关合同编号
                    ,LOAN_ENTER_ACCT_ACCT_NUM  --贷款入账账号
                    ,STL_ACCT_NUM  --结算账号
                    ,MARGIN_ACCT_NUM  --保证金账号
                    ,MARGIN_CURR_CD  --保证金币种代码
                    ,MARGIN_RATIO  --保证金比例
                    ,MARGIN_AMT  --保证金金额
                    ,TRAN_MARKET_TYPE_CD  --交易市场类型代码
                    ,INCRE_CRDT_WAY_CD  --增信方式代码
                    ,BATCH_DATA_SRC_CD  --批量数据来源代码
                    ,BACKUP_LMT_EFFECT_CD  --备份额度生效代码
                    ,BACKUP_LMT_CONT_ID  --备份额度合同编号
                    ,RISK_TYPE_CD  --风险类型代码
                    ,MAJOR_LOAN_CLS_CD  --专业贷款分类代码
                    ,RISK_EXPOSE_CLS  --风险暴露分类
                    ,UNDERLY_PROD_CLS_FLG  --标的产品分级标志
                    ,UNDERLY_PROD_CLS_LEV_CD  --标的产品分级级别代码
                    ,TRAN_ASSET_NAME  --交易资产名称
                    ,AGCLT_FLG  --涉农标志
                    ,AGCLT_LOAN_MAIN_TYPE_CD  --涉农贷款主体类型代码
                    ,AGCLT_LOAN_DIR_CD  --涉农贷款投向代码
                    ,PLAT_SOLV_CAP_SRC_CD  --平台偿债资金来源代码
                    ,BUID_BUS_GUAR_LOAN_FLG  --创业担保贷款标志
                    ,BUID_BUS_GUAR_LOAN_TYPE_CD  --创业担保贷款类型代码
                    ,DIR_IND_FUND_FLG  --投向产业基金标志
                    ,DIR_MAKTI_DEBT_EQTY_FLG  --投向市场化债转股标志
                    ,INVO_GOVER_CLASS_FIN_FLG  --涉及政府类融资标志
                    ,CONSM_SERV_CLASS_FIN_FLG  --消费服务类融资标志
                    ,STL_DEP_FLG  --结算性存款标志
										,COTA_OPT_CHOICE_FLG  --含有回售选择权标志
										,SEPTBL_FLG  --可分离标志
										,ONL_BUS_FLG  --线上业务标志
										,CLASS_CRDT_FLG  --类信贷标志
										,OUT_ACCT_FLG  --出账标志
										,IBANK_BOND_ID  --同业债券编号
										,CRDT_BUS_FLOW_TYPE_CD  --授信业务流程类型代码
										,CRDT_RG_CD  --授信区域代码
										,ESTATE_FIN_FLG  --房地产融资标志
										,ESTATE_LOAN_TYPE_CD  --房地产贷款类型代码
										,FINAL_DIR_TYPE_CD  --最终投向类型代码
										,PENTE_TYPE_CD  --穿透类型代码
										,ASSET_THD_CLS_CD  --资产三分类代码
										,GOVER_CLASS_FIN_FLG1  --政府类融资标志1
										,BR_BUILD_IFIN_FLG  --一带一路建设投融资标志
										,GREEN_CRDT_FIN_FLG  --绿色信贷融资标志
										,TRADE_CONT_ID  --贸易合同编号
										,TRADE_CONT_CURR_CD  --贸易合同币种代码
										,TRADE_CONT_AMT  --贸易合同金额
										,BILL_QTTY  --票据数量
										,DISCNT_BF_REVW_FLG  --先贴后查标志
										,DISCNT_INT_BUYER_BEAR_RATIO  --贴现利息买方承担比例
										,DISCNT_INT_APPLIT_PAY_RATIO  --贴现利息申请人支付比例
										,AGT_PAY_INT_FLG  --协议付息标志
										,BILL_UNIQ_IDF_ID  --票据唯一标识编号
										,IBANK_ASSET_UNIQ_IDF_ID  --同业资产唯一标识编号
										,TRDPTY_ACCT_ID  --第三方账户编号
										,LOAN_SRC_CD  --贷款来源代码
										,COMM_FEE_RAT  --手续费费率
										,COMM_FEE_AMT  --手续费金额
										,LC_ID  --信用证编号
										,LC_AMT  --信用证金额
										,TRAST_CHN_CD  --办理渠道代码
										,SYN_LOAN_TOT_AMT  --银团贷款总金额
										,SYN_LOAN_DISTR_AMT  --银团贷款发放金额
										,TENOR  --期限
										,BASE_RAT_TYPE_CD  --基准利率类型代码
										,BASE_RAT  --基准利率
										,INT_RAT_FLO_VAL  --利率浮动值
										,INT_RAT_MODE_CD  --利率模式代码
										,EXEC_INT_RAT  --执行利率
										,RSRV_AMT  --预留金额
										,BANK_FIN_TOT  --银行融资总额
										,OPEN_BAL  --敞口余额
										,UNDERLY_PROD_COLL_AMT  --标的产品募集金额
										,CONT_AMT  --合同金额
										,CONT_AVAL_BAL  --合同可用余额
										,ACM_DISTR_AMT  --累计发放金额
										,ACM_CALLBK_AMT  --累计回收金额
										,OCCU_CRDT_LMT  --已占用授信额度
										,SURP_CRDT_LMT  --剩余授信额度
										,JOB_CD  --任务代码
										,ETL_TIMESTAMP  --数据处理时间

    )
    SELECT

  										ETL_DT  --数据日期
										,LP_ID  --法人编号
										,CONT_ID  --合同编号
										,CUST_ID  --客户编号
										,LMT_CONT_ID  --额度合同编号
										,APV_FLOW_NUM  --授信申请流水号
										,MANU_CONT_ID  --人工合同编号
										,BUS_BREED_ID  --业务品种编号
										,STD_PROD_ID  --标准产品编号
										,BUS_SUB_TYPE_CD  --业务子类型代码
										,LOAN_HAPP_TYPE_CD  --贷款发生类型代码
										,CONT_TYPE_CD  --合同类型代码
										,ENTR_LOAN_ESPEC_DIR_CD  --委托贷款特殊投向代码
										,STRTG_NEW_INDUS_TYPE_CD  --战略新兴产业类型代码
										,PROD_TYPE_CD  --产品类型代码
										,VALID_FLG_CD  --有效标志代码
										,DIR_INDUS_CD  --投向行业代码
										,SURP_INDUS_CD  --过剩行业代码
										,SUB_GUAR_WAY_CD  --子担保方式代码
										,GUAR_TYPE_CD  --担保类型代码
										,MAJOR_GUAR_WAY_CD  --主要担保方式代码
										,SECD_GUAR_WAY_CD  --第二担保方式代码
										,CRDT_TYPE_CD  --授信类型代码
										,APPL_WAY_CD  --申请方式代码
										,LOAN_FIN_SUPT_WAY_CD  --贷款财政扶持方式代码
										,INVEST_WAY_CD  --投资方式代码
										,MGMT_MODE_CD  --管理模式代码
										,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
										,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
										,TENOR_TYPE_CD  --期限类型代码
										,PRIC_REPAY_WAY_CD  --本金还款方式代码
										,INT_RAT_FLOAT_WAY_CD  --利率浮动方式代码
										,CHARGE_WAY_CD  --收费方式代码
										,DRAW_WAY_CD  --提款方式代码
										,CAP_SRC_CD  --资金来源代码
										,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
										,CURR_CD  --币种代码
										,SUP_CHAIN_FIN_BUS_PROD_CLS_CD  --供应链金融业务产品分类代码
										,IMP_LOAN_PROJ  --重点贷款项目代码
										,SUP_CHAIN_FIN_BUS_FLG  --供应链金融业务标志
										,AGENT_PATIP_LOAN_FLG  --代理参贷标志
										,LMT_CIRCL_FLG  --额度循环标志
										,CIRCL_FLG  --循环标志
										,TEMP_STORE_FLG  --暂存标志
										,FROZ_FLG  --冻结标志
										,TURN_CRDT_FLG  --转授信标志
										,REMOTE_LOAN_FLG  --异地贷款标志
										,OTHER_GUAR_WAY_FLG  --其他担保方式标志
										,IMP_PROJ_LOAN_FLG  --重点项目贷款标志
										,CTY_LMT_INDUS_FLG  --国家限制行业标志
										,GOVER_CRDT_FLG  --政府授信标志
										,CDB_CRDT_FLG  --国开行授信标志
										,FIX_ASSET_CRDT_FLG  --固定资产授信标志
										,QUAL_CENTR_CNTPTY_FLG  --合格中央交易对手标志
										,FIN_SYS_CONT_FLG  --融资合同标志
										,LOW_RISK_BUS_FLG  --低风险业务标志
										,FILE_INT_ACCR_FLG  --靠档计息标志
										,HOST_BANK_NO  --主办行行号
										,PATIP_LOAN_BANK_NO  --参贷行行号
										,AGENT_BANK_NO  --代理行行号
										,CNTPTY_STRG  --交易对手实力
										,CNTPTY_CO_YEARS  --与交易对手合作年限
										,CNTPTY_SUCS_TRAN_CNT  --与交易对手成功交易次数
										,MGMT_ORG_ID  --管理机构编号
										,RGST_ORG_ID  --登记机构编号
										,OPER_ORG_ID  --经办机构编号
										,DISTR_ORG_ID  --放款机构编号
										,IBANK_TRAN_ORG_ID  --同业交易机构编号
										,MGMT_TELLER_ID  --管理柜员编号
										,OPER_TELLER_ID  --经办柜员编号
										,RGST_TELLER_ID  --登记柜员编号
										,START_DT  --起始日期
										,DISTR_DT  --发放日期
										,EXP_DT  --到期日期
										,OPER_DT  --经办日期
										,RGST_DT  --登记日期
										,TERMNT_DT  --终止日期
										,LMT_USE_LATEST_DT  --额度使用最迟日期
										,LMT_UNDER_BUS_LATEST_EXP_DT  --额度项下业务最迟到期日期
										,LOAN_USAGE_DESCB  --贷款用途描述
										,REPAY_SRC_DESCB  --还款来源描述
										,OTHER_COND_REQUEST_DESCB  --其他条件和要求描述
										,TRDPTY_CUST_NAME1  --第三方客户名称1
										,TRDPTY_CUST_NAME2  --第三方客户名称2
										,RELA_CONT_ID  --相关合同编号
										,LOAN_ENTER_ACCT_ACCT_NUM  --贷款入账账号
										,STL_ACCT_NUM  --结算账号
										,MARGIN_ACCT_NUM  --保证金账号
										,MARGIN_CURR_CD  --保证金币种代码
										,MARGIN_RATIO  --保证金比例
										,MARGIN_AMT  --保证金金额
										,TRAN_MARKET_TYPE_CD  --交易市场类型代码
										,INCRE_CRDT_WAY_CD  --增信方式代码
										,BATCH_DATA_SRC_CD  --批量数据来源代码
										,BACKUP_LMT_EFFECT_CD  --备份额度生效代码
										,BACKUP_LMT_CONT_ID  --备份额度合同编号
										,RISK_TYPE_CD  --风险类型代码
										,MAJOR_LOAN_CLS_CD  --专业贷款分类代码
										,RISK_EXPOSE_CLS  --风险暴露分类
										,UNDERLY_PROD_CLS_FLG  --标的产品分级标志
										,UNDERLY_PROD_CLS_LEV_CD  --标的产品分级级别代码
										,TRAN_ASSET_NAME  --交易资产名称
										,AGCLT_FLG  --涉农标志
										,AGCLT_LOAN_MAIN_TYPE_CD  --涉农贷款主体类型代码
										,AGCLT_LOAN_DIR_CD  --涉农贷款投向代码
										,PLAT_SOLV_CAP_SRC_CD  --平台偿债资金来源代码
										,BUID_BUS_GUAR_LOAN_FLG  --创业担保贷款标志
										,BUID_BUS_GUAR_LOAN_TYPE_CD  --创业担保贷款类型代码
										,DIR_IND_FUND_FLG  --投向产业基金标志
										,DIR_MAKTI_DEBT_EQTY_FLG  --投向市场化债转股标志
										,INVO_GOVER_CLASS_FIN_FLG  --涉及政府类融资标志
										,CONSM_SERV_CLASS_FIN_FLG  --消费服务类融资标志
										,STL_DEP_FLG  --结算性存款标志
										,COTA_OPT_CHOICE_FLG  --含有回售选择权标志
										,SEPTBL_FLG  --可分离标志
										,ONL_BUS_FLG  --线上业务标志
										,CLASS_CRDT_FLG  --类信贷标志
										,OUT_ACCT_FLG  --出账标志
										,IBANK_BOND_ID  --同业债券编号
										,CRDT_BUS_FLOW_TYPE_CD  --授信业务流程类型代码
										,CRDT_RG_CD  --授信区域代码
										,ESTATE_FIN_FLG  --房地产融资标志
										,ESTATE_LOAN_TYPE_CD  --房地产贷款类型代码
										,FINAL_DIR_TYPE_CD  --最终投向类型代码
										,PENTE_TYPE_CD  --穿透类型代码
										,ASSET_THD_CLS_CD  --资产三分类代码
										,GOVER_CLASS_FIN_FLG1  --政府类融资标志1
										,BR_BUILD_IFIN_FLG  --一带一路建设投融资标志
										,GREEN_CRDT_FIN_FLG  --绿色信贷融资标志
										,TRADE_CONT_ID  --贸易合同编号
										,TRADE_CONT_CURR_CD  --贸易合同币种代码
										,TRADE_CONT_AMT  --贸易合同金额
										,BILL_QTTY  --票据数量
										,DISCNT_BF_REVW_FLG  --先贴后查标志
										,DISCNT_INT_BUYER_BEAR_RATIO  --贴现利息买方承担比例
										,DISCNT_INT_APPLIT_PAY_RATIO  --贴现利息申请人支付比例
										,AGT_PAY_INT_FLG  --协议付息标志
										,BILL_UNIQ_IDF_ID  --票据唯一标识编号
										,IBANK_ASSET_UNIQ_IDF_ID  --同业资产唯一标识编号
										,TRDPTY_ACCT_ID  --第三方账户编号
										,LOAN_SRC_CD  --贷款来源代码
										,COMM_FEE_RAT  --手续费费率
										,COMM_FEE_AMT  --手续费金额
										,LC_ID  --信用证编号
										,LC_AMT  --信用证金额
										,TRAST_CHN_CD  --办理渠道代码
										,SYN_LOAN_TOT_AMT  --银团贷款总金额
										,SYN_LOAN_DISTR_AMT  --银团贷款发放金额
										,TENOR  --期限
										,BASE_RAT_TYPE_CD  --基准利率类型代码
										,BASE_RAT  --基准利率
										,INT_RAT_FLO_VAL  --利率浮动值
										,INT_RAT_MODE_CD  --利率模式代码
										,EXEC_INT_RAT  --执行利率
										,RSRV_AMT  --预留金额
										,BANK_FIN_TOT  --银行融资总额
										,OPEN_BAL  --敞口余额
										,UNDERLY_PROD_COLL_AMT  --标的产品募集金额
										,CONT_AMT  --合同金额
										,CONT_AVAL_BAL  --合同可用余额
										,ACM_DISTR_AMT  --累计发放金额
										,ACM_CALLBK_AMT  --累计回收金额
										,OCCU_CRDT_LMT  --已占用授信额度
										,SURP_CRDT_LMT  --剩余授信额度
										,JOB_CD  --任务代码
										,ETL_TIMESTAMP  --数据处理时间

    FROM ICL.V_CMM_CORP_LOAN_CONT_INFO  --视图-对公贷款合同信息
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

  END ETL_INIT_O_ICL_CMM_CORP_LOAN_CONT_INFO;
/

