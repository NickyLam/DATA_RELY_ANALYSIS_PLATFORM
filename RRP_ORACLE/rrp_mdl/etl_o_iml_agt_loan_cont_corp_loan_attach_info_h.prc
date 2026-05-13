CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：贷款合同对公贷款附属信息历史
  **存储过程名称：    ETL_O_IML_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H
  **存储过程创建日期：20250911
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250911    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-贷款合同对公贷款附属信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H NOLOGGING 
  (        AGT_ID                              --协议编号
          ,CONT_ID                             --合同编号
          ,TRADE_CONT_TOT_AMT                  --贸易合同总金额
          ,FIN_CONT_FLG                        --融资合同标志
          ,CONT_TYPE_CD                        --合同类型代码
          ,TRADE_CONT_ID                       --贸易合同编号
          ,LC_KIND_CD                          --信用证种类代码
          ,LC_AMT                              --信用证金额
          ,LC_CURR_CD                          --信用证币种代码
          ,LC_ID                               --信用证编号
          ,LOAD_BILL_ID                        --提单编号
          ,BATCH_ID                            --批文编号
          ,SETUP_PROJ_BATCH_ID                 --立项批文编号
          ,LC_TYPE_CD                          --信用证类型代码
          ,ALDY_ACPT_FWD_LC_FLG                --已承兑远期信用证标志
          ,LC_TENOR_TYPE_CD                    --信用证期限类型代码
          ,LC_CHAR_CD                          --信用证性质代码
          ,FWD_PAY_DAY_TENOR                   --远期付款日期限
          ,FEE_UNDERTAKER                      --费用承担人
          ,OTHER_FEE_RAT                       --其他费率
          ,CARGO_NAME                          --货物名称
          ,CARGO_UNDERLY                       --货物标的
          ,CARGO_TRAFF_DESTINATION             --货物运输目的地
          ,TRAFF_WAY_CD                        --运输方式代码
          ,CLS_FREQ                            --分类频率
          ,MOM_LICS_ID                         --母证编号
          ,MOM_LICS_CURR_CD                    --母证币种代码
          ,MOM_LICS_AMT                        --母证金额
          ,ACCT_RECVBL_NET_AMNT                --应收帐款净额
          ,GOVER_CRDT_TYPE_CD                  --政府授信类型代码
          ,TRAN_BG_DESCB                       --交易背景描述
          ,FIX_ASSET_CRDT_FLG                  --固定资产授信标志
          ,ENTR_DEP_EC_CLS_CD                  --委托存款钞汇分类代码
          ,PKG_RATIO                           --打包比例
          ,GUAR_TYPE_CD                        --担保类型代码
          ,ENTR_LOAN_CAP_SRC_CD                --委托贷款资金来源代码
          ,NEGO_BANK_CFM_FLG                   --经议付行确认标志
          ,DISCNT_INT_BUYER_BEAR_RATIO         --贴现利息买方承担比例
          ,DISCNT_BF_REVW_FLG                  --先贴后查标志
          ,QUAL_CENTR_CNTPTY_FLG               --合格中央交易对手标志
          ,MARGIN_ACCT_ID                      --保证金账户编号
          ,MARGIN_CURR_CD                      --保证金币种代码
          ,MARGIN_TRAN_OUT_ACCT_ID             --保证金转出账户编号
          ,COL_TURN_MARGIN_ACCT_ID             --押品转保证金账户编号
          ,MARGIN_AGT_RAT                      --保证金协议利率
          ,MARGIN_INT_RAT_TYPE_CD              --保证金利率类型代码
          ,MARGIN_FLO_VAL                      --保证金浮动值
          ,MARGIN_INT_RAT_FLOAT_TYPE_CD        --保证金利率浮动类型代码
          ,MARGIN_INT_RAT_FLOAT_WAY_CD         --保证金利率浮动方式代码
          ,MARGIN_INT_ACCR_METHOD_CD           --保证金计息方法代码
          ,MARGIN_INT_RAT_LEVEL_CD             --保证金利率档次代码
          ,CSNER_NAME                          --委托人名称
          ,REPAY_COMNT_DESCB                   --还款说明描述
          ,START_UP_BUS_GUAR_LOAN_TYPE_CD      --创业担保贷款类型代码
          ,CONSM_SERV_CLASS_FIN_FLG            --消费服务类融资标志
          ,PAY_WAY_CD                          --付款方式代码
          ,DRAW_COMNT_DESCB                    --提款说明描述
          ,LOAN_AMT_OCUP_TRAN_PRICE_MONEY_RATIO  --贷款金额占交易价款比例
          ,TRADE_FIN_MANG_MERCHD               --贸易融资经营商品
          ,DRAFT_QTTY                          --汇票数量
          ,DISCNT_COMMER_ACCPT_BIL_CLS_CD      --贴现商业承兑汇票分类代码
          ,COMMER_INV_ID                       --商业发票编号
          ,COMMER_INV_TYPE_CD                  --商业发票类型代码
          ,COMMER_INV_CURR_CD                  --商业发票币种代码
          ,COMMER_INV_AMT                      --商业发票金额
          ,OTHER_LICS_ID                       --其他许可证编号
          ,OTHER_LICS_NAME                     --其他许可证名称
          ,HP_LICS_ID                          --环评许可证编号
          ,ARCH_LAND_LICS_ID                   --建设用地许可证编号
          ,PLAN_LICS_ID                        --规划许可证编号
          ,CNSTR_LICS_ID                       --施工许可证编号
          ,DIR_IND_FUND_FLG                    --投向产业基金标志
          ,ENTR_LOAN_ESPEC_DIR_CD              --委托贷款特殊投向代码
          ,START_UP_BUS_GUAR_LOAN_FLG          --创业担保贷款标志
          ,ENTR_DEP_ACCT_ID                    --委托存款账户账号
          ,UNDERLY_PROD_ID                     --标的产品编号
          ,PROD_COLL_AMT                       --产品募集金额
          ,UNDERLY_PROD_CLS_LEV_CD             --标的产品分级级别代码
          ,SURP_INDUS_CD                       --过剩行业代码
          ,BUY_HOUSE_SITE_DIST_CD              --买房所在地行政区划代码
          ,AGCLT_FLG                           --涉农贷款标志
          ,CNTPTY_NAME                         --交易对手名称
          ,CNTPTY_CO_YEARS                     --与交易对手合作年限
          ,CNTPTY_SUCS_TRAN_CNT                --与交易对手成功交易次数
          ,CNTPTY_STRG                         --交易对手实力
          ,OTHER_COND_REQUEST_DESCB            --其他条件和要求描述
          ,IMP_LOAN_PROJ_CD                    --重点贷款项目代码
          ,AGCLT_LOAN_DIR_CD                   --涉农贷款用途类型代码
          ,DISTR_RATIO                         --放款比例
          ,OBANK_OPEN_FLG                      --他行代开标志
          ,CAPITAL_AMT                         --资本金金额
          ,MGERS_NAME                          --管理方名称
          ,TRADE_FIN_PROD_ID                   --贸易融资产品编号
          ,BENEFC_LOCAL_CTY_OR_RG_CD           --受益人所在国家或地区
          ,BUYER_NAME                          --买方名称
          ,AGCLT_LOAN_MAIN_TYPE_CD             --涉农贷款类型代码
          ,ISSUE_APPL_FORM_ID                  --开证申请书编号
          ,CSNER_ID                            --委托人编号
          ,IMP_LOAN_PROJ_FLG                   --重点贷款项目标志
          ,DISCNT_INT_RAT_COMNT_DESCB          --贴现利率说明描述
          ,FACTOR_TYPE_CD                      --保理类型代码
          ,AGT_PAY_INT_FLG                     --协议付息标志
          ,START_WORK_DT                       --开工日期
          ,CDB_CRDT_FLG                        --国开行授信标志
          ,PROVI_DOC_DT                        --提供单据日期
          ,ACTL_FINER                          --实际融资人
          ,DISCNT_APPLIT_TYPE_CD               --贴现申请人类型代码
          ,INVO_GOVER_CLASS_FIN_FLG            --涉及政府类融资标志
          ,LOAN_FIN_SUPT_WAY_CD                --贷款财政扶持方式代码
          ,THREE_OLD_TRASF_CITY_UPDATE_PROJ_FLG  --三旧改造城市更新项目标志
          ,SYN_DISTRD_LOAN_AMT                 --银团已发放贷款金额
          ,CAP_SRC_CD                          --资金来源代码
          ,GOVER_CRDT_SUPT_WAY_CD              --政府授信支持方式代码
          ,CRDTC_INDUS_DIR_CD                  --征信行业投向代码
          ,SUP_CHAIN_FIN_BUS_PROD_CLS_CD       --供应链金融业务产品分类代码
          ,PROJ_INFO_TEXT_ID                   --项目信息文本编号
          ,EXIST_M_L_CLAUS_FLG                 --存在溢短装的条款标志
          ,BENEFC_NAME                         --受益人名称
          ,ENTR_DEP_CURR_CD                    --委托存款币种代码
          ,PREPAY_ACCT_RECVBL_FLG              --预付应收帐款标志
          ,ACPT_BANK_NAME                      --承兑行名称
          ,DISTR_ORG_ID                        --放款机构编号
          ,CDB_CRDT_PROD_ID                    --国开行授信产品编号
          ,LOAN_USAGE_TRAN_AMT                 --贷款用途交易金额
          ,GOVER_CRDT_FLG                      --政府授信标志
          ,DIR_MAKTI_DEBT_EQTY_FLG             --投向市场化债转股标志
          ,MAJOR_INCRE_CRDT_WAY_CD             --主要增信方式代码
          ,M_L_RATIO                           --溢短装比例
          ,LOAN_CHAR_CD                        --贷款性质代码
          ,SUP_CHAIN_FIN_BUS_FLG               --供应链金融业务标志
          ,ADVISE_BANK_NAME                    --通知行名称
          ,TRAN_ASSET_NAME                     --交易资产名称
          ,LOAN_TRAST_WAY_CD                   --贷款办理方式代码
          ,PAYFAN_TYPE_CD                      --代付类型代码
          ,REMOTE_BUS_FLG                      --异地业务标志
          ,ESTATE_LOAN_TYPE_CD                 --房地产贷款类型代码
          ,DISCNT_INT_APPLIT_PAY_RATIO         --贴现利息申请人支付比例
          ,PROJ_TOT_INVEST_AMT                 --项目总投资金额
          ,CTY_LMT_INDUS_FLG                   --国家限制行业标志
          ,LOC_FIN_PLAT_SOLV_CAP_SRC_CD        --地方融资平台偿债资金来源代码
          ,ACCT_RECVBL_PREPAY_WAY_CD           --应收帐款预付方式代码
          ,DRAW_WAY_CD                         --提款方式代码
          ,REPAY_WAY_CD                        --还款方式代码
          ,OVERS_LOAN_FLG                      --境外贷款标志
          ,LAND_USE_CERT_ID                    --土地使用证编号
          ,LAND_USE_CERT_DT                    --土地使用证日期
          ,LAND_PLAN_LICS_ID                   --用地规划许可证编号
          ,LAND_PLAN_LICS_DT                   --用地规划许可证日期
          ,CNSTR_LICS_DT                       --施工许可证日期
          ,PROJ_PLAN_LICS_DT                   --工程规划许可证日期
          ,ORDER_NAME                          --购货方名称
          ,SELLER_NAME                         --销货方名称
          ,TRADE_TRAN_CONTENT_DESCB            --贸易交易内容描述
          ,ADVANCED_MANU_FLG                   --先进制造业标志
          ,CULTUR_INDUSTRY_FLG                 --文化产业标志
          ,ONLY_NEW_MINORENT_FLG               --专精特新中小企业标志
          ,ONLY_NEW_LITTLEGIANTENT_FLG         --专精特新小巨人企业标志
          ,STRTG_NEW_INDUS_TYPE_CD             --战略新兴产业类型代码
          ,INDENT_TECH_FLG                     --工业企业技术改造升级标志
          ,HIGH_TECH_SERV_LOAN_FLG             --高技术服务业贷款标志
          ,HIGH_TECH_SERV_LOAN_TYPE_CD         --高技术服务业贷款类型代码
          ,ACCT_RECVBL_TRAN_WAY_CD             --应收账款转让方式代码
          ,OPER_START_DT                       --运营开始日期
          ,PPP_PROJ_FLG                        --PPP项目标志
          ,NEW_DISTR_FLG                       --新机制放款标志
          ,CASHFLOW_COVER_BBAL_FLG             --预测现金流覆盖借款余额标志
          ,MGER_CERT_TYPE_CD                   --管理人证件类型代码
          ,MGER_CERT_NO                        --管理人证件号码
          ,INT_PAYER_NAME                      --付息方名称
          ,GUAR_HOUSING_LOAN_TYPE_CD           --保障性住房贷款类型代码
          ,CUST_INS_ADJ_TYPE_CD                --客户产业结构调整类型代码
          ,PROJ_FIN_FLG                        --项目融资标志
          ,RELA_PEOP_GUAR_LOAN_FLG             --关系人保证贷款标志
          ,START_DT                            --开始时间
          ,END_DT                              --结束时间
          ,ID_MARK                             --增删标志
          ,SRC_TABLE_NAME                      --源表名称
          ,JOB_CD                              --任务编码
          ,ETL_TIMESTAMP                       --ETL处理时间戳
    )
    SELECT
           AGT_ID                              --协议编号
          ,CONT_ID                             --合同编号
          ,TRADE_CONT_TOT_AMT                  --贸易合同总金额
          ,FIN_CONT_FLG                        --融资合同标志
          ,CONT_TYPE_CD                        --合同类型代码
          ,TRADE_CONT_ID                       --贸易合同编号
          ,LC_KIND_CD                          --信用证种类代码
          ,LC_AMT                              --信用证金额
          ,LC_CURR_CD                          --信用证币种代码
          ,LC_ID                               --信用证编号
          ,LOAD_BILL_ID                        --提单编号
          ,BATCH_ID                            --批文编号
          ,SETUP_PROJ_BATCH_ID                 --立项批文编号
          ,LC_TYPE_CD                          --信用证类型代码
          ,ALDY_ACPT_FWD_LC_FLG                --已承兑远期信用证标志
          ,LC_TENOR_TYPE_CD                    --信用证期限类型代码
          ,LC_CHAR_CD                          --信用证性质代码
          ,FWD_PAY_DAY_TENOR                   --远期付款日期限
          ,FEE_UNDERTAKER                      --费用承担人
          ,OTHER_FEE_RAT                       --其他费率
          ,CARGO_NAME                          --货物名称
          ,CARGO_UNDERLY                       --货物标的
          ,CARGO_TRAFF_DESTINATION             --货物运输目的地
          ,TRAFF_WAY_CD                        --运输方式代码
          ,CLS_FREQ                            --分类频率
          ,MOM_LICS_ID                         --母证编号
          ,MOM_LICS_CURR_CD                    --母证币种代码
          ,MOM_LICS_AMT                        --母证金额
          ,ACCT_RECVBL_NET_AMNT                --应收帐款净额
          ,GOVER_CRDT_TYPE_CD                  --政府授信类型代码
          ,TRAN_BG_DESCB                       --交易背景描述
          ,FIX_ASSET_CRDT_FLG                  --固定资产授信标志
          ,ENTR_DEP_EC_CLS_CD                  --委托存款钞汇分类代码
          ,PKG_RATIO                           --打包比例
          ,GUAR_TYPE_CD                        --担保类型代码
          ,ENTR_LOAN_CAP_SRC_CD                --委托贷款资金来源代码
          ,NEGO_BANK_CFM_FLG                   --经议付行确认标志
          ,DISCNT_INT_BUYER_BEAR_RATIO         --贴现利息买方承担比例
          ,DISCNT_BF_REVW_FLG                  --先贴后查标志
          ,QUAL_CENTR_CNTPTY_FLG               --合格中央交易对手标志
          ,MARGIN_ACCT_ID                      --保证金账户编号
          ,MARGIN_CURR_CD                      --保证金币种代码
          ,MARGIN_TRAN_OUT_ACCT_ID             --保证金转出账户编号
          ,COL_TURN_MARGIN_ACCT_ID             --押品转保证金账户编号
          ,MARGIN_AGT_RAT                      --保证金协议利率
          ,MARGIN_INT_RAT_TYPE_CD              --保证金利率类型代码
          ,MARGIN_FLO_VAL                      --保证金浮动值
          ,MARGIN_INT_RAT_FLOAT_TYPE_CD        --保证金利率浮动类型代码
          ,MARGIN_INT_RAT_FLOAT_WAY_CD         --保证金利率浮动方式代码
          ,MARGIN_INT_ACCR_METHOD_CD           --保证金计息方法代码
          ,MARGIN_INT_RAT_LEVEL_CD             --保证金利率档次代码
          ,CSNER_NAME                          --委托人名称
          ,REPAY_COMNT_DESCB                   --还款说明描述
          ,START_UP_BUS_GUAR_LOAN_TYPE_CD      --创业担保贷款类型代码
          ,CONSM_SERV_CLASS_FIN_FLG            --消费服务类融资标志
          ,PAY_WAY_CD                          --付款方式代码
          ,DRAW_COMNT_DESCB                    --提款说明描述
          ,LOAN_AMT_OCUP_TRAN_PRICE_MONEY_RATIO  --贷款金额占交易价款比例
          ,TRADE_FIN_MANG_MERCHD               --贸易融资经营商品
          ,DRAFT_QTTY                          --汇票数量
          ,DISCNT_COMMER_ACCPT_BIL_CLS_CD      --贴现商业承兑汇票分类代码
          ,COMMER_INV_ID                       --商业发票编号
          ,COMMER_INV_TYPE_CD                  --商业发票类型代码
          ,COMMER_INV_CURR_CD                  --商业发票币种代码
          ,COMMER_INV_AMT                      --商业发票金额
          ,OTHER_LICS_ID                       --其他许可证编号
          ,OTHER_LICS_NAME                     --其他许可证名称
          ,HP_LICS_ID                          --环评许可证编号
          ,ARCH_LAND_LICS_ID                   --建设用地许可证编号
          ,PLAN_LICS_ID                        --规划许可证编号
          ,CNSTR_LICS_ID                       --施工许可证编号
          ,DIR_IND_FUND_FLG                    --投向产业基金标志
          ,ENTR_LOAN_ESPEC_DIR_CD              --委托贷款特殊投向代码
          ,START_UP_BUS_GUAR_LOAN_FLG          --创业担保贷款标志
          ,ENTR_DEP_ACCT_ID                    --委托存款账户账号
          ,UNDERLY_PROD_ID                     --标的产品编号
          ,PROD_COLL_AMT                       --产品募集金额
          ,UNDERLY_PROD_CLS_LEV_CD             --标的产品分级级别代码
          ,SURP_INDUS_CD                       --过剩行业代码
          ,BUY_HOUSE_SITE_DIST_CD              --买房所在地行政区划代码
          ,AGCLT_FLG                           --涉农贷款标志
          ,CNTPTY_NAME                         --交易对手名称
          ,CNTPTY_CO_YEARS                     --与交易对手合作年限
          ,CNTPTY_SUCS_TRAN_CNT                --与交易对手成功交易次数
          ,CNTPTY_STRG                         --交易对手实力
          ,OTHER_COND_REQUEST_DESCB            --其他条件和要求描述
          ,IMP_LOAN_PROJ_CD                    --重点贷款项目代码
          ,AGCLT_LOAN_DIR_CD                   --涉农贷款用途类型代码
          ,DISTR_RATIO                         --放款比例
          ,OBANK_OPEN_FLG                      --他行代开标志
          ,CAPITAL_AMT                         --资本金金额
          ,MGERS_NAME                          --管理方名称
          ,TRADE_FIN_PROD_ID                   --贸易融资产品编号
          ,BENEFC_LOCAL_CTY_OR_RG_CD           --受益人所在国家或地区
          ,BUYER_NAME                          --买方名称
          ,AGCLT_LOAN_MAIN_TYPE_CD             --涉农贷款类型代码
          ,ISSUE_APPL_FORM_ID                  --开证申请书编号
          ,CSNER_ID                            --委托人编号
          ,IMP_LOAN_PROJ_FLG                   --重点贷款项目标志
          ,DISCNT_INT_RAT_COMNT_DESCB          --贴现利率说明描述
          ,FACTOR_TYPE_CD                      --保理类型代码
          ,AGT_PAY_INT_FLG                     --协议付息标志
          ,START_WORK_DT                       --开工日期
          ,CDB_CRDT_FLG                        --国开行授信标志
          ,PROVI_DOC_DT                        --提供单据日期
          ,ACTL_FINER                          --实际融资人
          ,DISCNT_APPLIT_TYPE_CD               --贴现申请人类型代码
          ,INVO_GOVER_CLASS_FIN_FLG            --涉及政府类融资标志
          ,LOAN_FIN_SUPT_WAY_CD                --贷款财政扶持方式代码
          ,THREE_OLD_TRASF_CITY_UPDATE_PROJ_FLG  --三旧改造城市更新项目标志
          ,SYN_DISTRD_LOAN_AMT                 --银团已发放贷款金额
          ,CAP_SRC_CD                          --资金来源代码
          ,GOVER_CRDT_SUPT_WAY_CD              --政府授信支持方式代码
          ,CRDTC_INDUS_DIR_CD                  --征信行业投向代码
          ,SUP_CHAIN_FIN_BUS_PROD_CLS_CD       --供应链金融业务产品分类代码
          ,PROJ_INFO_TEXT_ID                   --项目信息文本编号
          ,EXIST_M_L_CLAUS_FLG                 --存在溢短装的条款标志
          ,BENEFC_NAME                         --受益人名称
          ,ENTR_DEP_CURR_CD                    --委托存款币种代码
          ,PREPAY_ACCT_RECVBL_FLG              --预付应收帐款标志
          ,ACPT_BANK_NAME                      --承兑行名称
          ,DISTR_ORG_ID                        --放款机构编号
          ,CDB_CRDT_PROD_ID                    --国开行授信产品编号
          ,LOAN_USAGE_TRAN_AMT                 --贷款用途交易金额
          ,GOVER_CRDT_FLG                      --政府授信标志
          ,DIR_MAKTI_DEBT_EQTY_FLG             --投向市场化债转股标志
          ,MAJOR_INCRE_CRDT_WAY_CD             --主要增信方式代码
          ,M_L_RATIO                           --溢短装比例
          ,LOAN_CHAR_CD                        --贷款性质代码
          ,SUP_CHAIN_FIN_BUS_FLG               --供应链金融业务标志
          ,ADVISE_BANK_NAME                    --通知行名称
          ,TRAN_ASSET_NAME                     --交易资产名称
          ,LOAN_TRAST_WAY_CD                   --贷款办理方式代码
          ,PAYFAN_TYPE_CD                      --代付类型代码
          ,REMOTE_BUS_FLG                      --异地业务标志
          ,ESTATE_LOAN_TYPE_CD                 --房地产贷款类型代码
          ,DISCNT_INT_APPLIT_PAY_RATIO         --贴现利息申请人支付比例
          ,PROJ_TOT_INVEST_AMT                 --项目总投资金额
          ,CTY_LMT_INDUS_FLG                   --国家限制行业标志
          ,LOC_FIN_PLAT_SOLV_CAP_SRC_CD        --地方融资平台偿债资金来源代码
          ,ACCT_RECVBL_PREPAY_WAY_CD           --应收帐款预付方式代码
          ,DRAW_WAY_CD                         --提款方式代码
          ,REPAY_WAY_CD                        --还款方式代码
          ,OVERS_LOAN_FLG                      --境外贷款标志
          ,LAND_USE_CERT_ID                    --土地使用证编号
          ,LAND_USE_CERT_DT                    --土地使用证日期
          ,LAND_PLAN_LICS_ID                   --用地规划许可证编号
          ,LAND_PLAN_LICS_DT                   --用地规划许可证日期
          ,CNSTR_LICS_DT                       --施工许可证日期
          ,PROJ_PLAN_LICS_DT                   --工程规划许可证日期
          ,ORDER_NAME                          --购货方名称
          ,SELLER_NAME                         --销货方名称
          ,TRADE_TRAN_CONTENT_DESCB            --贸易交易内容描述
          ,ADVANCED_MANU_FLG                   --先进制造业标志
          ,CULTUR_INDUSTRY_FLG                 --文化产业标志
          ,ONLY_NEW_MINORENT_FLG               --专精特新中小企业标志
          ,ONLY_NEW_LITTLEGIANTENT_FLG         --专精特新小巨人企业标志
          ,STRTG_NEW_INDUS_TYPE_CD             --战略新兴产业类型代码
          ,INDENT_TECH_FLG                     --工业企业技术改造升级标志
          ,HIGH_TECH_SERV_LOAN_FLG             --高技术服务业贷款标志
          ,HIGH_TECH_SERV_LOAN_TYPE_CD         --高技术服务业贷款类型代码
          ,ACCT_RECVBL_TRAN_WAY_CD             --应收账款转让方式代码
          ,OPER_START_DT                       --运营开始日期
          ,PPP_PROJ_FLG                        --PPP项目标志
          ,NEW_DISTR_FLG                       --新机制放款标志
          ,CASHFLOW_COVER_BBAL_FLG             --预测现金流覆盖借款余额标志
          ,MGER_CERT_TYPE_CD                   --管理人证件类型代码
          ,MGER_CERT_NO                        --管理人证件号码
          ,INT_PAYER_NAME                      --付息方名称
          ,GUAR_HOUSING_LOAN_TYPE_CD           --保障性住房贷款类型代码
          ,CUST_INS_ADJ_TYPE_CD                --客户产业结构调整类型代码
          ,PROJ_FIN_FLG                        --项目融资标志
          ,RELA_PEOP_GUAR_LOAN_FLG             --关系人保证贷款标志
          ,START_DT                            --开始时间
          ,END_DT                              --结束时间
          ,ID_MARK                             --增删标志
          ,SRC_TABLE_NAME                      --源表名称
          ,JOB_CD                              --任务编码
          ,ETL_TIMESTAMP                       --ETL处理时间戳
  FROM IML.V_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H --视图-贷款合同对公贷款附属信息历史
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H;
/

