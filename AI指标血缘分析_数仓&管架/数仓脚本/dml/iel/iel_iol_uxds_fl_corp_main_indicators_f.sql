: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_fl_corp_main_indicators_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_fl_corp_main_indicators.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,chg_seq
,project_seq
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,ed
,statement_year
,replace(replace(t1.report_type_code,chr(13),''),chr(10),'') as report_type_code
,replace(replace(t1.statement_type_code,chr(13),''),chr(10),'') as statement_type_code
,announcement_date
,lastest_symbol
,replace(replace(t1.project_announced_name,chr(13),''),chr(10),'') as project_announced_name
,replace(replace(t1.project_speci_name_code,chr(13),''),chr(10),'') as project_speci_name_code
,numerical_value
,replace(replace(t1.unit,chr(13),''),chr(10),'') as unit
,replace(replace(t1.currency_variety_name_code,chr(13),''),chr(10),'') as currency_variety_name_code
,isvalid

from ${iol_schema}.uxds_fl_corp_main_indicators t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_fl_corp_main_indicators.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
