: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_org_dept_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_org_dept.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
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
,replace(replace(t1.deptcanceldate,chr(13),''),chr(10),'') as deptcanceldate
,depttype
,displayorder
,dr
,enablestate
,replace(replace(t1.hrcanceled,chr(13),''),chr(10),'') as hrcanceled
,replace(replace(t1.innercode,chr(13),''),chr(10),'') as innercode
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
,replace(replace(t1.pk_dept,chr(13),''),chr(10),'') as pk_dept
,replace(replace(t1.pk_fatherorg,chr(13),''),chr(10),'') as pk_fatherorg
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_vid,chr(13),''),chr(10),'') as pk_vid
,replace(replace(t1.principal,chr(13),''),chr(10),'') as principal
,replace(replace(t1.resposition,chr(13),''),chr(10),'') as resposition
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
,replace(replace(t1.chargeleader,chr(13),''),chr(10),'') as chargeleader
,replace(replace(t1.deptlevel,chr(13),''),chr(10),'') as deptlevel
,replace(replace(t1.orgtype13,chr(13),''),chr(10),'') as orgtype13
,replace(replace(t1.orgtype17,chr(13),''),chr(10),'') as orgtype17
,replace(replace(t1.deptduty,chr(13),''),chr(10),'') as deptduty
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_org_dept t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_org_dept.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
