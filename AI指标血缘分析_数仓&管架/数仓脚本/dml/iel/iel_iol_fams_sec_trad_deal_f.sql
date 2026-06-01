: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_sec_trad_deal_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_sec_trad_deal.f.${batch_date}.dat
IF_mark:    f
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
,replace(replace(t1.secid,chr(13),''),chr(10),'') as secid
,t1.prinamt as prinamt
,t1.cleanprice as cleanprice
,t1.dirtyprice as dirtyprice
,t1.accuir as accuir
,t1.cleanpriceamt as cleanpriceamt
,t1.dirtypriceamt as dirtypriceamt
,t1.accuiramt as accuiramt
,replace(replace(t1.buyclearingform,chr(13),''),chr(10),'') as buyclearingform
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.caltype,chr(13),''),chr(10),'') as caltype
,replace(replace(t1.hometrader,chr(13),''),chr(10),'') as hometrader
,replace(replace(t1.countertrader,chr(13),''),chr(10),'') as countertrader
,replace(replace(t1.lstmntuser,chr(13),''),chr(10),'') as lstmntuser
,t1.lstmntdate as lstmntdate
,replace(replace(t1.investtype,chr(13),''),chr(10),'') as investtype
,replace(replace(t1.issetsellcost,chr(13),''),chr(10),'') as issetsellcost
,t1.updatedate as updatedate
,t1.yield as yield
,t1.effdate as effdate
,t1.revdate as revdate
,replace(replace(t1.accountspeed,chr(13),''),chr(10),'') as accountspeed
,t1.purposedate as purposedate
,replace(replace(t1.fatherseqno,chr(13),''),chr(10),'') as fatherseqno
,replace(replace(t1.originalseqno,chr(13),''),chr(10),'') as originalseqno
,replace(replace(t1.refseqno,chr(13),''),chr(10),'') as refseqno
,replace(replace(t1.revseqno,chr(13),''),chr(10),'') as revseqno
,replace(replace(t1.splitflag,chr(13),''),chr(10),'') as splitflag
,replace(replace(t1.trademode,chr(13),''),chr(10),'') as trademode
,replace(replace(t1.occpcredit,chr(13),''),chr(10),'') as occpcredit
,t1.matemdate as matemdate
,replace(replace(t1.tranflag,chr(13),''),chr(10),'') as tranflag
,replace(replace(t1.tranuuid,chr(13),''),chr(10),'') as tranuuid
,replace(replace(t1.refpoolseqno,chr(13),''),chr(10),'') as refpoolseqno
,replace(replace(t1.dealtype,chr(13),''),chr(10),'') as dealtype
,t1.drpamt as drpamt
,replace(replace(t1.outpseqno,chr(13),''),chr(10),'') as outpseqno
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.tradeidp,chr(13),''),chr(10),'') as tradeidp
,replace(replace(t1.tradeids,chr(13),''),chr(10),'') as tradeids
,t1.start_dt as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_sec_trad_deal t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_sec_trad_deal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes