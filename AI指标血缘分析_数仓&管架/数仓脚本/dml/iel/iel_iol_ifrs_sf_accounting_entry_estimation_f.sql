: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifrs_sf_accounting_entry_estimation_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifrs_sf_accounting_entry_estimation.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sid,chr(13),''),chr(10),'') as sid
,replace(replace(t1.v_asset_type_cd,chr(13),''),chr(10),'') as v_asset_type_cd
,replace(replace(t1.v_assets_class_name,chr(13),''),chr(10),'') as v_assets_class_name
,replace(replace(t1.v_assets_accounts_cd,chr(13),''),chr(10),'') as v_assets_accounts_cd
,replace(replace(t1.v_assets_accounts_name,chr(13),''),chr(10),'') as v_assets_accounts_name
,replace(replace(t1.v_sub_debit_cd,chr(13),''),chr(10),'') as v_sub_debit_cd
,replace(replace(t1.v_sub_debit_name,chr(13),''),chr(10),'') as v_sub_debit_name
,replace(replace(t1.v_reportforms_debit_name,chr(13),''),chr(10),'') as v_reportforms_debit_name
,replace(replace(t1.v_sub_credit_cd,chr(13),''),chr(10),'') as v_sub_credit_cd
,replace(replace(t1.v_sub_credit_name,chr(13),''),chr(10),'') as v_sub_credit_name
,replace(replace(t1.v_reportforms_credit_name,chr(13),''),chr(10),'') as v_reportforms_credit_name
,replace(replace(t1.v_debit_credit_cd,chr(13),''),chr(10),'') as v_debit_credit_cd
,t1.d_effect_dt as d_effect_dt
,t1.d_lose_efficacy as d_lose_efficacy
from ${iol_schema}.ifrs_sf_accounting_entry_estimation t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_sf_accounting_entry_estimation.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes