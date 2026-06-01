: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_knc_acid_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_knc_acid.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.datatp,chr(13),''),chr(10),'') as datatp
,replace(replace(t.datavl,chr(13),''),chr(10),'') as datavl
,replace(replace(t.datast,chr(13),''),chr(10),'') as datast
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_knc_acid t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_knc_acid.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes