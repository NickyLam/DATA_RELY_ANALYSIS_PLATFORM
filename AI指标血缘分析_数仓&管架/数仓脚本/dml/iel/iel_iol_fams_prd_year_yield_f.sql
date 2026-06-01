: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_prd_year_yield_f
CreateDate: 20240613
FileName:   ${iel_data_path}/fams_prd_year_yield.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.val_date,chr(13),''),chr(10),'') as val_date
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,paidup_capital
,unit_net
,total_net
,asset_val
,day_yield
,seven_yield
,month_yield
,three_month_yield
,six_month_yield
,year_yield
,since_this_year_yield
,two_year_yield
,three_year_yield
,establish_yield
,upper_cycle_yield
,replace(replace(t1.send_type,chr(13),''),chr(10),'') as send_type
,replace(replace(t1.send_status,chr(13),''),chr(10),'') as send_status
,send_time
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,seven_retreat_yield
,month_retreat_yield
,three_month_retreat_yield
,six_month_retreat_yield
,year_retreat_yield
,since_this_year_retreat_yield
,establish_retreat_yield
,replace(replace(t1.deal_mode,chr(13),''),chr(10),'') as deal_mode
,replace(replace(t1.profit_type,chr(13),''),chr(10),'') as profit_type
,vdate
,mdate
,base_rule_value
,tot_net_unit_value
,five_year_yield
,day_yield_chg
,seven_yield_chg
,month_yield_chg
,three_month_yield_chg
,six_month_yield_chg
,year_yield_chg
,three_year_yield_chg
,five_year_yield_chg
,since_this_year_yield_chg
,establish_yield_chg
,past_fiscal_year_yield
,past_fiscal_year_two_yield
,past_fiscal_year_three_yield
,past_fiscal_year_four_yield
,past_fiscal_year_five_yield
,raise_amt

from ${iol_schema}.fams_prd_year_yield t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_prd_year_yield.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
