: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_eifs_field_his_regist_info_i
CreateDate: 20220819
FileName:   ${iel_data_path}/eifs_field_his_regist_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.modify_his_id,chr(13),''),chr(10),'') as modify_his_id
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.cust_num,chr(13),''),chr(10),'') as cust_num
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.srv_seq_num,chr(13),''),chr(10),'') as srv_seq_num
    ,replace(replace(t.glob_seq_num,chr(13),''),chr(10),'') as glob_seq_num
    ,replace(replace(t.modify_time,chr(13),''),chr(10),'') as modify_time
    ,replace(replace(t.create_te,chr(13),''),chr(10),'') as create_te
    ,replace(replace(t.create_org,chr(13),''),chr(10),'') as create_org
    ,replace(replace(t.init_system_id,chr(13),''),chr(10),'') as init_system_id
    ,t.init_created_ts as init_created_ts
    ,t.created_ts as created_ts
    ,t.updated_ts as updated_ts
    ,replace(replace(t.last_updated_te,chr(13),''),chr(10),'') as last_updated_te
    ,replace(replace(t.last_updated_org,chr(13),''),chr(10),'') as last_updated_org
    ,replace(replace(t.last_system_id,chr(13),''),chr(10),'') as last_system_id
    ,t.last_updated_ts as last_updated_ts
 from iol.eifs_field_his_regist_info t
where to_char(last_updated_ts,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_field_his_regist_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes