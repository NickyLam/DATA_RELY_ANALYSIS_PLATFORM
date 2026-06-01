: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_bond_fair_price_i
CreateDate: 20230315
FileName:   ${iel_data_path}/prd_bond_fair_price.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,price_dt
,replace(replace(t1.tran_market_name,chr(13),''),chr(10),'') as tran_market_name
,surp_tenor
,replace(replace(t1.recmd_flg,chr(13),''),chr(10),'') as recmd_flg
,full_price
,net_price
,exp_yld_rat
,duran
,coret_duran
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,end_day_full_price
,estim_yld_rat
,estim_coret_duran
,estim_cvty
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.prd_bond_fair_price t1
where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_bond_fair_price.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
