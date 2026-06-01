: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_inv_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_inv_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.inv_type_descb,chr(13),''),chr(10),'') as inv_type_descb
,replace(replace(t1.local_prov_cd,chr(13),''),chr(10),'') as local_prov_cd
,replace(replace(t1.local_city_cd,chr(13),''),chr(10),'') as local_city_cd
,replace(replace(t1.measure_corp_cd,chr(13),''),chr(10),'') as measure_corp_cd
,qtty
,apprv_price
,replace(replace(t1.supv_corp_supv_flg,chr(13),''),chr(10),'') as supv_corp_supv_flg
,replace(replace(t1.supv_corp_name,chr(13),''),chr(10),'') as supv_corp_name
,replace(replace(t1.supv_corp_orgnz_cd,chr(13),''),chr(10),'') as supv_corp_orgnz_cd
,agt_effect_dt
,agt_invalid_dt
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,replace(replace(t1.other_measure_corp,chr(13),''),chr(10),'') as other_measure_corp
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.mtg_rgst_b_id,chr(13),''),chr(10),'') as mtg_rgst_b_id
,create_dt
,update_dt

from ${iml_schema}.ast_col_inv_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_inv_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
