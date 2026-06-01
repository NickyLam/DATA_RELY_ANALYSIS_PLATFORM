: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ym_float_prft_loss_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_ym_float_prft_loss_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.fund_cd,chr(13),''),chr(10),'') as fund_cd
,replace(replace(t.fund_name,chr(13),''),chr(10),'') as fund_name
,replace(replace(t.fund_abbr,chr(13),''),chr(10),'') as fund_abbr
,replace(replace(t.fund_type_cd,chr(13),''),chr(10),'') as fund_type_cd
,t.fund_lot as fund_lot
,t.lot_dt as lot_dt
,t.nv as nv
,t.nv_dt as nv_dt
,t.divd_amt as divd_amt
,t.ld_lot as ld_lot
,t.ld_lot_dt as ld_lot_dt
,t.ld_nv as ld_nv
,t.ld_nv_dt as ld_nv_dt
,t.ld_divd_amt as ld_divd_amt
,t.invest_amt as invest_amt
,t.exclude_divd_prft as exclude_divd_prft
,t.divd_prft as divd_prft
,t.ld_invest_amt as ld_invest_amt
,t.ld_exclude_divd_prft as ld_exclude_divd_prft
,t.ld_divd_prft as ld_divd_prft
,t.nv_calc_latest_prft as nv_calc_latest_prft
,t.float_prft_loss_amt as float_prft_loss_amt
,t.ld_float_prft_loss_amt as ld_float_prft_loss_amt
,t.float_prft_loss_calc_latest as float_prft_loss_calc_latest
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_ym_float_prft_loss_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ym_float_prft_loss_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes