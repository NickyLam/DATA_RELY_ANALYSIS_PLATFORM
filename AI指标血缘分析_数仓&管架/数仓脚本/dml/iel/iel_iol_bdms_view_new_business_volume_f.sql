: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_view_new_business_volume_f
CreateDate: 20250828
FileName:   ${iel_data_path}/bdms_view_new_business_volume.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,txn_dt
,replace(replace(t1.txn_tm,chr(13),''),chr(10),'') as txn_tm
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.oper_teller_name,chr(13),''),chr(10),'') as oper_teller_name
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.auth_teller_name,chr(13),''),chr(10),'') as auth_teller_name
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_desc,chr(13),''),chr(10),'') as txn_desc
,replace(replace(t1.biz_sys_evt_id,chr(13),''),chr(10),'') as biz_sys_evt_id
,replace(replace(t1.bcs_evt_id,chr(13),''),chr(10),'') as bcs_evt_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.pay_agt_id,chr(13),''),chr(10),'') as pay_agt_id
,replace(replace(t1.rcv_agt_id,chr(13),''),chr(10),'') as rcv_agt_id
,txn_amt
,replace(replace(t1.etl_dt_ora,chr(13),''),chr(10),'') as etl_dt_ora
,replace(replace(t1.menuid,chr(13),''),chr(10),'') as menuid
,replace(replace(t1.eft_flag,chr(13),''),chr(10),'') as eft_flag
,replace(replace(t1.serv_flag,chr(13),''),chr(10),'') as serv_flag
,replace(replace(t1.acct_flag,chr(13),''),chr(10),'') as acct_flag
,replace(replace(t1.ca_flag,chr(13),''),chr(10),'') as ca_flag
,replace(replace(t1.bd_flag,chr(13),''),chr(10),'') as bd_flag
,replace(replace(t1.start_tm,chr(13),''),chr(10),'') as start_tm
,replace(replace(t1.end_tm,chr(13),''),chr(10),'') as end_tm
,replace(replace(t1.role_name,chr(13),''),chr(10),'') as role_name

from ${iol_schema}.bdms_view_new_business_volume t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_view_new_business_volume.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
