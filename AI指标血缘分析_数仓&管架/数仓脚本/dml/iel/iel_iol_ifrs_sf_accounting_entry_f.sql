: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifrs_sf_accounting_entry_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifrs_sf_accounting_entry.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.v_asset_type_cd,chr(13),''),chr(10),'') as v_asset_type_cd
,replace(replace(t1.v_asset_category,chr(13),''),chr(10),'') as v_asset_category
,replace(replace(t1.v_sub_cd,chr(13),''),chr(10),'') as v_sub_cd
,replace(replace(t1.v_sub_name,chr(13),''),chr(10),'') as v_sub_name
,replace(replace(t1.v_asset_three_cls_cd,chr(13),''),chr(10),'') as v_asset_three_cls_cd
,replace(replace(t1.v_sub_debit_cd,chr(13),''),chr(10),'') as v_sub_debit_cd
,replace(replace(t1.v_sub_debit_name,chr(13),''),chr(10),'') as v_sub_debit_name
,replace(replace(t1.v_sub_credit_cd,chr(13),''),chr(10),'') as v_sub_credit_cd
,replace(replace(t1.v_sub_credit_name,chr(13),''),chr(10),'') as v_sub_credit_name
,t1.sid as sid
,t1.d_effect_dt as d_effect_dt
,t1.d_lose_efficacy as d_lose_efficacy
,t1.v_journalizing_type as v_journalizing_type
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ifrs_sf_accounting_entry t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_sf_accounting_entry.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes