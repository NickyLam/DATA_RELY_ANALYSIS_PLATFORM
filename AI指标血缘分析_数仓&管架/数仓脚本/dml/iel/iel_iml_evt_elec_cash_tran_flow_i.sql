: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_elec_cash_tran_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_elec_cash_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sys_follow_id,chr(13),''),chr(10),'') as sys_follow_id
,replace(replace(t1.trader_type_cd,chr(13),''),chr(10),'') as trader_type_cd
,replace(replace(t1.send_org_id,chr(13),''),chr(10),'') as send_org_id
,replace(replace(t1.proc_org_id,chr(13),''),chr(10),'') as proc_org_id
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,t1.clear_dt as clear_dt
,t1.doc_dt as doc_dt
,t1.tran_dt as tran_dt
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.card_seq_no,chr(13),''),chr(10),'') as card_seq_no
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.tran_amt as tran_amt
,replace(replace(t1.check_rest_cd,chr(13),''),chr(10),'') as check_rest_cd
,t1.clear_amt as clear_amt
,replace(replace(t1.clear_curr_cd,chr(13),''),chr(10),'') as clear_curr_cd
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,t1.fee_rat as fee_rat
,replace(replace(t1.mercht_type_cd,chr(13),''),chr(10),'') as mercht_type_cd
,replace(replace(t1.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.init_tran_type_cd,chr(13),''),chr(10),'') as init_tran_type_cd
,replace(replace(t1.init_sys_follow_id,chr(13),''),chr(10),'') as init_sys_follow_id
,t1.init_tran_clear_dt as init_tran_clear_dt
,replace(replace(t1.init_tran_tm,chr(13),''),chr(10),'') as init_tran_tm
,t1.comm_fee_amt as comm_fee_amt
,t1.card_holder_deduct_exch_rat as card_holder_deduct_exch_rat
,t1.card_holder_deduct_amt as card_holder_deduct_amt
,replace(replace(t1.card_holder_curr_cd,chr(13),''),chr(10),'') as card_holder_curr_cd
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,t1.host_tran_dt as host_tran_dt
,replace(replace(t1.host_tran_flow,chr(13),''),chr(10),'') as host_tran_flow
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.td_rtn_goods_flg,chr(13),''),chr(10),'') as td_rtn_goods_flg
,t1.ghb_exch_fee as ghb_exch_fee
,t1.tran_clear_fee as tran_clear_fee
from ${iml_schema}.evt_elec_cash_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_elec_cash_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes