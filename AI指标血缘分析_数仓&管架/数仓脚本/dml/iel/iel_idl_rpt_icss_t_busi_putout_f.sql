: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_busi_putout_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_busi_putout.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno
,replace(replace(t1.duebillserialno,chr(13),''),chr(10),'') as duebillserialno
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t1.dealflag,chr(13),''),chr(10),'') as dealflag
,t1.businesssum as businesssum
,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,replace(replace(t1.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t1.tradedate1,chr(13),''),chr(10),'') as tradedate1
,replace(replace(t1.maturity,chr(13),''),chr(10),'') as maturity
,replace(replace(t1.backdate,chr(13),''),chr(10),'') as backdate
,replace(replace(t1.iccyc,chr(13),''),chr(10),'') as iccyc
,t1.baserate as baserate
,replace(replace(t1.ratetype,chr(13),''),chr(10),'') as ratetype
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,t1.ratefloat as ratefloat
,t1.businessrate as businessrate
,replace(replace(t1.adjustratetype,chr(13),''),chr(10),'') as adjustratetype
,t1.adjustratedate as adjustratedate
,t1.backrate as backrate
,replace(replace(t1.receivername,chr(13),''),chr(10),'') as receivername
,replace(replace(t1.receiveraccountno,chr(13),''),chr(10),'') as receiveraccountno
,replace(replace(t1.acceptorbankname,chr(13),''),chr(10),'') as acceptorbankname
,replace(replace(t1.acceptorbankno,chr(13),''),chr(10),'') as acceptorbankno
,replace(replace(t1.channelorgid,chr(13),''),chr(10),'') as channelorgid
,t1.channelfeeratio as channelfeeratio
,replace(replace(t1.operateuser,chr(13),''),chr(10),'') as operateuser
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid
 from iol.icss_t_busi_putout T1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_busi_putout.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes