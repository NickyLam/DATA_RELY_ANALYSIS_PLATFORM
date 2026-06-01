: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_fee_rat_set_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_fee_rat_set_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,replace(replace(t.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t.fee_type_cd,chr(13),''),chr(10),'') as fee_type_cd
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.sell_type_cd,chr(13),''),chr(10),'') as sell_type_cd
,replace(replace(t.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,t.lowt_buy_amt as lowt_buy_amt
,t.higt_buy_amt as higt_buy_amt
,t.min_precon_days as min_precon_days
,t.max_precon_days as max_precon_days
,t.min_surviv_days as min_surviv_days
,t.max_surviv_days as max_surviv_days
,t.fee_ratio as fee_ratio
,t.lowt_fee_amt as lowt_fee_amt
,t.higt_fee_amt as higt_fee_amt
,replace(replace(t.cntpty_prod_id,chr(13),''),chr(10),'') as cntpty_prod_id
,replace(replace(t.fee_corp_cd,chr(13),''),chr(10),'') as fee_corp_cd
,replace(replace(t.fee_corp_name,chr(13),''),chr(10),'') as fee_corp_name
,replace(replace(t.return_comm_fee_flg,chr(13),''),chr(10),'') as return_comm_fee_flg
,replace(replace(t.fee_mode_cd,chr(13),''),chr(10),'') as fee_mode_cd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_fee_rat_set_info_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_fee_rat_set_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes