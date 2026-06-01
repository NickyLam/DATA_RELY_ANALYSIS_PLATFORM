: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_mercht_tran_clear_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_mercht_tran_clear_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.sender_brac_org_id,chr(13),''),chr(10),'') as sender_brac_org_id
    ,replace(replace(t.send_org_id,chr(13),''),chr(10),'') as send_org_id
    ,replace(replace(t.intior_flow_num,chr(13),''),chr(10),'') as intior_flow_num
    ,replace(replace(t.tran_trans_tm,chr(13),''),chr(10),'') as tran_trans_tm
    ,t.tran_dt as tran_dt
    ,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
    ,t.tran_amt as tran_amt
    ,replace(replace(t.msg_type_cd,chr(13),''),chr(10),'') as msg_type_cd
    ,replace(replace(t.tran_proc_cd,chr(13),''),chr(10),'') as tran_proc_cd
    ,replace(replace(t.mercht_type_cd,chr(13),''),chr(10),'') as mercht_type_cd
    ,replace(replace(t.mercht_id,chr(13),''),chr(10),'') as mercht_id
    ,replace(replace(t.tran_serv_point_cond_cd,chr(13),''),chr(10),'') as tran_serv_point_cond_cd
    ,replace(replace(t.auth_reply_code,chr(13),''),chr(10),'') as auth_reply_code
    ,replace(replace(t.belong_clear_org_id,chr(13),''),chr(10),'') as belong_clear_org_id
    ,replace(replace(t.init_intior_flow_num,chr(13),''),chr(10),'') as init_intior_flow_num
    ,replace(replace(t.tran_return_cd,chr(13),''),chr(10),'') as tran_return_cd
    ,replace(replace(t.tran_serv_point_input_way_cd,chr(13),''),chr(10),'') as tran_serv_point_input_way_cd
    ,t.paybl_chn_comm_fee as paybl_chn_comm_fee
    ,t.recvbl_chn_comm_fee as recvbl_chn_comm_fee
    ,replace(replace(t.init_tran_tm,chr(13),''),chr(10),'') as init_tran_tm
    ,replace(replace(t.card_iss_org_id,chr(13),''),chr(10),'') as card_iss_org_id
    ,replace(replace(t.termn_type_cd,chr(13),''),chr(10),'') as termn_type_cd
from iml.evt_mercht_tran_clear_flow t
where etl_dt=to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_mercht_tran_clear_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes