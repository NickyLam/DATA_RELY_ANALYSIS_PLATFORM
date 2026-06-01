: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_busi_putout_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_busi_putout.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.contractserialno,chr(13),''),chr(10),'') as contractserialno
,replace(replace(t.duebillserialno,chr(13),''),chr(10),'') as duebillserialno
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t.dealflag,chr(13),''),chr(10),'') as dealflag
,t.businesssum as businesssum
,replace(replace(t.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,replace(replace(t.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t.tradedate1,chr(13),''),chr(10),'') as tradedate1
,replace(replace(t.maturity,chr(13),''),chr(10),'') as maturity
,replace(replace(t.backdate,chr(13),''),chr(10),'') as backdate
,replace(replace(t.iccyc,chr(13),''),chr(10),'') as iccyc
,t.baserate as baserate
,replace(replace(t.ratetype,chr(13),''),chr(10),'') as ratetype
,replace(replace(t.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,t.ratefloat as ratefloat
,t.businessrate as businessrate
,replace(replace(t.adjustratetype,chr(13),''),chr(10),'') as adjustratetype
,t.adjustratedate as adjustratedate
,t.backrate as backrate
,replace(replace(t.receivername,chr(13),''),chr(10),'') as receivername
,replace(replace(t.receiveraccountno,chr(13),''),chr(10),'') as receiveraccountno
,replace(replace(t.acceptorbankname,chr(13),''),chr(10),'') as acceptorbankname
,replace(replace(t.acceptorbankno,chr(13),''),chr(10),'') as acceptorbankno
,replace(replace(t.channelorgid,chr(13),''),chr(10),'') as channelorgid
,t.channelfeeratio as channelfeeratio
,replace(replace(t.operateuser,chr(13),''),chr(10),'') as operateuser
,replace(replace(t.operateorgid,chr(13),''),chr(10),'') as operateorgid
from ${iol_schema}.icss_t_busi_putout t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_busi_putout.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes