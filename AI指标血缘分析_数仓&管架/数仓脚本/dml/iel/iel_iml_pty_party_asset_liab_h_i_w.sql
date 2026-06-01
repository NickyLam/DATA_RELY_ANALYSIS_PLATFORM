: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_asset_liab_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_asset_liab_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.hold_obank_crdt_card_cd,chr(13),''),chr(10),'') as hold_obank_crdt_card_cd 
,t1.curr_unpayoff_crdt_loan_cnt as curr_unpayoff_crdt_loan_cnt 
,replace(replace(t1.indv_asset_liab_dtl_type_cd,chr(13),''),chr(10),'') as indv_asset_liab_dtl_type_cd 
,t1.provi_fund_payment_ratio as provi_fund_payment_ratio 
,t1.contgt_liab_amt as contgt_liab_amt 
,replace(replace(t1.contgt_liab_type_cd,chr(13),''),chr(10),'') as contgt_liab_type_cd 
,t1.ud_name_vehic_qtty as ud_name_vehic_qtty 
,t1.ud_name_estate_val as ud_name_estate_val 
,replace(replace(t1.li_policy_insu_comp_name,chr(13),''),chr(10),'') as li_policy_insu_comp_name 
,t1.soci_secu_payment_duran as soci_secu_payment_duran 
,replace(replace(t1.is_have_fin_invest_stock_city,chr(13),''),chr(10),'') as is_have_fin_invest_stock_city 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_party_asset_liab_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_asset_liab_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes