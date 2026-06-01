: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_float_fin_instm_tax_rat_info_h_f
CreateDate: 20230130
FileName:   ${iel_data_path}/ref_float_fin_instm_tax_rat_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tax_rat_id,chr(13),''),chr(10),'') as tax_rat_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.vat_entry_type_cd,chr(13),''),chr(10),'') as vat_entry_type_cd
,replace(replace(t1.tax_rat_pl_type_cd,chr(13),''),chr(10),'') as tax_rat_pl_type_cd
,tax_rat
,replace(replace(t1.prod_type_id,chr(13),''),chr(10),'') as prod_type_id
,replace(replace(t1.prod_cls_name,chr(13),''),chr(10),'') as prod_cls_name
,open_invoice_request_cd
,replace(replace(t1.tax_way_cd,chr(13),''),chr(10),'') as tax_way_cd
,replace(replace(t1.taxable_way_cd,chr(13),''),chr(10),'') as taxable_way_cd
,replace(replace(t1.tax_rat_status_cd,chr(13),''),chr(10),'') as tax_rat_status_cd
,effect_dt
,invalid_dt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ref_float_fin_instm_tax_rat_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_float_fin_instm_tax_rat_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
