: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_am_fin_prod_tran_attach_h_f
CreateDate: 20240304
FileName:   ${iel_data_path}/evt_am_fin_prod_tran_attach_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,pnlt_amt
,replace(replace(t1.custm_cashflow_type_cd,chr(13),''),chr(10),'') as custm_cashflow_type_cd
,expect_purch_cfm_day
,expect_redem_arriv_dt
,eqty_rgst_day
,expect_divd_day
,replace(replace(t1.creator_name,chr(13),''),chr(10),'') as creator_name
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_tm
,replace(replace(t1.updater_name,chr(13),''),chr(10),'') as updater_name
,update_tm
,redem_prft
,redem_cost
,eqty_rgst_day_amt
,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'') as fin_prod_id
,replace(replace(t1.brch_seq_num,chr(13),''),chr(10),'') as brch_seq_num
,replace(replace(t1.asset_refer_id,chr(13),''),chr(10),'') as asset_refer_id
,expect_turn_stock_val
,margin_amt
,adv_termnt_int_rat
,replace(replace(t1.inv_port_id,chr(13),''),chr(10),'') as inv_port_id

from ${iml_schema}.evt_am_fin_prod_tran_attach_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_am_fin_prod_tran_attach_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
