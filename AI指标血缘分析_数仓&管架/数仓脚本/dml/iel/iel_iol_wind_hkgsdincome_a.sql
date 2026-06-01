: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hkgsdincome_a
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hkgsdincome.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t.begin_dt,chr(13),''),chr(10),'') as begin_dt
,replace(replace(t.end_dt,chr(13),''),chr(10),'') as end_dt
,t.report_type as report_type
,t.statement_type as statement_type
,t.is_calc as is_calc
,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t.tot_oper_rev as tot_oper_rev
,t.bus_inc as bus_inc
,t.oth_bus_inc as oth_bus_inc
,t.rev_comm_inc as rev_comm_inc
,t.prov_loan_loss as prov_loan_loss
,t.premiums_earned as premiums_earned
,t.trade_inc_net as trade_inc_net
,t.int_inverst_inc as int_inverst_inc
,t.rev_rent as rev_rent
,t.tenant_reim_exp as tenant_reim_exp
,t.gain_sale_real_estate as gain_sale_real_estate
,t.mtg_inc as mtg_inc
,t.net_int_inc as net_int_inc
,t.broker_comm_inc as broker_comm_inc
,t.uw_ib_inc as uw_ib_inc
,t.aum_inc as aum_inc
,t.trade_inc as trade_inc
,t.net_fee_inc as net_fee_inc
,t.fee_inc as fee_inc
,t.fee_exp as fee_exp
,t.premiums_inc as premiums_inc
,t.reserve_chg as reserve_chg
,t.premium_ceded as premium_ceded
,t.tot_oper_cost as tot_oper_cost
,t.bus_cost as bus_cost
,t.oper_exp as oper_exp
,t.policy_int as policy_int
,t.sga_exp as sga_exp
,t.dist_exp as dist_exp
,t.admin_exp as admin_exp
,t.rd_exp as rd_exp
,t.oth_bus_exp as oth_bus_exp
,t.opprofit as opprofit
,t.grossmargin as grossmargin
,t.int_inc as int_inc
,t.int_exp as int_exp
,t.invest_gain as invest_gain
,t.oth_nonpo_inc as oth_nonpo_inc
,t.nonrecuritem_bef_profits as nonrecuritem_bef_profits
,t.unusual_items as unusual_items
,t.inc_pretax as inc_pretax
,t.tax as tax
,t.minority_int_inc as minority_int_inc
,t.noncontinuous_net_op as noncontinuous_net_op
,t.disc_oper as disc_oper
,t.oth_spec_item as oth_spec_item
,t.net_profit_cs as net_profit_cs
,t.dvd_pfd_adj as dvd_pfd_adj
,t.np_belongto_commonsh as np_belongto_commonsh
,t.ci_belongto_commonsh as ci_belongto_commonsh
,t.tot_ci as tot_ci
,t.inc_afttax as inc_afttax
,t.fairvalue_chg as fairvalue_chg
,replace(replace(t.s_info_comptype,chr(13),''),chr(10),'') as s_info_comptype
,replace(replace(t.s_memo,chr(13),''),chr(10),'') as s_memo
from iol.wind_hkgsdincome t
where etl_dt <=to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hkgsdincome.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes