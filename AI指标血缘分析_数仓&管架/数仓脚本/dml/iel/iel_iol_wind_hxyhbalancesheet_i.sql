: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hxyhbalancesheet_i
CreateDate: 20221108
FileName:   ${iel_data_path}/wind_hxyhbalancesheet.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.comp_id,chr(13),''),chr(10),'') as comp_id
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.iflisted_data,chr(13),''),chr(10),'') as iflisted_data
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,prepay
,inventories
,acct_rcv
,tot_cur_assets
,tot_assets
,st_borrow
,int_payable
,non_cur_liab_due_within_1y
,tot_cur_liab
,lt_borrow
,bonds_payable
,total_liabilities
,cap_stk
,cap_rsrv
,tot_shrhldr_eqy_excl_min_int
,tot_shrhldr_eqy_incl_min_int
,to_date('${batch_date}','yyyymmdd') as etl_dt

from ${iol_schema}.wind_hxyhbalancesheet t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hxyhbalancesheet.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
