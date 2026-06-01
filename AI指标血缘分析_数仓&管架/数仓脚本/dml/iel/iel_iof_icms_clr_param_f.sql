: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_clr_param_f
CreateDate: 20251010
FileName:   ${iel_data_path}/icms_clr_param.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.clrtypeid,chr(13),''),chr(10),'') as clrtypeid
,replace(replace(t1.clrtypename,chr(13),''),chr(10),'') as clrtypename
,replace(replace(t1.crmtype,chr(13),''),chr(10),'') as crmtype
,maxltv
,replace(replace(t1.maxltvscenario,chr(13),''),chr(10),'') as maxltvscenario
,replace(replace(t1.isallowedmort,chr(13),''),chr(10),'') as isallowedmort
,replace(replace(t1.isallowedpledge,chr(13),''),chr(10),'') as isallowedpledge
,replace(replace(t1.isallowedremort,chr(13),''),chr(10),'') as isallowedremort
,replace(replace(t1.isallowedremortinline,chr(13),''),chr(10),'') as isallowedremortinline
,replace(replace(t1.isacceptnfstrepay,chr(13),''),chr(10),'') as isacceptnfstrepay
,replace(replace(t1.registagencytype,chr(13),''),chr(10),'') as registagencytype
,replace(replace(t1.gntcerttype,chr(13),''),chr(10),'') as gntcerttype
,replace(replace(t1.atttemplate,chr(13),''),chr(10),'') as atttemplate
,replace(replace(t1.infotab,chr(13),''),chr(10),'') as infotab
,replace(replace(t1.iscurrmismatch,chr(13),''),chr(10),'') as iscurrmismatch
,replace(replace(t1.isneedinsurance,chr(13),''),chr(10),'') as isneedinsurance
,renewalterm
,replace(replace(t1.isneednotarizaiton,chr(13),''),chr(10),'') as isneednotarizaiton
,replace(replace(t1.isneedrgst,chr(13),''),chr(10),'') as isneedrgst
,replace(replace(t1.isneedmonitoring,chr(13),''),chr(10),'') as isneedmonitoring
,replace(replace(t1.monitoringfrq,chr(13),''),chr(10),'') as monitoringfrq
,maxguaterm
,replace(replace(t1.maxguascenario,chr(13),''),chr(10),'') as maxguascenario
,evalperiod
,replace(replace(t1.issuitineval,chr(13),''),chr(10),'') as issuitineval
,replace(replace(t1.issuitouteval,chr(13),''),chr(10),'') as issuitouteval
,replace(replace(t1.mainevalmethod,chr(13),''),chr(10),'') as mainevalmethod
,replace(replace(t1.detailevalmodel,chr(13),''),chr(10),'') as detailevalmodel
,replace(replace(t1.fastevalmodel,chr(13),''),chr(10),'') as fastevalmodel
,replace(replace(t1.evalflow,chr(13),''),chr(10),'') as evalflow
,replace(replace(t1.appraiseatt,chr(13),''),chr(10),'') as appraiseatt
,replace(replace(t1.reevalfrqunit,chr(13),''),chr(10),'') as reevalfrqunit
,reevalfrq
,replace(replace(t1.isautoreeval,chr(13),''),chr(10),'') as isautoreeval
,replace(replace(t1.autoreevalmode,chr(13),''),chr(10),'') as autoreevalmode
,replace(replace(t1.reevaldatedef,chr(13),''),chr(10),'') as reevaldatedef
,extweight
,inweight
,replace(replace(t1.isneedrightcert,chr(13),''),chr(10),'') as isneedrightcert
,replace(replace(t1.issuitcombineeval,chr(13),''),chr(10),'') as issuitcombineeval
,replace(replace(t1.ismanualbatchreval,chr(13),''),chr(10),'') as ismanualbatchreval
,replace(replace(t1.issysbatchreval,chr(13),''),chr(10),'') as issysbatchreval
,replace(replace(t1.evalmodelmarket,chr(13),''),chr(10),'') as evalmodelmarket
,replace(replace(t1.evalmodelprofit,chr(13),''),chr(10),'') as evalmodelprofit
,replace(replace(t1.evalmodelcost,chr(13),''),chr(10),'') as evalmodelcost
,replace(replace(t1.evalmodelquick,chr(13),''),chr(10),'') as evalmodelquick
,replace(replace(t1.ishavewarrant,chr(13),''),chr(10),'') as ishavewarrant
,replace(replace(t1.isneedin,chr(13),''),chr(10),'') as isneedin
,replace(replace(t1.isqualified,chr(13),''),chr(10),'') as isqualified
,replace(replace(t1.validcerttype,chr(13),''),chr(10),'') as validcerttype
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,inputdate
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,updatedate
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.entrycriteria,chr(13),''),chr(10),'') as entrycriteria
,replace(replace(t1.productlist,chr(13),''),chr(10),'') as productlist
,replace(replace(t1.clronlyscope,chr(13),''),chr(10),'') as clronlyscope
,replace(replace(t1.maincerttype,chr(13),''),chr(10),'') as maincerttype

from ${iol_schema}.icms_clr_param t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_clr_param.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
