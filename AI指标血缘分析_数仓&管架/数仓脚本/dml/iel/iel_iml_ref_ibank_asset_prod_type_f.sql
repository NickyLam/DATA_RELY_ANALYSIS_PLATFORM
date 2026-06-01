: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_ibank_asset_prod_type_f
CreateDate: 20230525
FileName:   ${iel_data_path}/ref_ibank_asset_prod_type.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd
,replace(replace(t1.prod_type_name,chr(13),''),chr(10),'') as prod_type_name
,replace(replace(t1.auto_ird_flg,chr(13),''),chr(10),'') as auto_ird_flg
,replace(replace(t1.delay_exp_flg,chr(13),''),chr(10),'') as delay_exp_flg
,replace(replace(t1.amort_way_cd,chr(13),''),chr(10),'') as amort_way_cd
,replace(replace(t1.amort_way_name,chr(13),''),chr(10),'') as amort_way_name
,replace(replace(t1.evltion_flg,chr(13),''),chr(10),'') as evltion_flg
,replace(replace(t1.evltion_type_cd,chr(13),''),chr(10),'') as evltion_type_cd
,replace(replace(t1.drawdown_flg,chr(13),''),chr(10),'') as drawdown_flg
,replace(replace(t1.provi_flg,chr(13),''),chr(10),'') as provi_flg
,replace(replace(t1.col_int_flg,chr(13),''),chr(10),'') as col_int_flg
,replace(replace(t1.auto_ovdue_flg,chr(13),''),chr(10),'') as auto_ovdue_flg
,replace(replace(t1.on_acct_id,chr(13),''),chr(10),'') as on_acct_id
,replace(replace(t1.on_acct_name,chr(13),''),chr(10),'') as on_acct_name
,create_dt
,update_dt

from ${iml_schema}.ref_ibank_asset_prod_type t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_ibank_asset_prod_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
