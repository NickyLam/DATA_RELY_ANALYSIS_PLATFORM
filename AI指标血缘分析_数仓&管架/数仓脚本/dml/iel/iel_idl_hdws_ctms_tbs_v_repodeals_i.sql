: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ctms_tbs_v_repodeals_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ctms_tbs_v_repodeals.i.${batch_date}.dat
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
,t1.serial_number
,t1.trade_date
,t1.value_date
,t1.maturity_date
,t1.buyorsell
,t1.face_amount
,t1.first_price
,t1.maturity_price
,t1.repo_rate
,t1.amount
,t1.maturity_amount
,t1.fee1
,t1.tax_amt1
,t1.broker_amt1
,t1.fee2
,t1.tax_amt2
,t1.broker_amt2
,t1.interest
,t1.portfolio_id
,t1.portfolio_name
,t1.keepfolder_id
,t1.keepfolder_shortname
,t1.cptys_short_name
,t1.cptys_id
,t1.settle_type
,t1.settle_type2
,t1.dealer_id
,t1.dealer_name
,t1.ref_number
,t1.cfets_from
,t1.lastmodified
,t1.datasymbol_id
,t1.repo_days
,t1.repodeals_id_grand
,t1.repo_id
,t1.clearing_type
,t1.dn_dealer
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_ctms_tbs_v_repodeals t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ctms_tbs_v_repodeals.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes