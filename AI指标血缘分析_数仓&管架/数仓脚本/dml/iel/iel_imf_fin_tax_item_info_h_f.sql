: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_fin_tax_item_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fin_tax_item_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tax_item_id,chr(13),''),chr(10),'') as tax_item_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tax_item_name,chr(13),''),chr(10),'') as tax_item_name
,t1.tax_rat as tax_rat
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,replace(replace(t1.tax_item_status_cd,chr(13),''),chr(10),'') as tax_item_status_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.dedu_idf_cd,chr(13),''),chr(10),'') as dedu_idf_cd
,replace(replace(t1.taxable_idf_cd,chr(13),''),chr(10),'') as taxable_idf_cd
,replace(replace(t1.tax_way_cd,chr(13),''),chr(10),'') as tax_way_cd
,replace(replace(t1.open_invoice_type_cd,chr(13),''),chr(10),'') as open_invoice_type_cd
,replace(replace(t1.item_type_cd,chr(13),''),chr(10),'') as item_type_cd
,replace(replace(t1.tax_cls_id,chr(13),''),chr(10),'') as tax_cls_id
,replace(replace(t1.free_tax_id,chr(13),''),chr(10),'') as free_tax_id
,replace(replace(t1.merchd_serv_name,chr(13),''),chr(10),'') as merchd_serv_name
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.fin_tax_item_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_tax_item_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes