: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_ind_economic_f
CreateDate: 20240101
FileName:   ${iel_data_path}/icms_ind_economic.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.licname,chr(13),''),chr(10),'') as licname
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.confirmcompsize,chr(13),''),chr(10),'') as confirmcompsize
,replace(replace(t1.taxtype,chr(13),''),chr(10),'') as taxtype
,replace(replace(t1.taxorganname,chr(13),''),chr(10),'') as taxorganname
,replace(replace(t1.relation,chr(13),''),chr(10),'') as relation
,replace(replace(t1.accountingsystem,chr(13),''),chr(10),'') as accountingsystem
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.taxlevel,chr(13),''),chr(10),'') as taxlevel
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.legalcertcode,chr(13),''),chr(10),'') as legalcertcode
,replace(replace(t1.comptel,chr(13),''),chr(10),'') as comptel
,replace(replace(t1.landtaxcode,chr(13),''),chr(10),'') as landtaxcode
,replace(replace(t1.shareratio,chr(13),''),chr(10),'') as shareratio
,replace(replace(t1.businessname,chr(13),''),chr(10),'') as businessname
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.legalcert,chr(13),''),chr(10),'') as legalcert
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,workersnum
,replace(replace(t1.regaddres,chr(13),''),chr(10),'') as regaddres
,realcapital
,replace(replace(t1.lictype,chr(13),''),chr(10),'') as lictype
,replace(replace(t1.citnum,chr(13),''),chr(10),'') as citnum
,replace(replace(t1.bussowner,chr(13),''),chr(10),'') as bussowner
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,bussenddate
,replace(replace(t1.busstime,chr(13),''),chr(10),'') as busstime
,replace(replace(t1.bussname,chr(13),''),chr(10),'') as bussname
,replace(replace(t1.taxpayerstate,chr(13),''),chr(10),'') as taxpayerstate
,replace(replace(t1.relrepyidtype,chr(13),''),chr(10),'') as relrepyidtype
,bussregdate
,replace(replace(t1.formtype,chr(13),''),chr(10),'') as formtype
,replace(replace(t1.compzip,chr(13),''),chr(10),'') as compzip
,replace(replace(t1.relrepyrsplpsntype,chr(13),''),chr(10),'') as relrepyrsplpsntype
,replace(replace(t1.compsize,chr(13),''),chr(10),'') as compsize
,replace(replace(t1.bussmain,chr(13),''),chr(10),'') as bussmain
,inputdate
,replace(replace(t1.comestatus,chr(13),''),chr(10),'') as comestatus
,replace(replace(t1.busilicname,chr(13),''),chr(10),'') as busilicname
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t1.legalname,chr(13),''),chr(10),'') as legalname
,replace(replace(t1.taxorgancode,chr(13),''),chr(10),'') as taxorgancode
,replace(replace(t1.regdist,chr(13),''),chr(10),'') as regdist
,replace(replace(t1.busscode,chr(13),''),chr(10),'') as busscode
,replace(replace(t1.ownerprop,chr(13),''),chr(10),'') as ownerprop
,replace(replace(t1.industryname,chr(13),''),chr(10),'') as industryname
,replace(replace(t1.compaddr,chr(13),''),chr(10),'') as compaddr
,totalassets
,replace(replace(t1.loanpassword,chr(13),''),chr(10),'') as loanpassword
,replace(replace(t1.accountingsystemname,chr(13),''),chr(10),'') as accountingsystemname
,operreve
,updatedate
,replace(replace(t1.businessid,chr(13),''),chr(10),'') as businessid
,replace(replace(t1.bussbank,chr(13),''),chr(10),'') as bussbank
,replace(replace(t1.busilictype,chr(13),''),chr(10),'') as busilictype
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.loancode,chr(13),''),chr(10),'') as loancode
,replace(replace(t1.relrepyid,chr(13),''),chr(10),'') as relrepyid
,establishdate
,replace(replace(t1.legalphone,chr(13),''),chr(10),'') as legalphone
,replace(replace(t1.legalemail,chr(13),''),chr(10),'') as legalemail
,regcapital
,replace(replace(t1.certcode,chr(13),''),chr(10),'') as certcode
,replace(replace(t1.relrepyidentype,chr(13),''),chr(10),'') as relrepyidentype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.busslegaltype,chr(13),''),chr(10),'') as busslegaltype
,bussrentend
,replace(replace(t1.nationaltaxcode,chr(13),''),chr(10),'') as nationaltaxcode
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.industrytype,chr(13),''),chr(10),'') as industrytype
,replace(replace(t1.isoperatingentinvolvespecialized,chr(13),''),chr(10),'') as isoperatingentinvolvespecialized
,replace(replace(t1.ishightechnologyent,chr(13),''),chr(10),'') as ishightechnologyent
,replace(replace(t1.istechnologyent,chr(13),''),chr(10),'') as istechnologyent
,replace(replace(t1.isscientifictechent,chr(13),''),chr(10),'') as isscientifictechent
,replace(replace(t1.isspecializedgiantent,chr(13),''),chr(10),'') as isspecializedgiantent
,replace(replace(t1.isspecializedsmallandmident,chr(13),''),chr(10),'') as isspecializedsmallandmident
,replace(replace(t1.istechnologysmallandmident,chr(13),''),chr(10),'') as istechnologysmallandmident
,replace(replace(t1.isindustrysinglechampionent,chr(13),''),chr(10),'') as isindustrysinglechampionent
,replace(replace(t1.isnationaltechnologinnovationent,chr(13),''),chr(10),'') as isnationaltechnologinnovationent

from ${iol_schema}.icms_ind_economic t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_ind_economic.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
