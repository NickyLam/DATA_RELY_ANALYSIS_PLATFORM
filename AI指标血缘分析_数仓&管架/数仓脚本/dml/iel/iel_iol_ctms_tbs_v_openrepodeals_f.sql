: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_openrepodeals_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ctms_tbs_v_openrepodeals.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.deal_id as deal_id
,replace(replace(t1.deal_tablename,chr(13),''),chr(10),'') as deal_tablename
,t1.aspclient_id as aspclient_id
,replace(replace(t1.serial_number,chr(13),''),chr(10),'') as serial_number
,t1.portfolio_id as portfolio_id
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,t1.keepfolder_id as keepfolder_id
,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.buyorsell,chr(13),''),chr(10),'') as buyorsell
,t1.amount as amount
,t1.trade_rate as trade_rate
,replace(replace(t1.ref_number,chr(13),''),chr(10),'') as ref_number
,t1.trade_date as trade_date
,t1.value_date as value_date
,t1.maturity_date as maturity_date
,replace(replace(t1.bondscode,chr(13),''),chr(10),'') as bondscode
,replace(replace(t1.bondsname,chr(13),''),chr(10),'') as bondsname
,t1.face_amount as face_amount
,t1.first_price as first_price
,t1.maturity_price as maturity_price
,t1.maturity_amount as maturity_amount
,t1.interest as interest
,t1.cpty_id as cpty_id
,replace(replace(t1.cpty_name,chr(13),''),chr(10),'') as cpty_name
,t1.dealer_id as dealer_id
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,t1.fee1 as fee1
,t1.tax_amt1 as tax_amt1
,t1.broker_amt1 as broker_amt1
,t1.fee2 as fee2
,t1.tax_amt2 as tax_amt2
,t1.broker_amt2 as broker_amt2
,t1.tradingfee as tradingfee
,replace(replace(t1.settle_type,chr(13),''),chr(10),'') as settle_type
,replace(replace(t1.settle_type2,chr(13),''),chr(10),'') as settle_type2
,replace(replace(t1.source,chr(13),''),chr(10),'') as source
,replace(replace(t1.cfets_from,chr(13),''),chr(10),'') as cfets_from
,t1.spot_v as spot_v
,t1.fwd_v as fwd_v
,replace(replace(t1.cstp_req,chr(13),''),chr(10),'') as cstp_req
,replace(replace(t1.keep_type,chr(13),''),chr(10),'') as keep_type
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,t1.datasymbol_id as datasymbol_id
,t1.lastmodified as lastmodified
,t1.openrepodeals_id_grand as openrepodeals_id_grand
,replace(replace(t1.dn_dealer,chr(13),''),chr(10),'') as dn_dealer

from ${iol_schema}.ctms_tbs_v_openrepodeals t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_openrepodeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
