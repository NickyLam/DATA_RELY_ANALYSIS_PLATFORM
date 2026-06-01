: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_msg_biz_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_msg_biz_acct_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
custid
,signedaccttype
,signedacct
,signedacctbr
,signedacctor
,status
,canceldate
,upddate
,opendate
,origin
,organ
,operator
,remark
from ${idl_schema}.odss_msg_biz_acct
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_msg_biz_acct_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes