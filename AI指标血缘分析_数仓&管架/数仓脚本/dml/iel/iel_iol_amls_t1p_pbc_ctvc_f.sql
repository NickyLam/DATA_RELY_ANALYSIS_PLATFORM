: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t1p_pbc_ctvc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t1p_pbc_ctvc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.ctvckey,chr(13),''),chr(10),'') as ctvckey
    ,replace(replace(t.ctvc_type_cd,chr(13),''),chr(10),'') as ctvc_type_cd
    ,replace(replace(t.ctvcdesc,chr(13),''),chr(10),'') as ctvcdesc
    ,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
    ,t.create_dt as create_dt
    ,replace(replace(t.ctvc_lvl,chr(13),''),chr(10),'') as ctvc_lvl
    ,replace(replace(t.upctvckey,chr(13),''),chr(10),'') as upctvckey
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amls_t1p_pbc_ctvc t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t1p_pbc_ctvc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes