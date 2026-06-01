: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_intstl_acct_ety_tran_evt_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_intstl_acct_ety_tran_evt.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,evt_id
      ,lp_id
      ,entry_id
      ,replace(replace(obj_name,chr(13),''),chr(10),'') as obj_name
      ,replace(replace(obj_flow_num,chr(13),''),chr(10),'') as obj_flow_num
      ,replace(replace(tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
      ,tran_acct_id
      ,debit_crdt_dir_cd
      ,entry_curr_cd
      ,entry_amt
      ,tran_curr_cd
      ,tran_curr_amt
      ,value_dt
      ,tran_dt
      ,replace(replace(memo_comnt_1,chr(13),''),chr(10),'') as memo_comnt_1
      ,replace(replace(sumos_memo,chr(13),''),chr(10),'') as sumos_memo
      ,replace(replace(memo_comnt_3,chr(13),''),chr(10),'') as memo_comnt_3
      ,replace(replace(entry_seq_num,chr(13),''),chr(10),'') as entry_seq_num
      ,exp_status_cd
      ,entry_org_id
      ,dubil_id
      ,off_bs_acct_id
      ,tran_exch_rat
      ,tran_type_cd
      ,intstl_party_id
      ,wrt_guat_type_cd
      ,subj_id
      ,wrt_guat_tran_type_cd
      ,mdl_p
      ,mdl_p_quot_tm
      ,wrt_guat_pl_amt
      ,memo_type_cd
      ,ec_idf_cd
      ,tran_cd
      ,cty_rg_cd
      ,espec_econ_rg_type_cd
      ,apprv_id
      ,replace(replace(cntpty_bank_name,chr(13),''),chr(10),'') as cntpty_bank_name
      ,sell_exch_rat
      ,buy_exch_rat
      ,prefr_point
  from ${iml_schema}.evt_intstl_acct_ety_tran_evt t1 where t1.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_intstl_acct_ety_tran_evt.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes