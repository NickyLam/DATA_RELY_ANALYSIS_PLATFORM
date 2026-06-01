: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_tran_bank_corp_user_f
CreateDate: 20230828
FileName:   ${iel_data_path}/pty_tran_bank_corp_user.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.user_login_id,chr(13),''),chr(10),'') as user_login_id
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,open_acct_dt
,clos_acct_dt
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t1.senti_cd,chr(13),''),chr(10),'') as senti_cd
,replace(replace(t1.admin_flg,chr(13),''),chr(10),'') as admin_flg
,replace(replace(t1.user_lab_remark,chr(13),''),chr(10),'') as user_lab_remark
,replace(replace(t1.user_froz_status_flg,chr(13),''),chr(10),'') as user_froz_status_flg
,replace(replace(t1.user_pause_status_cd,chr(13),''),chr(10),'') as user_pause_status_cd
,user_froz_dt
,user_pause_dt
,replace(replace(t1.resv_addr,chr(13),''),chr(10),'') as resv_addr
,replace(replace(t1.hp_id,chr(13),''),chr(10),'') as hp_id
,replace(replace(t1.operr_auth_status_cd,chr(13),''),chr(10),'') as operr_auth_status_cd
,replace(replace(t1.wx_sign_status_flg,chr(13),''),chr(10),'') as wx_sign_status_flg
,replace(replace(t1.recver_name_diplay_way_cd,chr(13),''),chr(10),'') as recver_name_diplay_way_cd
,replace(replace(t1.lp_cert_exp_nr_cert_no,chr(13),''),chr(10),'') as lp_cert_exp_nr_cert_no
,replace(replace(t1.corp_cert_exp_nr_cert_no,chr(13),''),chr(10),'') as corp_cert_exp_nr_cert_no
,replace(replace(t1.acct_num_exp_nr_acct_num,chr(13),''),chr(10),'') as acct_num_exp_nr_acct_num
,replace(replace(t1.ss_yqt_func_flg,chr(13),''),chr(10),'') as ss_yqt_func_flg
,replace(replace(t1.onl_bank_user_flg,chr(13),''),chr(10),'') as onl_bank_user_flg
,replace(replace(t1.mobile_no_bind_flg,chr(13),''),chr(10),'') as mobile_no_bind_flg
,replace(replace(t1.choice_not_bind_flg,chr(13),''),chr(10),'') as choice_not_bind_flg
,replace(replace(t1.oa_admin_flg,chr(13),''),chr(10),'') as oa_admin_flg
,replace(replace(t1.init_oa_user_id,chr(13),''),chr(10),'') as init_oa_user_id
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,create_dt
,update_dt

from ${iml_schema}.pty_tran_bank_corp_user t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_tran_bank_corp_user.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
