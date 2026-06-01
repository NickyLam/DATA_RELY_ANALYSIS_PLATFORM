: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mnm_dpbodeal_i
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_mnm_dpbodeal.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.seqno,chr(13),''),chr(10),'') as seqno
,replace(replace(t1.tradeid,chr(13),''),chr(10),'') as tradeid
,replace(replace(t1.ps,chr(13),''),chr(10),'') as ps
,t1.externalflag as externalflag
,t1.dealdate as dealdate
,t1.vdate as vdate
,t1.mdate as mdate
,replace(replace(t1.counterid,chr(13),''),chr(10),'') as counterid
,replace(replace(t1.countertrader,chr(13),''),chr(10),'') as countertrader
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.accounttrader,chr(13),''),chr(10),'') as accounttrader
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,t1.dlamt as dlamt
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.interestrate,chr(13),''),chr(10),'') as interestrate
,t1.rate as rate
,replace(replace(t1.ratecode,chr(13),''),chr(10),'') as ratecode
,t1.coefficient as coefficient
,t1.spreadrate as spreadrate
,t1.interestfrequency as interestfrequency
,replace(replace(t1.schecalrule,chr(13),''),chr(10),'') as schecalrule
,t1.firstpayrateday as firstpayrateday
,t1.rateadjfrequency as rateadjfrequency
,replace(replace(t1.rateadjrule,chr(13),''),chr(10),'') as rateadjrule
,t1.firstrateadjday as firstrateadjday
,replace(replace(t1.workdayrule,chr(13),''),chr(10),'') as workdayrule
,replace(replace(t1.ratevaluecdtn,chr(13),''),chr(10),'') as ratevaluecdtn
,t1.ratevaluedays as ratevaluedays
,replace(replace(t1.isoriginal,chr(13),''),chr(10),'') as isoriginal
,replace(replace(t1.assetps,chr(13),''),chr(10),'') as assetps
,t1.internalflag as internalflag
,t1.prinsettamt as prinsettamt
,t1.intsettamt as intsettamt
,t1.settdate as settdate
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.bookdate as bookdate
,t1.prinpayday as prinpayday
,replace(replace(t1.prinpaymark,chr(13),''),chr(10),'') as prinpaymark
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.lstmntuser,chr(13),''),chr(10),'') as lstmntuser
,t1.lstmntdate as lstmntdate
,replace(replace(t1.oriseqno,chr(13),''),chr(10),'') as oriseqno
,replace(replace(t1.countertype,chr(13),''),chr(10),'') as countertype
,t1.effdate as effdate
,t1.revdate as revdate
,t1.vamt as vamt
,replace(replace(t1.fatherseqno,chr(13),''),chr(10),'') as fatherseqno
,replace(replace(t1.originalseqno,chr(13),''),chr(10),'') as originalseqno
,replace(replace(t1.refseqno,chr(13),''),chr(10),'') as refseqno
,replace(replace(t1.revseqno,chr(13),''),chr(10),'') as revseqno
,replace(replace(t1.splitflag,chr(13),''),chr(10),'') as splitflag
,replace(replace(t1.trademode,chr(13),''),chr(10),'') as trademode
,t1.matureyield as matureyield
,replace(replace(t1.occpcredit,chr(13),''),chr(10),'') as occpcredit
,t1.matemdate as matemdate
,replace(replace(t1.tranflag,chr(13),''),chr(10),'') as tranflag
,replace(replace(t1.tranuuid,chr(13),''),chr(10),'') as tranuuid
,replace(replace(t1.tradmarket,chr(13),''),chr(10),'') as tradmarket
,replace(replace(t1.tradmarketdesc,chr(13),''),chr(10),'') as tradmarketdesc
,replace(replace(t1.pseqno,chr(13),''),chr(10),'') as pseqno
,replace(replace(t1.vatbreakeven,chr(13),''),chr(10),'') as vatbreakeven
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.booktype,chr(13),''),chr(10),'') as booktype
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,t1.start_dt as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_mnm_dpbodeal t1
where t1.start_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mnm_dpbodeal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes