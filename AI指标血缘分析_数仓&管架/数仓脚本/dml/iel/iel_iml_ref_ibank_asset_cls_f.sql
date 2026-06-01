: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_ibank_asset_cls_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_ibank_asset_cls.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_cls_id,chr(13),''),chr(10),'') as prod_cls_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.prod_cls_name,chr(13),''),chr(10),'') as prod_cls_name
,replace(replace(t1.prod_type_id,chr(13),''),chr(10),'') as prod_type_id
,replace(replace(t1.prod_type_name,chr(13),''),chr(10),'') as prod_type_name
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id

from ${iml_schema}.ref_ibank_asset_cls t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ibank_asset_cls.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
