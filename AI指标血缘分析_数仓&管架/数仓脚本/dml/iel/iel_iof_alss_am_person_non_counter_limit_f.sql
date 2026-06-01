: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_alss_am_person_non_counter_limit_f
CreateDate: 20250212
FileName:   ${iel_data_path}/alss_am_person_non_counter_limit.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.apply_status,chr(13),''),chr(10),'') as apply_status
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.pre_proc_id,chr(13),''),chr(10),'') as pre_proc_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.create_organ,chr(13),''),chr(10),'') as create_organ
,replace(replace(t1.create_user_teller_id,chr(13),''),chr(10),'') as create_user_teller_id
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,replace(replace(t1.cust_mgr_teller_id,chr(13),''),chr(10),'') as cust_mgr_teller_id
,replace(replace(t1.cust_mgr_deal_time,chr(13),''),chr(10),'') as cust_mgr_deal_time
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.check_time,chr(13),''),chr(10),'') as check_time
,replace(replace(t1.non_counter_limit,chr(13),''),chr(10),'') as non_counter_limit
,replace(replace(t1.person_non_counter_day_limit,chr(13),''),chr(10),'') as person_non_counter_day_limit
,replace(replace(t1.person_non_counter_day_count,chr(13),''),chr(10),'') as person_non_counter_day_count
,replace(replace(t1.person_non_counter_year_limit,chr(13),''),chr(10),'') as person_non_counter_year_limit
,replace(replace(t1.data_status,chr(13),''),chr(10),'') as data_status
,replace(replace(t1.apply_id,chr(13),''),chr(10),'') as apply_id
,replace(replace(t1.cust_mgr_organ,chr(13),''),chr(10),'') as cust_mgr_organ
,replace(replace(t1.check_organ,chr(13),''),chr(10),'') as check_organ
,replace(replace(t1.check_info,chr(13),''),chr(10),'') as check_info
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.card_class,chr(13),''),chr(10),'') as card_class
,replace(replace(t1.paper_no,chr(13),''),chr(10),'') as paper_no
,replace(replace(t1.paper_type,chr(13),''),chr(10),'') as paper_type

from ${iol_schema}.alss_am_person_non_counter_limit t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_am_person_non_counter_limit.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
