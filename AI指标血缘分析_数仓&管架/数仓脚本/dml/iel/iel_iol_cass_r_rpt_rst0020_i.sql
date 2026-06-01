: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cass_r_rpt_rst0020_i
CreateDate: 20251013
FileName:   ${iel_data_path}/cass_r_rpt_rst0020.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,etl_dt_ora
,replace(replace(t1.kpi_code,chr(13),''),chr(10),'') as kpi_code
,replace(replace(t1.kpi_name,chr(13),''),chr(10),'') as kpi_name
,replace(replace(t1.accts_org_no,chr(13),''),chr(10),'') as accts_org_no
,replace(replace(t1.manager_org,chr(13),''),chr(10),'') as manager_org
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,kpi_value_m
,kpi_value_y

from ${iol_schema}.cass_r_rpt_rst0020 t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cass_r_rpt_rst0020.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
