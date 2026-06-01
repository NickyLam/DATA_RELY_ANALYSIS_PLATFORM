: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_chn_channel_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/chn_channel_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.chn_id as chn_id
,t.lp_id as lp_id
,t.chn_type_cd as chn_type_cd
,t.chn_name as chn_name
,t.chn_status_cd as chn_status_cd
,t.effect_dt as effect_dt
,t.invalid_dt as invalid_dt
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
from ${idl_schema}.chn_channel t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/chn_channel_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes