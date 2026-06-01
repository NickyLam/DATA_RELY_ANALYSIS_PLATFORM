: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_sys_datadict_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_sys_datadict.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(dict_code,chr(13),''),chr(10),'') as dict_code
      ,replace(replace(system_code,chr(13),''),chr(10),'') as system_code
      ,replace(replace(dict_cnname,chr(13),''),chr(10),'') as dict_cnname
      ,replace(replace(dict_enname,chr(13),''),chr(10),'') as dict_enname
      ,replace(replace(update_flg,chr(13),''),chr(10),'') as update_flg
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_sys_datadict
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_sys_datadict.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes