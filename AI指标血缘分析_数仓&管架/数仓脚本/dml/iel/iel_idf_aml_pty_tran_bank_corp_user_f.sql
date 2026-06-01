: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_pty_tran_bank_corp_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_pty_tran_bank_corp_user.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,user_id
,lp_id
,user_login_id
,user_name
,open_acct_dt
,clos_acct_dt
,e_mail
,tel_num
,mobile_no
,acct_status_cd
,gender_cd
,senti_cd
,admin_flg
,user_lab_remark
,user_froz_status_flg
,user_pause_status_cd
,user_froz_dt
,user_pause_dt
,resv_addr
,hp_id
,operr_auth_status_cd
,wx_sign_status_flg
,recver_name_diplay_way_cd
,lp_cert_exp_nr_cert_no
,corp_cert_exp_nr_cert_no
,acct_num_exp_nr_acct_num
,ss_yqt_func_flg
,onl_bank_user_flg
,mobile_no_bind_flg
,choice_not_bind_flg
,oa_admin_flg
,init_oa_user_id from idl.aml_pty_tran_bank_corp_user where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_pty_tran_bank_corp_user.f.${batch_date}.dat" \
        charset=utf8
        safe=yes