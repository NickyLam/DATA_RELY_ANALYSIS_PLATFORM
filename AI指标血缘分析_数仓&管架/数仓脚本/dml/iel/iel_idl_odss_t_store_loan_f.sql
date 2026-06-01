: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_t_store_loan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_t_store_loan_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select serialno
   ,businesstype
   ,direction
   ,vouchtype
   ,classifyresulteleven
from ${idl_schema}.odss_t_store_loan
where etl_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_t_store_loan_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes