/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rwas_ws_exp_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rwas_ws_exp_map
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rwas_ws_exp_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwas_ws_exp_map(
    scenarioid number(9,0) -- 场景标识
    ,timeid number(9,0) -- 时间标识
    ,reportid number(9,0) -- 报表编号标识
    ,jurisdictionid number(9,0) -- 监管规则标识
    ,nettingpoolid number(9,0) -- 净额结算池标识
    ,collgua number(9,0) -- 抵制押保证标识
    ,crmid number(9,0) -- 信用风险缓释标识
    ,exposureid number(9,0) -- 暴露标识
    ,exposuretypeid number(9,0) -- 暴露类型标识
    ,inflowoutflowflag number(1,0) -- 流进流出标志
    ,exp_portfoliotypeid number(9,0) -- 暴露_暴露分类标识
    ,crm_portfoliotypeid number(9,0) -- 缓释_暴露分类标识
    ,portfoliotypeid number(9,0) -- 暴露分类标识
    ,exp_rwbandid number(9,0) -- 暴露_权重档次标识
    ,crm_rwbandid number(9,0) -- 缓释_权重档次标识
    ,rwbandid number(9,0) -- 风险权重区间标识
    ,pastdueflag number(1,0) -- 逾期标志
    ,unratedflag number(1,0) -- 未评级标识
    ,ccfbandid number(9,0) -- 信用转换因子等级标识
    ,legalentityid number(9,0) -- 法律实体标识
    ,internallegalentityid number(9,0) -- 内部法律实体标识
    ,exp_obligorgradeid number(9,0) -- 暴露_债务人等级标识
    ,crm_obligorgradeid number(9,0) -- 缓释_债务人等级标识
    ,obligorgradeid number(9,0) -- 债务人等级标识
    ,slottingid number(9,0) -- 专业贷款标识
    ,crmgroupid number(9,0) -- 信用风险缓释组标识
    ,jur_currencyid number(9,0) -- 监管_货币标识
    ,equity_obligorid number(9,0) -- 股权_债务人等级标识
    ,equityflag number(1,0) -- 股权标志
    ,orgexposureamount number(22,4) -- 原始暴露金额
    ,valueadjprov number(22,4) -- 拨备金额
    ,fccmvoladjtoexp number(22,4) -- 暴露的波动调整
    ,fccmcoladjvalcvam number(22,4) -- 综合法下金融抵置押品调整后价值
    ,fccmvolandmatadj number(22,4) -- 波动期限调整
    ,allocatedcrm number(22,4) -- 分配的缓释金额
    ,orgexposurefromccr number(22,4) -- 交易对手原始暴露金额
    ,exposureamtaftcrm number(22,4) -- 风险缓释后的暴露金额
    ,dilutionrisk_rwa number(22,4) -- 稀释风险
    ,pdobliggradeorpool number(22,4) -- 第一风险人等级或池违约概率
    ,expwtdlgd number(22,4) -- 暴露加权的违约损失率
    ,expwtdmaturity number(22,4) -- 暴露加权的违约期限
    ,exposurevalueamount number(22,4) -- 暴露价值金额
    ,rwaamount number(22,4) -- rwa（风险加权资产）金额
    ,elamount number(22,4) -- 预期损失金额
    ,capreqamount number(22,4) -- 资本需求额
    ,altirb_exptypeid number(22,4) -- 内评法_暴露类型标识
    ,doubledefaultflag number(22,4) -- 双重违约标志
    ,exposureaftercrmoffbalance number(22,4) -- 缓释后表外风险暴露余额
    ,exposurevalueamountoffbalance number(22,4) -- 缓释后表外风险暴露
    ,expnetprov number(22,4) -- 暴露净拨备
    ,unfeedcpddt number(22,4) -- 未收费分配缓释品保证的双重标识
    ,settlementprice number(22,4) -- 结算价格
    ,pricediffexp number(22,4) -- 价格差异暴露
    ,com_pref_flag number(1,0) -- 商业实体_优惠_标识
    ,obligorid number(9,0) -- 第一风险人标识
    ,cvaratingid number(9,0) -- 信用估值调整评级标识
    ,exp_effectivematurityuncapped number(10,6) -- 暴露_有效期限
    ,notionalprincipal number(22,4) -- 名义本金
    ,tradingbookapproachid number(9,0) -- 交易账户方法标识
    ,assettypeid number(9,0) -- 资产类型标识
    ,cva_ead number(22,4) -- 信用估值调整_风险暴露
    ,realestateflag number(1,0) -- 房地产标志
    ,mi_tiertypeid number(9,0) -- 少数股东_层级类型标识
    ,regionid varchar2(135) -- 地区标识
    ,batchgroupid number(9,0) -- 批处理组标识
    ,ccp_flag number(1,0) -- 中央交易对手_标志
    ,centralgov_rw_flag number(1,0) -- 中央交易权重_标志
    ,defaultfund_flag number(1,0) -- 违约基金_标志
    ,exposurevaluefromccr number(22,4) -- 交易对手风险暴露
    ,largefininst_flag number(1,0) -- 大型金融机融_标志
    ,lgd_own_est_flag number(1,0) -- 违约损失率_所有_标志
    ,valueadjustments number(22,4) -- 价值调整
    ,countryid number(9,0) -- 国家标识
    ,approachtypeid number(9,0) -- 方法类型标识
    ,exposurevaluepreccf number(22,4) -- ccf（信用转换系数）之前暴露
    ,exposurevaluepreccfoffbal number(22,4) -- ccf（信用转换系数）之前表外
    ,newdefaultflag number(1,0) -- 新违约标志
    ,smeflag number(1,0) -- 小微标志
    ,defaultflag number(1,0) -- 违约标志
    ,accountrefcd varchar2(1125) -- 账户参考代码
    ,crmrefcd varchar2(1125) -- 信用风险缓释参考代码
    ,obligorname varchar2(1125) -- 市场参与者名字
    ,cvarisk_flag number(1,0) -- 信用估值调整风险标识
    ,std_implementationtypeid number(9,0) -- 标准法实施类型标识
    ,approachid number(9,0) -- 方法标识
    ,rwa_post_adjustmentfactor number(22,4) -- 风险加权资产_后续_调整因子
    ,capreq_post_adjustmentfactor number(22,4) -- 资本要求_后续_调整因子
    ,reportingassettypeid number(9,0) -- 报告资产类型标识
    ,lgdbandid number(9,0) -- 违约损失率等级标识
    ,rwa_stdapproach number(22,4) -- 风险加权资产_标准法
    ,orig_portfoliotypeid number(9,0) -- 原始暴露分类标识
    ,obl_countryid number(9,0) -- 债务人国家标识
    ,crm_countryid number(9,0) -- 缓释国家标识
    ,loancategorygroupid number(9,0) -- 五级分类组标识
    ,dta_flag number(1,0) -- 递延所得税资产_标识
    ,msr_flag number(1,0) -- 抵押服务权利_标识
    ,obligor_pd number(10,8) -- 债务人_违约概率
    ,cbrc_otc_notionalprincipal number(22,4) -- 银监会_场外衍生_名义本金
    ,generalprovision number(22,4) -- 银监会_场外衍生_名义本金
    ,writeoff_amount number(22,4) -- 结清_金额
    ,arrearsstatusid number(9,0) -- 欠款状态标识
    ,largeexp_maturitybandid number(9,0) -- 巨额风险暴露_期限档次标识
    ,regulatedflag number(1,0) -- 监管标志
    ,financialinstitutionflag number(1,0) -- 金融机构标志
    ,connectedentityid number(9,0) -- 关联企业标识
    ,collateraltypeid number(9,0) -- 抵押品类型标识
    ,guaranteetypeid number(9,0) -- 保证类型标识
    ,marketparticipanttypeid number(9,0) -- 市场参与者类型标识
    ,exp_standardised_rwbandid number(9,0) -- 暴露_标准法_风险权重
    ,crm_marketparticipanttypeid number(9,0) -- 缓释品_市场参与者类型标识
    ,crm_standardised_rwbandid number(9,0) -- 缓释品_标准法_风险权重
    ,orig_predeflt_portfoliotypeid number(9,0) -- 原始_违约前_暴露分类标识
    ,largeexp_fin_inst_flag number(1,0) -- 大额暴露_金融机构_标志
    ,largeexp_unreg_finentity_flag number(1,0) -- 大额暴露_未监管_金融实体_标
    ,orig_obligortypeid number(9,0) -- 原始_债务人标识
    ,orig_crm_issuertypeid number(9,0) -- 原始_缓释_发行人类型
    ,largeexp_parentsignifent_flag number(9,0) -- 大额暴露_亲本意义_标志
    ,largeexp_valueadjprov number(22,4) -- 大额暴露_拨备金额
    ,largeexp_org_amount number(22,4) -- 大额暴露_余额
    ,largeexp_expnetprov number(22,4) -- 大额暴露_净拨备金额
    ,largeexp_allocatedcrm number(22,4) -- 大额暴露_分配风险缓释
    ,largeexp_fccmcoladjvalcvam number(22,4) -- 大额暴露_综合法下金融抵置押品
    ,largeexp_approachid number(9,0) -- 大额暴露_方法标识
    ,obl_internalmptypeid number(9,0) -- 债务人_内部市场参与者标识
    ,obligortypeid number(9,0) -- 第一风险人类型标识
    ,sourceid number(9,0) -- 业务条线
    ,productid varchar2(135) -- 产品
    ,orgstrucid number(38,0) -- 组织机构标识
    ,accounting_subjectid number(22,0) -- 会计科目
    ,principalamount number(22,4) -- 本金金额
    ,interestamount number(22,4) -- 应收利息金额
    ,industrygroupid varchar2(135) -- 行业组标识
    ,corp_size_cd varchar2(14) -- 企业规模代码国标
    ,grade_model_cd varchar2(45) -- 客户评级的模型代码
    ,remmaturity_bandid number(9,0) -- 
    ,loan_ref_no varchar2(150) -- 债项编号
    ,five_class_cd varchar2(15) -- 五级分类
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rwas_rwas_ws_exp_map to ${iml_schema};
grant select on ${iol_schema}.rwas_rwas_ws_exp_map to ${icl_schema};
grant select on ${iol_schema}.rwas_rwas_ws_exp_map to ${idl_schema};
grant select on ${iol_schema}.rwas_rwas_ws_exp_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rwas_ws_exp_map is '风险加权资产明细表';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.scenarioid is '场景标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.timeid is '时间标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.reportid is '报表编号标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.jurisdictionid is '监管规则标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.nettingpoolid is '净额结算池标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.collgua is '抵制押保证标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crmid is '信用风险缓释标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposureid is '暴露标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposuretypeid is '暴露类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.inflowoutflowflag is '流进流出标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exp_portfoliotypeid is '暴露_暴露分类标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crm_portfoliotypeid is '缓释_暴露分类标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.portfoliotypeid is '暴露分类标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exp_rwbandid is '暴露_权重档次标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crm_rwbandid is '缓释_权重档次标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.rwbandid is '风险权重区间标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.pastdueflag is '逾期标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.unratedflag is '未评级标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.ccfbandid is '信用转换因子等级标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.legalentityid is '法律实体标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.internallegalentityid is '内部法律实体标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exp_obligorgradeid is '暴露_债务人等级标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crm_obligorgradeid is '缓释_债务人等级标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.obligorgradeid is '债务人等级标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.slottingid is '专业贷款标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crmgroupid is '信用风险缓释组标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.jur_currencyid is '监管_货币标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.equity_obligorid is '股权_债务人等级标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.equityflag is '股权标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.orgexposureamount is '原始暴露金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.valueadjprov is '拨备金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.fccmvoladjtoexp is '暴露的波动调整';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.fccmcoladjvalcvam is '综合法下金融抵置押品调整后价值';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.fccmvolandmatadj is '波动期限调整';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.allocatedcrm is '分配的缓释金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.orgexposurefromccr is '交易对手原始暴露金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposureamtaftcrm is '风险缓释后的暴露金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.dilutionrisk_rwa is '稀释风险';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.pdobliggradeorpool is '第一风险人等级或池违约概率';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.expwtdlgd is '暴露加权的违约损失率';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.expwtdmaturity is '暴露加权的违约期限';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposurevalueamount is '暴露价值金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.rwaamount is 'rwa（风险加权资产）金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.elamount is '预期损失金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.capreqamount is '资本需求额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.altirb_exptypeid is '内评法_暴露类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.doubledefaultflag is '双重违约标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposureaftercrmoffbalance is '缓释后表外风险暴露余额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposurevalueamountoffbalance is '缓释后表外风险暴露';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.expnetprov is '暴露净拨备';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.unfeedcpddt is '未收费分配缓释品保证的双重标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.settlementprice is '结算价格';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.pricediffexp is '价格差异暴露';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.com_pref_flag is '商业实体_优惠_标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.obligorid is '第一风险人标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.cvaratingid is '信用估值调整评级标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exp_effectivematurityuncapped is '暴露_有效期限';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.notionalprincipal is '名义本金';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.tradingbookapproachid is '交易账户方法标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.assettypeid is '资产类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.cva_ead is '信用估值调整_风险暴露';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.realestateflag is '房地产标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.mi_tiertypeid is '少数股东_层级类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.regionid is '地区标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.batchgroupid is '批处理组标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.ccp_flag is '中央交易对手_标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.centralgov_rw_flag is '中央交易权重_标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.defaultfund_flag is '违约基金_标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposurevaluefromccr is '交易对手风险暴露';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largefininst_flag is '大型金融机融_标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.lgd_own_est_flag is '违约损失率_所有_标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.valueadjustments is '价值调整';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.countryid is '国家标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.approachtypeid is '方法类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposurevaluepreccf is 'ccf（信用转换系数）之前暴露';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exposurevaluepreccfoffbal is 'ccf（信用转换系数）之前表外';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.newdefaultflag is '新违约标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.smeflag is '小微标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.defaultflag is '违约标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.accountrefcd is '账户参考代码';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crmrefcd is '信用风险缓释参考代码';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.obligorname is '市场参与者名字';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.cvarisk_flag is '信用估值调整风险标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.std_implementationtypeid is '标准法实施类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.approachid is '方法标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.rwa_post_adjustmentfactor is '风险加权资产_后续_调整因子';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.capreq_post_adjustmentfactor is '资本要求_后续_调整因子';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.reportingassettypeid is '报告资产类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.lgdbandid is '违约损失率等级标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.rwa_stdapproach is '风险加权资产_标准法';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.orig_portfoliotypeid is '原始暴露分类标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.obl_countryid is '债务人国家标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crm_countryid is '缓释国家标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.loancategorygroupid is '五级分类组标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.dta_flag is '递延所得税资产_标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.msr_flag is '抵押服务权利_标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.obligor_pd is '债务人_违约概率';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.cbrc_otc_notionalprincipal is '银监会_场外衍生_名义本金';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.generalprovision is '银监会_场外衍生_名义本金';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.writeoff_amount is '结清_金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.arrearsstatusid is '欠款状态标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_maturitybandid is '巨额风险暴露_期限档次标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.regulatedflag is '监管标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.financialinstitutionflag is '金融机构标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.connectedentityid is '关联企业标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.collateraltypeid is '抵押品类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.guaranteetypeid is '保证类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.marketparticipanttypeid is '市场参与者类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.exp_standardised_rwbandid is '暴露_标准法_风险权重';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crm_marketparticipanttypeid is '缓释品_市场参与者类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.crm_standardised_rwbandid is '缓释品_标准法_风险权重';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.orig_predeflt_portfoliotypeid is '原始_违约前_暴露分类标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_fin_inst_flag is '大额暴露_金融机构_标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_unreg_finentity_flag is '大额暴露_未监管_金融实体_标';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.orig_obligortypeid is '原始_债务人标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.orig_crm_issuertypeid is '原始_缓释_发行人类型';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_parentsignifent_flag is '大额暴露_亲本意义_标志';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_valueadjprov is '大额暴露_拨备金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_org_amount is '大额暴露_余额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_expnetprov is '大额暴露_净拨备金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_allocatedcrm is '大额暴露_分配风险缓释';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_fccmcoladjvalcvam is '大额暴露_综合法下金融抵置押品';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.largeexp_approachid is '大额暴露_方法标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.obl_internalmptypeid is '债务人_内部市场参与者标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.obligortypeid is '第一风险人类型标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.sourceid is '业务条线';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.productid is '产品';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.orgstrucid is '组织机构标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.accounting_subjectid is '会计科目';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.principalamount is '本金金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.interestamount is '应收利息金额';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.industrygroupid is '行业组标识';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.corp_size_cd is '企业规模代码国标';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.grade_model_cd is '客户评级的模型代码';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.remmaturity_bandid is '';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.loan_ref_no is '债项编号';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.five_class_cd is '五级分类';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rwas_ws_exp_map.etl_timestamp is 'ETL处理时间戳';
