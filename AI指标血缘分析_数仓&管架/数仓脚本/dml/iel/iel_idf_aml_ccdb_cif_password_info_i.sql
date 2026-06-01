: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_ccdb_cif_password_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_ccdb_cif_password_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,id
,customer_no
,business_type
,password_type
,status
,update_date
,version
,card_no
,password
,from_channel
,verify_error_num
,verify_record_date
,start_dt
,end_dt
,id_mark
from idl.aml_ccdb_cif_password_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_ccdb_cif_password_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes