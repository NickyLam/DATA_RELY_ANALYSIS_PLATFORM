: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_org_intnal_org_addit_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/org_intnal_org_addit_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.org_id as org_id
,t.lp_id as lp_id
,t.bus_lics_num as bus_lics_num
,t.work_start_tm as work_start_tm
,t.work_end_tm as work_end_tm
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
from ${idl_schema}.org_intnal_org_addit_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/org_intnal_org_addit_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes