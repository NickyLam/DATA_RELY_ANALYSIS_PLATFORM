: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_batch_open_acct_acct_que_reply_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_batch_open_acct_acct_que_reply_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.msg_ind_no,chr(13),''),chr(10),'') as msg_ind_no
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.msg_id,chr(13),''),chr(10),'') as msg_id
,replace(replace(t1.init_msg_ind_no,chr(13),''),chr(10),'') as init_msg_ind_no
,t1.que_acct_qtty as que_acct_qtty
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.acct_que_rest_cd,chr(13),''),chr(10),'') as acct_que_rest_cd
,t1.midgrod_tran_dt as midgrod_tran_dt
,t1.midgrod_tran_tm as midgrod_tran_tm
,t1.msg_send_tm as msg_send_tm
,replace(replace(t1.init_dir_prtcpt_org_id,chr(13),''),chr(10),'') as init_dir_prtcpt_org_id
,replace(replace(t1.init_prtcpt_org_id,chr(13),''),chr(10),'') as init_prtcpt_org_id
,replace(replace(t1.recv_dir_prtcpt_org_id,chr(13),''),chr(10),'') as recv_dir_prtcpt_org_id
,replace(replace(t1.recv_prtcpt_org_id,chr(13),''),chr(10),'') as recv_prtcpt_org_id
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.idti_num_check_rest_cd,chr(13),''),chr(10),'') as idti_num_check_rest_cd
,replace(replace(t1.cont_mode_check_rest_cd,chr(13),''),chr(10),'') as cont_mode_check_rest_cd
,replace(replace(t1.open_bank_no,chr(13),''),chr(10),'') as open_bank_no
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.pbc_rest_cd,chr(13),''),chr(10),'') as pbc_rest_cd
,t1.pbc_proc_dt as pbc_proc_dt
,replace(replace(t1.nostro_cd,chr(13),''),chr(10),'') as nostro_cd
,replace(replace(t1.bus_refuse_code,chr(13),''),chr(10),'') as bus_refuse_code
,replace(replace(t1.bus_refuse_info_desc,chr(13),''),chr(10),'') as bus_refuse_info_desc
,replace(replace(t1.bus_process_cd,chr(13),''),chr(10),'') as bus_process_cd
,replace(replace(t1.bus_status_cd,chr(13),''),chr(10),'') as bus_status_cd
,replace(replace(t1.bus_refuse_process_cd,chr(13),''),chr(10),'') as bus_refuse_process_cd
,replace(replace(t1.bus_refuse_info,chr(13),''),chr(10),'') as bus_refuse_info
,replace(replace(t1.osb_tran_flow_num,chr(13),''),chr(10),'') as osb_tran_flow_num
,replace(replace(t1.osb_return_code,chr(13),''),chr(10),'') as osb_return_code
,replace(replace(t1.osb_return_info_desc,chr(13),''),chr(10),'') as osb_return_info_desc
,replace(replace(t1.osb_return_status,chr(13),''),chr(10),'') as osb_return_status
from ${iml_schema}.evt_batch_open_acct_acct_que_reply_rgst_b t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_batch_open_acct_acct_que_reply_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes