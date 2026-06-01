: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ctms_tbs_v_balance2_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ctms_tbs_v_balance2.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.baretrade_id
,t1.baretradename
,t1.balance_id
,t1.alterbalance_id
,t1.aspclient_id
,t1.keepfolder_id
,t1.settledate
,t1.assettype
,t1.buztype
,t1.majorassetcode
,t1.minorassetcode
,t1.holdposition
,t1.holdfaceamount
,t1.cleanpricecost
,t1.interestadjust
,t1.fairvaluealter
,t1.interestcost
,t1.dirtypricecost
,t1.impairment
,t1.priceearning
,t1.amortizeearning
,t1.interestearning
,t1.fairvalueincome
,t1.impairmentlost
,t1.tradeexpense
,t1.realrate
,t1.valuedate
,t1.maturitydate
,t1.lastmodified
,t1.occuramount
,t1.balance_id_prev
,t1.rev_flag
,t1.reservevalue1
,t1.reservevalue2
,t1.start_dt
,t1.end_dt
,t1.id_mark
,t1.etl_timestamp
from ${idl_schema}.hdws_ctms_tbs_v_balance2 t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ctms_tbs_v_balance2.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes