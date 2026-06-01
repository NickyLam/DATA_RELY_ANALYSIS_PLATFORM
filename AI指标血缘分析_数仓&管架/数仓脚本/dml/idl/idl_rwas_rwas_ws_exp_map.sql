/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rwas_rwas_ws_exp_map
CreateDate: 20240326
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.rwas_rwas_ws_exp_map drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rwas_rwas_ws_exp_map add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rwas_rwas_ws_exp_map (
etl_dt  --etl处理日期
,scenarioid  --场景标识
,timeid  --时间标识
,reportid  --报表编号标识
,jurisdictionid  --监管规则标识
,nettingpoolid  --净额结算池标识
,collgua  --抵制押保证标识
,crmid  --信用风险缓释标识
,exposureid  --暴露标识
,exposuretypeid  --暴露类型标识
,inflowoutflowflag  --流进流出标志
,exp_portfoliotypeid  --暴露_暴露分类标识
,crm_portfoliotypeid  --缓释_暴露分类标识
,portfoliotypeid  --暴露分类标识
,exp_rwbandid  --暴露_权重档次标识
,crm_rwbandid  --缓释_权重档次标识
,rwbandid  --风险权重区间标识
,pastdueflag  --逾期标志
,unratedflag  --未评级标识
,ccfbandid  --信用转换因子等级标识
,legalentityid  --法律实体标识
,internallegalentityid  --内部法律实体标识
,exp_obligorgradeid  --暴露_债务人等级标识
,crm_obligorgradeid  --缓释_债务人等级标识
,obligorgradeid  --债务人等级标识
,slottingid  --专业贷款标识
,crmgroupid  --信用风险缓释组标识
,jur_currencyid  --监管_货币标识
,equity_obligorid  --股权_债务人等级标识
,equityflag  --股权标志
,orgexposureamount  --原始暴露金额
,valueadjprov  --拨备金额
,fccmvoladjtoexp  --暴露的波动调整
,fccmcoladjvalcvam  --综合法下金融抵置押品调整后价值
,fccmvolandmatadj  --波动期限调整
,allocatedcrm  --分配的缓释金额
,orgexposurefromccr  --交易对手原始暴露金额
,exposureamtaftcrm  --风险缓释后的暴露金额
,dilutionrisk_rwa  --稀释风险
,pdobliggradeorpool  --第一风险人等级或池违约概率
,expwtdlgd  --暴露加权的违约损失率
,expwtdmaturity  --暴露加权的违约期限
,exposurevalueamount  --暴露价值金额
,rwaamount  --rwa（风险加权资产）金额
,elamount  --预期损失金额
,capreqamount  --资本需求额
,altirb_exptypeid  --内评法_暴露类型标识
,doubledefaultflag  --双重违约标志
,exposureaftercrmoffbalance  --缓释后表外风险暴露余额
,exposurevalueamountoffbalance  --缓释后表外风险暴露
,expnetprov  --暴露净拨备
,unfeedcpddt  --未收费分配缓释品保证的双重标识
,settlementprice  --结算价格
,pricediffexp  --价格差异暴露
,com_pref_flag  --商业实体_优惠_标识
,obligorid  --第一风险人标识
,cvaratingid  --信用估值调整评级标识
,exp_effectivematurityuncapped  --暴露_有效期限
,notionalprincipal  --名义本金
,tradingbookapproachid  --交易账户方法标识
,assettypeid  --资产类型标识
,cva_ead  --信用估值调整_风险暴露
,realestateflag  --房地产标志
,mi_tiertypeid  --少数股东_层级类型标识
,regionid  --地区标识
,batchgroupid  --批处理组标识
,ccp_flag  --中央交易对手_标志
,centralgov_rw_flag  --中央交易权重_标志
,defaultfund_flag  --违约基金_标志
,exposurevaluefromccr  --交易对手风险暴露
,largefininst_flag  --大型金融机融_标志
,lgd_own_est_flag  --违约损失率_所有_标志
,valueadjustments  --价值调整
,countryid  --国家标识
,approachtypeid  --方法类型标识
,exposurevaluepreccf  --ccf（信用转换系数）之前暴露
,exposurevaluepreccfoffbal  --ccf（信用转换系数）之前表外
,newdefaultflag  --新违约标志
,smeflag  --小微标志
,defaultflag  --违约标志
,accountrefcd  --账户参考代码
,crmrefcd  --信用风险缓释参考代码
,obligorname  --市场参与者名字
,cvarisk_flag  --信用估值调整风险标识
,std_implementationtypeid  --标准法实施类型标识
,approachid  --方法标识
,rwa_post_adjustmentfactor  --风险加权资产_后续_调整因子
,capreq_post_adjustmentfactor  --资本要求_后续_调整因子
,reportingassettypeid  --报告资产类型标识
,lgdbandid  --违约损失率等级标识
,rwa_stdapproach  --风险加权资产_标准法
,orig_portfoliotypeid  --原始暴露分类标识
,obl_countryid  --债务人国家标识
,crm_countryid  --缓释国家标识
,loancategorygroupid  --五级分类组标识
,dta_flag  --递延所得税资产_标识
,msr_flag  --抵押服务权利_标识
,obligor_pd  --债务人_违约概率
,cbrc_otc_notionalprincipal  --银监会_场外衍生_名义本金
,generalprovision  --银监会_场外衍生_名义本金
,writeoff_amount  --结清_金额
,arrearsstatusid  --欠款状态标识
,largeexp_maturitybandid  --巨额风险暴露_期限档次标识
,regulatedflag  --监管标志
,financialinstitutionflag  --金融机构标志
,connectedentityid  --关联企业标识
,collateraltypeid  --抵押品类型标识
,guaranteetypeid  --保证类型标识
,marketparticipanttypeid  --市场参与者类型标识
,exp_standardised_rwbandid  --暴露_标准法_风险权重
,crm_marketparticipanttypeid  --缓释品_市场参与者类型标识
,crm_standardised_rwbandid  --缓释品_标准法_风险权重
,orig_predeflt_portfoliotypeid  --原始_违约前_暴露分类标识
,largeexp_fin_inst_flag  --大额暴露_金融机构_标志
,largeexp_unreg_finentity_flag  --大额暴露_未监管_金融实体_标
,orig_obligortypeid  --原始_债务人标识
,orig_crm_issuertypeid  --原始_缓释_发行人类型
,largeexp_parentsignifent_flag  --大额暴露_亲本意义_标志
,largeexp_valueadjprov  --大额暴露_拨备金额
,largeexp_org_amount  --大额暴露_余额
,largeexp_expnetprov  --大额暴露_净拨备金额
,largeexp_allocatedcrm  --大额暴露_分配风险缓释
,largeexp_fccmcoladjvalcvam  --大额暴露_综合法下金融抵置押品
,largeexp_approachid  --大额暴露_方法标识
,obl_internalmptypeid  --债务人_内部市场参与者标识
,obligortypeid  --第一风险人类型标识
,sourceid  --业务条线
,productid  --产品
,orgstrucid  --组织机构标识
,accounting_subjectid  --会计科目
,principalamount  --本金金额
,interestamount  --应收利息金额
,industrygroupid  --行业组标识
,corp_size_cd  --企业规模代码国标
,grade_model_cd  --客户评级的模型代码
,remmaturity_bandid  --
,loan_ref_no  --债项编号
,five_class_cd  --五级分类

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,t1.scenarioid as scenarioid --场景标识
,t1.timeid as timeid --时间标识
,t1.reportid as reportid --报表编号标识
,t1.jurisdictionid as jurisdictionid --监管规则标识
,t1.nettingpoolid as nettingpoolid --净额结算池标识
,t1.collgua as collgua --抵制押保证标识
,t1.crmid as crmid --信用风险缓释标识
,t1.exposureid as exposureid --暴露标识
,t1.exposuretypeid as exposuretypeid --暴露类型标识
,t1.inflowoutflowflag as inflowoutflowflag --流进流出标志
,t1.exp_portfoliotypeid as exp_portfoliotypeid --暴露_暴露分类标识
,t1.crm_portfoliotypeid as crm_portfoliotypeid --缓释_暴露分类标识
,t1.portfoliotypeid as portfoliotypeid --暴露分类标识
,t1.exp_rwbandid as exp_rwbandid --暴露_权重档次标识
,t1.crm_rwbandid as crm_rwbandid --缓释_权重档次标识
,t1.rwbandid as rwbandid --风险权重区间标识
,t1.pastdueflag as pastdueflag --逾期标志
,t1.unratedflag as unratedflag --未评级标识
,t1.ccfbandid as ccfbandid --信用转换因子等级标识
,t1.legalentityid as legalentityid --法律实体标识
,t1.internallegalentityid as internallegalentityid --内部法律实体标识
,t1.exp_obligorgradeid as exp_obligorgradeid --暴露_债务人等级标识
,t1.crm_obligorgradeid as crm_obligorgradeid --缓释_债务人等级标识
,t1.obligorgradeid as obligorgradeid --债务人等级标识
,t1.slottingid as slottingid --专业贷款标识
,t1.crmgroupid as crmgroupid --信用风险缓释组标识
,t1.jur_currencyid as jur_currencyid --监管_货币标识
,t1.equity_obligorid as equity_obligorid --股权_债务人等级标识
,t1.equityflag as equityflag --股权标志
,t1.orgexposureamount as orgexposureamount --原始暴露金额
,t1.valueadjprov as valueadjprov --拨备金额
,t1.fccmvoladjtoexp as fccmvoladjtoexp --暴露的波动调整
,t1.fccmcoladjvalcvam as fccmcoladjvalcvam --综合法下金融抵置押品调整后价值
,t1.fccmvolandmatadj as fccmvolandmatadj --波动期限调整
,t1.allocatedcrm as allocatedcrm --分配的缓释金额
,t1.orgexposurefromccr as orgexposurefromccr --交易对手原始暴露金额
,t1.exposureamtaftcrm as exposureamtaftcrm --风险缓释后的暴露金额
,t1.dilutionrisk_rwa as dilutionrisk_rwa --稀释风险
,t1.pdobliggradeorpool as pdobliggradeorpool --第一风险人等级或池违约概率
,t1.expwtdlgd as expwtdlgd --暴露加权的违约损失率
,t1.expwtdmaturity as expwtdmaturity --暴露加权的违约期限
,t1.exposurevalueamount as exposurevalueamount --暴露价值金额
,t1.rwaamount as rwaamount --rwa（风险加权资产）金额
,t1.elamount as elamount --预期损失金额
,t1.capreqamount as capreqamount --资本需求额
,t1.altirb_exptypeid as altirb_exptypeid --内评法_暴露类型标识
,t1.doubledefaultflag as doubledefaultflag --双重违约标志
,t1.exposureaftercrmoffbalance as exposureaftercrmoffbalance --缓释后表外风险暴露余额
,t1.exposurevalueamountoffbalance as exposurevalueamountoffbalance --缓释后表外风险暴露
,t1.expnetprov as expnetprov --暴露净拨备
,t1.unfeedcpddt as unfeedcpddt --未收费分配缓释品保证的双重标识
,t1.settlementprice as settlementprice --结算价格
,t1.pricediffexp as pricediffexp --价格差异暴露
,t1.com_pref_flag as com_pref_flag --商业实体_优惠_标识
,t1.obligorid as obligorid --第一风险人标识
,t1.cvaratingid as cvaratingid --信用估值调整评级标识
,t1.exp_effectivematurityuncapped as exp_effectivematurityuncapped --暴露_有效期限
,t1.notionalprincipal as notionalprincipal --名义本金
,t1.tradingbookapproachid as tradingbookapproachid --交易账户方法标识
,t1.assettypeid as assettypeid --资产类型标识
,t1.cva_ead as cva_ead --信用估值调整_风险暴露
,t1.realestateflag as realestateflag --房地产标志
,t1.mi_tiertypeid as mi_tiertypeid --少数股东_层级类型标识
,replace(replace(t1.regionid,chr(13),''),chr(10),'') as regionid --地区标识
,t1.batchgroupid as batchgroupid --批处理组标识
,t1.ccp_flag as ccp_flag --中央交易对手_标志
,t1.centralgov_rw_flag as centralgov_rw_flag --中央交易权重_标志
,t1.defaultfund_flag as defaultfund_flag --违约基金_标志
,t1.exposurevaluefromccr as exposurevaluefromccr --交易对手风险暴露
,t1.largefininst_flag as largefininst_flag --大型金融机融_标志
,t1.lgd_own_est_flag as lgd_own_est_flag --违约损失率_所有_标志
,t1.valueadjustments as valueadjustments --价值调整
,t1.countryid as countryid --国家标识
,t1.approachtypeid as approachtypeid --方法类型标识
,t1.exposurevaluepreccf as exposurevaluepreccf --ccf（信用转换系数）之前暴露
,t1.exposurevaluepreccfoffbal as exposurevaluepreccfoffbal --ccf（信用转换系数）之前表外
,t1.newdefaultflag as newdefaultflag --新违约标志
,t1.smeflag as smeflag --小微标志
,t1.defaultflag as defaultflag --违约标志
,replace(replace(t1.accountrefcd,chr(13),''),chr(10),'') as accountrefcd --账户参考代码
,replace(replace(t1.crmrefcd,chr(13),''),chr(10),'') as crmrefcd --信用风险缓释参考代码
,replace(replace(t1.obligorname,chr(13),''),chr(10),'') as obligorname --市场参与者名字
,t1.cvarisk_flag as cvarisk_flag --信用估值调整风险标识
,t1.std_implementationtypeid as std_implementationtypeid --标准法实施类型标识
,t1.approachid as approachid --方法标识
,t1.rwa_post_adjustmentfactor as rwa_post_adjustmentfactor --风险加权资产_后续_调整因子
,t1.capreq_post_adjustmentfactor as capreq_post_adjustmentfactor --资本要求_后续_调整因子
,t1.reportingassettypeid as reportingassettypeid --报告资产类型标识
,t1.lgdbandid as lgdbandid --违约损失率等级标识
,t1.rwa_stdapproach as rwa_stdapproach --风险加权资产_标准法
,t1.orig_portfoliotypeid as orig_portfoliotypeid --原始暴露分类标识
,t1.obl_countryid as obl_countryid --债务人国家标识
,t1.crm_countryid as crm_countryid --缓释国家标识
,t1.loancategorygroupid as loancategorygroupid --五级分类组标识
,t1.dta_flag as dta_flag --递延所得税资产_标识
,t1.msr_flag as msr_flag --抵押服务权利_标识
,t1.obligor_pd as obligor_pd --债务人_违约概率
,t1.cbrc_otc_notionalprincipal as cbrc_otc_notionalprincipal --银监会_场外衍生_名义本金
,t1.generalprovision as generalprovision --银监会_场外衍生_名义本金
,t1.writeoff_amount as writeoff_amount --结清_金额
,t1.arrearsstatusid as arrearsstatusid --欠款状态标识
,t1.largeexp_maturitybandid as largeexp_maturitybandid --巨额风险暴露_期限档次标识
,t1.regulatedflag as regulatedflag --监管标志
,t1.financialinstitutionflag as financialinstitutionflag --金融机构标志
,t1.connectedentityid as connectedentityid --关联企业标识
,t1.collateraltypeid as collateraltypeid --抵押品类型标识
,t1.guaranteetypeid as guaranteetypeid --保证类型标识
,t1.marketparticipanttypeid as marketparticipanttypeid --市场参与者类型标识
,t1.exp_standardised_rwbandid as exp_standardised_rwbandid --暴露_标准法_风险权重
,t1.crm_marketparticipanttypeid as crm_marketparticipanttypeid --缓释品_市场参与者类型标识
,t1.crm_standardised_rwbandid as crm_standardised_rwbandid --缓释品_标准法_风险权重
,t1.orig_predeflt_portfoliotypeid as orig_predeflt_portfoliotypeid --原始_违约前_暴露分类标识
,t1.largeexp_fin_inst_flag as largeexp_fin_inst_flag --大额暴露_金融机构_标志
,t1.largeexp_unreg_finentity_flag as largeexp_unreg_finentity_flag --大额暴露_未监管_金融实体_标
,t1.orig_obligortypeid as orig_obligortypeid --原始_债务人标识
,t1.orig_crm_issuertypeid as orig_crm_issuertypeid --原始_缓释_发行人类型
,t1.largeexp_parentsignifent_flag as largeexp_parentsignifent_flag --大额暴露_亲本意义_标志
,t1.largeexp_valueadjprov as largeexp_valueadjprov --大额暴露_拨备金额
,t1.largeexp_org_amount as largeexp_org_amount --大额暴露_余额
,t1.largeexp_expnetprov as largeexp_expnetprov --大额暴露_净拨备金额
,t1.largeexp_allocatedcrm as largeexp_allocatedcrm --大额暴露_分配风险缓释
,t1.largeexp_fccmcoladjvalcvam as largeexp_fccmcoladjvalcvam --大额暴露_综合法下金融抵置押品
,t1.largeexp_approachid as largeexp_approachid --大额暴露_方法标识
,t1.obl_internalmptypeid as obl_internalmptypeid --债务人_内部市场参与者标识
,t1.obligortypeid as obligortypeid --第一风险人类型标识
,t1.sourceid as sourceid --业务条线
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid --产品
,t1.orgstrucid as orgstrucid --组织机构标识
,t1.accounting_subjectid as accounting_subjectid --会计科目
,t1.principalamount as principalamount --本金金额
,t1.interestamount as interestamount --应收利息金额
,replace(replace(t1.industrygroupid,chr(13),''),chr(10),'') as industrygroupid --行业组标识
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd --企业规模代码国标
,replace(replace(t1.grade_model_cd,chr(13),''),chr(10),'') as grade_model_cd --客户评级的模型代码
,t1.remmaturity_bandid as remmaturity_bandid --
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no --债项编号
,replace(replace(t1.five_class_cd,chr(13),''),chr(10),'') as five_class_cd --五级分类
from ${iol_schema}.rwas_rwas_ws_exp_map t1    --风险加权资产明细表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')-1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rwas_rwas_ws_exp_map',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
