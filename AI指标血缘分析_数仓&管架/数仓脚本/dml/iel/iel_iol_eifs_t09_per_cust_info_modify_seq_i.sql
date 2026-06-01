: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eifs_t09_per_cust_info_modify_seq_i
CreateDate: 20180529
FileName:   ${iel_data_path}/eifs_t09_per_cust_info_modify_seq.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cust_oper_type,chr(13),''),chr(10),'') as cust_oper_type
,replace(replace(t1.srv_seq_num,chr(13),''),chr(10),'') as srv_seq_num
,replace(replace(t1.glob_seq_num,chr(13),''),chr(10),'') as glob_seq_num
,replace(replace(t1.cust_num,chr(13),''),chr(10),'') as cust_num
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.tab_name,chr(13),''),chr(10),'') as tab_name
,replace(replace(t1.key_id,chr(13),''),chr(10),'') as key_id
,replace(replace(t1.col_name,chr(13),''),chr(10),'') as col_name
,replace(replace(t1.col_chn_name,chr(13),''),chr(10),'') as col_chn_name
,replace(replace(t1.before_change,chr(13),''),chr(10),'') as before_change
,replace(replace(t1.now_value,chr(13),''),chr(10),'') as now_value
,replace(replace(t1.last_updated_te,chr(13),''),chr(10),'') as last_updated_te
,replace(replace(t1.last_updated_org,chr(13),''),chr(10),'') as last_updated_org
,replace(replace(t1.last_system_id,chr(13),''),chr(10),'') as last_system_id
,t1.last_updated_ts as last_updated_ts
from ${iol_schema}.eifs_t09_per_cust_info_modify_seq t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_t09_per_cust_info_modify_seq.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes