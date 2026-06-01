: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareannfinancialindicator_a
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_ashareannfinancialindicator.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode 
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode 
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt 
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period 
,t1.iflisted_data as iflisted_data 
,t1.statement_type as statement_type 
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code 
,t1.s_fa_eps_diluted as s_fa_eps_diluted 
,t1.s_fa_eps_basic as s_fa_eps_basic 
,t1.s_fa_eps_diluted2 as s_fa_eps_diluted2 
,t1.s_fa_eps_ex as s_fa_eps_ex 
,t1.s_fa_eps_exbasic as s_fa_eps_exbasic 
,t1.s_fa_eps_exdiluted as s_fa_eps_exdiluted 
,t1.s_fa_bps as s_fa_bps 
,t1.s_fa_bps_sh as s_fa_bps_sh 
,t1.s_fa_bps_adjust as s_fa_bps_adjust 
,t1.roe_diluted as roe_diluted 
,t1.roe_weighted as roe_weighted 
,t1.roe_ex as roe_ex 
,t1.roe_exweighted as roe_exweighted 
,t1.net_profit as net_profit 
,t1.rd_expense as rd_expense 
,t1.s_fa_extraordinary as s_fa_extraordinary 
,t1.s_fa_current as s_fa_current 
,t1.s_fa_quick as s_fa_quick 
,t1.s_fa_arturn as s_fa_arturn 
,t1.s_fa_invturn as s_fa_invturn 
,t1.s_ft_debttoassets as s_ft_debttoassets 
,t1.s_fa_ocfps as s_fa_ocfps 
,t1.s_fa_yoyocfps as s_fa_yoyocfps 
,t1.s_fa_deductedprofit as s_fa_deductedprofit 
,t1.s_fa_deductedprofit_yoy as s_fa_deductedprofit_yoy 
,t1.contributionps as contributionps 
,t1.growth_bps_sh as growth_bps_sh 
,t1.s_fa_yoyequity as s_fa_yoyequity 
,t1.yoy_roe_diluted as yoy_roe_diluted 
,t1.yoy_net_cash_flows as yoy_net_cash_flows 
,t1.s_fa_yoyeps_basic as s_fa_yoyeps_basic 
,t1.s_fa_yoyeps_diluted as s_fa_yoyeps_diluted 
,t1.s_fa_yoyop as s_fa_yoyop 
,t1.s_fa_yoyebt as s_fa_yoyebt 
,t1.net_profit_yoy as net_profit_yoy 
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo 
from ${iol_schema}.wind_ashareannfinancialindicator t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareannfinancialindicator.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes