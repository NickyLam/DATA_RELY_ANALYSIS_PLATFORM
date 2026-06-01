: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_a_d_cm_currency_dt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_a_d_cm_currency_dt_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select curr_code
,curr_name
,curr_sign
from idl.orws_a_d_cm_currency_dt where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_a_d_cm_currency_dt_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes