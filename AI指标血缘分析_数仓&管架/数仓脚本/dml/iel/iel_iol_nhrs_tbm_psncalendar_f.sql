: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_tbm_psncalendar_f
CreateDate: 20240205
FileName:   ${iel_data_path}/nhrs_tbm_psncalendar.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.awaydatacostatus,chr(13),''),chr(10),'') as awaydatacostatus
,replace(replace(t1.calendar,chr(13),''),chr(10),'') as calendar
,replace(replace(t1.cancelflag,chr(13),''),chr(10),'') as cancelflag
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.datacreatestatus,chr(13),''),chr(10),'') as datacreatestatus
,replace(replace(t1.dataimportstatus,chr(13),''),chr(10),'') as dataimportstatus
,dr
,gzsj
,replace(replace(t1.if_rest,chr(13),''),chr(10),'') as if_rest
,replace(replace(t1.isflexiblefinal,chr(13),''),chr(10),'') as isflexiblefinal
,replace(replace(t1.isfromteam,chr(13),''),chr(10),'') as isfromteam
,replace(replace(t1.issolidifywhencalculation,chr(13),''),chr(10),'') as issolidifywhencalculation
,replace(replace(t1.iswtrecreate,chr(13),''),chr(10),'') as iswtrecreate
,replace(replace(t1.kqdatacostatus,chr(13),''),chr(10),'') as kqdatacostatus
,replace(replace(t1.leavedatacostatus,chr(13),''),chr(10),'') as leavedatacostatus
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.original_shift_b4cut,chr(13),''),chr(10),'') as original_shift_b4cut
,replace(replace(t1.original_shift_b4exg,chr(13),''),chr(10),'') as original_shift_b4exg
,replace(replace(t1.overtimedatacostatus,chr(13),''),chr(10),'') as overtimedatacostatus
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psncalendar,chr(13),''),chr(10),'') as pk_psncalendar
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_shift,chr(13),''),chr(10),'') as pk_shift
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts

from ${iol_schema}.nhrs_tbm_psncalendar t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_tbm_psncalendar.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
