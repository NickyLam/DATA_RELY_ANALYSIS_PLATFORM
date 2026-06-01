: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_bdms_branch_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_bdms_branch_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.id
,t1.brh_no
,t1.brh_name
,t1.brh_class
,t1.bln_up_brh_id
,t1.tele_no
,t1.address
,t1.postno
,t1.other_area_flag
,t1.ip
,t1.status
,t1.effect_date
,t1.expire_date
,t1.brh_type
,t1.brh_attr
,t1.brh_manage_type
,t1.bln_brh_no
,t1.ubank_no
,t1.acct_brh_id
,t1.acct_brh_name
,t1.bop_financ_org_code
,t1.last_upd_oper_id
,t1.last_upd_time
,t1.cert_bind_status
,t1.bln_brh_rep_no
,t1.bank_account
,t1.inner_user_account
,t1.inner_user_name
,t1.tuo_shou_account
,t1.sp_account
,t1.sp_name
,t1.is_same_trade
,t1.online_flag
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_bdms_branch_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_bdms_branch_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes