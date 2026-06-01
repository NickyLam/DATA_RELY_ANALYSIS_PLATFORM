: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_hep_house_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_hep_house.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.house_id as house_id
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.house_type,chr(13),''),chr(10),'') as house_type
,replace(replace(t.is_basement,chr(13),''),chr(10),'') as is_basement
,replace(replace(t.plot_name,chr(13),''),chr(10),'') as plot_name
,t.online_valuation as online_valuation
,t.house_area as house_area
,replace(replace(t.house_location,chr(13),''),chr(10),'') as house_location
,replace(replace(t.completion_year,chr(13),''),chr(10),'') as completion_year
,replace(replace(t.total_tier,chr(13),''),chr(10),'') as total_tier
,replace(replace(t.spare_house,chr(13),''),chr(10),'') as spare_house
,replace(replace(t.property_start_time,chr(13),''),chr(10),'') as property_start_time
,replace(replace(t.property_end_time,chr(13),''),chr(10),'') as property_end_time
,replace(replace(t.is_vacancy,chr(13),''),chr(10),'') as is_vacancy
,replace(replace(t.start_obligee,chr(13),''),chr(10),'') as start_obligee
,replace(replace(t.property_people_count,chr(13),''),chr(10),'') as property_people_count
,replace(replace(t.property_common_relation,chr(13),''),chr(10),'') as property_common_relation
,replace(replace(t.property_prove,chr(13),''),chr(10),'') as property_prove
,replace(replace(t.prove_no,chr(13),''),chr(10),'') as prove_no
,replace(replace(t.durable_years,chr(13),''),chr(10),'') as durable_years
,replace(replace(t.house_usage,chr(13),''),chr(10),'') as house_usage
,replace(replace(t.assess_way,chr(13),''),chr(10),'') as assess_way
,t.official_valuation as official_valuation
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.house_use,chr(13),''),chr(10),'') as house_use
,replace(replace(t.local_area,chr(13),''),chr(10),'') as local_area
,replace(replace(t.assessment_com,chr(13),''),chr(10),'') as assessment_com
,replace(replace(t.city_code,chr(13),''),chr(10),'') as city_code
,replace(replace(t.sub_divide_code,chr(13),''),chr(10),'') as sub_divide_code
,replace(replace(t.property_common_relation_des,chr(13),''),chr(10),'') as property_common_relation_des
,replace(replace(t.property_get_time,chr(13),''),chr(10),'') as property_get_time
from iol.heps_hep_house t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_hep_house.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes