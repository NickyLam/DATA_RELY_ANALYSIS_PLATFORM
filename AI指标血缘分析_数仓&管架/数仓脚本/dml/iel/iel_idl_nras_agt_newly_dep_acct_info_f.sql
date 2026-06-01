: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_nras_agt_newly_dep_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_newly_dep_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,agt_id
,lp_id
,liab_acct_num
,acct_name
,cust_id
,bus_id
,open_acct_org_id
,open_acct_teller_id
,clos_acct_teller_id
,clos_acct_org_id
,prod_id
,cust_acct_num
,dep_term
,acct_exp_dt
,acct_open_acct_dt
,acct_clos_acct_dt
,acct_valid_dt
,curr_gl_bal
,ld_gl_bal
,init_amt
,open_acct_amt
,acct_retnd_max_bal
,acct_retnd_min_bal
,recnt_update_dt
,last_bus_dt
,last_coll_pay_dt
,init_value_dt
,init_exp_dt
,statmt_create_dt
,recnt_check_entry_dt
,fir_depot_dt
,recnt_acct_vrfction_dt
,curr_unused_seq_num
,caln_name
,acct_flg_string
,liab_prod_type_cd
,prod_belong_obj_cd
,acct_cls_cd_1
,acct_cls_cd_3
,depot_ctrl_way_cd
,drawdown_ctrl_way_cd
,drawdown_mpr_flg
,redt_way_cd
,stdby_amt
,drawdown_intrv
,dep_kind_cd
,acct_status_cd
,check_entry_flg
,acct_check_entry_ped
,check_entry_range
,vrfction_flg
,bal_and_gl_sync_flg
,spec_expns_acct_flg
,cap_expns_acct
,spec_inco_acct_flg
,cap_inco_acct
,rec_status_cd
,acct_curr_cd
,ec_flg
,corp_curr_acct_attr_cd
,acct_lmt_flg
,acct_amt_froz_flg
,acct_close_froz_flg
,acct_only_out_flg
,acct_only_in_flg
,rela_circl_loan_flg
,have_acct_prot_rela_flg
,modal_tran_flg
,monit_acct_flg
,cap_veri_acct_flg
,rsrv_corp_check_pwd_flg
,check_acct_flg
,allow_od_flg
,prep_cfm_stl_acct_flg
,fx_supv_flg
,fx_vrfction_flg
,nomal_acct_charge_flg
,dormt_acct_charge_flg
,stl_acct_flg
,margin_dep_flg
,fin_dep_flg
,sign_finc_flg
,realtm_tran_flg
,rela_od_flg
,bal_coll_flg
,onl_fee_batch_post_recv_flg
,batch_post_recv_fee_freq
,matn_teller_id
,matn_org_id
,matn_dt
,matn_tm
,seq_num from idl.nras_agt_newly_dep_acct_info where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_newly_dep_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes