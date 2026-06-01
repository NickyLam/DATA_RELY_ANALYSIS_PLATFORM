: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_fixedterm_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_fixedterm_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,acct_id
      ,replace(replace(acct_code,chr(13),''),chr(10),'') as acct_code
      ,replace(replace(acct_name,chr(13),''),chr(10),'') as acct_name
      ,replace(replace(bank_code,chr(13),''),chr(10),'') as bank_code
      ,replace(replace(bank_name,chr(13),''),chr(10),'') as bank_name
      ,i_id
      ,party_id
      ,replace(replace(core_acct_code,chr(13),''),chr(10),'') as core_acct_code
      ,replace(replace(core_acct_name,chr(13),''),chr(10),'') as core_acct_name
      ,replace(replace(currency,chr(13),''),chr(10),'') as currency
      ,acct_type
      ,status
      ,update_user
      ,replace(replace(update_time,chr(13),''),chr(10),'') as update_time
      ,start_dt
      ,end_dt
      ,id_mark
  from ${iol_schema}.ibms_ttrd_fixedterm_account t1
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_fixedterm_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes