: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hxyhbalancesheet_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hxyhbalancesheet.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.comp_id,chr(13),''),chr(10),'') as comp_id
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.iflisted_data,chr(13),''),chr(10),'') as iflisted_data
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.prepay as prepay
,t1.inventories as inventories
,t1.acct_rcv as acct_rcv
,t1.tot_cur_assets as tot_cur_assets
,t1.tot_assets as tot_assets
,t1.st_borrow as st_borrow
,t1.int_payable as int_payable
,t1.non_cur_liab_due_within_1y as non_cur_liab_due_within_1y
,t1.tot_cur_liab as tot_cur_liab
,t1.lt_borrow as lt_borrow
,t1.bonds_payable as bonds_payable
,t1.total_liabilities as total_liabilities
,t1.cap_stk as cap_stk
,t1.cap_rsrv as cap_rsrv
,t1.tot_shrhldr_eqy_excl_min_int as tot_shrhldr_eqy_excl_min_int
,t1.tot_shrhldr_eqy_incl_min_int as tot_shrhldr_eqy_incl_min_int
from ${iol_schema}.wind_hxyhbalancesheet t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hxyhbalancesheet.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes