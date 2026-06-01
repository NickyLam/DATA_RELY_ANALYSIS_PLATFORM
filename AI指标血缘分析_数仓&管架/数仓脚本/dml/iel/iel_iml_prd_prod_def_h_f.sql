: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_prod_def_h_f
CreateDate: 20251023
FileName:   ${iel_data_path}/prd_prod_def_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.compnt_type_cd,chr(13),''),chr(10),'') as compnt_type_cd
,replace(replace(t1.compnt_id,chr(13),''),chr(10),'') as compnt_id
,replace(replace(t1.attr_key,chr(13),''),chr(10),'') as attr_key
,replace(replace(t1.attr_val,chr(13),''),chr(10),'') as attr_val
,replace(replace(t1.evt_cls_cd,chr(13),''),chr(10),'') as evt_cls_cd
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.prd_prod_def_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_prod_def_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
