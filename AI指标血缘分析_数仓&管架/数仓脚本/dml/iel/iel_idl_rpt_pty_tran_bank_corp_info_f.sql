: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_pty_tran_bank_corp_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_pty_tran_bank_corp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,party_id
,lp_id
,cust_cn_name
,cust_en_name
,cust_type_cd
,edit_flg
,corp_addr
,charge_acct_num
,curr_cd
,zip_cd
,tel_num
,fax
,e_mail
,open_acct_tm
,final_update_tm
,acct_status_cd
,status_remark
,orgnz_id
,legal_rep_name
,lp_cert_type_cd
,lp_cert_no
,lp_tel_num
,cust_mgr_id
,open_acct_brch_id
,open_acct_brac_id
,bus_belong_brac_id
,open_acct_operr_id
,cash_ctrl_flg
,lp_cert_exp_dt
,sup_chain_sys_flg
,sign_yqt_flg
,sign_yqt_tm
,oa_wrtoff_tm
,init_oa_id
,oa_reim_rela_acct from idl.rpt_pty_tran_bank_corp_info where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_pty_tran_bank_corp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes