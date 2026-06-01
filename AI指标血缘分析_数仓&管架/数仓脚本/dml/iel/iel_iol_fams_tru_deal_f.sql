: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_tru_deal_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_tru_deal.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select seqno
,tradeid
,source
,dealdate
,vdate
,inputdate
,counterid
,countertype
,account
,ps
,trustuuid
,accuir
,prinamt
,accuiramt
,settamt
,yield
,remark
,effectflag
,hometrader
,countertrader
,createuser
,createtime
,updateuser
,updatetime
,dealtype
,mdate
,isoriginal
,settdate
,lastintpaydate
,theoryrepayprinamt
,revdate
,effdate
,counterid2
,counterid3
,counterid4
,actpaydate
,creditaccuir
,creditaccuirold
,hisaccuiramt
,hisaccuir
,otheramt
,hisotheramt
,basicyield
,ccy
,trpruuid
,totalaccuiramt
,transfertype
,actpositionamt
,revseqno
,canamt
,fatherseqno
,originalseqno
,refseqno
,splitflag
,trademode
,investtype
,occpcredit
,matemdate
,tradeno
,cprice
,cpriceamt
,dprice
,myield
,caltype
,tranflag
,tranuuid
,payacc
,wflno
,retype
,paymethodgns
,poolseqno
,serialno
,start_dt as etl_dt
,etl_timestamp from iol.fams_tru_deal where start_dt=TO_DATE('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_tru_deal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes