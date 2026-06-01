: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_bondsdeals_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_bondsdeals_w.f.${batch_date}.dat
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
,replace(replace(bondstype,chr(10),''),chr(13),'') as bondstype
,replace(replace(serial_number,chr(10),''),chr(13),'') as serial_number
,replace(replace(tradedate,chr(10),''),chr(13),'') as tradedate
,replace(replace(settledate,chr(10),''),chr(13),'') as settledate
,replace(replace(buyorsell,chr(10),''),chr(13),'') as buyorsell
,replace(replace(cleanprice,chr(10),''),chr(13),'') as cleanprice
,replace(replace(dirtyprice,chr(10),''),chr(13),'') as dirtyprice
,replace(replace(yieldtomaturity,chr(10),''),chr(13),'') as yieldtomaturity
,replace(replace(settleamount,chr(10),''),chr(13),'') as settleamount
,replace(replace(portfolio_id,chr(10),''),chr(13),'') as portfolio_id
,replace(replace(portfolio_name,chr(10),''),chr(13),'') as portfolio_name
,replace(replace(keepfolder_id,chr(10),''),chr(13),'') as keepfolder_id
,replace(replace(keepfolder_shortname,chr(10),''),chr(13),'') as keepfolder_shortname
,replace(replace(folderatts,chr(10),''),chr(13),'') as folderatts
,replace(replace(classfyname,chr(10),''),chr(13),'') as classfyname
,replace(replace(cptys_shortname,chr(10),''),chr(13),'') as cptys_shortname
,replace(replace(cptys_id,chr(10),''),chr(13),'') as cptys_id
,replace(replace(settletype,chr(10),''),chr(13),'') as settletype
,replace(replace(dealer_id,chr(10),''),chr(13),'') as dealer_id
,replace(replace(dealer_name,chr(10),''),chr(13),'') as dealer_name
,replace(replace(ref_number,chr(10),''),chr(13),'') as ref_number
,replace(replace(feeamount,chr(10),''),chr(13),'') as feeamount
,replace(replace(taxamount,chr(10),''),chr(13),'') as taxamount
,replace(replace(brokeramount,chr(10),''),chr(13),'') as brokeramount
,replace(replace(note,chr(10),''),chr(13),'') as note
,replace(replace(nominal,chr(10),''),chr(13),'') as nominal
,replace(replace(accruedamount,chr(10),''),chr(13),'') as accruedamount
,replace(replace(cfets_from,chr(10),''),chr(13),'') as cfets_from
,replace(replace(source,chr(10),''),chr(13),'') as source
,replace(replace(lastmodified,chr(10),''),chr(13),'') as lastmodified
,replace(replace(datasymbol_id,chr(10),''),chr(13),'') as datasymbol_id
,replace(replace(assettype_id,chr(10),''),chr(13),'') as assettype_id
,replace(replace(bondsdeals_id_grand,chr(10),''),chr(13),'') as bondsdeals_id_grand
,replace(replace(stock_id,chr(10),''),chr(13),'') as stock_id
,replace(replace(convert_price,chr(10),''),chr(13),'') as convert_price
,replace(replace(stock_price,chr(10),''),chr(13),'') as stock_price
,replace(replace(convert_quantity,chr(10),''),chr(13),'') as convert_quantity
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_v_bondsdeals
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_bondsdeals_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes