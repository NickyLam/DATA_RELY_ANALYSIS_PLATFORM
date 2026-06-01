: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_bondsdeals_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_bondsdeals.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.deal_id as deal_id
,replace(replace(t1.deal_tablename,chr(13),''),chr(10),'') as deal_tablename
,t1.aspclient_id as aspclient_id
,replace(replace(t1.bondscode,chr(13),''),chr(10),'') as bondscode
,replace(replace(t1.bondsname,chr(13),''),chr(10),'') as bondsname
,replace(replace(t1.bondstype,chr(13),''),chr(10),'') as bondstype
,replace(replace(t1.serial_number,chr(13),''),chr(10),'') as serial_number
,t1.tradedate as tradedate
,t1.settledate as settledate
,replace(replace(t1.buyorsell,chr(13),''),chr(10),'') as buyorsell
,t1.cleanprice as cleanprice
,t1.dirtyprice as dirtyprice
,t1.yieldtomaturity as yieldtomaturity
,t1.settleamount as settleamount
,t1.portfolio_id as portfolio_id
,replace(replace(t1.portfolio_name,chr(13),''),chr(10),'') as portfolio_name
,t1.keepfolder_id as keepfolder_id
,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,replace(replace(t1.folderatts,chr(13),''),chr(10),'') as folderatts
,replace(replace(t1.classfyname,chr(13),''),chr(10),'') as classfyname
,replace(replace(t1.cptys_shortname,chr(13),''),chr(10),'') as cptys_shortname
,t1.cptys_id as cptys_id
,replace(replace(t1.settletype,chr(13),''),chr(10),'') as settletype
,t1.dealer_id as dealer_id
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.ref_number,chr(13),''),chr(10),'') as ref_number
,t1.feeamount as feeamount
,t1.taxamount as taxamount
,t1.brokeramount as brokeramount
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,t1.nominal as nominal
,t1.accruedamount as accruedamount
,replace(replace(t1.cfets_from,chr(13),''),chr(10),'') as cfets_from
,replace(replace(t1.source,chr(13),''),chr(10),'') as source
,t1.lastmodified as lastmodified
,t1.datasymbol_id as datasymbol_id
,t1.assettype_id as assettype_id
,t1.bondsdeals_id_grand as bondsdeals_id_grand
,replace(replace(t1.stock_id,chr(13),''),chr(10),'') as stock_id
,t1.convert_price as convert_price
,t1.stock_price as stock_price
,t1.convert_quantity as convert_quantity
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.ctms_tbs_v_bondsdeals t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_bondsdeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes