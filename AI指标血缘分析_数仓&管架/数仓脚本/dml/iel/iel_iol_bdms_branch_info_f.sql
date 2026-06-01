: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_branch_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_branch_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.brh_no,chr(13),''),chr(10),'') as brh_no
,replace(replace(t.brh_name,chr(13),''),chr(10),'') as brh_name
,replace(replace(t.brh_class,chr(13),''),chr(10),'') as brh_class
,t.bln_up_brh_id as bln_up_brh_id
,replace(replace(t.tele_no,chr(13),''),chr(10),'') as tele_no
,replace(replace(t.address,chr(13),''),chr(10),'') as address
,replace(replace(t.postno,chr(13),''),chr(10),'') as postno
,replace(replace(t.other_area_flag,chr(13),''),chr(10),'') as other_area_flag
,replace(replace(t.ip,chr(13),''),chr(10),'') as ip
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.effect_date,chr(13),''),chr(10),'') as effect_date
,replace(replace(t.expire_date,chr(13),''),chr(10),'') as expire_date
,replace(replace(t.brh_type,chr(13),''),chr(10),'') as brh_type
,replace(replace(t.brh_attr,chr(13),''),chr(10),'') as brh_attr
,replace(replace(t.brh_manage_type,chr(13),''),chr(10),'') as brh_manage_type
,t.bln_brh_no as bln_brh_no
,replace(replace(t.ubank_no,chr(13),''),chr(10),'') as ubank_no
,t.acct_brh_id as acct_brh_id
,replace(replace(t.acct_brh_name,chr(13),''),chr(10),'') as acct_brh_name
,replace(replace(t.bop_financ_org_code,chr(13),''),chr(10),'') as bop_financ_org_code
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.cert_bind_status,chr(13),''),chr(10),'') as cert_bind_status
,t.bln_brh_rep_no as bln_brh_rep_no
,replace(replace(t.bank_account,chr(13),''),chr(10),'') as bank_account
,replace(replace(t.inner_user_account,chr(13),''),chr(10),'') as inner_user_account
,replace(replace(t.inner_user_name,chr(13),''),chr(10),'') as inner_user_name
,replace(replace(t.tuo_shou_account,chr(13),''),chr(10),'') as tuo_shou_account
,replace(replace(t.sp_account,chr(13),''),chr(10),'') as sp_account
,replace(replace(t.sp_name,chr(13),''),chr(10),'') as sp_name
,replace(replace(t.is_same_trade,chr(13),''),chr(10),'') as is_same_trade
,replace(replace(t.online_flag,chr(13),''),chr(10),'') as online_flag
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_branch_info t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_branch_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes