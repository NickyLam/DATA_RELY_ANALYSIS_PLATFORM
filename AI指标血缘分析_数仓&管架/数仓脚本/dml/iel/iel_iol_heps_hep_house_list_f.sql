: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_hep_house_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_hep_house_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.property_prove,chr(13),''),chr(10),'') as property_prove
,replace(replace(t.prove_no,chr(13),''),chr(10),'') as prove_no
,replace(replace(t.durable_years,chr(13),''),chr(10),'') as durable_years
,replace(replace(t.house_usage,chr(13),''),chr(10),'') as house_usage
,replace(replace(t.house_use,chr(13),''),chr(10),'') as house_use
,t.id as id
from iol.heps_hep_house_list t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_hep_house_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes