: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_csb_dmms_f
CreateDate: 20260403
FileName:   ${iel_data_path}/pams_csb_dmms.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.dmmc,chr(13),''),chr(10),'') as dmmc
,replace(replace(t1.dmz,chr(13),''),chr(10),'') as dmz
,replace(replace(t1.dmms,chr(13),''),chr(10),'') as dmms
,replace(replace(t1.dmsm,chr(13),''),chr(10),'') as dmsm
,xh

from ${iol_schema}.pams_csb_dmms t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_csb_dmms.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
