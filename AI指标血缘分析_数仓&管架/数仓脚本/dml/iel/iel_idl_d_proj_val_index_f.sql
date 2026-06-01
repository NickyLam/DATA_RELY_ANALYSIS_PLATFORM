: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_d_proj_val_index_f
CreateDate: 20180529
FileName:   ${iel_data_path}/d_proj_val_index.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,proj_val_id
,proj_id
,proj_name
,proj_online_dt
,dep_name
,sys_short_name
,sys_name
,budg_amt
,xq_id
,index_type
,weht_ratio
,index_name
,index_unit
,tgt_val
,index_val
,stati_peri
from idl.d_proj_val_index
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/d_proj_val_index.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes