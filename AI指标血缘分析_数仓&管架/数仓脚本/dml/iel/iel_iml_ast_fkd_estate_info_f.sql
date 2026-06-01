: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_fkd_estate_info_f
CreateDate: 20240813
FileName:   ${iel_data_path}/ast_fkd_estate_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.estate_list_id,chr(13),''),chr(10),'') as estate_list_id
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.city_cd,chr(13),''),chr(10),'') as city_cd
,replace(replace(t1.city_name,chr(13),''),chr(10),'') as city_name
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t1.rg_name,chr(13),''),chr(10),'') as rg_name
,replace(replace(t1.estat_id,chr(13),''),chr(10),'') as estat_id
,replace(replace(t1.comm_addr,chr(13),''),chr(10),'') as comm_addr
,replace(replace(t1.estat_position,chr(13),''),chr(10),'') as estat_position
,replace(replace(t1.estate_type_cd,chr(13),''),chr(10),'') as estate_type_cd
,replace(replace(t1.house_id,chr(13),''),chr(10),'') as house_id
,replace(replace(t1.floor_num,chr(13),''),chr(10),'') as floor_num
,replace(replace(t1.unit_num,chr(13),''),chr(10),'') as unit_num
,replace(replace(t1.estate_fitmt_situ_cd,chr(13),''),chr(10),'') as estate_fitmt_situ_cd
,replace(replace(t1.orient_cd,chr(13),''),chr(10),'') as orient_cd
,replace(replace(t1.estim_corp_name,chr(13),''),chr(10),'') as estim_corp_name
,onl_estim_val
,replace(replace(t1.estim_way_cd,chr(13),''),chr(10),'') as estim_way_cd
,formal_estim_val
,house_area
,build_year
,replace(replace(t1.ths_tm_mtg_flg,chr(13),''),chr(10),'') as ths_tm_mtg_flg
,replace(replace(t1.empty_flg,chr(13),''),chr(10),'') as empty_flg
,replace(replace(t1.vacy_flg,chr(13),''),chr(10),'') as vacy_flg
,replace(replace(t1.rent_flg,chr(13),''),chr(10),'') as rent_flg
,rent_dt
,get_house_dt
,replace(replace(t1.get_house_way_cd,chr(13),''),chr(10),'') as get_house_way_cd
,replace(replace(t1.prop_exp_dt,chr(13),''),chr(10),'') as prop_exp_dt
,replace(replace(t1.prop_co_ownr_rela_cd,chr(13),''),chr(10),'') as prop_co_ownr_rela_cd
,replace(replace(t1.lh_obg_cd,chr(13),''),chr(10),'') as lh_obg_cd
,lh_mtg_amt
,replace(replace(t1.land_char_cd,chr(13),''),chr(10),'') as land_char_cd
,replace(replace(t1.basm_flg,chr(13),''),chr(10),'') as basm_flg
,arch_area
,land_up_area
,land_next_area
,resv_house_qtty
,replace(replace(t1.resv_house_empty_flg,chr(13),''),chr(10),'') as resv_house_empty_flg
,replace(replace(t1.resv_house_addr,chr(13),''),chr(10),'') as resv_house_addr
,entry_dt
,relief_dt
,replace(replace(t1.main_debit_ps_obg_flg,chr(13),''),chr(10),'') as main_debit_ps_obg_flg
,replace(replace(t1.spouse_obg_flg,chr(13),''),chr(10),'') as spouse_obg_flg
,replace(replace(t1.house_usage,chr(13),''),chr(10),'') as house_usage
,tot_floor_cnt

from ${iml_schema}.ast_fkd_estate_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_fkd_estate_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
