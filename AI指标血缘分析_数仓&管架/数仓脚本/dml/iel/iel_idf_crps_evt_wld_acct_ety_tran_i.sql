: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_evt_wld_acct_ety_tran_i
CreateDate: 20230608
FileName:   ${iel_data_path}/crps_evt_wld_acct_ety_tran.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.ser_num as ser_num
,t1.batch_doc_name as batch_doc_name
,t1.batch_dt as batch_dt
,t1.grouping_seq_num as grouping_seq_num
,t1.evt_tran_code as evt_tran_code
,t1.core_tran_flow as core_tran_flow
,t1.tran_descb as tran_descb
,t1.perds as perds
,t1.card_no as card_no
,t1.curr_cd as curr_cd
,t1.enter_acct_amt as enter_acct_amt
,t1.debit_crdt_flg as debit_crdt_flg
,t1.enter_acct_way_cd as enter_acct_way_cd
,t1.subrch_id as subrch_id
,t1.subj_id as subj_id
,t1.loan_prod_id as loan_prod_id
,t1.crdt_plan_id as crdt_plan_id
,t1.syn_id as syn_id
,t1.bank_id as bank_id
,t1.rb_w_flg as rb_w_flg
,t1.tran_ref_no as tran_ref_no
,t1.aging_group_cd as aging_group_cd
,t1.bal_compnt_group_cd as bal_compnt_group_cd

from ${idl_schema}.crps_evt_wld_acct_ety_tran t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_evt_wld_acct_ety_tran.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
