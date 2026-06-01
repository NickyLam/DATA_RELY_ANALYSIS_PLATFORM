: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_spv_cust_info_f
CreateDate: 20220719
FileName:   ${iel_data_path}/pty_spv_cust_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.spv_cust_id,chr(13),''),chr(10),'') as spv_cust_id
    ,replace(replace(t.spv_name,chr(13),''),chr(10),'') as spv_name
    ,replace(replace(t.spv_type_cd,chr(13),''),chr(10),'') as spv_type_cd
    ,replace(replace(t.am_prod_stat_type_id,chr(13),''),chr(10),'') as am_prod_stat_type_id
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.pty_spv_cust_info t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_spv_cust_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes