: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_evt_ibank_tran_a
CreateDate: 20220916
FileName:   ${iel_data_path}/icrm_evt_ibank_tran.a.${batch_date}.dat
IF_mark:    a
Logs:
   sundexin
' \
        query="select evt_id
,lp_id
,tran_num
,entr_dt
,entr_tm
,cfm_dt
,cfm_tm
,intnal_tran_num
,ext_tran_num
,operr_name
,tran_type_id
,ext_cap_acct_id
,intnal_cap_acct_id
,ext_secu_acct_id
,intnal_secu_acct_id
,cntpty_id
,pric_intnal_cap_acct_id
,fin_instm_id
,asset_type_id
,tran_market_id
,fin_instm_name
,tran_qtty
,tran_price
,tran_amt
,tran_fee
,stl_dt
,tran_status_cd
,stl_way_cd
,net_price_amt
,int_recvbl
,quote_tran_num
,ignore_flg
,tran_exec_market_id
,agent_name
,cntpty_name
,evltion_net_price_brkb
,tran_src_cd
,deal_qtty
,actl_recv_int
,actl_recv_amt
,dealer_name
,cntpty_zzd_acct_id
,cntpty_open_bank_num
,cntpty_acct_num
,cntpty_open_bank_name
,cntpty_acct_name
,cbond_yld_rat
,exp_yld_rat
,recvbl_uncol_int
,operr_id
,checker_id
,recvbl_uncol_pric
,actl_int
,actl_pric
,ref_type_cd
,recvbl_uncol_int_resv_flg
,recvbl_uncol_pric_resv_flg
,dealer_id
,tran_mode_cd
,clear_mode_cd
,apv_odd_no
,stl_status_cd
,accti_tran_num
,ftp_int_rat
,assoced_apv_odd_no
,bi_valid_cont_id
,data_src_cd
,nv_dt
,cntpty_swift_cd
,splt_type_cd
,parent_tran_num
,main_tran_num
,merge_tran_num
,miro_tran_num
,rela_tran_num
,ex_yld_rat
,cust_mgr_name
,cust_mgr_id
,camp_org_id
,redem_cfm_dt
,tran_way_cd
,dlvy_dt
,cont_id
,cap_dir_descb
,final_dir_type_cd
,rela_ser_num
,level5_cls_cd
,prod_char_cd
,curr_lot
,unpay_turn_lot
,input_dt
,dlvy_site_id
,not_stl_comm_fee
,int_accr_base_cd
,contn_int_flg
,rela_party_info
,redem_type_cd
,etl_dt
,job_cd 
,std_prod_id
,ftp_id
,is_term
,term_start_day
,term_end_day
,bank_cap_acct_open_bank_num
,bank_cap_acct_id
,th_ssn_redem_flg
,plan_redem_dt
,acct_b_cate_cd
,underly_fin_instm_id
,underly_asset_type_id
,underly_tran_market_id
from idl.icrm_evt_ibank_tran 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_evt_ibank_tran.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes