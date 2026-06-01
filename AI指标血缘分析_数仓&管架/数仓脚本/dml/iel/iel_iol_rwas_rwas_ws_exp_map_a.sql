: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rwas_rwas_ws_exp_map_a
CreateDate: 20231115
FileName:   ${iel_data_path}/rwas_rwas_ws_exp_map.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,scenarioid
,timeid
,reportid
,jurisdictionid
,nettingpoolid
,collgua
,crmid
,exposureid
,exposuretypeid
,inflowoutflowflag
,exp_portfoliotypeid
,crm_portfoliotypeid
,portfoliotypeid
,exp_rwbandid
,crm_rwbandid
,rwbandid
,pastdueflag
,unratedflag
,ccfbandid
,legalentityid
,internallegalentityid
,exp_obligorgradeid
,crm_obligorgradeid
,obligorgradeid
,slottingid
,crmgroupid
,jur_currencyid
,equity_obligorid
,equityflag
,orgexposureamount
,valueadjprov
,fccmvoladjtoexp
,fccmcoladjvalcvam
,fccmvolandmatadj
,allocatedcrm
,orgexposurefromccr
,exposureamtaftcrm
,dilutionrisk_rwa
,pdobliggradeorpool
,expwtdlgd
,expwtdmaturity
,exposurevalueamount
,rwaamount
,elamount
,capreqamount
,altirb_exptypeid
,doubledefaultflag
,exposureaftercrmoffbalance
,exposurevalueamountoffbalance
,expnetprov
,unfeedcpddt
,settlementprice
,pricediffexp
,com_pref_flag
,obligorid
,cvaratingid
,exp_effectivematurityuncapped
,notionalprincipal
,tradingbookapproachid
,assettypeid
,cva_ead
,realestateflag
,mi_tiertypeid
,replace(replace(t1.regionid,chr(13),''),chr(10),'') as regionid
,batchgroupid
,ccp_flag
,centralgov_rw_flag
,defaultfund_flag
,exposurevaluefromccr
,largefininst_flag
,lgd_own_est_flag
,valueadjustments
,countryid
,approachtypeid
,exposurevaluepreccf
,exposurevaluepreccfoffbal
,newdefaultflag
,smeflag
,defaultflag
,replace(replace(t1.accountrefcd,chr(13),''),chr(10),'') as accountrefcd
,replace(replace(t1.crmrefcd,chr(13),''),chr(10),'') as crmrefcd
,replace(replace(t1.obligorname,chr(13),''),chr(10),'') as obligorname
,cvarisk_flag
,std_implementationtypeid
,approachid
,rwa_post_adjustmentfactor
,capreq_post_adjustmentfactor
,reportingassettypeid
,lgdbandid
,rwa_stdapproach
,orig_portfoliotypeid
,obl_countryid
,crm_countryid
,loancategorygroupid
,dta_flag
,msr_flag
,obligor_pd
,cbrc_otc_notionalprincipal
,generalprovision
,writeoff_amount
,arrearsstatusid
,largeexp_maturitybandid
,regulatedflag
,financialinstitutionflag
,connectedentityid
,collateraltypeid
,guaranteetypeid
,marketparticipanttypeid
,exp_standardised_rwbandid
,crm_marketparticipanttypeid
,crm_standardised_rwbandid
,orig_predeflt_portfoliotypeid
,largeexp_fin_inst_flag
,largeexp_unreg_finentity_flag
,orig_obligortypeid
,orig_crm_issuertypeid
,largeexp_parentsignifent_flag
,largeexp_valueadjprov
,largeexp_org_amount
,largeexp_expnetprov
,largeexp_allocatedcrm
,largeexp_fccmcoladjvalcvam
,largeexp_approachid
,obl_internalmptypeid
,obligortypeid
,sourceid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,orgstrucid
,accounting_subjectid
,principalamount
,interestamount
,replace(replace(t1.industrygroupid,chr(13),''),chr(10),'') as industrygroupid
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.grade_model_cd,chr(13),''),chr(10),'') as grade_model_cd
,remmaturity_bandid
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no
,replace(replace(t1.five_class_cd,chr(13),''),chr(10),'') as five_class_cd

from ${iol_schema}.rwas_rwas_ws_exp_map t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_rwas_ws_exp_map.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
