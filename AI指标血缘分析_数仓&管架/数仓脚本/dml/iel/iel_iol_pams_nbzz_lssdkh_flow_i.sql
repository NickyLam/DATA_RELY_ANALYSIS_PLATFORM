: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_lssdkh_flow_i
CreateDate: 20250729
FileName:   ${iel_data_path}/pams_nbzz_lssdkh_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.ztbs,chr(13),''),chr(10),'') as ztbs

from ${iol_schema}.pams_nbzz_lssdkh_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_lssdkh_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
