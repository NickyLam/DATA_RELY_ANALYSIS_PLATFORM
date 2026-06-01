: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_fund_risk_pct_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_fund_risk_pct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.risk_pct_id,chr(13),''),chr(10),'') as risk_pct_id
,replace(replace(t1.asset_name,chr(13),''),chr(10),'') as asset_name
,t1.wt as wt
,t1.pct as pct
,t1.effect_dt as effect_dt
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.prd_fund_risk_pct_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_fund_risk_pct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes