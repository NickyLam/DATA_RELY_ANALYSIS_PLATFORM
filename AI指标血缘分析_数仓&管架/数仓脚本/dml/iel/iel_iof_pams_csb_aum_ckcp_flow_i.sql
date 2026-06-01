: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_csb_aum_ckcp_flow_i
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_csb_aum_ckcp_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.cplx,chr(13),''),chr(10),'') as cplx

from ${iol_schema}.pams_csb_aum_ckcp_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_csb_aum_ckcp_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
