: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mst_bond_credit_rating_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_mst_bond_credit_rating.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(sec_id,chr(13),''),chr(10),'') as sec_id
      ,replace(replace(grade_org_id,chr(13),''),chr(10),'') as grade_org_id
      ,grade_date
      ,replace(replace(grade_type,chr(13),''),chr(10),'') as grade_type
      ,replace(replace(short_long_term,chr(13),''),chr(10),'') as short_long_term
      ,replace(replace(grade_result,chr(13),''),chr(10),'') as grade_result
      ,replace(replace(sec_issue_id,chr(13),''),chr(10),'') as sec_issue_id
      ,replace(replace(input_type,chr(13),''),chr(10),'') as input_type
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,replace(replace(is_recommand,chr(13),''),chr(10),'') as is_recommand
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_mst_bond_credit_rating
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mst_bond_credit_rating.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes