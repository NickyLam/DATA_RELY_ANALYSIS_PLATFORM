: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_agt_saving_prod_dmic_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_agt_saving_prod_dmic_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,agt_id
,lp_id
,dtl_seq_num
,liab_acct_num
,acct_name
,bal_name_field
,tran_amt
,bal
,cust_acct_num
,acct_num_seq_num
,prod_id
,debit_crdt_flg
,tran_curr_cd
,ec_flg
,prod_belong_obj_cd
,cash_trans_cd
,cntpty_fin_inst_type_cd
,rec_status_cd
,dep_term
,vouch_kind_cd
,vouch_batch_no
,vouch_seq_num
,tran_chn
,ext_tran_code
,intnal_tran_code
,tran_org_id
,tran_acct_instit_id
,open_acct_org_id
,acct_acct_instit_id
,operr_id
,cntpty_cust_acct_num
,cntpty_acct_name
,cntpty_fin_inst_name
,cntpty_acct_open_bank_num
,teller_flow_num
,trast_dt
,trast_tm
,host_dt
,revs_cd
,brevs_flg
,wa_init_dt
,wa_init_teller_flow_num
,tran_proc_char
,matn_teller_id
,matn_org_id
,matn_dt
,matn_tm
,update_tm_stamp
,memo_id
,memo_descb
,cntpty_acct_num
from idl.aml_agt_saving_prod_dmic_tran_dtl
where trast_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_agt_saving_prod_dmic_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes