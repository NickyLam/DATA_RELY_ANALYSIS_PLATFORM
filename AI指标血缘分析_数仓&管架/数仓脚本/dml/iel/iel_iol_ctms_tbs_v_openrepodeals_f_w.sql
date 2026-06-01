: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_openrepodeals_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_openrepodeals_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(deal_id,chr(10),''),chr(13),'') as deal_id
,replace(replace(deal_tablename,chr(10),''),chr(13),'') as deal_tablename
,replace(replace(aspclient_id,chr(10),''),chr(13),'') as aspclient_id
,replace(replace(serial_number,chr(10),''),chr(13),'') as serial_number
,replace(replace(portfolio_id,chr(10),''),chr(13),'') as portfolio_id
,replace(replace(portfolio_name,chr(10),''),chr(13),'') as portfolio_name
,replace(replace(keepfolder_id,chr(10),''),chr(13),'') as keepfolder_id
,replace(replace(keepfolder_shortname,chr(10),''),chr(13),'') as keepfolder_shortname
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(buyorsell,chr(10),''),chr(13),'') as buyorsell
,replace(replace(amount,chr(10),''),chr(13),'') as amount
,replace(replace(trade_rate,chr(10),''),chr(13),'') as trade_rate
,replace(replace(ref_number,chr(10),''),chr(13),'') as ref_number
,replace(replace(trade_date,chr(10),''),chr(13),'') as trade_date
,replace(replace(value_date,chr(10),''),chr(13),'') as value_date
,replace(replace(maturity_date,chr(10),''),chr(13),'') as maturity_date
,replace(replace(bondscode,chr(10),''),chr(13),'') as bondscode
,replace(replace(bondsname,chr(10),''),chr(13),'') as bondsname
,replace(replace(face_amount,chr(10),''),chr(13),'') as face_amount
,replace(replace(first_price,chr(10),''),chr(13),'') as first_price
,replace(replace(maturity_price,chr(10),''),chr(13),'') as maturity_price
,replace(replace(maturity_amount,chr(10),''),chr(13),'') as maturity_amount
,replace(replace(interest,chr(10),''),chr(13),'') as interest
,replace(replace(cpty_id,chr(10),''),chr(13),'') as cpty_id
,replace(replace(cpty_name,chr(10),''),chr(13),'') as cpty_name
,replace(replace(dealer_id,chr(10),''),chr(13),'') as dealer_id
,replace(replace(dealer_name,chr(10),''),chr(13),'') as dealer_name
,replace(replace(fee1,chr(10),''),chr(13),'') as fee1
,replace(replace(tax_amt1,chr(10),''),chr(13),'') as tax_amt1
,replace(replace(broker_amt1,chr(10),''),chr(13),'') as broker_amt1
,replace(replace(fee2,chr(10),''),chr(13),'') as fee2
,replace(replace(tax_amt2,chr(10),''),chr(13),'') as tax_amt2
,replace(replace(broker_amt2,chr(10),''),chr(13),'') as broker_amt2
,replace(replace(tradingfee,chr(10),''),chr(13),'') as tradingfee
,replace(replace(settle_type,chr(10),''),chr(13),'') as settle_type
,replace(replace(settle_type2,chr(10),''),chr(13),'') as settle_type2
,replace(replace(source,chr(10),''),chr(13),'') as source
,replace(replace(cfets_from,chr(10),''),chr(13),'') as cfets_from
,replace(replace(spot_v,chr(10),''),chr(13),'') as spot_v
,replace(replace(fwd_v,chr(10),''),chr(13),'') as fwd_v
,replace(replace(cstp_req,chr(10),''),chr(13),'') as cstp_req
,replace(replace(keep_type,chr(10),''),chr(13),'') as keep_type
,replace(replace(note,chr(10),''),chr(13),'') as note
,replace(replace(datasymbol_id,chr(10),''),chr(13),'') as datasymbol_id
,replace(replace(lastmodified,chr(10),''),chr(13),'') as lastmodified
,replace(replace(openrepodeals_id_grand,chr(10),''),chr(13),'') as openrepodeals_id_grand
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_v_openrepodeals
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_openrepodeals_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes