: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rwas_rwa_ws_exp_map_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rwas_rwa_ws_exp_map.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.scenarioid as scenarioid
,t1.timeid as timeid
,t1.reportid as reportid
,t1.jurisdictionid as jurisdictionid
,t1.nettingpoolid as nettingpoolid
,t1.collgua as collgua
,t1.crmid as crmid
,t1.exposureid as exposureid
,t1.exposuretypeid as exposuretypeid
,t1.inflowoutflowflag as inflowoutflowflag
,t1.exp_portfoliotypeid as exp_portfoliotypeid
,t1.crm_portfoliotypeid as crm_portfoliotypeid
,t1.portfoliotypeid as portfoliotypeid
,t1.exp_rwbandid as exp_rwbandid
,t1.crm_rwbandid as crm_rwbandid
,t1.rwbandid as rwbandid
,t1.pastdueflag as pastdueflag
,t1.unratedflag as unratedflag
,t1.ccfbandid as ccfbandid
,t1.legalentityid as legalentityid
,t1.internallegalentityid as internallegalentityid
,t1.exp_obligorgradeid as exp_obligorgradeid
,t1.crm_obligorgradeid as crm_obligorgradeid
,t1.obligorgradeid as obligorgradeid
,t1.slottingid as slottingid
,t1.crmgroupid as crmgroupid
,t1.jur_currencyid as jur_currencyid
,t1.equity_obligorid as equity_obligorid
,t1.equityflag as equityflag
,t1.orgexposureamount as orgexposureamount
,t1.valueadjprov as valueadjprov
,t1.fccmvoladjtoexp as fccmvoladjtoexp
,t1.fccmcoladjvalcvam as fccmcoladjvalcvam
,t1.fccmvolandmatadj as fccmvolandmatadj
,t1.allocatedcrm as allocatedcrm
,t1.orgexposurefromccr as orgexposurefromccr
,t1.exposureamtaftcrm as exposureamtaftcrm
,t1.dilutionrisk_rwa as dilutionrisk_rwa
,t1.pdobliggradeorpool as pdobliggradeorpool
,t1.expwtdlgd as expwtdlgd
,t1.expwtdmaturity as expwtdmaturity
,t1.exposurevalueamount as exposurevalueamount
,t1.rwaamount as rwaamount
,t1.elamount as elamount
,t1.capreqamount as capreqamount
,t1.altirb_exptypeid as altirb_exptypeid
,t1.doubledefaultflag as doubledefaultflag
,t1.exposureaftercrmoffbalance as exposureaftercrmoffbalance
,t1.exposurevalueamountoffbalance as exposurevalueamountoffbalance
,t1.expnetprov as expnetprov
,t1.unfeedcpddt as unfeedcpddt
,t1.settlementprice as settlementprice
,t1.pricediffexp as pricediffexp
,t1.com_pref_flag as com_pref_flag
,t1.obligorid as obligorid
,t1.cvaratingid as cvaratingid
,t1.exp_effectivematurityuncapped as exp_effectivematurityuncapped
,t1.notionalprincipal as notionalprincipal
,t1.tradingbookapproachid as tradingbookapproachid
,t1.assettypeid as assettypeid
,t1.cva_ead as cva_ead
,t1.realestateflag as realestateflag
,t1.mi_tiertypeid as mi_tiertypeid
,replace(replace(t1.regionid,chr(13),''),chr(10),'') as regionid
,t1.batchgroupid as batchgroupid
,t1.ccp_flag as ccp_flag
,t1.centralgov_rw_flag as centralgov_rw_flag
,t1.defaultfund_flag as defaultfund_flag
,t1.exposurevaluefromccr as exposurevaluefromccr
,t1.largefininst_flag as largefininst_flag
,t1.lgd_own_est_flag as lgd_own_est_flag
,t1.valueadjustments as valueadjustments
,t1.countryid as countryid
,t1.approachtypeid as approachtypeid
,t1.exposurevaluepreccf as exposurevaluepreccf
,t1.exposurevaluepreccfoffbal as exposurevaluepreccfoffbal
,t1.newdefaultflag as newdefaultflag
,t1.smeflag as smeflag
,t1.defaultflag as defaultflag
,replace(replace(t1.accountrefcd,chr(13),''),chr(10),'') as accountrefcd
,replace(replace(t1.crmrefcd,chr(13),''),chr(10),'') as crmrefcd
,replace(replace(t1.obligorname,chr(13),''),chr(10),'') as obligorname
,t1.cvarisk_flag as cvarisk_flag
,t1.std_implementationtypeid as std_implementationtypeid
,t1.approachid as approachid
,t1.rwa_post_adjustmentfactor as rwa_post_adjustmentfactor
,t1.capreq_post_adjustmentfactor as capreq_post_adjustmentfactor
,t1.reportingassettypeid as reportingassettypeid
,t1.lgdbandid as lgdbandid
,t1.rwa_stdapproach as rwa_stdapproach
,t1.orig_portfoliotypeid as orig_portfoliotypeid
,t1.obl_countryid as obl_countryid
,t1.crm_countryid as crm_countryid
,t1.loancategorygroupid as loancategorygroupid
,t1.dta_flag as dta_flag
,t1.msr_flag as msr_flag
,t1.obligor_pd as obligor_pd
,t1.cbrc_otc_notionalprincipal as cbrc_otc_notionalprincipal
,t1.generalprovision as generalprovision
,t1.writeoff_amount as writeoff_amount
,t1.arrearsstatusid as arrearsstatusid
,t1.largeexp_maturitybandid as largeexp_maturitybandid
,t1.regulatedflag as regulatedflag
,t1.financialinstitutionflag as financialinstitutionflag
,t1.connectedentityid as connectedentityid
,t1.collateraltypeid as collateraltypeid
,t1.guaranteetypeid as guaranteetypeid
,t1.marketparticipanttypeid as marketparticipanttypeid
,t1.exp_standardised_rwbandid as exp_standardised_rwbandid
,t1.crm_marketparticipanttypeid as crm_marketparticipanttypeid
,t1.crm_standardised_rwbandid as crm_standardised_rwbandid
,t1.orig_predeflt_portfoliotypeid as orig_predeflt_portfoliotypeid
,t1.largeexp_fin_inst_flag as largeexp_fin_inst_flag
,t1.largeexp_unreg_finentity_flag as largeexp_unreg_finentity_flag
,t1.orig_obligortypeid as orig_obligortypeid
,t1.orig_crm_issuertypeid as orig_crm_issuertypeid
,t1.largeexp_parentsignifent_flag as largeexp_parentsignifent_flag
,t1.largeexp_valueadjprov as largeexp_valueadjprov
,t1.largeexp_org_amount as largeexp_org_amount
,t1.largeexp_expnetprov as largeexp_expnetprov
,t1.largeexp_allocatedcrm as largeexp_allocatedcrm
,t1.largeexp_fccmcoladjvalcvam as largeexp_fccmcoladjvalcvam
,t1.largeexp_approachid as largeexp_approachid
,t1.obl_internalmptypeid as obl_internalmptypeid
,t1.obligortypeid as obligortypeid
,t1.sourceid as sourceid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,t1.orgstrucid as orgstrucid
,t1.accounting_subjectid as accounting_subjectid
,t1.principalamount as principalamount
,t1.interestamount as interestamount
,replace(replace(t1.industrygroupid,chr(13),''),chr(10),'') as industrygroupid
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.grade_model_cd,chr(13),''),chr(10),'') as grade_model_cd
,t1.remmaturity_bandid as remmaturity_bandid
from ${iol_schema}.rwas_rwa_ws_exp_map t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rwa_ws_exp_map.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes