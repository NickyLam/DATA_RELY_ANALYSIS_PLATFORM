: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_svss_bussiness_info_statistics_f
CreateDate: 20180529
FileName:   ${iel_data_path}/svss_bussiness_info_statistics.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.id as id
,t1.txn_dt as txn_dt
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
,t1.txn_amt as txn_amt
,t1.etl_dt_ora as etl_dt_ora
,replace(replace(t1.menuid,chr(13),''),chr(10),'') as menuid
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.svss_bussiness_info_statistics t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/svss_bussiness_info_statistics.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes