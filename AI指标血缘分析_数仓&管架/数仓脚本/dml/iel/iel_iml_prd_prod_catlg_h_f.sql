: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_prod_catlg_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/prd_prod_catlg_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,prod_hibchy
,replace(replace(t1.prod_gen_id,chr(13),''),chr(10),'') as prod_gen_id
,replace(replace(t1.prod_gen_name,chr(13),''),chr(10),'') as prod_gen_name
,replace(replace(t1.prod_sclass_id,chr(13),''),chr(10),'') as prod_sclass_id
,replace(replace(t1.prod_sclass_name,chr(13),''),chr(10),'') as prod_sclass_name
,replace(replace(t1.prod_group_id,chr(13),''),chr(10),'') as prod_group_id
,replace(replace(t1.prod_group_name,chr(13),''),chr(10),'') as prod_group_name
,replace(replace(t1.base_prod_id,chr(13),''),chr(10),'') as base_prod_id
,replace(replace(t1.base_prod_name,chr(13),''),chr(10),'') as base_prod_name
,replace(replace(t1.sellbl_prod_id,chr(13),''),chr(10),'') as sellbl_prod_id
,replace(replace(t1.sellbl_prod_name,chr(13),''),chr(10),'') as sellbl_prod_name
,replace(replace(t1.prod_descb,chr(13),''),chr(10),'') as prod_descb
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,tran_tm
,effect_dt
,invalid_dt

from ${iml_schema}.prd_prod_catlg_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_prod_catlg_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
