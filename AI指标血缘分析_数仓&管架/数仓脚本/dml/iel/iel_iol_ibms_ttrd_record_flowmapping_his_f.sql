: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_record_flowmapping_his_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_record_flowmapping_his.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(sendflow_no,chr(13),''),chr(10),'') as sendflow_no
      ,replace(replace(flow_no,chr(13),''),chr(10),'') as flow_no
      ,replace(replace(hostflow_no,chr(13),''),chr(10),'') as hostflow_no
      ,is_erase
      ,state
      ,replace(replace(ref_sendflow_no,chr(13),''),chr(10),'') as ref_sendflow_no
      ,replace(replace(batch_no,chr(13),''),chr(10),'') as batch_no
      ,opt_type
      ,his_flag
      ,replace(replace(business_date,chr(13),''),chr(10),'') as business_date
  from ${iol_schema}.ibms_ttrd_record_flowmapping_his t1
 where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_record_flowmapping_his.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes