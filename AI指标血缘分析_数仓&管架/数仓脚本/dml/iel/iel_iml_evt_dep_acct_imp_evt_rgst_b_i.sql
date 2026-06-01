: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_dep_acct_imp_evt_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_dep_acct_imp_evt_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,t1.open_acct_dt as open_acct_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.dep_redt_type_cd,chr(13),''),chr(10),'') as dep_redt_type_cd
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,t1.bank_int_int_rat as bank_int_int_rat
,t1.float_int_rat as float_int_rat
,t1.float_point as float_point
,t1.exec_int_rat as exec_int_rat
,t1.acm_int_adj_amt as acm_int_adj_amt
,t1.provi_day_int_adj_amt as provi_day_int_adj_amt
,t1.base_int_rat as base_int_rat
,t1.tot_int_amt as tot_int_amt
,t1.int_accr_amt as int_accr_amt
,t1.last_int_set_dt as last_int_set_dt
,replace(replace(t1.cap_flg,chr(13),''),chr(10),'') as cap_flg
,t1.dep_term_tenor as dep_term_tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,t1.exp_dt as exp_dt
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,t1.tran_happ_pric as tran_happ_pric
,t1.tran_amt as tran_amt
,t1.wdraw_int_rat as wdraw_int_rat
,t1.net_int as net_int
,t1.int_accr_days as int_accr_days
,t1.tax_rat as tax_rat
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,t1.tax_amt as tax_amt
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.redt_seq_num,chr(13),''),chr(10),'') as redt_seq_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,t1.tran_revs_dt as tran_revs_dt
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.bus_proc_status_cd,chr(13),''),chr(10),'') as bus_proc_status_cd
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,t1.tran_tm as tran_tm
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.check_entry_cd,chr(13),''),chr(10),'') as check_entry_cd
from ${iml_schema}.evt_dep_acct_imp_evt_rgst_b t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dep_acct_imp_evt_rgst_b.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes