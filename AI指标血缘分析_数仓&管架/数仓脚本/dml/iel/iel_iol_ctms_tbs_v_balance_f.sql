: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_balance_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_balance.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.baretrade_id as baretrade_id
,replace(replace(t.baretradename,chr(13),''),chr(10),'') as baretradename
,t.balance_id as balance_id
,t.alterbalance_id as alterbalance_id
,t.aspclient_id as aspclient_id
,t.keepfolder_id as keepfolder_id
,t.settledate as settledate
,replace(replace(t.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t.buztype,chr(13),''),chr(10),'') as buztype
,replace(replace(t.majorassetcode,chr(13),''),chr(10),'') as majorassetcode
,replace(replace(t.minorassetcode,chr(13),''),chr(10),'') as minorassetcode
,t.holdposition as holdposition
,t.holdfaceamount as holdfaceamount
,t.cleanpricecost as cleanpricecost
,t.interestadjust as interestadjust
,t.fairvaluealter as fairvaluealter
,t.interestcost as interestcost
,t.dirtypricecost as dirtypricecost
,t.impairment as impairment
,t.priceearning as priceearning
,t.amortizeearning as amortizeearning
,t.interestearning as interestearning
,t.fairvalueincome as fairvalueincome
,t.impairmentlost as impairmentlost
,t.tradeexpense as tradeexpense
,t.realrate as realrate
,t.valuedate as valuedate
,t.maturitydate as maturitydate
,t.lastmodified as lastmodified
,t.occuramount as occuramount
,t.balance_id_prev as balance_id_prev
,replace(replace(t.rev_flag,chr(13),''),chr(10),'') as rev_flag
,t.reservevalue1 as reservevalue1
,t.reservevalue2 as reservevalue2
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ctms_tbs_v_balance t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_balance.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes