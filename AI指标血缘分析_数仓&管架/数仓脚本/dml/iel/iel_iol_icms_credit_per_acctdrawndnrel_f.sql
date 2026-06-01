: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_credit_per_acctdrawndnrel_f
CreateDate: 20250114
FileName:   ${iel_data_path}/icms_credit_per_acctdrawndnrel.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,acctcode
,drawndnseqno

from ${iol_schema}.icms_credit_per_acctdrawndnrel t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit_per_acctdrawndnrel.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
