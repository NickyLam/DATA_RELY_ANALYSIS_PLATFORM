: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alms_rp_alm_rrs_b01_report_result_f
CreateDate: 20240126
FileName:   ${iel_data_path}/alms_rp_alm_rrs_b01_report_result.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,as_of_date
,n_as_of_date_skey
,n_run_skey
,n_entity_skey
,n_business_unit_skey
,n_org_unit_skey
,n_forecast_point_skey
,n_report_scenario_skey
,n_rep_line_cd
,replace(replace(t1.v_currency_type,chr(13),''),chr(10),'') as v_currency_type
,n_rep_line_value
,d_created_dt
,n_previous_day_variation
,n_previous_month_variation
,n_previous_year_variation

from ${iol_schema}.alms_rp_alm_rrs_b01_report_result t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alms_rp_alm_rrs_b01_report_result.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
