: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_eifs_t00_party_pub_info_f
CreateDate: 20240507
FileName:   ${iel_data_path}/eifs_t00_party_pub_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_num,chr(13),''),chr(10),'') as cust_num
,replace(replace(t1.en_name,chr(13),''),chr(10),'') as en_name
,replace(replace(t1.short_name,chr(13),''),chr(10),'') as short_name
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t1.dom_forgn_cd,chr(13),''),chr(10),'') as dom_forgn_cd
,replace(replace(t1.farmer_flag,chr(13),''),chr(10),'') as farmer_flag
,replace(replace(t1.tax_pay_ctzn_idnt,chr(13),''),chr(10),'') as tax_pay_ctzn_idnt
,replace(replace(t1.addr_dist_cd,chr(13),''),chr(10),'') as addr_dist_cd
,replace(replace(t1.info_completed_flag,chr(13),''),chr(10),'') as info_completed_flag
,replace(replace(t1.info_isnull_reason,chr(13),''),chr(10),'') as info_isnull_reason
,replace(replace(t1.level_five_class_flag,chr(13),''),chr(10),'') as level_five_class_flag
,replace(replace(t1.level_five_class_dt,chr(13),''),chr(10),'') as level_five_class_dt
,replace(replace(t1.cust_open_dt,chr(13),''),chr(10),'') as cust_open_dt
,replace(replace(t1.agent_acct_open,chr(13),''),chr(10),'') as agent_acct_open
,replace(replace(t1.cust_status_cd,chr(13),''),chr(10),'') as cust_status_cd
,replace(replace(t1.close_dt,chr(13),''),chr(10),'') as close_dt
,replace(replace(t1.recommendation_type,chr(13),''),chr(10),'') as recommendation_type
,replace(replace(t1.recommendation_num,chr(13),''),chr(10),'') as recommendation_num
,replace(replace(t1.cust_mgr_num,chr(13),''),chr(10),'') as cust_mgr_num
,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'') as cust_mgr_name
,replace(replace(t1.mgmt_org_num,chr(13),''),chr(10),'') as mgmt_org_num
,replace(replace(t1.mgmt_team_num,chr(13),''),chr(10),'') as mgmt_team_num
,replace(replace(t1.create_te,chr(13),''),chr(10),'') as create_te
,replace(replace(t1.create_org,chr(13),''),chr(10),'') as create_org
,replace(replace(t1.init_system_id,chr(13),''),chr(10),'') as init_system_id
,t1.init_created_ts as init_created_ts
,t1.created_ts as created_ts
,t1.updated_ts as updated_ts
,replace(replace(t1.last_updated_te,chr(13),''),chr(10),'') as last_updated_te
,replace(replace(t1.last_updated_org,chr(13),''),chr(10),'') as last_updated_org
,replace(replace(t1.last_system_id,chr(13),''),chr(10),'') as last_system_id
,t1.last_updated_ts as last_updated_ts
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_sys_num,chr(13),''),chr(10),'') as src_sys_num
,replace(replace(t1.last_updated_src_sys_num,chr(13),''),chr(10),'') as last_updated_src_sys_num
,replace(replace(t1.cust_belong_org,chr(13),''),chr(10),'') as cust_belong_org
from ${iol_schema}.eifs_t00_party_pub_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_t00_party_pub_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes