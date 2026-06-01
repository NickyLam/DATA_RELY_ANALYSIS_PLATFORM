: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_ldrepodeals_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_ldrepodeals_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(deal_id,chr(10),''),chr(13),'') as deal_id
,replace(replace(deal_tablename,chr(10),''),chr(13),'') as deal_tablename
,replace(replace(aspclient_id,chr(10),''),chr(13),'') as aspclient_id
,replace(replace(bondscode,chr(10),''),chr(13),'') as bondscode
,replace(replace(bondsname,chr(10),''),chr(13),'') as bondsname
,replace(replace(serial_number,chr(10),''),chr(13),'') as serial_number
,replace(replace(trade_date,chr(10),''),chr(13),'') as trade_date
,replace(replace(value_date,chr(10),''),chr(13),'') as value_date
,replace(replace(maturity_date,chr(10),''),chr(13),'') as maturity_date
,replace(replace(buyorsell,chr(10),''),chr(13),'') as buyorsell
,replace(replace(face_amount,chr(10),''),chr(13),'') as face_amount
,replace(replace(repo_rate,chr(10),''),chr(13),'') as repo_rate
,replace(replace(amount,chr(10),''),chr(13),'') as amount
,replace(replace(maturity_amount,chr(10),''),chr(13),'') as maturity_amount
,replace(replace(fee,chr(10),''),chr(13),'') as fee
,replace(replace(tax_amt,chr(10),''),chr(13),'') as tax_amt
,replace(replace(broker_amt,chr(10),''),chr(13),'') as broker_amt
,replace(replace(interest,chr(10),''),chr(13),'') as interest
,replace(replace(portfolio_id,chr(10),''),chr(13),'') as portfolio_id
,replace(replace(portfolio_name,chr(10),''),chr(13),'') as portfolio_name
,replace(replace(keepfolder_id,chr(10),''),chr(13),'') as keepfolder_id
,replace(replace(keepfolder_shortname,chr(10),''),chr(13),'') as keepfolder_shortname
,replace(replace(cptys_short_name,chr(10),''),chr(13),'') as cptys_short_name
,replace(replace(cptys_id,chr(10),''),chr(13),'') as cptys_id
,replace(replace(settle_type,chr(10),''),chr(13),'') as settle_type
,replace(replace(settle_type2,chr(10),''),chr(13),'') as settle_type2
,replace(replace(dealer_id,chr(10),''),chr(13),'') as dealer_id
,replace(replace(dealer_name,chr(10),''),chr(13),'') as dealer_name
,replace(replace(ref_number,chr(10),''),chr(13),'') as ref_number
,replace(replace(cfets_from,chr(10),''),chr(13),'') as cfets_from
,replace(replace(lastmodified,chr(10),''),chr(13),'') as lastmodified
,replace(replace(datasymbol_id,chr(10),''),chr(13),'') as datasymbol_id
,replace(replace(trade_rate,chr(10),''),chr(13),'') as trade_rate
,replace(replace(repo_days,chr(10),''),chr(13),'') as repo_days
,replace(replace(ldrepodeals_id_grand,chr(10),''),chr(13),'') as ldrepodeals_id_grand
,replace(replace(repo_id,chr(10),''),chr(13),'') as repo_id
,replace(replace(counterparty_type,chr(10),''),chr(13),'') as counterparty_type
,replace(replace(clearing_type,chr(10),''),chr(13),'') as clearing_type
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_v_ldrepodeals
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_ldrepodeals_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes