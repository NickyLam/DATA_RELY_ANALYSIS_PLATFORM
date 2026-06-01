: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_fkd_estate_info_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_fkd_estate_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.bus_flow_num as bus_flow_num
,t1.city_cd as city_cd
,t1.city_name as city_name
,t1.rg_cd as rg_cd
,t1.rg_name as rg_name
,t1.estat_id as estat_id
,t1.comm_addr as comm_addr
,t1.estat_position as estat_position
,t1.estate_type_cd as estate_type_cd
,t1.house_id as house_id
,t1.floor_num as floor_num
,t1.unit_num as unit_num
,t1.estate_fitmt_situ_cd as estate_fitmt_situ_cd
,t1.orient_cd as orient_cd
,t1.estim_corp_name as estim_corp_name
,t1.onl_estim_val as onl_estim_val
,t1.estim_way_cd as estim_way_cd
,t1.formal_estim_val as formal_estim_val
,t1.house_area as house_area
,t1.build_year as build_year
,t1.ths_tm_mtg_flg as ths_tm_mtg_flg
,t1.empty_flg as empty_flg
,t1.vacy_flg as vacy_flg
,t1.rent_flg as rent_flg
,t1.rent_dt as rent_dt
,t1.get_house_dt as get_house_dt
,t1.get_house_way_cd as get_house_way_cd
,t1.prop_exp_dt as prop_exp_dt
,t1.prop_co_ownr_rela_cd as prop_co_ownr_rela_cd
,t1.lh_obg_cd as lh_obg_cd
,t1.lh_mtg_amt as lh_mtg_amt
,t1.land_char_cd as land_char_cd
,t1.basm_flg as basm_flg
,t1.arch_area as arch_area
,t1.land_up_area as land_up_area
,t1.land_next_area as land_next_area
,t1.resv_house_qtty as resv_house_qtty
,t1.resv_house_empty_flg as resv_house_empty_flg
,t1.resv_house_addr as resv_house_addr
,t1.entry_dt as entry_dt
,t1.relief_dt as relief_dt
,t1.main_debit_ps_obg_flg as main_debit_ps_obg_flg
,t1.spouse_obg_flg as spouse_obg_flg
,t1.house_usage as house_usage
,t1.tot_floor_cnt as tot_floor_cnt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.estate_list_id as estate_list_id
,t1.asset_id as asset_id

from ${idl_schema}.oass_ast_fkd_estate_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_fkd_estate_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
