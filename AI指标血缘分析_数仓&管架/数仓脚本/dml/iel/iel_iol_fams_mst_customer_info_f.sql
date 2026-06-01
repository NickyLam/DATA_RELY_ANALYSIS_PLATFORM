: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mst_customer_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_mst_customer_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(customer_id,chr(13),''),chr(10),'') as customer_id
      ,replace(replace(customer_name,chr(13),''),chr(10),'') as customer_name
      ,replace(replace(customer_abbr,chr(13),''),chr(10),'') as customer_abbr
      ,replace(replace(customer_type,chr(13),''),chr(10),'') as customer_type
      ,replace(replace(is_issuer,chr(13),''),chr(10),'') as is_issuer
      ,replace(replace(is_asste_manager,chr(13),''),chr(10),'') as is_asste_manager
      ,replace(replace(is_truster,chr(13),''),chr(10),'') as is_truster
      ,replace(replace(is_saler,chr(13),''),chr(10),'') as is_saler
      ,replace(replace(is_financier,chr(13),''),chr(10),'') as is_financier
      ,replace(replace(is_guarantee,chr(13),''),chr(10),'') as is_guarantee
      ,replace(replace(is_rating_agencies,chr(13),''),chr(10),'') as is_rating_agencies
      ,replace(replace(is_pledgor,chr(13),''),chr(10),'') as is_pledgor
      ,replace(replace(is_deposit_bank,chr(13),''),chr(10),'') as is_deposit_bank
      ,replace(replace(is_invest_adviser,chr(13),''),chr(10),'') as is_invest_adviser
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_mst_customer_info
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mst_customer_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes