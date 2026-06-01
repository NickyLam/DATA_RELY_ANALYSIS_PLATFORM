: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_fkd_belong_proof_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_fkd_belong_proof_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.belong_proof_list_id,chr(13),''),chr(10),'') as belong_proof_list_id
,replace(replace(t.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t.house_id,chr(13),''),chr(10),'') as house_id
,replace(replace(t.belong_proof_cd,chr(13),''),chr(10),'') as belong_proof_cd
,replace(replace(t.house_wat_num,chr(13),''),chr(10),'') as house_wat_num
,t.land_area as land_area
,replace(replace(t.land_usage,chr(13),''),chr(10),'') as land_usage
,replace(replace(t.land_position,chr(13),''),chr(10),'') as land_position
,t.get_dt as get_dt
,t.use_years as use_years
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.ast_fkd_belong_proof_info t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_fkd_belong_proof_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes