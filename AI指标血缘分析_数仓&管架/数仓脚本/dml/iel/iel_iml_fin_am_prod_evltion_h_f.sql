: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_am_prod_evltion_h_f
CreateDate: 20221013
FileName:   ${iel_data_path}/fin_am_prod_evltion_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sob_name,chr(13),''),chr(10),'') as sob_name
,replace(replace(t1.evltion_type_cd,chr(13),''),chr(10),'') as evltion_type_cd
,replace(replace(t1.evltion_descb,chr(13),''),chr(10),'') as evltion_descb
,t1.evltion as evltion
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.fin_am_prod_evltion_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_am_prod_evltion_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
