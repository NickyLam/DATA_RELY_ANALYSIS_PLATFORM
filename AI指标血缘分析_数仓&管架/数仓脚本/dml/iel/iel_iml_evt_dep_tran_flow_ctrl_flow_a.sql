: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_dep_tran_flow_ctrl_flow_a
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_dep_tran_flow_ctrl_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,chn_tran_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.core_tran_org_id,chr(13),''),chr(10),'') as core_tran_org_id
,replace(replace(t1.onl_bus_proc_status_cd,chr(13),''),chr(10),'') as onl_bus_proc_status_cd
,replace(replace(t1.intfc_serv_type_cd,chr(13),''),chr(10),'') as intfc_serv_type_cd
,replace(replace(t1.intfc_serv_id,chr(13),''),chr(10),'') as intfc_serv_id
,bus_tran_dt
,tran_tm

from ${iml_schema}.evt_dep_tran_flow_ctrl_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dep_tran_flow_ctrl_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
