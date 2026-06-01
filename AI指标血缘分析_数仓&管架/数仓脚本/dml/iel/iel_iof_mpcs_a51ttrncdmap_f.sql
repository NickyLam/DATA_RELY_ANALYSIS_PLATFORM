: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a51ttrncdmap_f
CreateDate: 20240530
FileName:   ${iel_data_path}/mpcs_a51ttrncdmap.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.msgtype,chr(13),''),chr(10),'') as msgtype
,replace(replace(t1.fld003,chr(13),''),chr(10),'') as fld003
,replace(replace(t1.fld025,chr(13),''),chr(10),'') as fld025
,replace(replace(t1.trncd,chr(13),''),chr(10),'') as trncd
,replace(replace(t1.cbstrncd,chr(13),''),chr(10),'') as cbstrncd
,replace(replace(t1.rsmsgtype,chr(13),''),chr(10),'') as rsmsgtype
,macfld090
,macfld102
,replace(replace(t1.trnname,chr(13),''),chr(10),'') as trnname
,replace(replace(t1.macfields,chr(13),''),chr(10),'') as macfields
,replace(replace(t1.rsmacfields,chr(13),''),chr(10),'') as rsmacfields
,replace(replace(t1.issndrsk,chr(13),''),chr(10),'') as issndrsk
,replace(replace(t1.isfallbk,chr(13),''),chr(10),'') as isfallbk
,replace(replace(t1.isstop,chr(13),''),chr(10),'') as isstop
,replace(replace(t1.memocd,chr(13),''),chr(10),'') as memocd
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.dealtype,chr(13),''),chr(10),'') as dealtype
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.transtp,chr(13),''),chr(10),'') as transtp

from ${iol_schema}.mpcs_a51ttrncdmap t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a51ttrncdmap.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
