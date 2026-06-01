: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_std_mdl_class_prod_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_std_mdl_class_prod.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name 
,replace(replace(t1.prod_route,chr(13),''),chr(10),'') as prod_route 
,replace(replace(t1.level1_cls_code,chr(13),''),chr(10),'') as level1_cls_code 
,replace(replace(t1.level2_cls_code,chr(13),''),chr(10),'') as level2_cls_code 
,replace(replace(t1.level3_cls_code,chr(13),''),chr(10),'') as level3_cls_code 
,replace(replace(t1.level4_cls_code,chr(13),''),chr(10),'') as level4_cls_code 
,replace(replace(t1.issue_status_cd,chr(13),''),chr(10),'') as issue_status_cd 
,replace(replace(t1.prod_sum,chr(13),''),chr(10),'') as prod_sum 
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd 
,t1.effect_dt as effect_dt 
,t1.invalid_dt as invalid_dt 
,t1.issue_dt as issue_dt 
,replace(replace(t1.mgmt_dept_name,chr(13),''),chr(10),'') as mgmt_dept_name 
,replace(replace(t1.map_rule,chr(13),''),chr(10),'') as map_rule 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_std_mdl_class_prod t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_std_mdl_class_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes