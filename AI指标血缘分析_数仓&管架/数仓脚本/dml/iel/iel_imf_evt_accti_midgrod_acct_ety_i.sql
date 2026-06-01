: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_accti_midgrod_acct_ety_i
CreateDate: 20231013
FileName:   ${iel_data_path}/evt_accti_midgrod_acct_ety.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,evt_id
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.bus_sys_id,chr(13),''),chr(10),'') as bus_sys_id
,tran_dt
,tran_flow_num
,replace(replace(t1.sumos_seq_num,chr(13),''),chr(10),'') as sumos_seq_num
,replace(replace(t1.sumos_id,chr(13),''),chr(10),'') as sumos_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.fin_org_id,chr(13),''),chr(10),'') as fin_org_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name
,batch_no
,tran_tm
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.off_bs_flg,chr(13),''),chr(10),'') as off_bs_flg
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cash_trans_flg_cd,chr(13),''),chr(10),'') as cash_trans_flg_cd
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,tran_amt
,tran_bal
,memo_id
,memo_descb
,convt_exch_rat
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,sorc_sys_dt
,sorc_sys_flow_num
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.src_tran_flow_seq_num,chr(13),''),chr(10),'') as src_tran_flow_seq_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.sellbl_prod_id,chr(13),''),chr(10),'') as sellbl_prod_id
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,clear_flow_num
,clear_dt
,replace(replace(t1.enter_acct_status_cd,chr(13),''),chr(10),'') as enter_acct_status_cd
,replace(replace(t1.src_sob_id,chr(13),''),chr(10),'') as src_sob_id
,replace(replace(t1.revs_status_cd,chr(13),''),chr(10),'') as revs_status_cd
,init_bus_dt
,replace(replace(t1.init_bus_flow_num,chr(13),''),chr(10),'') as init_bus_flow_num
,stand_mony_amt
,replace(replace(t1.aldy_sync_flg,chr(13),''),chr(10),'') as aldy_sync_flg
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num

from ${iml_schema}.evt_accti_midgrod_acct_ety t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_accti_midgrod_acct_ety.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
