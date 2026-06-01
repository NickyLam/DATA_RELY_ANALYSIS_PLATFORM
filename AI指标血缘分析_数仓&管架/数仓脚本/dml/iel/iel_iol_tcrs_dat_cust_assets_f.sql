: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_dat_cust_assets_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_dat_cust_assets.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.seq_id,chr(13),''),chr(10),'') as seq_id
,replace(replace(t.src_seq,chr(13),''),chr(10),'') as src_seq
,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t.ecif_cust_no,chr(13),''),chr(10),'') as ecif_cust_no
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.deposit_mon_avg,chr(13),''),chr(10),'') as deposit_mon_avg
,replace(replace(t.fnc_mon_avg,chr(13),''),chr(10),'') as fnc_mon_avg
,replace(replace(t.fund_mon_avg,chr(13),''),chr(10),'') as fund_mon_avg
,replace(replace(t.nsr_fnc_mon_avg,chr(13),''),chr(10),'') as nsr_fnc_mon_avg
,replace(replace(t.total_balance_mon_avg,chr(13),''),chr(10),'') as total_balance_mon_avg
,replace(replace(t.open_branch,chr(13),''),chr(10),'') as open_branch
,replace(replace(t.open_branch_name,chr(13),''),chr(10),'') as open_branch_name
,replace(replace(t.manager_org_id,chr(13),''),chr(10),'') as manager_org_id
,replace(replace(t.manager_org_name,chr(13),''),chr(10),'') as manager_org_name
,replace(replace(t.cust_manager_id,chr(13),''),chr(10),'') as cust_manager_id
,replace(replace(t.cust_manager_name,chr(13),''),chr(10),'') as cust_manager_name
,replace(replace(t.co_manager_id,chr(13),''),chr(10),'') as co_manager_id
,replace(replace(t.co_manager_name,chr(13),''),chr(10),'') as co_manager_name
,t.ctime as ctime
,t.mtime as mtime
,replace(replace(t.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t.return_msg,chr(13),''),chr(10),'') as return_msg
,t.version as version
,replace(replace(t.annual_avg_deposit,chr(13),''),chr(10),'') as annual_avg_deposit
,replace(replace(t.annual_avg_financial,chr(13),''),chr(10),'') as annual_avg_financial
,replace(replace(t.annual_avg_fund,chr(13),''),chr(10),'') as annual_avg_fund
,replace(replace(t.annual_avg_insurance,chr(13),''),chr(10),'') as annual_avg_insurance
,replace(replace(t.annual_avg_asset_total_balance,chr(13),''),chr(10),'') as annual_avg_asset_total_balance
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tcrs_dat_cust_assets t
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_dat_cust_assets.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes