: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hxyhbalancesheet_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hxyhbalancesheet_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(comp_id,chr(10),''),chr(13),'') as comp_id
,replace(replace(ann_dt,chr(10),''),chr(13),'') as ann_dt
,replace(replace(report_period,chr(10),''),chr(13),'') as report_period
,replace(replace(statement_type,chr(10),''),chr(13),'') as statement_type
,replace(replace(iflisted_data,chr(10),''),chr(13),'') as iflisted_data
,replace(replace(crncy_code,chr(10),''),chr(13),'') as crncy_code
,replace(replace(prepay,chr(10),''),chr(13),'') as prepay
,replace(replace(inventories,chr(10),''),chr(13),'') as inventories
,replace(replace(acct_rcv,chr(10),''),chr(13),'') as acct_rcv
,replace(replace(tot_cur_assets,chr(10),''),chr(13),'') as tot_cur_assets
,replace(replace(tot_assets,chr(10),''),chr(13),'') as tot_assets
,replace(replace(st_borrow,chr(10),''),chr(13),'') as st_borrow
,replace(replace(int_payable,chr(10),''),chr(13),'') as int_payable
,replace(replace(non_cur_liab_due_within_1y,chr(10),''),chr(13),'') as non_cur_liab_due_within_1y
,replace(replace(tot_cur_liab,chr(10),''),chr(13),'') as tot_cur_liab
,replace(replace(lt_borrow,chr(10),''),chr(13),'') as lt_borrow
,replace(replace(bonds_payable,chr(10),''),chr(13),'') as bonds_payable
,replace(replace(total_liabilities,chr(10),''),chr(13),'') as total_liabilities
,replace(replace(cap_stk,chr(10),''),chr(13),'') as cap_stk
,replace(replace(cap_rsrv,chr(10),''),chr(13),'') as cap_rsrv
,replace(replace(tot_shrhldr_eqy_excl_min_int,chr(10),''),chr(13),'') as tot_shrhldr_eqy_excl_min_int
,replace(replace(tot_shrhldr_eqy_incl_min_int,chr(10),''),chr(13),'') as tot_shrhldr_eqy_incl_min_int
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_hxyhbalancesheet where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hxyhbalancesheet_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes