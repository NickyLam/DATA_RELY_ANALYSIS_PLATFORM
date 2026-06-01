: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mst_bond_valuation_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_mst_bond_valuation_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(sec_id,chr(13),''),chr(10),'') as sec_id
      ,value_date
      ,replace(replace(value_source,chr(13),''),chr(10),'') as value_source
      ,last_period
      ,price
      ,netprice
      ,m_duration
      ,m_convexity
      ,bpvalue
      ,sduration
      ,scnvxty
      ,interest_duration
      ,interest_cnvxty
      ,bpyield
      ,replace(replace(input_type,chr(13),''),chr(10),'') as input_type
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,mbpvalue
      ,var
      ,cvar
      ,mduration
      ,replace(replace(implicit_grade,chr(13),''),chr(10),'') as implicit_grade
      ,replace(replace(implicit_hgrade,chr(13),''),chr(10),'') as implicit_hgrade
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_mst_bond_valuation_info
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mst_bond_valuation_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes