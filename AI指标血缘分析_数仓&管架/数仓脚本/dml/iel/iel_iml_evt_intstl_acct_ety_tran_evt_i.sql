: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_intstl_acct_ety_tran_evt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_intstl_acct_ety_tran_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.entry_id,chr(13),''),chr(10),'') as entry_id
,replace(replace(t1.obj_name,chr(13),''),chr(10),'') as obj_name
,replace(replace(t1.obj_flow_num,chr(13),''),chr(10),'') as obj_flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t1.entry_curr_cd,chr(13),''),chr(10),'') as entry_curr_cd
,t1.entry_amt as entry_amt
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,t1.tran_curr_amt as tran_curr_amt
,t1.value_dt as value_dt
,t1.tran_dt as tran_dt
,replace(replace(t1.memo_comnt_1,chr(13),''),chr(10),'') as memo_comnt_1
,replace(replace(t1.sumos_memo,chr(13),''),chr(10),'') as sumos_memo
,replace(replace(t1.memo_comnt_3,chr(13),''),chr(10),'') as memo_comnt_3
,replace(replace(t1.entry_seq_num,chr(13),''),chr(10),'') as entry_seq_num
,replace(replace(t1.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.off_bs_acct_id,chr(13),''),chr(10),'') as off_bs_acct_id
,t1.tran_exch_rat as tran_exch_rat
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.intstl_party_id,chr(13),''),chr(10),'') as intstl_party_id
,replace(replace(t1.wrt_guat_type_cd,chr(13),''),chr(10),'') as wrt_guat_type_cd
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.wrt_guat_tran_type_cd,chr(13),''),chr(10),'') as wrt_guat_tran_type_cd
,t1.mdl_p as mdl_p
,t1.mdl_p_quot_tm as mdl_p_quot_tm
,t1.wrt_guat_pl_amt as wrt_guat_pl_amt
,replace(replace(t1.memo_type_cd,chr(13),''),chr(10),'') as memo_type_cd
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
,replace(replace(t1.espec_econ_rg_type_cd,chr(13),''),chr(10),'') as espec_econ_rg_type_cd
,replace(replace(t1.apprv_id,chr(13),''),chr(10),'') as apprv_id
,replace(replace(t1.cntpty_bank_name,chr(13),''),chr(10),'') as cntpty_bank_name
,t1.sell_exch_rat as sell_exch_rat
,t1.buy_exch_rat as buy_exch_rat
,t1.prefr_point as prefr_point
,replace(replace(t1.fin_type_cd,chr(13),''),chr(10),'') as fin_type_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
from ${iml_schema}.evt_intstl_acct_ety_tran_evt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_intstl_acct_ety_tran_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes