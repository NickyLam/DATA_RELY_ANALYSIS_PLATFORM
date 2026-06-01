/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_wind_ashareincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_wind_ashareincome
whenever sqlerror continue none;
drop table ${msl_schema}.msl_wind_ashareincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_wind_ashareincome(
    ETL_DT DATE
    ,OBJECT_ID VARCHAR2(100)
    ,S_INFO_WINDCODE VARCHAR2(40)
    ,WIND_CODE VARCHAR2(40)
    ,ANN_DT VARCHAR2(8)
    ,REPORT_PERIOD VARCHAR2(8)
    ,STATEMENT_TYPE VARCHAR2(10)
    ,CRNCY_CODE VARCHAR2(10)
    ,TOT_OPER_REV NUMBER(20,4)
    ,OPER_REV NUMBER(20,4)
    ,INT_INC NUMBER(20,4)
    ,NET_INT_INC NUMBER(20,4)
    ,INSUR_PREM_UNEARNED NUMBER(20,4)
    ,HANDLING_CHRG_COMM_INC NUMBER(20,4)
    ,NET_HANDLING_CHRG_COMM_INC NUMBER(20,4)
    ,NET_INC_OTHER_OPS NUMBER(20,4)
    ,PLUS_NET_INC_OTHER_BUS NUMBER(20,4)
    ,PREM_INC NUMBER(20,4)
    ,LESS_CEDED_OUT_PREM NUMBER(20,4)
    ,CHG_UNEARNED_PREM_RES NUMBER(20,4)
    ,INCL_REINSURANCE_PREM_INC NUMBER(20,4)
    ,NET_INC_SEC_TRADING_BROK_BUS NUMBER(20,4)
    ,NET_INC_SEC_UW_BUS NUMBER(20,4)
    ,NET_INC_EC_ASSET_MGMT_BUS NUMBER(20,4)
    ,OTHER_BUS_INC NUMBER(20,4)
    ,PLUS_NET_GAIN_CHG_FV NUMBER(20,4)
    ,PLUS_NET_INVEST_INC NUMBER(20,4)
    ,INCL_INC_INVEST_ASSOC_JV_ENTP NUMBER(20,4)
    ,PLUS_NET_GAIN_FX_TRANS NUMBER(20,4)
    ,TOT_OPER_COST NUMBER(20,4)
    ,LESS_OPER_COST NUMBER(20,4)
    ,LESS_INT_EXP NUMBER(20,4)
    ,LESS_HANDLING_CHRG_COMM_EXP NUMBER(20,4)
    ,LESS_TAXES_SURCHARGES_OPS NUMBER(20,4)
    ,LESS_SELLING_DIST_EXP NUMBER(20,4)
    ,LESS_GERL_ADMIN_EXP NUMBER(20,4)
    ,LESS_FIN_EXP NUMBER(20,4)
    ,LESS_IMPAIR_LOSS_ASSETS NUMBER(20,4)
    ,PREPAY_SURR NUMBER(20,4)
    ,TOT_CLAIM_EXP NUMBER(20,4)
    ,CHG_INSUR_CONT_RSRV NUMBER(20,4)
    ,DVD_EXP_INSURED NUMBER(20,4)
    ,REINSURANCE_EXP NUMBER(20,4)
    ,OPER_EXP NUMBER(20,4)
    ,LESS_CLAIM_RECB_REINSURER NUMBER(20,4)
    ,LESS_INS_RSRV_RECB_REINSURER NUMBER(20,4)
    ,LESS_EXP_RECB_REINSURER NUMBER(20,4)
    ,OTHER_BUS_COST NUMBER(20,4)
    ,OPER_PROFIT NUMBER(20,4)
    ,PLUS_NON_OPER_REV NUMBER(20,4)
    ,LESS_NON_OPER_EXP NUMBER(20,4)
    ,IL_NET_LOSS_DISP_NONCUR_ASSET NUMBER(20,4)
    ,TOT_PROFIT NUMBER(20,4)
    ,INC_TAX NUMBER(20,4)
    ,UNCONFIRMED_INVEST_LOSS NUMBER(20,4)
    ,NET_PROFIT_INCL_MIN_INT_INC NUMBER(20,4)
    ,NET_PROFIT_EXCL_MIN_INT_INC NUMBER(20,4)
    ,MINORITY_INT_INC NUMBER(20,4)
    ,OTHER_COMPREH_INC NUMBER(20,4)
    ,TOT_COMPREH_INC NUMBER(20,4)
    ,TOT_COMPREH_INC_PARENT_COMP NUMBER(20,4)
    ,TOT_COMPREH_INC_MIN_SHRHLDR NUMBER(20,4)
    ,EBIT NUMBER(20,4)
    ,EBITDA NUMBER(20,4)
    ,NET_PROFIT_AFTER_DED_NR_LP NUMBER(20,4)
    ,NET_PROFIT_UNDER_INTL_ACC_STA NUMBER(20,4)
    ,COMP_TYPE_CODE VARCHAR2(2)
    ,S_FA_EPS_BASIC NUMBER(20,4)
    ,S_FA_EPS_DILUTED NUMBER(20,4)
    ,ACTUAL_ANN_DT VARCHAR2(8)
    ,INSURANCE_EXPENSE NUMBER(20,4)
    ,SPE_BAL_OPER_PROFIT NUMBER(20,4)
    ,TOT_BAL_OPER_PROFIT NUMBER(20,4)
    ,SPE_BAL_TOT_PROFIT NUMBER(20,4)
    ,TOT_BAL_TOT_PROFIT NUMBER(20,4)
    ,SPE_BAL_NET_PROFIT NUMBER(20,4)
    ,TOT_BAL_NET_PROFIT NUMBER(20,4)
    ,UNDISTRIBUTED_PROFIT NUMBER(20,4)
    ,ADJLOSSGAIN_PREVYEAR NUMBER(20,4)
    ,TRANSFER_FROM_SURPLUSRESERVE NUMBER(20,4)
    ,TRANSFER_FROM_HOUSINGIMPREST NUMBER(20,4)
    ,TRANSFER_FROM_OTHERS NUMBER(20,4)
    ,DISTRIBUTABLE_PROFIT NUMBER(20,4)
    ,WITHDR_LEGALSURPLUS NUMBER(20,4)
    ,WITHDR_LEGALPUBWELFUNDS NUMBER(20,4)
    ,WORKERS_WELFARE NUMBER(20,4)
    ,WITHDR_BUZEXPWELFARE NUMBER(20,4)
    ,WITHDR_RESERVEFUND NUMBER(20,4)
    ,DISTRIBUTABLE_PROFIT_SHRHDER NUMBER(20,4)
    ,PRFSHARE_DVD_PAYABLE NUMBER(20,4)
    ,WITHDR_OTHERSURPRESERVE NUMBER(20,4)
    ,COMSHARE_DVD_PAYABLE NUMBER(20,4)
    ,CAPITALIZED_COMSTOCK_DIV NUMBER(20,4)
    ,S_INFO_COMPCODE VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_wind_ashareincome to itl;

-- comment
comment on table ${msl_schema}.msl_wind_ashareincome is '中国A股利润表';
comment on column ${msl_schema}.msl_wind_ashareincome.ETL_DT is 'ETL处理日期';
comment on column ${msl_schema}.msl_wind_ashareincome.OBJECT_ID is '对象ID';
comment on column ${msl_schema}.msl_wind_ashareincome.S_INFO_WINDCODE is 'Wind代码';
comment on column ${msl_schema}.msl_wind_ashareincome.WIND_CODE is 'Wind代码';
comment on column ${msl_schema}.msl_wind_ashareincome.ANN_DT is '公告日期';
comment on column ${msl_schema}.msl_wind_ashareincome.REPORT_PERIOD is '报告期';
comment on column ${msl_schema}.msl_wind_ashareincome.STATEMENT_TYPE is '报表类型';
comment on column ${msl_schema}.msl_wind_ashareincome.CRNCY_CODE is '货币代码';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_OPER_REV is '营业总收入';
comment on column ${msl_schema}.msl_wind_ashareincome.OPER_REV is '营业收入';
comment on column ${msl_schema}.msl_wind_ashareincome.INT_INC is '利息收入';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_INT_INC is '利息净收入';
comment on column ${msl_schema}.msl_wind_ashareincome.INSUR_PREM_UNEARNED is '已赚保费';
comment on column ${msl_schema}.msl_wind_ashareincome.HANDLING_CHRG_COMM_INC is '手续费及佣金收入';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_HANDLING_CHRG_COMM_INC is '手续费及佣金净收入';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_INC_OTHER_OPS is '其他经营净收益';
comment on column ${msl_schema}.msl_wind_ashareincome.PLUS_NET_INC_OTHER_BUS is '加:其他业务净收益';
comment on column ${msl_schema}.msl_wind_ashareincome.PREM_INC is '保费业务收入';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_CEDED_OUT_PREM is '减:分出保费';
comment on column ${msl_schema}.msl_wind_ashareincome.CHG_UNEARNED_PREM_RES is '提取未到期责任准备金';
comment on column ${msl_schema}.msl_wind_ashareincome.INCL_REINSURANCE_PREM_INC is '其中:分保费收入';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_INC_SEC_TRADING_BROK_BUS is '代理买卖证券业务净收入';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_INC_SEC_UW_BUS is '证券承销业务净收入';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_INC_EC_ASSET_MGMT_BUS is '受托客户资产管理业务净收入';
comment on column ${msl_schema}.msl_wind_ashareincome.OTHER_BUS_INC is '其他业务收入';
comment on column ${msl_schema}.msl_wind_ashareincome.PLUS_NET_GAIN_CHG_FV is '加:公允价值变动净收益';
comment on column ${msl_schema}.msl_wind_ashareincome.PLUS_NET_INVEST_INC is '加:投资净收益';
comment on column ${msl_schema}.msl_wind_ashareincome.INCL_INC_INVEST_ASSOC_JV_ENTP is '其中:对联营企业和合营企业的投资收益';
comment on column ${msl_schema}.msl_wind_ashareincome.PLUS_NET_GAIN_FX_TRANS is '加:汇兑净收益';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_OPER_COST is '营业总成本';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_OPER_COST is '减:营业成本';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_INT_EXP is '减:利息支出';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_HANDLING_CHRG_COMM_EXP is '减:手续费及佣金支出';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_TAXES_SURCHARGES_OPS is '减:营业税金及附加';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_SELLING_DIST_EXP is '减:销售费用';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_GERL_ADMIN_EXP is '减:管理费用';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_FIN_EXP is '减:财务费用';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_IMPAIR_LOSS_ASSETS is '减:资产减值损失';
comment on column ${msl_schema}.msl_wind_ashareincome.PREPAY_SURR is '退保金';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_CLAIM_EXP is '赔付总支出';
comment on column ${msl_schema}.msl_wind_ashareincome.CHG_INSUR_CONT_RSRV is '提取保险责任准备金';
comment on column ${msl_schema}.msl_wind_ashareincome.DVD_EXP_INSURED is '保户红利支出';
comment on column ${msl_schema}.msl_wind_ashareincome.REINSURANCE_EXP is '分保费用';
comment on column ${msl_schema}.msl_wind_ashareincome.OPER_EXP is '营业支出';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_CLAIM_RECB_REINSURER is '减:摊回赔付支出';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_INS_RSRV_RECB_REINSURER is '减:摊回保险责任准备金';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_EXP_RECB_REINSURER is '减:摊回分保费用';
comment on column ${msl_schema}.msl_wind_ashareincome.OTHER_BUS_COST is '其他业务成本';
comment on column ${msl_schema}.msl_wind_ashareincome.OPER_PROFIT is '营业利润';
comment on column ${msl_schema}.msl_wind_ashareincome.PLUS_NON_OPER_REV is '加:营业外收入';
comment on column ${msl_schema}.msl_wind_ashareincome.LESS_NON_OPER_EXP is '减:营业外支出';
comment on column ${msl_schema}.msl_wind_ashareincome.IL_NET_LOSS_DISP_NONCUR_ASSET is '其中:减:非流动资产处置净损失';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_PROFIT is '利润总额';
comment on column ${msl_schema}.msl_wind_ashareincome.INC_TAX is '所得税';
comment on column ${msl_schema}.msl_wind_ashareincome.UNCONFIRMED_INVEST_LOSS is '未确认投资损失';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_PROFIT_INCL_MIN_INT_INC is '净利润(含少数股东损益)';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_PROFIT_EXCL_MIN_INT_INC is '净利润(不含少数股东损益)';
comment on column ${msl_schema}.msl_wind_ashareincome.MINORITY_INT_INC is '少数股东损益';
comment on column ${msl_schema}.msl_wind_ashareincome.OTHER_COMPREH_INC is '其他综合收益';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_COMPREH_INC is '综合收益总额';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_COMPREH_INC_PARENT_COMP is '综合收益总额(母公司)';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_COMPREH_INC_MIN_SHRHLDR is '综合收益总额(少数股东)';
comment on column ${msl_schema}.msl_wind_ashareincome.EBIT is '息税前利润';
comment on column ${msl_schema}.msl_wind_ashareincome.EBITDA is '息税折旧摊销前利润';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_PROFIT_AFTER_DED_NR_LP is '扣除非经常性损益后净利润（扣除少数股东损益）';
comment on column ${msl_schema}.msl_wind_ashareincome.NET_PROFIT_UNDER_INTL_ACC_STA is '国际会计准则净利润';
comment on column ${msl_schema}.msl_wind_ashareincome.COMP_TYPE_CODE is '公司类型代码';
comment on column ${msl_schema}.msl_wind_ashareincome.S_FA_EPS_BASIC is '基本每股收益';
comment on column ${msl_schema}.msl_wind_ashareincome.S_FA_EPS_DILUTED is '稀释每股收益';
comment on column ${msl_schema}.msl_wind_ashareincome.ACTUAL_ANN_DT is '实际公告日期';
comment on column ${msl_schema}.msl_wind_ashareincome.INSURANCE_EXPENSE is '保险业务支出';
comment on column ${msl_schema}.msl_wind_ashareincome.SPE_BAL_OPER_PROFIT is '营业利润差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_BAL_OPER_PROFIT is '营业利润差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_ashareincome.SPE_BAL_TOT_PROFIT is '利润总额差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_BAL_TOT_PROFIT is '利润总额差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_ashareincome.SPE_BAL_NET_PROFIT is '净利润差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_ashareincome.TOT_BAL_NET_PROFIT is '净利润差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_ashareincome.UNDISTRIBUTED_PROFIT is '年初未分配利润';
comment on column ${msl_schema}.msl_wind_ashareincome.ADJLOSSGAIN_PREVYEAR is '调整以前年度损益';
comment on column ${msl_schema}.msl_wind_ashareincome.TRANSFER_FROM_SURPLUSRESERVE is '盈余公积转入';
comment on column ${msl_schema}.msl_wind_ashareincome.TRANSFER_FROM_HOUSINGIMPREST is '住房周转金转入';
comment on column ${msl_schema}.msl_wind_ashareincome.TRANSFER_FROM_OTHERS is '其他转入';
comment on column ${msl_schema}.msl_wind_ashareincome.DISTRIBUTABLE_PROFIT is '可分配利润';
comment on column ${msl_schema}.msl_wind_ashareincome.WITHDR_LEGALSURPLUS is '提取法定盈余公积';
comment on column ${msl_schema}.msl_wind_ashareincome.WITHDR_LEGALPUBWELFUNDS is '提取法定公益金';
comment on column ${msl_schema}.msl_wind_ashareincome.WORKERS_WELFARE is '职工奖金福利';
comment on column ${msl_schema}.msl_wind_ashareincome.WITHDR_BUZEXPWELFARE is '提取企业发展基金';
comment on column ${msl_schema}.msl_wind_ashareincome.WITHDR_RESERVEFUND is '提取储备基金';
comment on column ${msl_schema}.msl_wind_ashareincome.DISTRIBUTABLE_PROFIT_SHRHDER is '可供股东分配的利润';
comment on column ${msl_schema}.msl_wind_ashareincome.PRFSHARE_DVD_PAYABLE is '应付优先股股利';
comment on column ${msl_schema}.msl_wind_ashareincome.WITHDR_OTHERSURPRESERVE is '提取任意盈余公积金';
comment on column ${msl_schema}.msl_wind_ashareincome.COMSHARE_DVD_PAYABLE is '应付普通股股利';
comment on column ${msl_schema}.msl_wind_ashareincome.CAPITALIZED_COMSTOCK_DIV is '转作股本的普通股股利';
comment on column ${msl_schema}.msl_wind_ashareincome.S_INFO_COMPCODE is '公司ID';
