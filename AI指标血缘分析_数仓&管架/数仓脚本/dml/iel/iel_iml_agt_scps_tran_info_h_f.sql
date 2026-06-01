: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_scps_tran_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_scps_tran_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.task_no,chr(13),''),chr(10),'') as task_no
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.sub_task_no,chr(13),''),chr(10),'') as sub_task_no
,replace(replace(t1.init_task_no,chr(13),''),chr(10),'') as init_task_no
,replace(replace(t1.task_status_cd,chr(13),''),chr(10),'') as task_status_cd
,replace(replace(t1.payment_flow_num,chr(13),''),chr(10),'') as payment_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.bus_scene_id,chr(13),''),chr(10),'') as bus_scene_id
,t1.tran_dt as tran_dt
,t1.tran_tm as tran_tm
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.blip_flow_num,chr(13),''),chr(10),'') as blip_flow_num
,replace(replace(t1.ghb_acct_id,chr(13),''),chr(10),'') as ghb_acct_id
,replace(replace(t1.ghb_acct_name,chr(13),''),chr(10),'') as ghb_acct_name
,t1.invalid_tm as invalid_tm
,t1.invalid_dt as invalid_dt
,replace(replace(t1.refuse_rs_descb,chr(13),''),chr(10),'') as refuse_rs_descb
,replace(replace(t1.err_idtfy_rs_descb,chr(13),''),chr(10),'') as err_idtfy_rs_descb
,replace(replace(t1.opera_mode_cd,chr(13),''),chr(10),'') as opera_mode_cd
,replace(replace(t1.opera_status_cd,chr(13),''),chr(10),'') as opera_status_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.bus_init_teller_id,chr(13),''),chr(10),'') as bus_init_teller_id
,replace(replace(t1.bus_init_director_teller_id,chr(13),''),chr(10),'') as bus_init_director_teller_id
,replace(replace(t1.bus_init_org_id,chr(13),''),chr(10),'') as bus_init_org_id
,replace(replace(t1.oper_status_cd,chr(13),''),chr(10),'') as oper_status_cd
,replace(replace(t1.bus_gen_cd,chr(13),''),chr(10),'') as bus_gen_cd
,replace(replace(t1.prob_node_cd,chr(13),''),chr(10),'') as prob_node_cd
,replace(replace(t1.prob_cls_cd,chr(13),''),chr(10),'') as prob_cls_cd
,t1.prob_init_dt as prob_init_dt
,t1.prob_init_tm as prob_init_tm
,replace(replace(t1.prob_rs,chr(13),''),chr(10),'') as prob_rs
,replace(replace(t1.prob_init_teller_id,chr(13),''),chr(10),'') as prob_init_teller_id
,t1.issue_dt as issue_dt
,t1.issue_tm as issue_tm
,replace(replace(t1.check_idtfy_rest_cd,chr(13),''),chr(10),'') as check_idtfy_rest_cd
,replace(replace(t1.check_remark,chr(13),''),chr(10),'') as check_remark
,replace(replace(t1.check_idtfy_rs,chr(13),''),chr(10),'') as check_idtfy_rs
,replace(replace(t1.authoriz_diret_teller_id,chr(13),''),chr(10),'') as authoriz_diret_teller_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_scps_tran_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_scps_tran_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes