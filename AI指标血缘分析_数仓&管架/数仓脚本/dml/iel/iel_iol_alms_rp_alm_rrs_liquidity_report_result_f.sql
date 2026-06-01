: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alms_rp_alm_rrs_liquidity_report_result_f
CreateDate: 20240126
FileName:   ${iel_data_path}/alms_rp_alm_rrs_liquidity_report_result.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.v_rep_cd,chr(13),''),chr(10),'') as v_rep_cd
,v_rep_line_order
,n_rep_line_cd
,replace(replace(t1.v_rep_line_name,chr(13),''),chr(10),'') as v_rep_line_name
,v_rep_line_display_order
,n_bold_ind
,n_indent_level
,replace(replace(t1.v_regulatory_level,chr(13),''),chr(10),'') as v_regulatory_level
,replace(replace(t1.v_index_class,chr(13),''),chr(10),'') as v_index_class
,replace(replace(t1.v_supervision_require,chr(13),''),chr(10),'') as v_supervision_require
,replace(replace(t1.v_limit_value,chr(13),''),chr(10),'') as v_limit_value
,replace(replace(t1.v_prewarning_value,chr(13),''),chr(10),'') as v_prewarning_value
,replace(replace(t1.v_index_type,chr(13),''),chr(10),'') as v_index_type
,replace(replace(t1.v_statistical_frequency,chr(13),''),chr(10),'') as v_statistical_frequency
,replace(replace(t1.v_monitor_frequency,chr(13),''),chr(10),'') as v_monitor_frequency
,replace(replace(t1.v_read_lvl,chr(13),''),chr(10),'') as v_read_lvl
,replace(replace(t1.v_department_type,chr(13),''),chr(10),'') as v_department_type
,d_created_dt

from ${iol_schema}.alms_rp_alm_rrs_liquidity_report_result t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alms_rp_alm_rrs_liquidity_report_result.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
