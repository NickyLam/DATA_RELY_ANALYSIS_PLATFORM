: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ctms_tbs_v_bondsdeals_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ctms_tbs_v_bondsdeals.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.deal_id
,t1.deal_tablename
,t1.aspclient_id
,t1.bondscode
,t1.bondsname
,t1.bondstype
,t1.serial_number
,t1.tradedate
,t1.settledate
,t1.buyorsell
,t1.cleanprice
,t1.dirtyprice
,t1.yieldtomaturity
,t1.settleamount
,t1.portfolio_id
,t1.portfolio_name
,t1.keepfolder_id
,t1.keepfolder_shortname
,t1.folderatts
,t1.classfyname
,t1.cptys_shortname
,t1.cptys_id
,t1.settletype
,t1.dealer_id
,t1.dealer_name
,t1.ref_number
,t1.feeamount
,t1.taxamount
,t1.brokeramount
,t1.note
,t1.nominal
,t1.accruedamount
,t1.cfets_from
,t1.source
,t1.lastmodified
,t1.datasymbol_id
,t1.assettype_id
,t1.bondsdeals_id_grand
,t1.stock_id
,t1.convert_price
,t1.stock_price
,t1.convert_quantity
,t1.dn_dealer
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_ctms_tbs_v_bondsdeals t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ctms_tbs_v_bondsdeals.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes