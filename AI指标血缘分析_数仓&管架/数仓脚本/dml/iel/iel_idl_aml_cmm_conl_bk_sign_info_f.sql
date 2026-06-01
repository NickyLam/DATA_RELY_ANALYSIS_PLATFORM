: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_conl_bk_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_conl_bk_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,cust_id
,cust_cn_name
,cust_en_name
,open_acct_tm
,open_acct_brch_id
,open_acct_brac_id
,belong_brac_id
,open_acct_operr_id
,cust_mgr_id
,group_cust_flg
,cash_ctrl_flg
,sup_chain_sys_flg
,sign_yqt_flg
,onl_bank_cust_type_cd
,onl_bank_cust_status_cd
,cert_type_cd
,cert_no
,orgnz_cd
,legal_rep_name
,lp_cert_type_cd
,lp_cert_no
,lp_tel_num
,lp_cert_exp_dt
,edit_flg
,posta_addr
,tel_num
,fax_num
,zip_cd
,charge_acct_id
,charge_curr_cd
,final_tran_tm
,status_modif_descb_info
,sign_yqt_tm
,oa_wrtoff_tm
,init_oa_id
,oa_reim_rela_acct_id
from idl.aml_cmm_conl_bk_sign_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_conl_bk_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes