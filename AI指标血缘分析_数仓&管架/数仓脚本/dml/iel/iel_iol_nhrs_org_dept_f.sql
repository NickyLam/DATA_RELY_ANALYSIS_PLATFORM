: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_org_dept_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_org_dept.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.address,chr(13),''),chr(10),'') as address
    ,replace(replace(t.code,chr(13),''),chr(10),'') as code
    ,replace(replace(t.createdate,chr(13),''),chr(10),'') as createdate
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dataoriginflag as dataoriginflag
    ,replace(replace(t.def1,chr(13),''),chr(10),'') as def1
    ,replace(replace(t.def10,chr(13),''),chr(10),'') as def10
    ,replace(replace(t.def11,chr(13),''),chr(10),'') as def11
    ,replace(replace(t.def12,chr(13),''),chr(10),'') as def12
    ,replace(replace(t.def13,chr(13),''),chr(10),'') as def13
    ,replace(replace(t.def14,chr(13),''),chr(10),'') as def14
    ,replace(replace(t.def15,chr(13),''),chr(10),'') as def15
    ,replace(replace(t.def16,chr(13),''),chr(10),'') as def16
    ,replace(replace(t.def17,chr(13),''),chr(10),'') as def17
    ,replace(replace(t.def18,chr(13),''),chr(10),'') as def18
    ,replace(replace(t.def19,chr(13),''),chr(10),'') as def19
    ,replace(replace(t.def2,chr(13),''),chr(10),'') as def2
    ,replace(replace(t.def20,chr(13),''),chr(10),'') as def20
    ,replace(replace(t.def3,chr(13),''),chr(10),'') as def3
    ,replace(replace(t.def4,chr(13),''),chr(10),'') as def4
    ,replace(replace(t.def5,chr(13),''),chr(10),'') as def5
    ,replace(replace(t.def6,chr(13),''),chr(10),'') as def6
    ,replace(replace(t.def7,chr(13),''),chr(10),'') as def7
    ,replace(replace(t.def8,chr(13),''),chr(10),'') as def8
    ,replace(replace(t.def9,chr(13),''),chr(10),'') as def9
    ,replace(replace(t.deptcanceldate,chr(13),''),chr(10),'') as deptcanceldate
    ,replace(replace(t.deptlevel,chr(13),''),chr(10),'') as deptlevel
    ,t.depttype as depttype
    ,t.displayorder as displayorder
    ,t.dr as dr
    ,t.enablestate as enablestate
    ,replace(replace(t.hrcanceled,chr(13),''),chr(10),'') as hrcanceled
    ,replace(replace(t.innercode,chr(13),''),chr(10),'') as innercode
    ,replace(replace(t.islastversion,chr(13),''),chr(10),'') as islastversion
    ,replace(replace(t.isretail,chr(13),''),chr(10),'') as isretail
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
    ,replace(replace(t.mnecode,chr(13),''),chr(10),'') as mnecode
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.name2,chr(13),''),chr(10),'') as name2
    ,replace(replace(t.name3,chr(13),''),chr(10),'') as name3
    ,replace(replace(t.name4,chr(13),''),chr(10),'') as name4
    ,replace(replace(t.name5,chr(13),''),chr(10),'') as name5
    ,replace(replace(t.name6,chr(13),''),chr(10),'') as name6
    ,replace(replace(t.orgtype13,chr(13),''),chr(10),'') as orgtype13
    ,replace(replace(t.orgtype17,chr(13),''),chr(10),'') as orgtype17
    ,replace(replace(t.pk_dept,chr(13),''),chr(10),'') as pk_dept
    ,replace(replace(t.pk_fatherorg,chr(13),''),chr(10),'') as pk_fatherorg
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pk_vid,chr(13),''),chr(10),'') as pk_vid
    ,replace(replace(t.principal,chr(13),''),chr(10),'') as principal
    ,replace(replace(t.resposition,chr(13),''),chr(10),'') as resposition
    ,replace(replace(t.shortname,chr(13),''),chr(10),'') as shortname
    ,replace(replace(t.shortname2,chr(13),''),chr(10),'') as shortname2
    ,replace(replace(t.shortname3,chr(13),''),chr(10),'') as shortname3
    ,replace(replace(t.shortname4,chr(13),''),chr(10),'') as shortname4
    ,replace(replace(t.shortname5,chr(13),''),chr(10),'') as shortname5
    ,replace(replace(t.shortname6,chr(13),''),chr(10),'') as shortname6
    ,replace(replace(t.tel,chr(13),''),chr(10),'') as tel
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,replace(replace(t.venddate,chr(13),''),chr(10),'') as venddate
    ,replace(replace(t.vname,chr(13),''),chr(10),'') as vname
    ,replace(replace(t.vname2,chr(13),''),chr(10),'') as vname2
    ,replace(replace(t.vname3,chr(13),''),chr(10),'') as vname3
    ,replace(replace(t.vname4,chr(13),''),chr(10),'') as vname4
    ,replace(replace(t.vname5,chr(13),''),chr(10),'') as vname5
    ,replace(replace(t.vname6,chr(13),''),chr(10),'') as vname6
    ,replace(replace(t.vno,chr(13),''),chr(10),'') as vno
    ,replace(replace(t.vstartdate,chr(13),''),chr(10),'') as vstartdate
    ,replace(replace(t.deptduty,chr(13),''),chr(10),'') as deptduty
    ,replace(replace(t.glbdef1,chr(13),''),chr(10),'') as glbdef1
    ,replace(replace(t.glbdef2,chr(13),''),chr(10),'') as glbdef2
    ,replace(replace(t.glbdef3,chr(13),''),chr(10),'') as glbdef3
    ,replace(replace(t.glbdef4,chr(13),''),chr(10),'') as glbdef4
    ,replace(replace(t.glbdef5,chr(13),''),chr(10),'') as glbdef5
    ,replace(replace(t.glbdef6,chr(13),''),chr(10),'') as glbdef6
    ,t.glbdef7 as glbdef7
    ,t.glbdef8 as glbdef8
    ,replace(replace(t.glbdef9,chr(13),''),chr(10),'') as glbdef9
    ,replace(replace(t.glbdef10,chr(13),''),chr(10),'') as glbdef10
    ,replace(replace(t.glbdef11,chr(13),''),chr(10),'') as glbdef11
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_org_dept t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_org_dept.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes