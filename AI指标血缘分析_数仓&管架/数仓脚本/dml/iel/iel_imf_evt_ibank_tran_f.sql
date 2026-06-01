: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_ibank_tran_f
CreateDate: 20251103
FileName:   ${iel_data_path}/evt_ibank_tran.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_num,chr(13),''),chr(10),'') as tran_num
,entr_dt
,replace(replace(t1.entr_tm,chr(13),''),chr(10),'') as entr_tm
,cfm_dt
,replace(replace(t1.cfm_tm,chr(13),''),chr(10),'') as cfm_tm
,replace(replace(t1.intnal_tran_num,chr(13),''),chr(10),'') as intnal_tran_num
,replace(replace(t1.ext_tran_num,chr(13),''),chr(10),'') as ext_tran_num
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.tran_type_id,chr(13),''),chr(10),'') as tran_type_id
,replace(replace(t1.ext_cap_acct_id,chr(13),''),chr(10),'') as ext_cap_acct_id
,replace(replace(t1.intnal_cap_acct_id,chr(13),''),chr(10),'') as intnal_cap_acct_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.pric_intnal_cap_acct_id,chr(13),''),chr(10),'') as pric_intnal_cap_acct_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'') as tran_market_id
,replace(replace(t1.fin_instm_name,chr(13),''),chr(10),'') as fin_instm_name
,tran_qtty
,tran_price
,tran_amt
,tran_fee
,stl_dt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,net_price_amt
,int_recvbl
,replace(replace(t1.quote_tran_num,chr(13),''),chr(10),'') as quote_tran_num
,replace(replace(t1.ignore_flg,chr(13),''),chr(10),'') as ignore_flg
,replace(replace(t1.tran_exec_market_id,chr(13),''),chr(10),'') as tran_exec_market_id
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,evltion_net_price_brkb
,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'') as tran_src_cd
,deal_qtty
,actl_recv_int
,actl_recv_amt
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.cntpty_zzd_acct_id,chr(13),''),chr(10),'') as cntpty_zzd_acct_id
,replace(replace(t1.cntpty_open_bank_num,chr(13),''),chr(10),'') as cntpty_open_bank_num
,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'') as cntpty_acct_num
,replace(replace(t1.cntpty_open_bank_name,chr(13),''),chr(10),'') as cntpty_open_bank_name
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,cbond_yld_rat
,exp_yld_rat
,recvbl_uncol_int
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.checker_id,chr(13),''),chr(10),'') as checker_id
,recvbl_uncol_pric
,actl_int
,actl_pric
,replace(replace(t1.ref_type_cd,chr(13),''),chr(10),'') as ref_type_cd
,replace(replace(t1.recvbl_uncol_int_resv_flg,chr(13),''),chr(10),'') as recvbl_uncol_int_resv_flg
,replace(replace(t1.recvbl_uncol_pric_resv_flg,chr(13),''),chr(10),'') as recvbl_uncol_pric_resv_flg
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.tran_mode_cd,chr(13),''),chr(10),'') as tran_mode_cd
,replace(replace(t1.clear_mode_cd,chr(13),''),chr(10),'') as clear_mode_cd
,replace(replace(t1.apv_odd_no,chr(13),''),chr(10),'') as apv_odd_no
,replace(replace(t1.stl_status_cd,chr(13),''),chr(10),'') as stl_status_cd
,replace(replace(t1.accti_tran_num,chr(13),''),chr(10),'') as accti_tran_num
,ftp_int_rat
,replace(replace(t1.assoced_apv_odd_no,chr(13),''),chr(10),'') as assoced_apv_odd_no
,replace(replace(t1.bi_valid_cont_id,chr(13),''),chr(10),'') as bi_valid_cont_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,nv_dt
,replace(replace(t1.cntpty_swift_cd,chr(13),''),chr(10),'') as cntpty_swift_cd
,replace(replace(t1.splt_type_cd,chr(13),''),chr(10),'') as splt_type_cd
,replace(replace(t1.parent_tran_num,chr(13),''),chr(10),'') as parent_tran_num
,replace(replace(t1.main_tran_num,chr(13),''),chr(10),'') as main_tran_num
,replace(replace(t1.merge_tran_num,chr(13),''),chr(10),'') as merge_tran_num
,replace(replace(t1.miro_tran_num,chr(13),''),chr(10),'') as miro_tran_num
,replace(replace(t1.rela_tran_num,chr(13),''),chr(10),'') as rela_tran_num
,ex_yld_rat
,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'') as cust_mgr_name
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.camp_org_id,chr(13),''),chr(10),'') as camp_org_id
,redem_cfm_dt
,replace(replace(t1.tran_way_cd,chr(13),''),chr(10),'') as tran_way_cd
,dlvy_dt
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cap_dir_descb,chr(13),''),chr(10),'') as cap_dir_descb
,replace(replace(t1.final_dir_type_cd,chr(13),''),chr(10),'') as final_dir_type_cd
,replace(replace(t1.rela_ser_num,chr(13),''),chr(10),'') as rela_ser_num
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,replace(replace(t1.prod_char_cd,chr(13),''),chr(10),'') as prod_char_cd
,curr_lot
,unpay_turn_lot
,input_dt
,replace(replace(t1.dlvy_site_id,chr(13),''),chr(10),'') as dlvy_site_id
,not_stl_comm_fee
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.contn_int_flg,chr(13),''),chr(10),'') as contn_int_flg
,replace(replace(t1.rela_party_info,chr(13),''),chr(10),'') as rela_party_info
,replace(replace(t1.redem_type_cd,chr(13),''),chr(10),'') as redem_type_cd
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.ftp_id,chr(13),''),chr(10),'') as ftp_id
,replace(replace(t1.is_term,chr(13),''),chr(10),'') as is_term
,term_start_day
,term_end_day
,replace(replace(t1.bank_cap_acct_open_bank_num,chr(13),''),chr(10),'') as bank_cap_acct_open_bank_num
,replace(replace(t1.bank_cap_acct_id,chr(13),''),chr(10),'') as bank_cap_acct_id
,replace(replace(t1.th_ssn_redem_flg,chr(13),''),chr(10),'') as th_ssn_redem_flg
,plan_redem_dt
,replace(replace(t1.acct_b_cate_cd,chr(13),''),chr(10),'') as acct_b_cate_cd
,replace(replace(t1.underly_fin_instm_id,chr(13),''),chr(10),'') as underly_fin_instm_id
,replace(replace(t1.underly_asset_type_id,chr(13),''),chr(10),'') as underly_asset_type_id
,replace(replace(t1.underly_tran_market_id,chr(13),''),chr(10),'') as underly_tran_market_id
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t1.p_g_bond_flg,chr(13),''),chr(10),'') as p_g_bond_flg

from ${iml_schema}.evt_ibank_tran t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_tran.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
