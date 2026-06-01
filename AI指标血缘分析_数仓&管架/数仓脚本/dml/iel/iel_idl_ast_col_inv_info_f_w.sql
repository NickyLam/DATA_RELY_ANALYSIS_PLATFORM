: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_inv_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_inv_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.inv_type_descb as inv_type_descb
,t.local_prov_cd as local_prov_cd
,t.local_city_cd as local_city_cd
,t.measure_corp_cd as measure_corp_cd
,t.qtty as qtty
,t.apprv_price as apprv_price
,t.supv_corp_supv_flg as supv_corp_supv_flg
,t.supv_corp_name as supv_corp_name
,t.supv_corp_orgnz_cd as supv_corp_orgnz_cd
,t.agt_effect_dt as agt_effect_dt
,t.agt_invalid_dt as agt_invalid_dt
,t.other_comnt as other_comnt
,t.other_measure_corp as other_measure_corp
,t.curr_cd as curr_cd
,t.mtg_rgst_b_id as mtg_rgst_b_id
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_inv_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_inv_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes