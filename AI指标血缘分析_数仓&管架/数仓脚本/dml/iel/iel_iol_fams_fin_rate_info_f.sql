: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_rate_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_fin_rate_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(cash_id,chr(13),''),chr(10),'') as cash_id
      ,eff_date
      ,replace(replace(int_type,chr(13),''),chr(10),'') as int_type
      ,replace(replace(basis,chr(13),''),chr(10),'') as basis
      ,replace(replace(reset_type,chr(13),''),chr(10),'') as reset_type
      ,replace(replace(reset_freq,chr(13),''),chr(10),'') as reset_freq
      ,first_reset_date
      ,replace(replace(reset_date,chr(13),''),chr(10),'') as reset_date
      ,observe_bef_day
      ,replace(replace(observe_bef_unit,chr(13),''),chr(10),'') as observe_bef_unit
      ,rate
      ,coefficient
      ,spread_rate
      ,highest_rate
      ,lowest_rate
      ,replace(replace(benchmark_id,chr(13),''),chr(10),'') as benchmark_id
      ,replace(replace(benchmark_type,chr(13),''),chr(10),'') as benchmark_type
      ,replace(replace(finprod_id,chr(13),''),chr(10),'') as finprod_id
      ,branch
      ,replace(replace(finprod_type,chr(13),''),chr(10),'') as finprod_type
      ,replace(replace(finprod_type2,chr(13),''),chr(10),'') as finprod_type2
      ,replace(replace(remark,chr(13),''),chr(10),'') as remark
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,first_confirm_date
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_fin_rate_info
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_rate_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes