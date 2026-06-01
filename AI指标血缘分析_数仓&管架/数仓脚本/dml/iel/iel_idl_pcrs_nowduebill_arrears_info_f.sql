: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pcrs_nowduebill_arrears_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nowduebill_arrears_info_${batch_date}_all.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
balanceserialno
,duebillno
,duebillflag
,balancemoduletype
,arrearsdate
,arrearssum
,currentbalance
,interesttype
from idl.pcrs_nowduebill_arrears_info
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/nowduebill_arrears_info_${batch_date}_all.dat" \
        charset=zhs16gbk
        safe=yes