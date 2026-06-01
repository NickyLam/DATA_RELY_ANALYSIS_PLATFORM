: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_csb_qjpz_f
CreateDate: 20260108
FileName:   ${iel_data_path}/pams_csb_qjpz.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.qjmc,chr(13),''),chr(10),'') as qjmc
,qjsx
,qsrq
,jsrq
,qjxx
,replace(replace(t1.qjz,chr(13),''),chr(10),'') as qjz
,replace(replace(t1.sxxms,chr(13),''),chr(10),'') as sxxms
,replace(replace(t1.qjms,chr(13),''),chr(10),'') as qjms

from ${iol_schema}.pams_csb_qjpz t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_csb_qjpz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
