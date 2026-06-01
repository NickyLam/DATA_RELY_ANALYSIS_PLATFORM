: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hr_trnstype_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_hr_trnstype.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dr as dr
    ,t.enablestate as enablestate
    ,replace(replace(t.ishrss,chr(13),''),chr(10),'') as ishrss
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pk_trnstype,chr(13),''),chr(10),'') as pk_trnstype
    ,replace(replace(t.systypeflag,chr(13),''),chr(10),'') as systypeflag
    ,t.trnsevent as trnsevent
    ,replace(replace(t.trnstypecode,chr(13),''),chr(10),'') as trnstypecode
    ,replace(replace(t.trnstypename,chr(13),''),chr(10),'') as trnstypename
    ,replace(replace(t.trnstypename2,chr(13),''),chr(10),'') as trnstypename2
    ,replace(replace(t.trnstypename3,chr(13),''),chr(10),'') as trnstypename3
    ,replace(replace(t.trnstypename4,chr(13),''),chr(10),'') as trnstypename4
    ,replace(replace(t.trnstypename5,chr(13),''),chr(10),'') as trnstypename5
    ,replace(replace(t.trnstypename6,chr(13),''),chr(10),'') as trnstypename6
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_hr_trnstype t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hr_trnstype.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes