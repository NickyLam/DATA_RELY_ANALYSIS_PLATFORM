: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_deal_pledge_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_fin_deal_pledge.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(finprod_id,chr(13),''),chr(10),'') as finprod_id
      ,branch
      ,replace(replace(pledge_finprod_id,chr(13),''),chr(10),'') as pledge_finprod_id
      ,pledge_face_value
      ,pledge_number
      ,pledge_ratio
      ,pledge_amt
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_fin_deal_pledge
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_deal_pledge.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes