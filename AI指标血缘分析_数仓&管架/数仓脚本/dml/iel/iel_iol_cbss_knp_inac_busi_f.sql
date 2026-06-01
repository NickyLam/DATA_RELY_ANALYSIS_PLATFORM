: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_knp_inac_busi_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_knp_inac_busi.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.busino,chr(13),''),chr(10),'') as busino
,replace(replace(t.prodcd,chr(13),''),chr(10),'') as prodcd
,replace(replace(t.serial,chr(13),''),chr(10),'') as serial
,replace(replace(t.opacna,chr(13),''),chr(10),'') as opacna
,replace(replace(t.spectg,chr(13),''),chr(10),'') as spectg
,replace(replace(t.acnofm,chr(13),''),chr(10),'') as acnofm
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_knp_inac_busi t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_knp_inac_busi.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes