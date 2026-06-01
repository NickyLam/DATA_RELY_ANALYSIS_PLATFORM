: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_ind_economic_f
CreateDate: 20250619
FileName:   ${iel_data_path}/icms_ind_economic.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.serialno as serialno
,t1.licname as licname
,t1.certtype as certtype
,t1.migtflag as migtflag
,t1.confirmcompsize as confirmcompsize
,t1.taxtype as taxtype
,t1.taxorganname as taxorganname
,t1.relation as relation
,t1.accountingsystem as accountingsystem
,t1.customername as customername
,t1.taxlevel as taxlevel
,t1.customerid as customerid
,t1.legalcertcode as legalcertcode
,t1.comptel as comptel
,t1.landtaxcode as landtaxcode
,t1.shareratio as shareratio
,t1.businessname as businessname
,t1.inputuserid as inputuserid
,t1.legalcert as legalcert
,t1.updateuserid as updateuserid
,t1.workersnum as workersnum
,t1.regaddres as regaddres
,t1.realcapital as realcapital
,t1.lictype as lictype
,t1.citnum as citnum
,t1.bussowner as bussowner
,t1.telephone as telephone
,t1.bussenddate as bussenddate
,t1.busstime as busstime
,t1.bussname as bussname
,t1.taxpayerstate as taxpayerstate
,t1.relrepyidtype as relrepyidtype
,t1.bussregdate as bussregdate
,t1.formtype as formtype
,t1.compzip as compzip
,t1.relrepyrsplpsntype as relrepyrsplpsntype
,t1.compsize as compsize
,t1.bussmain as bussmain
,t1.inputdate as inputdate
,t1.comestatus as comestatus
,t1.busilicname as busilicname
,t1.industry as industry
,t1.legalname as legalname
,t1.taxorgancode as taxorgancode
,t1.regdist as regdist
,t1.busscode as busscode
,t1.ownerprop as ownerprop
,t1.industryname as industryname
,t1.compaddr as compaddr
,t1.totalassets as totalassets
,t1.loanpassword as loanpassword
,t1.accountingsystemname as accountingsystemname
,t1.operreve as operreve
,t1.updatedate as updatedate
,t1.businessid as businessid
,t1.bussbank as bussbank
,t1.busilictype as busilictype
,t1.corporgid as corporgid
,t1.loancode as loancode
,t1.relrepyid as relrepyid
,t1.establishdate as establishdate
,t1.legalphone as legalphone
,t1.legalemail as legalemail
,t1.regcapital as regcapital
,t1.certcode as certcode
,t1.relrepyidentype as relrepyidentype
,t1.certid as certid
,t1.busslegaltype as busslegaltype
,t1.bussrentend as bussrentend
,t1.nationaltaxcode as nationaltaxcode
,t1.updateorgid as updateorgid
,t1.inputorgid as inputorgid
,t1.industrytype as industrytype
,t1.isoperatingentinvolvespecialized as isoperatingentinvolvespecialized
,t1.ishightechnologyent as ishightechnologyent
,t1.istechnologyent as istechnologyent
,t1.isscientifictechent as isscientifictechent
,t1.isspecializedgiantent as isspecializedgiantent
,t1.isspecializedsmallandmident as isspecializedsmallandmident
,t1.istechnologysmallandmident as istechnologysmallandmident
,t1.isindustrysinglechampionent as isindustrysinglechampionent
,t1.isnationaltechnologinnovationent as isnationaltechnologinnovationent
,t1.isgarden as isgarden
,t1.regno as regno
,t1.offareacode as offareacode
,t1.province as province
,t1.regcapcur as regcapcur
,t1.runstatus as runstatus
,t1.canceldate as canceldate
,t1.revokedate as revokedate
,t1.address as address
,t1.busiscope2 as busiscope2
,t1.chkyear as chkyear
,t1.cocode as cocode
,t1.coname as coname
,t1.creditcode as creditcode
,t1.city as city
,t1.economicid as economicid

from ${idl_schema}.icms_ind_economic t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_ind_economic.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
