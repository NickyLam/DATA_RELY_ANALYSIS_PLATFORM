: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_supv_acct_req_flow_i
CreateDate: 20230927
FileName:   ${iel_data_path}/evt_supv_acct_req_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,midgrod_tran_dt
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,tran_cnt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.supv_acct_id,chr(13),''),chr(10),'') as supv_acct_id
,replace(replace(t1.bus_msg_id,chr(13),''),chr(10),'') as bus_msg_id
,replace(replace(t1.intfc_name,chr(13),''),chr(10),'') as intfc_name
,proc_tm
,replace(replace(t1.rest_cd,chr(13),''),chr(10),'') as rest_cd
,que_start_tm
,que_end_tm
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info_desc,chr(13),''),chr(10),'') as return_info_desc
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.proc_org_id,chr(13),''),chr(10),'') as proc_org_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.prpery_flow_num,chr(13),''),chr(10),'') as prpery_flow_num
,replace(replace(t1.sys_in_flow_num,chr(13),''),chr(10),'') as sys_in_flow_num

from ${iml_schema}.evt_supv_acct_req_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_supv_acct_req_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
