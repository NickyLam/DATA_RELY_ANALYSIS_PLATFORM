: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mst_counter_party_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_mst_counter_party.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(counter_id,chr(13),''),chr(10),'') as counter_id
      ,replace(replace(counter_type,chr(13),''),chr(10),'') as counter_type
      ,replace(replace(counter_name,chr(13),''),chr(10),'') as counter_name
      ,replace(replace(link_id,chr(13),''),chr(10),'') as link_id
      ,replace(replace(manager_id,chr(13),''),chr(10),'') as manager_id
      ,replace(replace(head_bank,chr(13),''),chr(10),'') as head_bank
      ,replace(replace(contact,chr(13),''),chr(10),'') as contact
      ,replace(replace(contact_way,chr(13),''),chr(10),'') as contact_way
      ,replace(replace(remark,chr(13),''),chr(10),'') as remark
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,replace(replace(link_dept_code,chr(13),''),chr(10),'') as link_dept_code
      ,replace(replace(p_type_one,chr(13),''),chr(10),'') as p_type_one
      ,replace(replace(p_type_two,chr(13),''),chr(10),'') as p_type_two
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_mst_counter_party
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mst_counter_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes