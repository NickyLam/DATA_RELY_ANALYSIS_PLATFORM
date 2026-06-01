: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_wld_acct_ety_tran_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_wld_acct_ety_tran.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num
,replace(replace(t1.batch_doc_name,chr(13),''),chr(10),'') as batch_doc_name
,t1.batch_dt as batch_dt
,replace(replace(t1.grouping_seq_num,chr(13),''),chr(10),'') as grouping_seq_num
,replace(replace(t1.evt_tran_code,chr(13),''),chr(10),'') as evt_tran_code
,replace(replace(t1.core_tran_flow,chr(13),''),chr(10),'') as core_tran_flow
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,t1.perds as perds
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.enter_acct_amt as enter_acct_amt
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.enter_acct_way_cd,chr(13),''),chr(10),'') as enter_acct_way_cd
,replace(replace(t1.subrch_id,chr(13),''),chr(10),'') as subrch_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.loan_prod_id,chr(13),''),chr(10),'') as loan_prod_id
,replace(replace(t1.crdt_plan_id,chr(13),''),chr(10),'') as crdt_plan_id
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.rb_w_flg,chr(13),''),chr(10),'') as rb_w_flg
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.aging_group_cd,chr(13),''),chr(10),'') as aging_group_cd
,replace(replace(t1.bal_compnt_group_cd,chr(13),''),chr(10),'') as bal_compnt_group_cd
from ${iml_schema}.evt_wld_acct_ety_tran t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wld_acct_ety_tran.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes