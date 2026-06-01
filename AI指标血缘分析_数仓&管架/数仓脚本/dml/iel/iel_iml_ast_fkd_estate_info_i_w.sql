: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_fkd_estate_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_fkd_estate_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.estate_list_id,chr(13),''),chr(10),'') as estate_list_id
,replace(replace(t.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t.city_name,chr(13),''),chr(10),'') as city_name
,replace(replace(t.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t.rg_name,chr(13),''),chr(10),'') as rg_name
,replace(replace(t.estat_id,chr(13),''),chr(10),'') as estat_id
,replace(replace(t.comm_addr,chr(13),''),chr(10),'') as comm_addr
,replace(replace(t.estat_position,chr(13),''),chr(10),'') as estat_position
,replace(replace(t.estate_type_cd,chr(13),''),chr(10),'') as estate_type_cd
,replace(replace(t.house_id,chr(13),''),chr(10),'') as house_id
,replace(replace(t.floor_num,chr(13),''),chr(10),'') as floor_num
,replace(replace(t.unit_num,chr(13),''),chr(10),'') as unit_num
,replace(replace(t.estate_fitmt_situ_cd,chr(13),''),chr(10),'') as estate_fitmt_situ_cd
,replace(replace(t.orient_cd,chr(13),''),chr(10),'') as orient_cd
,replace(replace(t.estim_corp_name,chr(13),''),chr(10),'') as estim_corp_name
,t.onl_estim_val as onl_estim_val
,replace(replace(t.estim_way_cd,chr(13),''),chr(10),'') as estim_way_cd
,t.formal_estim_val as formal_estim_val
,t.house_area as house_area
,t.build_year as build_year
,replace(replace(t.ths_tm_mtg_flg,chr(13),''),chr(10),'') as ths_tm_mtg_flg
,replace(replace(t.empty_flg,chr(13),''),chr(10),'') as empty_flg
,replace(replace(t.vacy_flg,chr(13),''),chr(10),'') as vacy_flg
,replace(replace(t.rent_flg,chr(13),''),chr(10),'') as rent_flg
,t.rent_dt as rent_dt
,t.get_house_dt as get_house_dt
,replace(replace(t.get_house_way_cd,chr(13),''),chr(10),'') as get_house_way_cd
,replace(replace(t.prop_exp_dt,chr(13),''),chr(10),'') as prop_exp_dt
,replace(replace(t.prop_co_ownr_rela_cd,chr(13),''),chr(10),'') as prop_co_ownr_rela_cd
,replace(replace(t.lh_obg_cd,chr(13),''),chr(10),'') as lh_obg_cd
,t.lh_mtg_amt as lh_mtg_amt
,replace(replace(t.land_char_cd,chr(13),''),chr(10),'') as land_char_cd
,replace(replace(t.basm_flg,chr(13),''),chr(10),'') as basm_flg
,t.arch_area as arch_area
,t.land_up_area as land_up_area
,t.land_next_area as land_next_area
,t.resv_house_qtty as resv_house_qtty
,replace(replace(t.resv_house_empty_flg,chr(13),''),chr(10),'') as resv_house_empty_flg
,replace(replace(t.resv_house_addr,chr(13),''),chr(10),'') as resv_house_addr
,t.entry_dt as entry_dt
,t.relief_dt as relief_dt
,replace(replace(t.main_debit_ps_obg_flg,chr(13),''),chr(10),'') as main_debit_ps_obg_flg
,replace(replace(t.spouse_obg_flg,chr(13),''),chr(10),'') as spouse_obg_flg
,replace(replace(t.house_usage,chr(13),''),chr(10),'') as house_usage
,t.tot_floor_cnt as tot_floor_cnt
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.ast_fkd_estate_info t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_fkd_estate_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes