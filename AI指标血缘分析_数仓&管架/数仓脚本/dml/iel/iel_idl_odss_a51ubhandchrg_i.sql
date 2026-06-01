: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a51ubhandchrg_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a51ubhandchrg_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
trandate
,trantype
,tranflag
,brnnbr
,tranamt
,recvamt
,uniodate
,unionbr
,hostnbr
,hostdate
,status
,errcode
,errmsg
from ${idl_schema}.odss_a51ubhandchrg
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a51ubhandchrg_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes