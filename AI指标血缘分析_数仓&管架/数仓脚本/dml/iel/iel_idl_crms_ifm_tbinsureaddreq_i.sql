: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbinsureaddreq_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbinsureaddreq_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
trans_date
,serial_no
,bank_no
,ta_code
,prd_code
,prd_add_code
,insure_vol
,insure_fee
,amt
,pay_type
,pay_year
,insure_year_type
,insure_year
,reserve1
,reserve2
from ${idl_schema}.crms_ifm_tbinsureaddreq
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbinsureaddreq_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes