: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_log_tran_flow_a
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_log_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.tran_seq_num,chr(13),''),chr(10),'') as tran_seq_num
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.vrif_post_forbid_flg,chr(13),''),chr(10),'') as vrif_post_forbid_flg
,replace(replace(t1.revo_flg,chr(13),''),chr(10),'') as revo_flg
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id
,replace(replace(t1.bus_prod_id,chr(13),''),chr(10),'') as bus_prod_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.guar_org_id,chr(13),''),chr(10),'') as guar_org_id
,replace(replace(t1.rev_guar_org_id,chr(13),''),chr(10),'') as rev_guar_org_id
,replace(replace(t1.log_cont_id,chr(13),''),chr(10),'') as log_cont_id
,replace(replace(t1.applit_stl_acct_id,chr(13),''),chr(10),'') as applit_stl_acct_id
,replace(replace(t1.benefc_acct_id,chr(13),''),chr(10),'') as benefc_acct_id
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,log_amt
,stop_pay_ratio
,margin_amt
,replace(replace(t1.pymc_cust_acct_num,chr(13),''),chr(10),'') as pymc_cust_acct_num
,replace(replace(t1.pymc_acct_sub_acct_num,chr(13),''),chr(10),'') as pymc_acct_sub_acct_num
,replace(replace(t1.pymc_acct_curr_cd,chr(13),''),chr(10),'') as pymc_acct_curr_cd
,replace(replace(t1.pymc_acct_prod_id,chr(13),''),chr(10),'') as pymc_acct_prod_id
,replace(replace(t1.pbc_clear_cust_acct_num,chr(13),''),chr(10),'') as pbc_clear_cust_acct_num
,replace(replace(t1.stl_acct_sub_acct_num,chr(13),''),chr(10),'') as stl_acct_sub_acct_num
,replace(replace(t1.stl_acct_curr_cd,chr(13),''),chr(10),'') as stl_acct_curr_cd
,replace(replace(t1.stl_acct_prod_id,chr(13),''),chr(10),'') as stl_acct_prod_id
,replace(replace(t1.margin_cust_acct_num,chr(13),''),chr(10),'') as margin_cust_acct_num
,replace(replace(t1.margin_acct_sub_acct_num,chr(13),''),chr(10),'') as margin_acct_sub_acct_num
,replace(replace(t1.margin_acct_curr_cd,chr(13),''),chr(10),'') as margin_acct_curr_cd
,replace(replace(t1.margin_acct_prod_id,chr(13),''),chr(10),'') as margin_acct_prod_id
,advc_amt
,replace(replace(t1.advc_dubil_id,chr(13),''),chr(10),'') as advc_dubil_id
,advc_fix_pnlt_int_rat
,begin_dt
,exp_dt
,replace(replace(t1.log_status_cd,chr(13),''),chr(10),'') as log_status_cd
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id
,replace(replace(t1.log_valid_flg,chr(13),''),chr(10),'') as log_valid_flg
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.mtg_cont_id,chr(13),''),chr(10),'') as mtg_cont_id
,replace(replace(t1.log_compens_status_cd,chr(13),''),chr(10),'') as log_compens_status_cd
,loan_sign_cont_amt
,replace(replace(t1.benefc_cert_type_cd,chr(13),''),chr(10),'') as benefc_cert_type_cd
,replace(replace(t1.benefc_cert_no,chr(13),''),chr(10),'') as benefc_cert_no
,col_book_val
,new_log_termnt_dt
,replace(replace(t1.benefc_resdnt_addr,chr(13),''),chr(10),'') as benefc_resdnt_addr
,replace(replace(t1.cont_curr_cd,chr(13),''),chr(10),'') as cont_curr_cd
,log_compens_amt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,tran_tm
,replace(replace(t1.check_entry_code,chr(13),''),chr(10),'') as check_entry_code
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num

from ${iml_schema}.evt_log_tran_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_log_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
