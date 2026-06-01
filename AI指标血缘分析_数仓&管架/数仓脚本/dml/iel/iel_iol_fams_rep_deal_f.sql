: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_rep_deal_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_rep_deal.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.repduuid,chr(13),''),chr(10),'') as repduuid
,replace(replace(t1.tradeid,chr(13),''),chr(10),'') as tradeid
,replace(replace(t1.ismanaul,chr(13),''),chr(10),'') as ismanaul
,t1.dealdate as dealdate
,t1.vdate as vdate
,replace(replace(t1.prodtype,chr(13),''),chr(10),'') as prodtype
,replace(replace(t1.ps,chr(13),''),chr(10),'') as ps
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.repotype,chr(13),''),chr(10),'') as repotype
,t1.term as term
,t1.mdate as mdate
,replace(replace(t1.dealtype,chr(13),''),chr(10),'') as dealtype
,t1.reporate as reporate
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,t1.facetotalamt as facetotalamt
,t1.repoprinamt as repoprinamt
,t1.repointamt as repointamt
,t1.allrepointamt as allrepointamt
,t1.vdealamt as vdealamt
,t1.mdealamt as mdealamt
,replace(replace(t1.vclrform,chr(13),''),chr(10),'') as vclrform
,replace(replace(t1.mclrform,chr(13),''),chr(10),'') as mclrform
,replace(replace(t1.revdealno,chr(13),''),chr(10),'') as revdealno
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.trader,chr(13),''),chr(10),'') as trader
,replace(replace(t1.custaccount,chr(13),''),chr(10),'') as custaccount
,replace(replace(t1.custtype,chr(13),''),chr(10),'') as custtype
,replace(replace(t1.custtrader,chr(13),''),chr(10),'') as custtrader
,replace(replace(t1.assetps,chr(13),''),chr(10),'') as assetps
,t1.prinsettamt as prinsettamt
,t1.intsettamt as intsettamt
,t1.intunaccamt as intunaccamt
,t1.settdate as settdate
,replace(replace(t1.dealtext,chr(13),''),chr(10),'') as dealtext
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser
,t1.createtime as createtime
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,t1.updatetime as updatetime
,replace(replace(t1.prop1,chr(13),''),chr(10),'') as prop1
,replace(replace(t1.prop2,chr(13),''),chr(10),'') as prop2
,replace(replace(t1.prop3,chr(13),''),chr(10),'') as prop3
,replace(replace(t1.prop4,chr(13),''),chr(10),'') as prop4
,replace(replace(t1.prop5,chr(13),''),chr(10),'') as prop5
,replace(replace(t1.prop6,chr(13),''),chr(10),'') as prop6
,replace(replace(t1.prop7,chr(13),''),chr(10),'') as prop7
,replace(replace(t1.prop8,chr(13),''),chr(10),'') as prop8
,replace(replace(t1.prop9,chr(13),''),chr(10),'') as prop9
,replace(replace(t1.prop10,chr(13),''),chr(10),'') as prop10
,replace(replace(t1.paymark,chr(13),''),chr(10),'') as paymark
,t1.payday as payday
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,t1.inputdate as inputdate
,t1.disrate as disrate
,replace(replace(t1.tradetype,chr(13),''),chr(10),'') as tradetype
,replace(replace(t1.counterid2,chr(13),''),chr(10),'') as counterid2
,replace(replace(t1.counterid3,chr(13),''),chr(10),'') as counterid3
,replace(replace(t1.counterid4,chr(13),''),chr(10),'') as counterid4
,replace(replace(t1.counterid5,chr(13),''),chr(10),'') as counterid5
,replace(replace(t1.counterid6,chr(13),''),chr(10),'') as counterid6
,replace(replace(t1.counterid7,chr(13),''),chr(10),'') as counterid7
,t1.revdate as revdate
,t1.effdate as effdate
,replace(replace(t1.amtbank,chr(13),''),chr(10),'') as amtbank
,replace(replace(t1.fatherseqno,chr(13),''),chr(10),'') as fatherseqno
,replace(replace(t1.originalseqno,chr(13),''),chr(10),'') as originalseqno
,replace(replace(t1.refseqno,chr(13),''),chr(10),'') as refseqno
,replace(replace(t1.revseqno,chr(13),''),chr(10),'') as revseqno
,replace(replace(t1.splitflag,chr(13),''),chr(10),'') as splitflag
,replace(replace(t1.trademode,chr(13),''),chr(10),'') as trademode
,t1.matureyield as matureyield
,replace(replace(t1.occpcredit,chr(13),''),chr(10),'') as occpcredit
,t1.matemdate as matemdate
,t1.allrepointtheoryamt as allrepointtheoryamt
,replace(replace(t1.tranflag,chr(13),''),chr(10),'') as tranflag
,replace(replace(t1.tranuuid,chr(13),''),chr(10),'') as tranuuid
,replace(replace(t1.tradmarket,chr(13),''),chr(10),'') as tradmarket
,replace(replace(t1.tradmarketdesc,chr(13),''),chr(10),'') as tradmarketdesc
,replace(replace(t1.pseqno,chr(13),''),chr(10),'') as pseqno
,replace(replace(t1.vatbreakeven,chr(13),''),chr(10),'') as vatbreakeven
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.tradeidp,chr(13),''),chr(10),'') as tradeidp
,t1.start_dt as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.fams_rep_deal t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_rep_deal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes