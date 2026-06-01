: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_dep_acct_stl_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_dep_acct_stl_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.stl_id as stl_id
,t1.lp_id as lp_id
,t1.lmt_id as lmt_id
,t1.evt_cate_id as evt_cate_id
,t1.tran_ref_no as tran_ref_no
,t1.stl_acct_cls_cd as stl_acct_cls_cd
,t1.stl_method_cd as stl_method_cd
,t1.tran_cd as tran_cd
,t1.acpt_pay_idf_cd as acpt_pay_idf_cd
,t1.amt_type_cd as amt_type_cd
,t1.stl_cust_id as stl_cust_id
,t1.out_line_flg as out_line_flg
,t1.hxb_stl_flg as hxb_stl_flg
,t1.recv_bank_no as recv_bank_no
,t1.recv_bank_name as recv_bank_name
,t1.stl_bk_bank_no as stl_bk_bank_no
,t1.stl_acct_id as stl_acct_id
,t1.stl_cust_acct_num as stl_cust_acct_num
,t1.stl_acct_prod_id as stl_acct_prod_id
,t1.stl_acct_curr_cd as stl_acct_curr_cd
,t1.stl_acct_sub_acct_num as stl_acct_sub_acct_num
,t1.stl_acct_name as stl_acct_name
,t1.stl_acct_bind_mobile_no as stl_acct_bind_mobile_no
,t1.stl_org_id as stl_org_id
,t1.auto_lock_flg as auto_lock_flg
,t1.entr_pay_id as entr_pay_id
,t1.stl_wt as stl_wt
,t1.stl_curr_cd as stl_curr_cd
,t1.stl_amt as stl_amt
,t1.stl_exch_rat as stl_exch_rat
,t1.entred_ps_acct_froz_way_cd as entred_ps_acct_froz_way_cd
,t1.sel_sup_flg as sel_sup_flg
,t1.prior_level as prior_level
,t1.prft_cut_ratio as prft_cut_ratio
,t1.exch_way_cd as exch_way_cd
,t1.cust_id as cust_id
,t1.tran_teller_id as tran_teller_id
,t1.final_modif_dt as final_modif_dt
,t1.final_modif_teller_id as final_modif_teller_id
,t1.tran_tm as tran_tm
,t1.open_acct_bank_fin_inst_id as open_acct_bank_fin_inst_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.acct_id as acct_id

from ${idl_schema}.oass_agt_dep_acct_stl_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_dep_acct_stl_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
