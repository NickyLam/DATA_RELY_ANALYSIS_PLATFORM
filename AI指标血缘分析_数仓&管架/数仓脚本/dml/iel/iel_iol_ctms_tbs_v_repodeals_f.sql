: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_repodeals_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ctms_tbs_v_repodeals.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.deal_id as deal_id
,replace(replace(t1.deal_tablename,chr(13),''),chr(10),'') as deal_tablename
,t1.aspclient_id as aspclient_id
,replace(replace(t1.bondscode,chr(13),''),chr(10),'') as bondscode
,replace(replace(t1.bondsname,chr(13),''),chr(10),'') as bondsname
,replace(replace(t1.serial_number,chr(13),''),chr(10),'') as serial_number
,t1.trade_date as trade_date
,t1.value_date as value_date
,t1.maturity_date as maturity_date
,replace(replace(t1.buyorsell,chr(13),''),chr(10),'') as buyorsell
,t1.face_amount as face_amount
,t1.first_price as first_price
,t1.maturity_price as maturity_price
,t1.repo_rate as repo_rate
,t1.amount as amount
,t1.maturity_amount as maturity_amount
,t1.fee1 as fee1
,t1.tax_amt1 as tax_amt1
,t1.broker_amt1 as broker_amt1
,t1.fee2 as fee2
,t1.tax_amt2 as tax_amt2
,t1.broker_amt2 as broker_amt2
,t1.interest as interest
,t1.portfolio_id as portfolio_id
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,t1.keepfolder_id as keepfolder_id
,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,replace(replace(t1.cptys_short_name,chr(13),''),chr(10),'') as cptys_short_name
,t1.cptys_id as cptys_id
,replace(replace(t1.settle_type,chr(13),''),chr(10),'') as settle_type
,replace(replace(t1.settle_type2,chr(13),''),chr(10),'') as settle_type2
,t1.dealer_id as dealer_id
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.ref_number,chr(13),''),chr(10),'') as ref_number
,replace(replace(t1.cfets_from,chr(13),''),chr(10),'') as cfets_from
,t1.lastmodified as lastmodified
,t1.datasymbol_id as datasymbol_id
,t1.repo_days as repo_days
,t1.repodeals_id_grand as repodeals_id_grand
,replace(replace(t1.repo_id,chr(13),''),chr(10),'') as repo_id
,replace(replace(t1.clearing_type,chr(13),''),chr(10),'') as clearing_type
,replace(replace(t1.dn_dealer,chr(13),''),chr(10),'') as dn_dealer

from ${iol_schema}.ctms_tbs_v_repodeals t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_repodeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
