: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_t_exch_merchant_user_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_t_exch_merchant_user_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,merchant_no
,merchant_name
,information_id
,merchant_path
,is_valid
,branch_no
,operator_id
,operator_date
,accept_org_no
,account_no
,region
,expand_1
,expand_2
,expand_3
,expand_4
,expand_5
from ${idl_schema}.odss_t_exch_merchant_user
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_t_exch_merchant_user_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes