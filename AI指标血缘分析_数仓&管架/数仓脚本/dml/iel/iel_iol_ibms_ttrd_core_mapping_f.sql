: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_core_mapping_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_core_mapping.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,subj_org_id
      ,replace(replace(subj_code,chr(13),''),chr(10),'') as subj_code
      ,replace(replace(subj_sub_code,chr(13),''),chr(10),'') as subj_sub_code
      ,replace(replace(core_acct_code,chr(13),''),chr(10),'') as core_acct_code
      ,replace(replace(core_acct_name,chr(13),''),chr(10),'') as core_acct_name
      ,replace(replace(currency,chr(13),''),chr(10),'') as currency
      ,replace(replace(inner_acct_sn,chr(13),''),chr(10),'') as inner_acct_sn
      ,core_id
      ,start_dt
      ,end_dt
      ,id_mark
  from ${iol_schema}.ibms_ttrd_core_mapping t1
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_core_mapping.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes