: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_inv_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_inv_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.inv_type_descb as inv_type_descb
,t1.local_prov_cd as local_prov_cd
,t1.local_city_cd as local_city_cd
,t1.measure_corp_cd as measure_corp_cd
,t1.qtty as qtty
,t1.apprv_price as apprv_price
,t1.supv_corp_supv_flg as supv_corp_supv_flg
,t1.supv_corp_name as supv_corp_name
,t1.supv_corp_orgnz_cd as supv_corp_orgnz_cd
,t1.agt_effect_dt as agt_effect_dt
,t1.agt_invalid_dt as agt_invalid_dt
,t1.other_comnt as other_comnt
,t1.other_measure_corp as other_measure_corp
,t1.curr_cd as curr_cd
,t1.mtg_rgst_b_id as mtg_rgst_b_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_inv_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_inv_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
