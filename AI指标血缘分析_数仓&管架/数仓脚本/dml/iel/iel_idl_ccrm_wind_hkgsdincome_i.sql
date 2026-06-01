: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hkgsdincome_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hkgsdincome.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.begin_dt,chr(13),''),chr(10),'') as begin_dt
,replace(replace(t1.end_dt,chr(13),''),chr(10),'') as end_dt
,t1.report_type as report_type
,t1.statement_type as statement_type
,t1.is_calc as is_calc
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.tot_oper_rev as tot_oper_rev
,t1.bus_inc as bus_inc
,t1.oth_bus_inc as oth_bus_inc
,t1.rev_comm_inc as rev_comm_inc
,t1.prov_loan_loss as prov_loan_loss
,t1.premiums_earned as premiums_earned
,t1.trade_inc_net as trade_inc_net
,t1.int_inverst_inc as int_inverst_inc
,t1.rev_rent as rev_rent
,t1.tenant_reim_exp as tenant_reim_exp
,t1.gain_sale_real_estate as gain_sale_real_estate
,t1.mtg_inc as mtg_inc
,t1.net_int_inc as net_int_inc
,t1.broker_comm_inc as broker_comm_inc
,t1.uw_ib_inc as uw_ib_inc
,t1.aum_inc as aum_inc
,t1.trade_inc as trade_inc
,t1.net_fee_inc as net_fee_inc
,t1.fee_inc as fee_inc
,t1.fee_exp as fee_exp
,t1.premiums_inc as premiums_inc
,t1.reserve_chg as reserve_chg
,t1.premium_ceded as premium_ceded
,t1.tot_oper_cost as tot_oper_cost
,t1.bus_cost as bus_cost
,t1.oper_exp as oper_exp
,t1.policy_int as policy_int
,t1.sga_exp as sga_exp
,t1.dist_exp as dist_exp
,t1.admin_exp as admin_exp
,t1.rd_exp as rd_exp
,t1.oth_bus_exp as oth_bus_exp
,t1.opprofit as opprofit
,t1.grossmargin as grossmargin
,t1.int_inc as int_inc
,t1.int_exp as int_exp
,t1.invest_gain as invest_gain
,t1.oth_nonpo_inc as oth_nonpo_inc
,t1.nonrecuritem_bef_profits as nonrecuritem_bef_profits
,t1.unusual_items as unusual_items
,t1.inc_pretax as inc_pretax
,t1.tax as tax
,t1.minority_int_inc as minority_int_inc
,t1.noncontinuous_net_op as noncontinuous_net_op
,t1.disc_oper as disc_oper
,t1.oth_spec_item as oth_spec_item
,t1.net_profit_cs as net_profit_cs
,t1.dvd_pfd_adj as dvd_pfd_adj
,t1.np_belongto_commonsh as np_belongto_commonsh
,t1.ci_belongto_commonsh as ci_belongto_commonsh
,t1.tot_ci as tot_ci
,t1.inc_afttax as inc_afttax
,t1.fairvalue_chg as fairvalue_chg
,replace(replace(t1.s_info_comptype,chr(13),''),chr(10),'') as s_info_comptype
,replace(replace(t1.s_memo,chr(13),''),chr(10),'') as s_memo
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_hkgsdincome t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hkgsdincome.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes