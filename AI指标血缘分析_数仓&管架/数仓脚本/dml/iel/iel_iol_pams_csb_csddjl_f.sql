: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_csb_csddjl_f
CreateDate: 20240315
FileName:   ${iel_data_path}/pams_csb_csddjl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,csqsrq
,csjsrq
,csts

from ${iol_schema}.pams_csb_csddjl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_csb_csddjl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
