: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cass_r_rpt_rst0016_a
CreateDate: 20250305
FileName:   ${iel_data_path}/cass_r_rpt_rst0016.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="
select
	t1.etl_dt
	,etl_dt_ora
	,replace(replace(t1.com_line,chr(13),''),chr(10),'') as com_line
	,replace(replace(t1.manager_org,chr(13),''),chr(10),'') as manager_org
	,replace(replace(t1.std_prod_no,chr(13),''),chr(10),'') as std_prod_no
	,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
	,header_line_fee
	,header_other_fee
	,branch_line_fee
	,branch_other_fee
	,sub_team_fee
	,share_bal_avg_y

from ${iol_schema}.cass_r_rpt_rst0016 t1
where etl_dt <= to_date('${batch_date}', 'yyyymmdd') 
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cass_r_rpt_rst0016.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
