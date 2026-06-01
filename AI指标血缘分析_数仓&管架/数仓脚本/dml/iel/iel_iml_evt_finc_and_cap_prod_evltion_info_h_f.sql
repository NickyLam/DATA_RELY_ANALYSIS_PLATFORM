: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_and_cap_prod_evltion_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_finc_and_cap_prod_evltion_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,batch_dt
,replace(replace(t1.comb_prod_cd_descb,chr(13),''),chr(10),'') as comb_prod_cd_descb
,replace(replace(t1.fin_prod_cd_descb,chr(13),''),chr(10),'') as fin_prod_cd_descb
,replace(replace(t1.invest_aim_cd,chr(13),''),chr(10),'') as invest_aim_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,asset_qtty
,evha_val_chag
,amort_tot_cost
,amort_cost_net_price
,td_acru_int
,create_tm
,update_tm
,amort_actl_day_int_rat
,replace(replace(t1.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
,ovdue_asset_prep_clear_cap
,surp_tenor
,surp_surviv_tenor
,provi_int_rat
,td_spd_inco

from ${iml_schema}.evt_finc_and_cap_prod_evltion_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_and_cap_prod_evltion_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
