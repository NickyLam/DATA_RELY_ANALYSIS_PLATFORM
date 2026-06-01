: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_bal_table_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_bok_bal_table_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(seq_no,chr(13),''),chr(10),'') as seq_no
      ,replace(replace(o_ccy,chr(13),''),chr(10),'') as o_ccy
      ,replace(replace(o_open_bal_flag,chr(13),''),chr(10),'') as o_open_bal_flag
      ,o_open_balance
      ,o_happen_amt_d
      ,o_happen_amt_c
      ,replace(replace(o_end_bal_flag,chr(13),''),chr(10),'') as o_end_bal_flag
      ,o_end_balance
      ,replace(replace(b_open_bal_flag,chr(13),''),chr(10),'') as b_open_bal_flag
      ,b_open_balance
      ,b_happen_amt_d
      ,b_happen_amt_c
      ,replace(replace(b_end_bal_flag,chr(13),''),chr(10),'') as b_end_bal_flag
      ,b_end_balance
      ,replace(replace(bookset_id,chr(13),''),chr(10),'') as bookset_id
      ,replace(replace(bookset_name,chr(13),''),chr(10),'') as bookset_name
      ,bal_date
      ,replace(replace(subject_no,chr(13),''),chr(10),'') as subject_no
      ,replace(replace(subject_name,chr(13),''),chr(10),'') as subject_name
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_bok_bal_table_data
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_bal_table_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes