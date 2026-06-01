: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cash_mgmt_bank_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cash_mgmt_bank_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.stl_center_acct_id,chr(13),''),chr(10),'') as stl_center_acct_id
,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,t1.open_dt as open_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t1.basic_acct_flg,chr(13),''),chr(10),'') as basic_acct_flg
,replace(replace(t1.open_bank_id,chr(13),''),chr(10),'') as open_bank_id
,replace(replace(t1.super_acct_id,chr(13),''),chr(10),'') as super_acct_id
,replace(replace(t1.bal_pay_attr_cd,chr(13),''),chr(10),'') as bal_pay_attr_cd
,replace(replace(t1.bank_intfc_id,chr(13),''),chr(10),'') as bank_intfc_id
,replace(replace(t1.super_acct_flg,chr(13),''),chr(10),'') as super_acct_flg
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,t1.oper_dt as oper_dt
,replace(replace(t1.priv_id,chr(13),''),chr(10),'') as priv_id
,t1.int_accr_start_dt as int_accr_start_dt
,t1.int_accr_exp_dt as int_accr_exp_dt
,t1.int_rat_fl_rt as int_rat_fl_rt
,replace(replace(t1.int_rat_float_flg,chr(13),''),chr(10),'') as int_rat_float_flg
,replace(replace(t1.int_accr_ped_cd,chr(13),''),chr(10),'') as int_accr_ped_cd
,replace(replace(t1.int_accr_day,chr(13),''),chr(10),'') as int_accr_day
,replace(replace(t1.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd
,t1.int_rat as int_rat
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,t1.exp_tenor as exp_tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.agree_cont_id,chr(13),''),chr(10),'') as agree_cont_id
,t1.agree_start_dt as agree_start_dt
,t1.agree_end_dt as agree_end_dt
,t1.agree_int_rat as agree_int_rat
,t1.agree_amt as agree_amt
,t1.acct_invalid_dt as acct_invalid_dt
,t1.acct_resume_dt as acct_resume_dt
,replace(replace(t1.cap_pool_acct_flg,chr(13),''),chr(10),'') as cap_pool_acct_flg
,t1.mini_guart_amt as mini_guart_amt
,replace(replace(t1.sign_acct_flg,chr(13),''),chr(10),'') as sign_acct_flg
,replace(replace(t1.group_id,chr(13),''),chr(10),'') as group_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_cash_mgmt_bank_acct t1
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cash_mgmt_bank_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes