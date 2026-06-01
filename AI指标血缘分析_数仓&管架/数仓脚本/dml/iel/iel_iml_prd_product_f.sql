: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_product_f
CreateDate: 20221021
FileName:   ${iel_data_path}/prd_product.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(prod_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(prod_name,chr(13),''),chr(10),'')
,replace(replace(prod_descb,chr(13),''),chr(10),'')
,replace(replace(prod_type_cd,chr(13),''),chr(10),'')
,replace(replace(self_own_prod_flg,chr(13),''),chr(10),'')
,replace(replace(sellbl_prod_flg,chr(13),''),chr(10),'')
,prod_effect_dt
,prod_invalid_dt
,create_dt
,update_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')

from ${iml_schema}.prd_product t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
