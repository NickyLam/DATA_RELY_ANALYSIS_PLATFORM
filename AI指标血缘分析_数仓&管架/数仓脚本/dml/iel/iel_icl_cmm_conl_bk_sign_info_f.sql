: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_conl_bk_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_conl_bk_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_cn_name,chr(13),''),chr(10),'') as cust_cn_name
,replace(replace(t1.cust_en_name,chr(13),''),chr(10),'') as cust_en_name
,t1.open_acct_tm as open_acct_tm
,replace(replace(t1.open_acct_brch_id,chr(13),''),chr(10),'') as open_acct_brch_id
,replace(replace(t1.open_acct_brac_id,chr(13),''),chr(10),'') as open_acct_brac_id
,replace(replace(t1.belong_brac_id,chr(13),''),chr(10),'') as belong_brac_id
,replace(replace(t1.open_acct_operr_id,chr(13),''),chr(10),'') as open_acct_operr_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg
,replace(replace(t1.cash_ctrl_flg,chr(13),''),chr(10),'') as cash_ctrl_flg
,replace(replace(t1.sup_chain_sys_flg,chr(13),''),chr(10),'') as sup_chain_sys_flg
,replace(replace(t1.sign_yqt_flg,chr(13),''),chr(10),'') as sign_yqt_flg
,replace(replace(t1.onl_bank_cust_type_cd,chr(13),''),chr(10),'') as onl_bank_cust_type_cd
,replace(replace(t1.onl_bank_cust_status_cd,chr(13),''),chr(10),'') as onl_bank_cust_status_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,replace(replace(t1.lp_cert_type_cd,chr(13),''),chr(10),'') as lp_cert_type_cd
,replace(replace(t1.lp_cert_no,chr(13),''),chr(10),'') as lp_cert_no
,replace(replace(t1.lp_tel_num,chr(13),''),chr(10),'') as lp_tel_num
,t1.lp_cert_exp_dt as lp_cert_exp_dt
,replace(replace(t1.edit_flg,chr(13),''),chr(10),'') as edit_flg
,replace(replace(t1.posta_addr,chr(13),''),chr(10),'') as posta_addr
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.charge_acct_id,chr(13),''),chr(10),'') as charge_acct_id
,replace(replace(t1.charge_curr_cd,chr(13),''),chr(10),'') as charge_curr_cd
,t1.final_tran_tm as final_tran_tm
,replace(replace(t1.status_modif_descb_info,chr(13),''),chr(10),'') as status_modif_descb_info
,t1.sign_yqt_tm as sign_yqt_tm
,t1.oa_wrtoff_tm as oa_wrtoff_tm
,replace(replace(t1.init_oa_id,chr(13),''),chr(10),'') as init_oa_id
,replace(replace(t1.oa_reim_rela_acct_id,chr(13),''),chr(10),'') as oa_reim_rela_acct_id
,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
,t1.onl_bank_tran_lmt as onl_bank_tran_lmt
from ${icl_schema}.cmm_conl_bk_sign_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_conl_bk_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes