: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_fin_prod_cls_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/prd_am_fin_prod_cls_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(fin_prod_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(brch_seq_num,chr(13),''),chr(10),'')
,replace(replace(bank_int_prod_level2_cls_cd,chr(13),''),chr(10),'')
,replace(replace(bank_int_prod_level3_cls_cd,chr(13),''),chr(10),'')
,replace(replace(bank_int_prod_level4_cls_cd,chr(13),''),chr(10),'')
,replace(replace(bank_int_prod_level5_cls_cd,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')
,replace(replace(std_prod_id,chr(13),''),chr(10),'')

from ${iml_schema}.prd_am_fin_prod_cls_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_fin_prod_cls_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
