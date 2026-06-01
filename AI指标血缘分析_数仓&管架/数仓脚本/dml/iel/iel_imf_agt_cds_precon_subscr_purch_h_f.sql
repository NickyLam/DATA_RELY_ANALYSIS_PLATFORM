: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_cds_precon_subscr_purch_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cds_precon_subscr_purch_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.precon_subscr_way_cd,chr(13),''),chr(10),'') as precon_subscr_way_cd
,replace(replace(t1.precon_id,chr(13),''),chr(10),'') as precon_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_cty_rg_cd,chr(13),''),chr(10),'') as cert_cty_rg_cd
,replace(replace(t1.cust_cn_name,chr(13),''),chr(10),'') as cust_cn_name
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.pd_prod_precon_status_cd,chr(13),''),chr(10),'') as pd_prod_precon_status_cd
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,replace(replace(t1.pd_prod_cate_cd,chr(13),''),chr(10),'') as pd_prod_cate_cd
,t1.issue_termnt_dt as issue_termnt_dt
,t1.issue_begin_dt as issue_begin_dt
,t1.open_acct_dt as open_acct_dt
,t1.precon_rgst_dt as precon_rgst_dt
,t1.precon_open_acct_dt as precon_open_acct_dt
,replace(replace(t1.aval_amt_cfg_org_id,chr(13),''),chr(10),'') as aval_amt_cfg_org_id
,replace(replace(t1.precon_subscr_org_id,chr(13),''),chr(10),'') as precon_subscr_org_id
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,t1.pd_issue_amt as pd_issue_amt
,t1.precon_amt as precon_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.bank_int_int_rat as bank_int_int_rat
,t1.float_int_rat as float_int_rat
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,t1.exec_int_rat as exec_int_rat
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,t1.del_dt as del_dt
,replace(replace(t1.del_rs,chr(13),''),chr(10),'') as del_rs
,replace(replace(t1.fail_rs,chr(13),''),chr(10),'') as fail_rs
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.del_auth_teller_id,chr(13),''),chr(10),'') as del_auth_teller_id
,replace(replace(t1.del_teller_id,chr(13),''),chr(10),'') as del_teller_id
,t1.tran_tm as tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_cds_precon_subscr_purch_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cds_precon_subscr_purch_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes