: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_scps_bus_flow_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_scps_bus_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.task_no,chr(13),''),chr(10),'') as task_no
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.sub_task_no,chr(13),''),chr(10),'') as sub_task_no
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.blip_flow_num,chr(13),''),chr(10),'') as blip_flow_num
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.bus_scene_id,chr(13),''),chr(10),'') as bus_scene_id
,replace(replace(t1.bus_proc_prior_level,chr(13),''),chr(10),'') as bus_proc_prior_level
,replace(replace(t1.prior_level_descb,chr(13),''),chr(10),'') as prior_level_descb
,replace(replace(t1.opera_mode_cd,chr(13),''),chr(10),'') as opera_mode_cd
,replace(replace(t1.init_teller_id,chr(13),''),chr(10),'') as init_teller_id
,replace(replace(t1.init_org_id,chr(13),''),chr(10),'') as init_org_id
,replace(replace(t1.bus_proc_org_id,chr(13),''),chr(10),'') as bus_proc_org_id
,t1.tran_amt as tran_amt
,t1.tran_tm as tran_tm
,t1.tran_dt as tran_dt
,replace(replace(t1.task_status_cd,chr(13),''),chr(10),'') as task_status_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.payer_acct_name,chr(13),''),chr(10),'') as payer_acct_name
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.refuse_rs_descb,chr(13),''),chr(10),'') as refuse_rs_descb
,t1.invalid_tm as invalid_tm
,t1.invalid_dt as invalid_dt
,replace(replace(t1.init_task_no,chr(13),''),chr(10),'') as init_task_no
,replace(replace(t1.recver_acct_name,chr(13),''),chr(10),'') as recver_acct_name
,replace(replace(t1.ghb_acct_id,chr(13),''),chr(10),'') as ghb_acct_id
,replace(replace(t1.ghb_acct_name,chr(13),''),chr(10),'') as ghb_acct_name
,replace(replace(t1.authoriz_diret_teller_id,chr(13),''),chr(10),'') as authoriz_diret_teller_id
,replace(replace(t1.termnt_rs_descb,chr(13),''),chr(10),'') as termnt_rs_descb
,replace(replace(t1.blip_model_id,chr(13),''),chr(10),'') as blip_model_id
,t1.blip_upload_tm as blip_upload_tm
,replace(replace(t1.entry_flow_num,chr(13),''),chr(10),'') as entry_flow_num
,t1.entry_dt as entry_dt
,t1.entry_tm as entry_tm
,replace(replace(t1.prob_initor_cd,chr(13),''),chr(10),'') as prob_initor_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
from ${iml_schema}.evt_scps_bus_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_scps_bus_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes