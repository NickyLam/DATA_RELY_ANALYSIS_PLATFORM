: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_ptl_portfolio_f
CreateDate: 20240606
FileName:   ${iel_data_path}/fams_ptl_portfolio.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.portfolio_id,chr(13),''),chr(10),'') as portfolio_id
,replace(replace(t1.portfolio_type,chr(13),''),chr(10),'') as portfolio_type
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,vdate
,mdate
,replace(replace(t1.profit_type,chr(13),''),chr(10),'') as profit_type
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.income_flag,chr(13),''),chr(10),'') as income_flag
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.parent_portfolio_id,chr(13),''),chr(10),'') as parent_portfolio_id
,replace(replace(t1.invest_yesorno,chr(13),''),chr(10),'') as invest_yesorno
,replace(replace(t1.inv_trans_portf,chr(13),''),chr(10),'') as inv_trans_portf
,replace(replace(t1.risk_enabled,chr(13),''),chr(10),'') as risk_enabled
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy

from ${iol_schema}.fams_ptl_portfolio t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ptl_portfolio.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
