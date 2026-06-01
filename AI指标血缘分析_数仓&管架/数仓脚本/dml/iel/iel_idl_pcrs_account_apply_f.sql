: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pcrs_account_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/account_apply_${batch_date}_all.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
serialno
,duebillno
,customerid
,customername
,accounttype
,businesscurrency
,businesssum
,balance
,applyexpain
,inputuserid
,inputorgid
,inputdate
,flag
,liquidatedsum
,newdate
,putoutno
from idl.pcrs_account_apply
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/account_apply_${batch_date}_all.dat" \
        charset=zhs16gbk
        safe=yes