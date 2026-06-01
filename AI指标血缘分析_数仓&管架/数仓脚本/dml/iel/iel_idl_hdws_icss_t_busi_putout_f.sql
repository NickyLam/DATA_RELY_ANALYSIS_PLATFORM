: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_busi_putout_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_busi_putout.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.contractserialno
,t1.duebillserialno
,t1.serialno
,t1.inputdate
,t1.dealflag
,t1.businesssum
,t1.businesscurrency
,t1.putoutdate
,t1.tradedate1
,t1.maturity
,t1.backdate
,t1.iccyc
,t1.baserate
,t1.ratetype
,t1.ratefloattype
,t1.ratefloat
,t1.businessrate
,t1.adjustratetype
,t1.adjustratedate
,t1.backrate
,t1.receivername
,t1.receiveraccountno
,t1.acceptorbankname
,t1.acceptorbankno
,t1.channelorgid
,t1.channelfeeratio
,t1.operateuser
,t1.operateorgid
from ${idl_schema}.hdws_icss_t_busi_putout t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_busi_putout.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes