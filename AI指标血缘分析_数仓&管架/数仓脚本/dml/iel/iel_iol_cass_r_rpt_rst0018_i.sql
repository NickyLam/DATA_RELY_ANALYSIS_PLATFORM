: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cass_r_rpt_rst0018_i
CreateDate: 20250711
FileName:   ${iel_data_path}/cass_r_rpt_rst0018.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,etl_dt_ora
,replace(replace(t1.index_name,chr(13),''),chr(10),'') as index_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.curr_name,chr(13),''),chr(10),'') as curr_name
,replace(replace(t1.manager_org,chr(13),''),chr(10),'') as manager_org
,replace(replace(t1.manager_org_name,chr(13),''),chr(10),'') as manager_org_name
,kpi_value_mm
,kpi_value_mom

from ${iol_schema}.cass_r_rpt_rst0018 t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cass_r_rpt_rst0018.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
