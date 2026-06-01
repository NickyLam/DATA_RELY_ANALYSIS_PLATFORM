: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ctms_tbs_v_balance_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ctms_tbs_v_balance.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 t1.baretrade_id as baretrade_id
,replace(replace(t1.baretradename,chr(13),''),chr(10),'') as baretradename
,t1.balance_id as balance_id
,t1.alterbalance_id as alterbalance_id
,t1.aspclient_id as aspclient_id
,t1.keepfolder_id as keepfolder_id
,t1.settledate as settledate
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.buztype,chr(13),''),chr(10),'') as buztype
,replace(replace(t1.majorassetcode,chr(13),''),chr(10),'') as majorassetcode
,replace(replace(t1.minorassetcode,chr(13),''),chr(10),'') as minorassetcode
,t1.holdposition as holdposition
,t1.holdfaceamount as holdfaceamount
,t1.cleanpricecost as cleanpricecost
,t1.interestadjust as interestadjust
,t1.fairvaluealter as fairvaluealter
,t1.interestcost as interestcost
,t1.dirtypricecost as dirtypricecost
,t1.impairment as impairment
,t1.priceearning as priceearning
,t1.amortizeearning as amortizeearning
,t1.interestearning as interestearning
,t1.fairvalueincome as fairvalueincome
,t1.impairmentlost as impairmentlost
,t1.tradeexpense as tradeexpense
,t1.realrate as realrate
,t1.valuedate as valuedate
,t1.maturitydate as maturitydate
,t1.lastmodified as lastmodified
,t1.occuramount as occuramount
,t1.balance_id_prev as balance_id_prev
,replace(replace(t1.rev_flag,chr(13),''),chr(10),'') as rev_flag
,t1.reservevalue1 as reservevalue1
,t1.reservevalue2 as reservevalue2
 from iol.ctms_tbs_v_balance T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ctms_tbs_v_balance.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes