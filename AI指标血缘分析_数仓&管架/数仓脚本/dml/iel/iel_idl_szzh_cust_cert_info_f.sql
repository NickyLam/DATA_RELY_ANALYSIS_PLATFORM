: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_szzh_cust_cert_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/671313584012014${batch_date}00000001.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select doc_rec
from idl.szzh_cust_cert_info where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/671313584012014${batch_date}00000001.dat" \
        charset=zhs16gbk
        safe=yes