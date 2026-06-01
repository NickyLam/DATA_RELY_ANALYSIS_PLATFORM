: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cass_r_rpt_rst0015_i
CreateDate: 20250102
FileName:   ${iel_data_path}/cass_r_rpt_rst0015.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
t1.etl_dt as etl_dt
,etl_dt_ora
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.curr_name,chr(13),''),chr(10),'') as curr_name
,replace(replace(t1.com_line,chr(13),''),chr(10),'') as com_line
,replace(replace(t1.com_line_name,chr(13),''),chr(10),'') as com_line_name
,replace(replace(t1.index_level1_class,chr(13),''),chr(10),'') as index_level1_class
,replace(replace(t1.index_level2_class,chr(13),''),chr(10),'') as index_level2_class
,replace(replace(t1.index_level3_class,chr(13),''),chr(10),'') as index_level3_class
,replace(replace(t1.std_pro_no,chr(13),''),chr(10),'') as std_pro_no
,replace(replace(t1.std_pro_name,chr(13),''),chr(10),'') as std_pro_name
,replace(replace(t1.manager_org,chr(13),''),chr(10),'') as manager_org
,replace(replace(t1.manager_org_name,chr(13),''),chr(10),'') as manager_org_name
,replace(replace(t1.cust_mgr_no,chr(13),''),chr(10),'') as cust_mgr_no
,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'') as cust_mgr_name
,kpi_value_y
,kpi_value_m
,kpi_value_yy
,kpi_value_mm
,kpi_value_yoy
,kpi_value_mom

from ${iol_schema}.cass_r_rpt_rst0015 t1
where etl_dt = (case when to_date('${batch_date}','yyyymmdd') = last_day(to_date('${batch_date}','yyyymmdd'))
						then to_date('${batch_date}','yyyymmdd')
					 else 
						trunc(to_date('${batch_date}','yyyymmdd'), 'mm') - 1
				end) " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cass_r_rpt_rst0015.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
