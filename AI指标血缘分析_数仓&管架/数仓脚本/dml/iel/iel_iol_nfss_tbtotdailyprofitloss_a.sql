: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_tbtotdailyprofitloss_a
CreateDate: 20211230
FileName:   ${iel_data_path}/nfss_tbtotdailyprofitloss.a.${batch_date}.dat
IF_mark:    a
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.in_client_no,chr(13),''),chr(10),'') as in_client_no
    ,replace(replace(t.bank_acc,chr(13),''),chr(10),'') as bank_acc
    ,replace(replace(t.bank_no,chr(13),''),chr(10),'') as bank_no
    ,replace(replace(t.client_no,chr(13),''),chr(10),'') as client_no
    ,replace(replace(t.ta_code,chr(13),''),chr(10),'') as ta_code
    ,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
    ,t.nav as nav
    ,t.record_date as record_date
    ,t.beg_date as beg_date
    ,t.beg_nav as beg_nav
    ,t.end_date as end_date
    ,t.end_nav as end_nav
    ,t.tot_vol as tot_vol
    ,t.allot_amt as allot_amt
    ,t.allot_cfm_amt as allot_cfm_amt
    ,t.sub_amt as sub_amt
    ,t.auto_sub_amt as auto_sub_amt
    ,t.conv_in_amt as conv_in_amt
    ,t.trust_in_amt as trust_in_amt
    ,t.assign_in_amt as assign_in_amt
    ,t.force_add_amt as force_add_amt
    ,t.red_amt as red_amt
    ,t.force_red_amt as force_red_amt
    ,t.conv_out_amt as conv_out_amt
    ,t.trust_out_amt as trust_out_amt
    ,t.assign_out_amt as assign_out_amt
    ,t.div_vol_amt as div_vol_amt
    ,t.div_vol as div_vol
    ,t.div_amt as div_amt
    ,t.fund_end_amt as fund_end_amt
    ,t.force_sub_amt as force_sub_amt
    ,t.income_rate as income_rate
    ,t.total_cost as total_cost
    ,t.total_income as total_income
    ,t.avg_price as avg_price
    ,t.amt1 as amt1
    ,t.amt2 as amt2
    ,t.amt3 as amt3
    ,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
    ,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
    ,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
    ,t.avg_hold_price as avg_hold_price
    ,t.hold_profit_loss as hold_profit_loss
    ,t.old_hold_profit_loss as old_hold_profit_loss
    ,t.hold_tot_cost as hold_tot_cost
    ,t.bag_total_income as bag_total_income
    ,t.day_rate as day_rate
    ,t.income_new as income_new
    ,t.nav_date as nav_date
    ,t.profit_loss as profit_loss
    ,t.bag_cost as bag_cost
    ,t.bag_div_amt as bag_div_amt
from iol.nfss_tbtotdailyprofitloss t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_tbtotdailyprofitloss.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes