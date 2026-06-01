: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_o_cbs_kdb_xyrt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_o_cbs_kdb_xyrt_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
acctid
,bgindt
,edindt
,instrt
,inptdt
,inptsq
,acctno
,subsac
,crcycd
from idl.irrs_o_cbs_kdb_xyrt
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_o_cbs_kdb_xyrt_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes