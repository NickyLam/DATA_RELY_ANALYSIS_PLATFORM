: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_group_info_f
CreateDate: 20241113
FileName:   ${iel_data_path}/icms_group_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.groupid,chr(13),''),chr(10),'') as groupid
,replace(replace(t1.businessscope,chr(13),''),chr(10),'') as businessscope
,replace(replace(t1.mgtorgid,chr(13),''),chr(10),'') as mgtorgid
,replace(replace(t1.currentversionseq,chr(13),''),chr(10),'') as currentversionseq
,replace(replace(t1.countrycode,chr(13),''),chr(10),'') as countrycode
,firstloandate
,groupmembercount
,replace(replace(t1.registerregioncode,chr(13),''),chr(10),'') as registerregioncode
,replace(replace(t1.creditlevel,chr(13),''),chr(10),'') as creditlevel
,replace(replace(t1.groupcredittype,chr(13),''),chr(10),'') as groupcredittype
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.newregioncode,chr(13),''),chr(10),'') as newregioncode
,industrytypeproportion
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,officeaddupdatedate
,replace(replace(t1.isretiveeconmics,chr(13),''),chr(10),'') as isretiveeconmics
,replace(replace(t1.groupname,chr(13),''),chr(10),'') as groupname
,replace(replace(t1.familymapstatus,chr(13),''),chr(10),'') as familymapstatus
,replace(replace(t1.approveorgid,chr(13),''),chr(10),'') as approveorgid
,replace(replace(t1.isrelatedparty,chr(13),''),chr(10),'') as isrelatedparty
,replace(replace(t1.parentcompanyofficeadd,chr(13),''),chr(10),'') as parentcompanyofficeadd
,industrytypeproportion2
,replace(replace(t1.corpidetitytype,chr(13),''),chr(10),'') as corpidetitytype
,replace(replace(t1.refversionseq,chr(13),''),chr(10),'') as refversionseq
,replace(replace(t1.oldfinancefocus,chr(13),''),chr(10),'') as oldfinancefocus
,replace(replace(t1.oldheadofficemanage,chr(13),''),chr(10),'') as oldheadofficemanage
,replace(replace(t1.industrytype,chr(13),''),chr(10),'') as industrytype
,replace(replace(t1.subjectbusiness,chr(13),''),chr(10),'') as subjectbusiness
,replace(replace(t1.groupstatus,chr(13),''),chr(10),'') as groupstatus
,replace(replace(t1.groupabbname,chr(13),''),chr(10),'') as groupabbname
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,updatedate
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.groupcustomertype,chr(13),''),chr(10),'') as groupcustomertype
,replace(replace(t1.oldgroupcredittype,chr(13),''),chr(10),'') as oldgroupcredittype
,industrytypeproportion1
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.mgtuserid,chr(13),''),chr(10),'') as mgtuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.oldgroupabbname,chr(13),''),chr(10),'') as oldgroupabbname
,replace(replace(t1.isrelativetrade,chr(13),''),chr(10),'') as isrelativetrade
,actualcontrollercounts
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.industrytype1,chr(13),''),chr(10),'') as industrytype1
,replace(replace(t1.industrytype2,chr(13),''),chr(10),'') as industrytype2
,inputdate
,replace(replace(t1.financialgroupscope,chr(13),''),chr(10),'') as financialgroupscope
,replace(replace(t1.financialgroupposition,chr(13),''),chr(10),'') as financialgroupposition
,replace(replace(t1.grouptype,chr(13),''),chr(10),'') as grouptype
,approvedate
,replace(replace(t1.oldgroupname,chr(13),''),chr(10),'') as oldgroupname
,replace(replace(t1.headofficemanage,chr(13),''),chr(10),'') as headofficemanage
,replace(replace(t1.approveuserid,chr(13),''),chr(10),'') as approveuserid
,investmencounts
,replace(replace(t1.keymembercustomerid,chr(13),''),chr(10),'') as keymembercustomerid
,replace(replace(t1.financefocus,chr(13),''),chr(10),'') as financefocus
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue
,replace(replace(t1.actualcontroller,chr(13),''),chr(10),'') as actualcontroller
,replace(replace(t1.groupstatusone,chr(13),''),chr(10),'') as groupstatusone

from ${iol_schema}.icms_group_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_group_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
