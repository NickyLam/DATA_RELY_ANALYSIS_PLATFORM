: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_industry_eco_index_basic_info_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_industry_eco_index_basic_info.f.${batch_date}.dat
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
,replace(replace(t1.unit,chr(13),''),chr(10),'') as unit
,replace(replace(t1.sources,chr(13),''),chr(10),'') as sources
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.frequency,chr(13),''),chr(10),'') as frequency
,replace(replace(t1.currency_variety,chr(13),''),chr(10),'') as currency_variety
,is_tree_node
,replace(replace(t1.first_level_directory,chr(13),''),chr(10),'') as first_level_directory
,replace(replace(t1.second_level_directory,chr(13),''),chr(10),'') as second_level_directory
,replace(replace(t1.third_level_directory,chr(13),''),chr(10),'') as third_level_directory
,replace(replace(t1.forth_level_directory,chr(13),''),chr(10),'') as forth_level_directory
,replace(replace(t1.fifth_level_directory,chr(13),''),chr(10),'') as fifth_level_directory
,replace(replace(t1.sixth_level_directory,chr(13),''),chr(10),'') as sixth_level_directory
,replace(replace(t1.seventh_level_directory,chr(13),''),chr(10),'') as seventh_level_directory
,replace(replace(t1.eigth_level_directory,chr(13),''),chr(10),'') as eigth_level_directory
,replace(replace(t1.ninth_level_directory,chr(13),''),chr(10),'') as ninth_level_directory
,parent_node
,indicator_seq
,isvalid

from ${iol_schema}.uxds_industry_eco_index_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_industry_eco_index_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
