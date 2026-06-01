: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_epc_org_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_epc_org_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.epc_org_id,chr(13),''),chr(10),'') as epc_org_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.epc_org_name,chr(13),''),chr(10),'') as epc_org_name
,t1.create_tm as create_tm
,replace(replace(t1.epc_org_abbr,chr(13),''),chr(10),'') as epc_org_abbr
,replace(replace(t1.custm_agt_type_name,chr(13),''),chr(10),'') as custm_agt_type_name
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_epc_org_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_epc_org_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes