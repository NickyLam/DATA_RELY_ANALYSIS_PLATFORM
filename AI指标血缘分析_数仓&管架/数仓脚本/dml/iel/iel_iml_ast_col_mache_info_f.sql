: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_mache_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ast_col_mache_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.equip_id,chr(13),''),chr(10),'') as equip_id
,replace(replace(t1.house_used_flg,chr(13),''),chr(10),'') as house_used_flg
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd
,replace(replace(t1.equip_type_cd,chr(13),''),chr(10),'') as equip_type_cd
,replace(replace(t1.equip_cls_cd,chr(13),''),chr(10),'') as equip_cls_cd
,replace(replace(t1.equip_model,chr(13),''),chr(10),'') as equip_model
,replace(replace(t1.prod_manuf,chr(13),''),chr(10),'') as prod_manuf
,leave_factory_dt
,use_exp_dt
,replace(replace(t1.prod_qual_cert_flg,chr(13),''),chr(10),'') as prod_qual_cert_flg
,replace(replace(t1.inv_id,chr(13),''),chr(10),'') as inv_id
,inv_dt
,inv_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.descb,chr(13),''),chr(10),'') as descb
,create_dt
,update_dt

from ${iml_schema}.ast_col_mache_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_mache_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
