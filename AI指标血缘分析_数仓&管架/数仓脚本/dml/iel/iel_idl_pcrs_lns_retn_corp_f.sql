: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pcrs_lns_retn_corp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/lns_retn_corp_${batch_date}_all.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
cmsqno
,lncfno
,accrbl
,corpam
,adjutp
,newtrm
,trandt
,recvtm
,transt
,dfltam
from idl.pcrs_lns_retn_corp
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/lns_retn_corp_${batch_date}_all.dat" \
        charset=zhs16gbk
        safe=yes