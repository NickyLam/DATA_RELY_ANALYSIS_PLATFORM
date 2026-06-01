: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_credit_principal_i
CreateDate: 20180529
FileName:   ${iel_data_path}/credit_principal_${batch_date}_all.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 duebillserialno
,businesscurrency
,principalsum
,principaldate
,billtype
,attribute1
,attribute2
,attribute3
,attribute4
from idl.ecrs_credit_principal
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/credit_principal_${batch_date}_all.dat" \
        charset=zhs16gbk
        safe=yes