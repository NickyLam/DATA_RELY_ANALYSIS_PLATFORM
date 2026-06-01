: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_agt_saving_prod_dmic_tran_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_agt_saving_prod_dmic_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.dtl_seq_num as dtl_seq_num
,replace(replace(t.liab_acct_num,chr(13),''),chr(10),'') as liab_acct_num
,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t.bal_name_field,chr(13),''),chr(10),'') as bal_name_field
,t.tran_amt as tran_amt
,t.bal as bal
,replace(replace(t.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t.acct_num_seq_num,chr(13),''),chr(10),'') as acct_num_seq_num
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,replace(replace(t.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t.prod_belong_obj_cd,chr(13),''),chr(10),'') as prod_belong_obj_cd
,replace(replace(t.cash_trans_cd,chr(13),''),chr(10),'') as cash_trans_cd
,replace(replace(t.cntpty_fin_inst_type_cd,chr(13),''),chr(10),'') as cntpty_fin_inst_type_cd
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,replace(replace(t.dep_term,chr(13),''),chr(10),'') as dep_term
,replace(replace(t.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
,replace(replace(t.vouch_batch_no,chr(13),''),chr(10),'') as vouch_batch_no
,replace(replace(t.vouch_seq_num,chr(13),''),chr(10),'') as vouch_seq_num
,replace(replace(t.tran_chn,chr(13),''),chr(10),'') as tran_chn
,replace(replace(t.ext_tran_code,chr(13),''),chr(10),'') as ext_tran_code
,replace(replace(t.intnal_tran_code,chr(13),''),chr(10),'') as intnal_tran_code
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_acct_instit_id,chr(13),''),chr(10),'') as tran_acct_instit_id
,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t.acct_acct_instit_id,chr(13),''),chr(10),'') as acct_acct_instit_id
,replace(replace(t.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t.cntpty_fin_inst_name,chr(13),''),chr(10),'') as cntpty_fin_inst_name
,replace(replace(t.cntpty_acct_open_bank_num,chr(13),''),chr(10),'') as cntpty_acct_open_bank_num
,replace(replace(t.teller_flow_num,chr(13),''),chr(10),'') as teller_flow_num
,t.trast_dt as trast_dt
,replace(replace(t.trast_tm,chr(13),''),chr(10),'') as trast_tm
,t.host_dt as host_dt
,replace(replace(t.revs_cd,chr(13),''),chr(10),'') as revs_cd
,replace(replace(t.brevs_flg,chr(13),''),chr(10),'') as brevs_flg
,t.wa_init_dt as wa_init_dt
,replace(replace(t.wa_init_teller_flow_num,chr(13),''),chr(10),'') as wa_init_teller_flow_num
,replace(replace(t.tran_proc_char,chr(13),''),chr(10),'') as tran_proc_char
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,t.matn_dt as matn_dt
,replace(replace(t.matn_tm,chr(13),''),chr(10),'') as matn_tm
,t.update_tm_stamp as update_tm_stamp
,replace(replace(t.memo_id,chr(13),''),chr(10),'') as memo_id
,replace(replace(t.memo_descb,chr(13),''),chr(10),'') as memo_descb
,replace(replace(t.cntpty_acct_num,chr(13),''),chr(10),'') as cntpty_acct_num
from iml.agt_saving_prod_dmic_tran_dtl t
where t.trast_dt >= to_date('20200101','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_agt_saving_prod_dmic_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes