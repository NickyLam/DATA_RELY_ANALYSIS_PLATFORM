: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_org_intnal_org_addit_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/org_intnal_org_addit_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(org_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(bus_lics_num,chr(13),''),chr(10),'')
,replace(replace(work_start_tm,chr(13),''),chr(10),'')
,replace(replace(work_end_tm,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.org_intnal_org_addit_info t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/org_intnal_org_addit_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
