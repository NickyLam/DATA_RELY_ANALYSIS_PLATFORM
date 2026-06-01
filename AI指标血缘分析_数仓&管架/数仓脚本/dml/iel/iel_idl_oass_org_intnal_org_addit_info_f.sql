: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_org_intnal_org_addit_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_org_intnal_org_addit_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.bus_lics_num as bus_lics_num
,t1.work_start_tm as work_start_tm
,t1.work_end_tm as work_end_tm
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.org_id as org_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_org_intnal_org_addit_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_org_intnal_org_addit_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
