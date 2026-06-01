: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_std_prod_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_std_prod_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.level1_prod_id,chr(13),''),chr(10),'') as level1_prod_id
,replace(replace(t1.level1_prod_name,chr(13),''),chr(10),'') as level1_prod_name
,replace(replace(t1.level2_prod_id,chr(13),''),chr(10),'') as level2_prod_id
,replace(replace(t1.level2_prod_name,chr(13),''),chr(10),'') as level2_prod_name
,replace(replace(t1.level3_prod_id,chr(13),''),chr(10),'') as level3_prod_id
,replace(replace(t1.level3_prod_name,chr(13),''),chr(10),'') as level3_prod_name
,replace(replace(t1.level4_prod_id,chr(13),''),chr(10),'') as level4_prod_id
,replace(replace(t1.level4_prod_name,chr(13),''),chr(10),'') as level4_prod_name
,replace(replace(t1.issue_status_cd,chr(13),''),chr(10),'') as issue_status_cd
,replace(replace(t1.prod_lev_cd,chr(13),''),chr(10),'') as prod_lev_cd
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,replace(replace(t1.prod_sum,chr(13),''),chr(10),'') as prod_sum
,replace(replace(t1.mgmt_dept_name,chr(13),''),chr(10),'') as mgmt_dept_name
,replace(replace(t1.map_rule_descb,chr(13),''),chr(10),'') as map_rule_descb
,replace(replace(t1.base_prod_id,chr(13),''),chr(10),'') as base_prod_id
,replace(replace(t1.comb_prod_flg,chr(13),''),chr(10),'') as comb_prod_flg
,replace(replace(t1.prod_range_cd,chr(13),''),chr(10),'') as prod_range_cd
,replace(replace(t1.provi_merge_flg,chr(13),''),chr(10),'') as provi_merge_flg
from ${icl_schema}.cmm_std_prod_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_std_prod_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes