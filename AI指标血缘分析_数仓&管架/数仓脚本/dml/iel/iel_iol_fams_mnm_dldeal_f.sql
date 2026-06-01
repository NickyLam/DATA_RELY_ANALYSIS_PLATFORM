: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mnm_dldeal_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_mnm_dldeal.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select seqno
,tradeid
,datasource
,dealdate
,periodid
,vdate
,mdate
,ps
,psflow
,countertype
,counterid
,countertrader
,account
,accounttrader
,basis
,dlamt
,ccy
,rate
,prinamt
,assetps
,assetpsflow
,prinsettamt
,intsettamt
,intunaccamt
,settdate
,remark
,bookdate
,prinpayday
,prinpaymark
,effectflag
,lstmntuser
,lstmntdate
,oriseqno
,revdate
,effdate
,vamt
,fatherseqno
,originalseqno
,refseqno
,revseqno
,splitflag
,trademode
,matureyield
,occpcredit
,prinamttheory
,matemdate
,tranflag
,tranuuid
,tradmarket                 
,tradmarketdesc
,vatbreakeven
,start_dt as etl_dt
,etl_timestamp from iol.fams_mnm_dldeal where start_dt=TO_DATE('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mnm_dldeal.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes