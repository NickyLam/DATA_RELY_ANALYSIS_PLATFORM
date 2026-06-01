: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_credit_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_credit_base_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,branch_id
,credit_no
,credit_type
,busi_type
,prod_info_id
,sub_key1
,sub_key2
,busi_no_type
,busi_no
,use_type
,credit_status
,up_credit_id
,credit_number
from ${idl_schema}.odss_credit_base_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_credit_base_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes