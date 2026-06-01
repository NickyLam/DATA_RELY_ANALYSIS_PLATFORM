: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_estimationdeals_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ctms_tbs_v_estimationdeals.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.deal_id as deal_id
,replace(replace(t1.deal_name,chr(13),''),chr(10),'') as deal_name
,t1.aspclient_id as aspclient_id
,t1.calcdate as calcdate
,t1.balance_id as balance_id
,t1.holdamount as holdamount
,t1.faceamountestimate as faceamountestimate
,t1.marketestimate as marketestimate
,t1.fairvaluealter as fairvaluealter
,t1.pricedate as pricedate
,t1.fairprice as fairprice
,replace(replace(t1.pricesrc,chr(13),''),chr(10),'') as pricesrc
,t1.keepfolder_id as keepfolder_id
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.majorassetcode,chr(13),''),chr(10),'') as majorassetcode
,t1.lastmodified as lastmodified

from ${iol_schema}.ctms_tbs_v_estimationdeals t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_estimationdeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
