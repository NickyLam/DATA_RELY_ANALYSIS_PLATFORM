: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_mercht_tran_clear_flow_f
CreateDate: 20250711
FileName:   ${iel_data_path}/evt_mercht_tran_clear_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sender_brac_org_id,chr(13),''),chr(10),'') as sender_brac_org_id
,replace(replace(t1.send_org_id,chr(13),''),chr(10),'') as send_org_id
,replace(replace(t1.intior_flow_num,chr(13),''),chr(10),'') as intior_flow_num
,replace(replace(t1.tran_trans_tm,chr(13),''),chr(10),'') as tran_trans_tm
,tran_dt
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,tran_amt
,replace(replace(t1.msg_type_cd,chr(13),''),chr(10),'') as msg_type_cd
,replace(replace(t1.tran_proc_cd,chr(13),''),chr(10),'') as tran_proc_cd
,replace(replace(t1.mercht_type_cd,chr(13),''),chr(10),'') as mercht_type_cd
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.tran_serv_point_cond_cd,chr(13),''),chr(10),'') as tran_serv_point_cond_cd
,replace(replace(t1.auth_reply_code,chr(13),''),chr(10),'') as auth_reply_code
,replace(replace(t1.belong_clear_org_id,chr(13),''),chr(10),'') as belong_clear_org_id
,replace(replace(t1.init_intior_flow_num,chr(13),''),chr(10),'') as init_intior_flow_num
,replace(replace(t1.tran_return_cd,chr(13),''),chr(10),'') as tran_return_cd
,replace(replace(t1.tran_serv_point_input_way_cd,chr(13),''),chr(10),'') as tran_serv_point_input_way_cd
,paybl_chn_comm_fee
,recvbl_chn_comm_fee
,replace(replace(t1.init_tran_tm,chr(13),''),chr(10),'') as init_tran_tm
,replace(replace(t1.card_iss_org_id,chr(13),''),chr(10),'') as card_iss_org_id
,replace(replace(t1.termn_type_cd,chr(13),''),chr(10),'') as termn_type_cd

from ${iml_schema}.evt_mercht_tran_clear_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_mercht_tran_clear_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
