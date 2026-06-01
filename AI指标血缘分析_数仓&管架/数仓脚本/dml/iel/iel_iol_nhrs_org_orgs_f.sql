: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_org_orgs_f
CreateDate: 20251222
FileName:   ${iel_data_path}/nhrs_org_orgs.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.countryzone,chr(13),''),chr(10),'') as countryzone
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dataoriginflag
,replace(replace(t1.def1,chr(13),''),chr(10),'') as def1
,replace(replace(t1.def10,chr(13),''),chr(10),'') as def10
,replace(replace(t1.def11,chr(13),''),chr(10),'') as def11
,replace(replace(t1.def12,chr(13),''),chr(10),'') as def12
,replace(replace(t1.def13,chr(13),''),chr(10),'') as def13
,replace(replace(t1.def14,chr(13),''),chr(10),'') as def14
,replace(replace(t1.def15,chr(13),''),chr(10),'') as def15
,replace(replace(t1.def16,chr(13),''),chr(10),'') as def16
,replace(replace(t1.def17,chr(13),''),chr(10),'') as def17
,replace(replace(t1.def18,chr(13),''),chr(10),'') as def18
,replace(replace(t1.def19,chr(13),''),chr(10),'') as def19
,replace(replace(t1.def2,chr(13),''),chr(10),'') as def2
,replace(replace(t1.def20,chr(13),''),chr(10),'') as def20
,replace(replace(t1.def3,chr(13),''),chr(10),'') as def3
,replace(replace(t1.def4,chr(13),''),chr(10),'') as def4
,replace(replace(t1.def5,chr(13),''),chr(10),'') as def5
,replace(replace(t1.def6,chr(13),''),chr(10),'') as def6
,replace(replace(t1.def7,chr(13),''),chr(10),'') as def7
,replace(replace(t1.def8,chr(13),''),chr(10),'') as def8
,replace(replace(t1.def9,chr(13),''),chr(10),'') as def9
,dr
,enablestate
,replace(replace(t1.entitytype,chr(13),''),chr(10),'') as entitytype
,replace(replace(t1.innercode,chr(13),''),chr(10),'') as innercode
,replace(replace(t1.isbusinessunit,chr(13),''),chr(10),'') as isbusinessunit
,replace(replace(t1.islastversion,chr(13),''),chr(10),'') as islastversion
,replace(replace(t1.isretail,chr(13),''),chr(10),'') as isretail
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.mnecode,chr(13),''),chr(10),'') as mnecode
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.name2,chr(13),''),chr(10),'') as name2
,replace(replace(t1.name3,chr(13),''),chr(10),'') as name3
,replace(replace(t1.name4,chr(13),''),chr(10),'') as name4
,replace(replace(t1.name5,chr(13),''),chr(10),'') as name5
,replace(replace(t1.name6,chr(13),''),chr(10),'') as name6
,replace(replace(t1.ncindustry,chr(13),''),chr(10),'') as ncindustry
,replace(replace(t1.organizationcode,chr(13),''),chr(10),'') as organizationcode
,replace(replace(t1.orgtype1,chr(13),''),chr(10),'') as orgtype1
,replace(replace(t1.orgtype10,chr(13),''),chr(10),'') as orgtype10
,replace(replace(t1.orgtype11,chr(13),''),chr(10),'') as orgtype11
,replace(replace(t1.orgtype12,chr(13),''),chr(10),'') as orgtype12
,replace(replace(t1.orgtype13,chr(13),''),chr(10),'') as orgtype13
,replace(replace(t1.orgtype14,chr(13),''),chr(10),'') as orgtype14
,replace(replace(t1.orgtype15,chr(13),''),chr(10),'') as orgtype15
,replace(replace(t1.orgtype16,chr(13),''),chr(10),'') as orgtype16
,replace(replace(t1.orgtype17,chr(13),''),chr(10),'') as orgtype17
,replace(replace(t1.orgtype18,chr(13),''),chr(10),'') as orgtype18
,replace(replace(t1.orgtype19,chr(13),''),chr(10),'') as orgtype19
,replace(replace(t1.orgtype2,chr(13),''),chr(10),'') as orgtype2
,replace(replace(t1.orgtype20,chr(13),''),chr(10),'') as orgtype20
,replace(replace(t1.orgtype21,chr(13),''),chr(10),'') as orgtype21
,replace(replace(t1.orgtype22,chr(13),''),chr(10),'') as orgtype22
,replace(replace(t1.orgtype23,chr(13),''),chr(10),'') as orgtype23
,replace(replace(t1.orgtype24,chr(13),''),chr(10),'') as orgtype24
,replace(replace(t1.orgtype25,chr(13),''),chr(10),'') as orgtype25
,replace(replace(t1.orgtype26,chr(13),''),chr(10),'') as orgtype26
,replace(replace(t1.orgtype27,chr(13),''),chr(10),'') as orgtype27
,replace(replace(t1.orgtype28,chr(13),''),chr(10),'') as orgtype28
,replace(replace(t1.orgtype29,chr(13),''),chr(10),'') as orgtype29
,replace(replace(t1.orgtype3,chr(13),''),chr(10),'') as orgtype3
,replace(replace(t1.orgtype30,chr(13),''),chr(10),'') as orgtype30
,replace(replace(t1.orgtype31,chr(13),''),chr(10),'') as orgtype31
,replace(replace(t1.orgtype32,chr(13),''),chr(10),'') as orgtype32
,replace(replace(t1.orgtype33,chr(13),''),chr(10),'') as orgtype33
,replace(replace(t1.orgtype34,chr(13),''),chr(10),'') as orgtype34
,replace(replace(t1.orgtype35,chr(13),''),chr(10),'') as orgtype35
,replace(replace(t1.orgtype36,chr(13),''),chr(10),'') as orgtype36
,replace(replace(t1.orgtype37,chr(13),''),chr(10),'') as orgtype37
,replace(replace(t1.orgtype38,chr(13),''),chr(10),'') as orgtype38
,replace(replace(t1.orgtype39,chr(13),''),chr(10),'') as orgtype39
,replace(replace(t1.orgtype4,chr(13),''),chr(10),'') as orgtype4
,replace(replace(t1.orgtype40,chr(13),''),chr(10),'') as orgtype40
,replace(replace(t1.orgtype5,chr(13),''),chr(10),'') as orgtype5
,replace(replace(t1.orgtype6,chr(13),''),chr(10),'') as orgtype6
,replace(replace(t1.orgtype7,chr(13),''),chr(10),'') as orgtype7
,replace(replace(t1.orgtype8,chr(13),''),chr(10),'') as orgtype8
,replace(replace(t1.orgtype9,chr(13),''),chr(10),'') as orgtype9
,replace(replace(t1.pk_accperiodscheme,chr(13),''),chr(10),'') as pk_accperiodscheme
,replace(replace(t1.pk_controlarea,chr(13),''),chr(10),'') as pk_controlarea
,replace(replace(t1.pk_corp,chr(13),''),chr(10),'') as pk_corp
,replace(replace(t1.pk_currtype,chr(13),''),chr(10),'') as pk_currtype
,replace(replace(t1.pk_exratescheme,chr(13),''),chr(10),'') as pk_exratescheme
,replace(replace(t1.pk_fatherorg,chr(13),''),chr(10),'') as pk_fatherorg
,replace(replace(t1.pk_format,chr(13),''),chr(10),'') as pk_format
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_timezone,chr(13),''),chr(10),'') as pk_timezone
,replace(replace(t1.pk_vid,chr(13),''),chr(10),'') as pk_vid
,replace(replace(t1.principal,chr(13),''),chr(10),'') as principal
,replace(replace(t1.reportconfirm,chr(13),''),chr(10),'') as reportconfirm
,replace(replace(t1.shortname,chr(13),''),chr(10),'') as shortname
,replace(replace(t1.shortname2,chr(13),''),chr(10),'') as shortname2
,replace(replace(t1.shortname3,chr(13),''),chr(10),'') as shortname3
,replace(replace(t1.shortname4,chr(13),''),chr(10),'') as shortname4
,replace(replace(t1.shortname5,chr(13),''),chr(10),'') as shortname5
,replace(replace(t1.shortname6,chr(13),''),chr(10),'') as shortname6
,replace(replace(t1.tel,chr(13),''),chr(10),'') as tel
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.venddate,chr(13),''),chr(10),'') as venddate
,replace(replace(t1.vname,chr(13),''),chr(10),'') as vname
,replace(replace(t1.vname2,chr(13),''),chr(10),'') as vname2
,replace(replace(t1.vname3,chr(13),''),chr(10),'') as vname3
,replace(replace(t1.vname4,chr(13),''),chr(10),'') as vname4
,replace(replace(t1.vname5,chr(13),''),chr(10),'') as vname5
,replace(replace(t1.vname6,chr(13),''),chr(10),'') as vname6
,replace(replace(t1.vno,chr(13),''),chr(10),'') as vno
,replace(replace(t1.vstartdate,chr(13),''),chr(10),'') as vstartdate
,replace(replace(t1.workcalendar,chr(13),''),chr(10),'') as workcalendar
,replace(replace(t1.orgtype60,chr(13),''),chr(10),'') as orgtype60
,replace(replace(t1.virtual,chr(13),''),chr(10),'') as virtual
,replace(replace(t1.glbdef1,chr(13),''),chr(10),'') as glbdef1
,replace(replace(t1.glbdef2,chr(13),''),chr(10),'') as glbdef2

from ${iol_schema}.nhrs_org_orgs t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_org_orgs.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
