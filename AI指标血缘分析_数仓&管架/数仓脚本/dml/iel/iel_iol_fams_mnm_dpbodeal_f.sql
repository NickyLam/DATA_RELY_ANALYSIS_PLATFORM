: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mnm_dpbodeal_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_mnm_dpbodeal.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select seqno
,tradeid
,ps
,externalflag
,dealdate
,vdate
,mdate
,counterid
,countertrader
,account
,accounttrader
,basis
,dlamt
,ccy
,interestrate
,rate
,ratecode
,coefficient
,spreadrate
,interestfrequency
,schecalrule
,firstpayrateday
,rateadjfrequency
,rateadjrule
,firstrateadjday
,workdayrule
,ratevaluecdtn
,ratevaluedays
,isoriginal
,assetps
,internalflag
,prinsettamt
,intsettamt
,settdate
,remark
,bookdate
,prinpayday
,prinpaymark
,effectflag
,lstmntuser
,lstmntdate
,oriseqno
,countertype
,effdate
,revdate
,vamt
,fatherseqno
,originalseqno
,refseqno
,revseqno
,splitflag
,trademode
,matureyield
,occpcredit
,matemdate
,tranflag
,tranuuid
,tradmarket
,tradmarketdesc
,pseqno
,vatbreakeven
,assettype
,booktype
,serialno
,start_dt as etl_dt
,etl_timestamp from iol.fams_mnm_dpbodeal where start_dt=TO_DATE('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mnm_dpbodeal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes