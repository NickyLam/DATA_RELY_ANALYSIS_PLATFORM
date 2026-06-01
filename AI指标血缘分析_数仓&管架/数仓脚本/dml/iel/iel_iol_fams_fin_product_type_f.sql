: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_product_type_f
CreateDate: 20240604
FileName:   ${iel_data_path}/fams_fin_product_type.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,branch
,replace(replace(t1.type_1,chr(13),''),chr(10),'') as type_1
,replace(replace(t1.type_2,chr(13),''),chr(10),'') as type_2
,replace(replace(t1.type_3,chr(13),''),chr(10),'') as type_3
,replace(replace(t1.type_4,chr(13),''),chr(10),'') as type_4
,replace(replace(t1.type_5,chr(13),''),chr(10),'') as type_5
,replace(replace(t1.type_6,chr(13),''),chr(10),'') as type_6
,replace(replace(t1.type_7,chr(13),''),chr(10),'') as type_7
,replace(replace(t1.type_8,chr(13),''),chr(10),'') as type_8
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.type_9,chr(13),''),chr(10),'') as type_9
,replace(replace(t1.type_10,chr(13),''),chr(10),'') as type_10
,replace(replace(t1.type_11,chr(13),''),chr(10),'') as type_11
,replace(replace(t1.type_12,chr(13),''),chr(10),'') as type_12
,replace(replace(t1.type_13,chr(13),''),chr(10),'') as type_13
,replace(replace(t1.type_14,chr(13),''),chr(10),'') as type_14
,replace(replace(t1.type_15,chr(13),''),chr(10),'') as type_15
,replace(replace(t1.type_16,chr(13),''),chr(10),'') as type_16
,replace(replace(t1.type_17,chr(13),''),chr(10),'') as type_17
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id

from ${iol_schema}.fams_fin_product_type t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_product_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
