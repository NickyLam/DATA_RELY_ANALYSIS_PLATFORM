: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_business_extension_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_business_extension_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 serialno
,relativeserialno
,transactionflag
,occurdate
,occurtime
,lastrate
,lastmaturity
,extensionsum
,lastsum
,extendtermyear
,extendtermmonth
,extendtermday
,extendrate
,extendmaturity
,voucherno
,orgid
,userid
,extendflag
,remark
from idl.ecrs_business_extension
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_business_extension_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes