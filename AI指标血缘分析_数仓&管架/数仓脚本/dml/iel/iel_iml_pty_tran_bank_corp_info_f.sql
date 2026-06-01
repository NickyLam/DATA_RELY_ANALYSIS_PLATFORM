: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_tran_bank_corp_info_f
CreateDate: 20240604
FileName:   ${iel_data_path}/pty_tran_bank_corp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_cn_name,chr(13),''),chr(10),'') as cust_cn_name
,replace(replace(t1.cust_en_name,chr(13),''),chr(10),'') as cust_en_name
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.edit_flg,chr(13),''),chr(10),'') as edit_flg
,replace(replace(t1.corp_addr,chr(13),''),chr(10),'') as corp_addr
,replace(replace(t1.charge_acct_num,chr(13),''),chr(10),'') as charge_acct_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail
,open_acct_tm
,final_update_tm
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.status_remark,chr(13),''),chr(10),'') as status_remark
,replace(replace(t1.orgnz_id,chr(13),''),chr(10),'') as orgnz_id
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,replace(replace(t1.lp_cert_type_cd,chr(13),''),chr(10),'') as lp_cert_type_cd
,replace(replace(t1.lp_cert_no,chr(13),''),chr(10),'') as lp_cert_no
,replace(replace(t1.lp_tel_num,chr(13),''),chr(10),'') as lp_tel_num
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.open_acct_brch_id,chr(13),''),chr(10),'') as open_acct_brch_id
,replace(replace(t1.open_acct_brac_id,chr(13),''),chr(10),'') as open_acct_brac_id
,replace(replace(t1.bus_belong_brac_id,chr(13),''),chr(10),'') as bus_belong_brac_id
,replace(replace(t1.open_acct_operr_id,chr(13),''),chr(10),'') as open_acct_operr_id
,replace(replace(t1.cash_ctrl_flg,chr(13),''),chr(10),'') as cash_ctrl_flg
,lp_cert_exp_dt
,replace(replace(t1.sup_chain_sys_flg,chr(13),''),chr(10),'') as sup_chain_sys_flg
,replace(replace(t1.sign_yqt_flg,chr(13),''),chr(10),'') as sign_yqt_flg
,sign_yqt_tm
,oa_wrtoff_tm
,replace(replace(t1.init_oa_id,chr(13),''),chr(10),'') as init_oa_id
,replace(replace(t1.oa_reim_rela_acct,chr(13),''),chr(10),'') as oa_reim_rela_acct
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg
,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
,create_dt
,update_dt

from ${iml_schema}.pty_tran_bank_corp_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_tran_bank_corp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
