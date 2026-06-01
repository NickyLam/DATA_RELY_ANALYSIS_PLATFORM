: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_bd_defdoclist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_bd_defdoclist.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.associatename,chr(13),''),chr(10),'') as associatename
    ,replace(replace(t.bpfcomponentid,chr(13),''),chr(10),'') as bpfcomponentid
    ,replace(replace(t.code,chr(13),''),chr(10),'') as code
    ,t.codectlgrade as codectlgrade
    ,replace(replace(t.coderule,chr(13),''),chr(10),'') as coderule
    ,replace(replace(t.componentid,chr(13),''),chr(10),'') as componentid
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dataoriginflag as dataoriginflag
    ,replace(replace(t.docclass,chr(13),''),chr(10),'') as docclass
    ,t.doclevel as doclevel
    ,t.doctype as doctype
    ,t.dr as dr
    ,replace(replace(t.funcode,chr(13),''),chr(10),'') as funcode
    ,replace(replace(t.isgrade,chr(13),''),chr(10),'') as isgrade
    ,replace(replace(t.isrelease,chr(13),''),chr(10),'') as isrelease
    ,t.mngctlmode as mngctlmode
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.name2,chr(13),''),chr(10),'') as name2
    ,replace(replace(t.name3,chr(13),''),chr(10),'') as name3
    ,replace(replace(t.name4,chr(13),''),chr(10),'') as name4
    ,replace(replace(t.name5,chr(13),''),chr(10),'') as name5
    ,replace(replace(t.name6,chr(13),''),chr(10),'') as name6
    ,replace(replace(t.pk_defdoclist,chr(13),''),chr(10),'') as pk_defdoclist
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_bd_defdoclist t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_bd_defdoclist.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes