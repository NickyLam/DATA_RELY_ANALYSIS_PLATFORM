: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_sgdr_dxlcbotcp_flow_i
CreateDate: 20250604
FileName:   ${iel_data_path}/pams_sgdr_dxlcbotcp_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,tjksrq
,replace(replace(t1.cpdm,chr(13),''),chr(10),'') as cpdm
,xssxfzsbl
,glfzsfcbl

from ${iol_schema}.pams_sgdr_dxlcbotcp_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_sgdr_dxlcbotcp_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
