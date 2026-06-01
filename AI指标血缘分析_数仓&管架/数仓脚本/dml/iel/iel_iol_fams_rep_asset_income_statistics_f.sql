: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_rep_asset_income_statistics_f
CreateDate: 20250523
FileName:   ${iel_data_path}/fams_rep_asset_income_statistics.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cdate,chr(13),''),chr(10),'') as cdate
,replace(replace(t1.assetcode,chr(13),''),chr(10),'') as assetcode
,replace(replace(t1.assetname,chr(13),''),chr(10),'') as assetname
,replace(replace(t1.vdate,chr(13),''),chr(10),'') as vdate
,replace(replace(t1.mdate,chr(13),''),chr(10),'') as mdate
,replace(replace(t1.cmdate,chr(13),''),chr(10),'') as cmdate
,replace(replace(t1.basis_name,chr(13),''),chr(10),'') as basis_name
,issue_amt
,position
,custrate
,ratio_rate
,capital_rate
,replace(replace(t1.debt_cost,chr(13),''),chr(10),'') as debt_cost
,share_amt_pre_tax
,share_amt
,adjust_amt_pre_tax
,adjust_amt
,share_amount_pre_tax
,share_amount
,replace(replace(t1.org_code,chr(13),''),chr(10),'') as org_code
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_rep_asset_income_statistics t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_rep_asset_income_statistics.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
