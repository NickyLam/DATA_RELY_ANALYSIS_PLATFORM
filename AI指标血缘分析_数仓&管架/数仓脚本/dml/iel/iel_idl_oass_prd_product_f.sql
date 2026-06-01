: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_product_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_prd_product.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.prod_name as prod_name
,t1.prod_descb as prod_descb
,t1.prod_type_cd as prod_type_cd
,t1.self_own_prod_flg as self_own_prod_flg
,t1.sellbl_prod_flg as sellbl_prod_flg
,t1.prod_effect_dt as prod_effect_dt
,t1.prod_invalid_dt as prod_invalid_dt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.prod_id as prod_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_prd_product t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
