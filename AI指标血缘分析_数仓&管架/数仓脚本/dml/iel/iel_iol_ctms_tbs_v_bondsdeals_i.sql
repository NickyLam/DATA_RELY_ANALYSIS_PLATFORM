: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_bondsdeals_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_bondsdeals.i.${batch_date}.dat
IF_mark:    i
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
,replace(replace(t.bondstype,chr(13),''),chr(10),'') as bondstype
,replace(replace(t.serial_number,chr(13),''),chr(10),'') as serial_number
,t.tradedate as tradedate
,t.settledate as settledate
,replace(replace(t.buyorsell,chr(13),''),chr(10),'') as buyorsell
,t.cleanprice as cleanprice
,t.dirtyprice as dirtyprice
,t.yieldtomaturity as yieldtomaturity
,t.settleamount as settleamount
,t.portfolio_id as portfolio_id
,replace(replace(t.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,t.keepfolder_id as keepfolder_id
,replace(replace(t.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,replace(replace(t.folderatts,chr(13),''),chr(10),'') as folderatts
,replace(replace(t.classfyname,chr(13),''),chr(10),'') as classfyname
,replace(replace(t.cptys_shortname,chr(13),''),chr(10),'') as cptys_shortname
,t.cptys_id as cptys_id
,replace(replace(t.settletype,chr(13),''),chr(10),'') as settletype
,t.dealer_id as dealer_id
,replace(replace(t.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t.ref_number,chr(13),''),chr(10),'') as ref_number
,t.feeamount as feeamount
,t.taxamount as taxamount
,t.brokeramount as brokeramount
,replace(replace(t.note,chr(13),''),chr(10),'') as note
,t.nominal as nominal
,t.accruedamount as accruedamount
,replace(replace(t.cfets_from,chr(13),''),chr(10),'') as cfets_from
,replace(replace(t.source,chr(13),''),chr(10),'') as source
,t.lastmodified as lastmodified
,t.datasymbol_id as datasymbol_id
,t.assettype_id as assettype_id
,t.bondsdeals_id_grand as bondsdeals_id_grand
,replace(replace(t.stock_id,chr(13),''),chr(10),'') as stock_id
,t.convert_price as convert_price
,t.stock_price as stock_price
,t.convert_quantity as convert_quantity
,replace(replace(t.dn_dealer,chr(13),''),chr(10),'') as dn_dealer
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ctms_tbs_v_bondsdeals t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_bondsdeals.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes