: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khdx_jgcy_f
CreateDate: 20260330
FileName:   ${iel_data_path}/pams_khdx_jgcy.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,khdxdh
,qsrq
,jsrq
,jgkhdxdh
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.pams_khdx_jgcy t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khdx_jgcy.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
