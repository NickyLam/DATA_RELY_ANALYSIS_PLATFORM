: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_cms_union_accept_f
CreateDate: 20250617
FileName:   ${iel_data_path}/amss_cms_union_accept.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,data_num
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.cust_num,chr(13),''),chr(10),'') as cust_num
,replace(replace(t1.cust_account,chr(13),''),chr(10),'') as cust_account
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.partner_name,chr(13),''),chr(10),'') as partner_name
,stat_cycle
,stat_cycle_tra_money
,stat_cycle_tra_count
,perk
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,create_user
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,create_time
,update_time
,physics_flag
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.account_type,chr(13),''),chr(10),'') as account_type
,term_count
,partner_dt
,is_rural
,replace(replace(t1.account_num,chr(13),''),chr(10),'') as account_num

from ${iol_schema}.amss_cms_union_accept t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_cms_union_accept.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
