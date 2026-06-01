: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_dfcls_credit_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_dfcls_credit_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,draft_class
,brcode
,used_amt
,pre_amt
,misc
,last_upd_oper_id
,last_upd_time
from ${idl_schema}.odss_dfcls_credit
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_dfcls_credit_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes