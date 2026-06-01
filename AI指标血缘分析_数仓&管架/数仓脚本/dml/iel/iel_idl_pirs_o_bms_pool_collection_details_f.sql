: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_bms_pool_collection_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_bms_pool_collection_details_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
,business_no
,bacth_id
,draft_id
,account_status
,colle_date
,account_amount
,field1
,field2
,field3
,status
,storage_id from idl.pirs_o_bms_pool_collection_details where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_bms_pool_collection_details_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes