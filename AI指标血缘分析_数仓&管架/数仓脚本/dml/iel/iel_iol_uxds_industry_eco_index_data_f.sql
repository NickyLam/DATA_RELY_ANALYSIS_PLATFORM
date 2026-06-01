: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_industry_eco_index_data_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_industry_eco_index_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.indicator_id,chr(13),''),chr(10),'') as indicator_id
,replace(replace(t1.indicator_name,chr(13),''),chr(10),'') as indicator_name
,replace(replace(t1.tm,chr(13),''),chr(10),'') as tm
,replace(replace(t1.numerical_value,chr(13),''),chr(10),'') as numerical_value
,isvalid

from ${iol_schema}.uxds_industry_eco_index_data t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_industry_eco_index_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
