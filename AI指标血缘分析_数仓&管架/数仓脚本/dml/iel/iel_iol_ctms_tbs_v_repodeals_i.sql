: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_repodeals_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_repodeals.i.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.deal_id as deal_id
,replace(replace(t.deal_tablename,chr(13),''),chr(10),'') as deal_tablename
,t.aspclient_id as aspclient_id
,replace(replace(t.bondscode,chr(13),''),chr(10),'') as bondscode
,replace(replace(t.bondsname,chr(13),''),chr(10),'') as bondsname
,replace(replace(t.serial_number,chr(13),''),chr(10),'') as serial_number
,t.trade_date as trade_date
,t.value_date as value_date
,t.maturity_date as maturity_date
,replace(replace(t.buyorsell,chr(13),''),chr(10),'') as buyorsell
,t.face_amount as face_amount
,t.first_price as first_price
,t.maturity_price as maturity_price
,t.repo_rate as repo_rate
,t.amount as amount
,t.maturity_amount as maturity_amount
,t.fee1 as fee1
,t.tax_amt1 as tax_amt1
,t.broker_amt1 as broker_amt1
,t.fee2 as fee2
,t.tax_amt2 as tax_amt2
,t.broker_amt2 as broker_amt2
,t.interest as interest
,t.portfolio_id as portfolio_id
,replace(replace(t.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,t.keepfolder_id as keepfolder_id
,replace(replace(t.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,replace(replace(t.cptys_short_name,chr(13),''),chr(10),'') as cptys_short_name
,t.cptys_id as cptys_id
,replace(replace(t.settle_type,chr(13),''),chr(10),'') as settle_type
,replace(replace(t.settle_type2,chr(13),''),chr(10),'') as settle_type2
,t.dealer_id as dealer_id
,replace(replace(t.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t.ref_number,chr(13),''),chr(10),'') as ref_number
,replace(replace(t.cfets_from,chr(13),''),chr(10),'') as cfets_from
,t.lastmodified as lastmodified
,t.datasymbol_id as datasymbol_id
,t.repo_days as repo_days
,t.repodeals_id_grand as repodeals_id_grand
,replace(replace(t.repo_id,chr(13),''),chr(10),'') as repo_id
,replace(replace(t.clearing_type,chr(13),''),chr(10),'') as clearing_type
,replace(replace(t.dn_dealer,chr(13),''),chr(10),'') as dn_dealer
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ctms_tbs_v_repodeals t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_repodeals.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes