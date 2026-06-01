: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_tru_deal_i
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_tru_deal.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.seqno,chr(13),''),chr(10),'') as seqno
,replace(replace(t1.tradeid,chr(13),''),chr(10),'') as tradeid
,replace(replace(t1.source,chr(13),''),chr(10),'') as source
,t1.dealdate as dealdate
,t1.vdate as vdate
,t1.inputdate as inputdate
,replace(replace(t1.counterid,chr(13),''),chr(10),'') as counterid
,replace(replace(t1.countertype,chr(13),''),chr(10),'') as countertype
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.ps,chr(13),''),chr(10),'') as ps
,replace(replace(t1.trustuuid,chr(13),''),chr(10),'') as trustuuid
,t1.accuir as accuir
,t1.prinamt as prinamt
,t1.accuiramt as accuiramt
,t1.settamt as settamt
,t1.yield as yield
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.hometrader,chr(13),''),chr(10),'') as hometrader
,replace(replace(t1.countertrader,chr(13),''),chr(10),'') as countertrader
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser
,t1.createtime as createtime
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,t1.updatetime as updatetime
,replace(replace(t1.dealtype,chr(13),''),chr(10),'') as dealtype
,t1.mdate as mdate
,replace(replace(t1.isoriginal,chr(13),''),chr(10),'') as isoriginal
,t1.settdate as settdate
,t1.lastintpaydate as lastintpaydate
,t1.theoryrepayprinamt as theoryrepayprinamt
,t1.revdate as revdate
,t1.effdate as effdate
,replace(replace(t1.counterid2,chr(13),''),chr(10),'') as counterid2
,replace(replace(t1.counterid3,chr(13),''),chr(10),'') as counterid3
,replace(replace(t1.counterid4,chr(13),''),chr(10),'') as counterid4
,t1.actpaydate as actpaydate
,t1.creditaccuir as creditaccuir
,t1.creditaccuirold as creditaccuirold
,t1.hisaccuiramt as hisaccuiramt
,t1.hisaccuir as hisaccuir
,t1.otheramt as otheramt
,t1.hisotheramt as hisotheramt
,t1.basicyield as basicyield
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.trpruuid,chr(13),''),chr(10),'') as trpruuid
,t1.totalaccuiramt as totalaccuiramt
,replace(replace(t1.transfertype,chr(13),''),chr(10),'') as transfertype
,t1.actpositionamt as actpositionamt
,replace(replace(t1.revseqno,chr(13),''),chr(10),'') as revseqno
,t1.canamt as canamt
,replace(replace(t1.fatherseqno,chr(13),''),chr(10),'') as fatherseqno
,replace(replace(t1.originalseqno,chr(13),''),chr(10),'') as originalseqno
,replace(replace(t1.refseqno,chr(13),''),chr(10),'') as refseqno
,replace(replace(t1.splitflag,chr(13),''),chr(10),'') as splitflag
,replace(replace(t1.trademode,chr(13),''),chr(10),'') as trademode
,replace(replace(t1.investtype,chr(13),''),chr(10),'') as investtype
,replace(replace(t1.occpcredit,chr(13),''),chr(10),'') as occpcredit
,t1.matemdate as matemdate
,replace(replace(t1.tradeno,chr(13),''),chr(10),'') as tradeno
,t1.cprice as cprice
,t1.cpriceamt as cpriceamt
,t1.dprice as dprice
,t1.myield as myield
,replace(replace(t1.caltype,chr(13),''),chr(10),'') as caltype
,replace(replace(t1.tranflag,chr(13),''),chr(10),'') as tranflag
,replace(replace(t1.tranuuid,chr(13),''),chr(10),'') as tranuuid
,replace(replace(t1.payacc,chr(13),''),chr(10),'') as payacc
,replace(replace(t1.wflno,chr(13),''),chr(10),'') as wflno
,replace(replace(t1.retype,chr(13),''),chr(10),'') as retype
,replace(replace(t1.paymethodgns,chr(13),''),chr(10),'') as paymethodgns
,replace(replace(t1.poolseqno,chr(13),''),chr(10),'') as poolseqno
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,t1.start_dt as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_tru_deal t1
where t1.start_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_tru_deal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes