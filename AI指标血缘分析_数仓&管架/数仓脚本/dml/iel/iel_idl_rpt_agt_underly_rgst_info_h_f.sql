: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_agt_underly_rgst_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_agt_underly_rgst_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,underly_rgst_id
,bid_trdpty_tran_flow_num
,borw_id
,underly_id
,underly_name
,underly_intro
,mercht_id
,prod_type_cd
,cred_rht_tran_underly_flg
,invt_bid_start_tm
,invt_bid_stop_tm
,init_underly_id
,init_bid_trdpty_tran_flow_num
,int_accr_way_name
,year_int_rat
,repay_way_name
,repay_tm
,tenor
,tot_underly_amt
,lowt_bid_amt
,higt_bid_amt
,actl_distr_amt
,entr_pay_flg
,underly_status_cd
,borw_amt
,brwer_cert_no
,brwer_col_id
,brwer_col_simp_descb
,brwer_cert_type
,brwer_apved_tm
,brwer_belong_bank_num
,brwer_belong_bank_name
,brwer_acct
,brwer_name
,fail_type_cd
,issu_fail_rs from idl.rpt_agt_underly_rgst_info_h where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_agt_underly_rgst_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes