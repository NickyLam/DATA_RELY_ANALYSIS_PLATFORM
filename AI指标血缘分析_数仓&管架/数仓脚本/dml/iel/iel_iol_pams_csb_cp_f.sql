: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_csb_cp_f
CreateDate: 20260403
FileName:   ${iel_data_path}/pams_csb_cp.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,replace(replace(t1.cpyjfl,chr(13),''),chr(10),'') as cpyjfl
,replace(replace(t1.cpejfl,chr(13),''),chr(10),'') as cpejfl
,replace(replace(t1.cpsjfl,chr(13),''),chr(10),'') as cpsjfl
,replace(replace(t1.cpsijfl,chr(13),''),chr(10),'') as cpsijfl
,replace(replace(t1.cpzt,chr(13),''),chr(10),'') as cpzt

from ${iol_schema}.pams_csb_cp t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_csb_cp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
