: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_prd_product_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_product_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.prod_id
,t.lp_id
,t.prod_name
,t.prod_descb
,t.prod_type_cd
,t.self_own_prod_flg
,t.sellbl_prod_flg
,t.prod_effect_dt
,t.prod_invalid_dt
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.prd_product t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_product_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes