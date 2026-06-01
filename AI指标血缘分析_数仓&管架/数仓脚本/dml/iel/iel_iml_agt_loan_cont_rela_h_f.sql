: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_cont_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_cont_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
      ,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
      ,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
      ,replace(replace(t1.rela_cont_type,chr(13),''),chr(10),'') as rela_cont_type
      ,replace(replace(t1.rela_cont_id,chr(13),''),chr(10),'') as rela_cont_id
      ,rela_amt
      ,replace(replace(t1.rela_status_cd,chr(13),''),chr(10),'') as rela_status_cd
      ,replace(replace(t1.matn_flg_cd,chr(13),''),chr(10),'') as matn_flg_cd
      ,start_dt
      ,end_dt
      ,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iml_schema}.agt_loan_cont_rela_h t1
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_cont_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes