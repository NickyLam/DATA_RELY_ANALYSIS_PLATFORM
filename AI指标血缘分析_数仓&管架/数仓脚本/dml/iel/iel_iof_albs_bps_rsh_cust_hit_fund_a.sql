: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_albs_bps_rsh_cust_hit_fund_a
CreateDate: 20240827
FileName:   ${iel_data_path}/albs_bps_rsh_cust_hit_fund.a.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.main_id,chr(13),''),chr(10),'') as main_id
,replace(replace(t1.own_org,chr(13),''),chr(10),'') as own_org
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.sch_result,chr(13),''),chr(10),'') as sch_result
,replace(replace(t1.match_level_id,chr(13),''),chr(10),'') as match_level_id
,replace(replace(t1.risk_level,chr(13),''),chr(10),'') as risk_level
,replace(replace(t1.list_scope,chr(13),''),chr(10),'') as list_scope
,replace(replace(t1.confirm_result,chr(13),''),chr(10),'') as confirm_result
,replace(replace(t1.last_confirm_result,chr(13),''),chr(10),'') as last_confirm_result
,replace(replace(t1.crt_date,chr(13),''),chr(10),'') as crt_date
,replace(replace(t1.crt_datetime,chr(13),''),chr(10),'') as crt_datetime
,replace(replace(t1.last_datetime,chr(13),''),chr(10),'') as last_datetime
,replace(replace(t1.last_user_id,chr(13),''),chr(10),'') as last_user_id
,replace(replace(t1.last_user_code,chr(13),''),chr(10),'') as last_user_code
,replace(replace(t1.system_id,chr(13),''),chr(10),'') as system_id
,replace(replace(t1.cust_code,chr(13),''),chr(10),'') as cust_code
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.cust_kind,chr(13),''),chr(10),'') as cust_kind
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_eng_name,chr(13),''),chr(10),'') as cust_eng_name
,replace(replace(t1.cust_addr,chr(13),''),chr(10),'') as cust_addr
,replace(replace(t1.cust_eng_addr,chr(13),''),chr(10),'') as cust_eng_addr
,replace(replace(t1.cust_id_type,chr(13),''),chr(10),'') as cust_id_type
,replace(replace(t1.cust_id_no,chr(13),''),chr(10),'') as cust_id_no
,replace(replace(t1.cust_country,chr(13),''),chr(10),'') as cust_country
,replace(replace(t1.crt_user_code,chr(13),''),chr(10),'') as crt_user_code
,replace(replace(t1.crt_branch_code,chr(13),''),chr(10),'') as crt_branch_code
,replace(replace(t1.last_branch_id,chr(13),''),chr(10),'') as last_branch_id
,replace(replace(t1.last_txn,chr(13),''),chr(10),'') as last_txn
,replace(replace(t1.sch_kind,chr(13),''),chr(10),'') as sch_kind
,replace(replace(t1.backfiels1,chr(13),''),chr(10),'') as backfiels1
,replace(replace(t1.backfiels2,chr(13),''),chr(10),'') as backfiels2
,replace(replace(t1.backfiels3,chr(13),''),chr(10),'') as backfiels3
,replace(replace(t1.confirm_desc,chr(13),''),chr(10),'') as confirm_desc
,replace(replace(t1.cust_check_pass,chr(13),''),chr(10),'') as cust_check_pass
,replace(replace(t1.check_pass_flag,chr(13),''),chr(10),'') as check_pass_flag

from ${iol_schema}.albs_bps_rsh_cust_hit_fund t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/albs_bps_rsh_cust_hit_fund.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
