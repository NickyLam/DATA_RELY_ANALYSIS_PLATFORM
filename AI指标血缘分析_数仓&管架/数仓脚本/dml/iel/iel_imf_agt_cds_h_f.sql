: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_cds_h_f
CreateDate: 20230131
FileName:   ${iel_data_path}/agt_cds_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.precon_id,chr(13),''),chr(10),'') as precon_id
,precon_rgst_dt
,precon_open_acct_dt
,replace(replace(t1.precon_rgst_acct_type,chr(13),''),chr(10),'') as precon_rgst_acct_type
,replace(replace(t1.precon_org,chr(13),''),chr(10),'') as precon_org
,replace(replace(t1.precon_curr_cd,chr(13),''),chr(10),'') as precon_curr_cd
,precon_amt
,replace(replace(t1.pd_prod_precon_status_cd,chr(13),''),chr(10),'') as pd_prod_precon_status_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,replace(replace(t1.pd_prod_cate_cd,chr(13),''),chr(10),'') as pd_prod_cate_cd
,pd_issue_amt
,replace(replace(t1.issue_year,chr(13),''),chr(10),'') as issue_year
,issue_begin_dt
,issue_termnt_dt
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t1.cntpty_acct_curr_cd,chr(13),''),chr(10),'') as cntpty_acct_curr_cd
,replace(replace(t1.cntpty_sub_acct_num,chr(13),''),chr(10),'') as cntpty_sub_acct_num
,replace(replace(t1.cntpty_prod_id,chr(13),''),chr(10),'') as cntpty_prod_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.auto_payoff_flg,chr(13),''),chr(10),'') as auto_payoff_flg
,bank_int_int_rat
,exec_int_rat
,float_int_rat
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,int_set_day
,replace(replace(t1.int_set_freq_cd,chr(13),''),chr(10),'') as int_set_freq_cd
,replace(replace(t1.accrd_freq_pay_int_flg,chr(13),''),chr(10),'') as accrd_freq_pay_int_flg
,next_int_set_dt
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,redem_dt
,expect_redem_int
,replace(replace(t1.inpwn_flg,chr(13),''),chr(10),'') as inpwn_flg
,replace(replace(t1.wdraw_way_cd,chr(13),''),chr(10),'') as wdraw_way_cd
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.potd_acct_id,chr(13),''),chr(10),'') as potd_acct_id
,replace(replace(t1.cds_int_accr_way_cd,chr(13),''),chr(10),'') as cds_int_accr_way_cd
,replace(replace(t1.subscr_acct_id,chr(13),''),chr(10),'') as subscr_acct_id
,replace(replace(t1.col_int_acct_id,chr(13),''),chr(10),'') as col_int_acct_id
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.on_acct_seq_num,chr(13),''),chr(10),'') as on_acct_seq_num
,replace(replace(t1.supp_on_acct_sub_seq_num,chr(13),''),chr(10),'') as supp_on_acct_sub_seq_num
,tran_amt
,replace(replace(t1.comb_prod_id,chr(13),''),chr(10),'') as comb_prod_id

from ${iml_schema}.agt_cds_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cds_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
