: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_deposit_apply_info_a1
CreateDate: 20241211
FileName:   ${iel_data_path}/icms_deposit_apply_info.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.remake,chr(13),''),chr(10),'') as remake
,replace(replace(t1.cusname,chr(13),''),chr(10),'') as cusname
,replace(replace(t1.grteac,chr(13),''),chr(10),'') as grteac
,pigeonholedate
,pdrifv
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.cntrtp,chr(13),''),chr(10),'') as cntrtp
,exchangedate
,replace(replace(t1.otrvbldn,chr(13),''),chr(10),'') as otrvbldn
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.otrvacno,chr(13),''),chr(10),'') as otrvacno
,replace(replace(t1.fxfltp,chr(13),''),chr(10),'') as fxfltp
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.hascancel,chr(13),''),chr(10),'') as hascancel
,replace(replace(t1.isopen,chr(13),''),chr(10),'') as isopen
,replace(replace(t1.batchserialno,chr(13),''),chr(10),'') as batchserialno
,replace(replace(t1.initexchangeserialno,chr(13),''),chr(10),'') as initexchangeserialno
,exchangetime
,interestrate
,bailsum
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.putoutno,chr(13),''),chr(10),'') as putoutno
,matudt
,replace(replace(t1.subaccount,chr(13),''),chr(10),'') as subaccount
,replace(replace(t1.exchangeserialno,chr(13),''),chr(10),'') as exchangeserialno
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t1.otsusbtp,chr(13),''),chr(10),'') as otsusbtp
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,tranam
,replace(replace(t1.exchangestate,chr(13),''),chr(10),'') as exchangestate
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,balance
,inputdate
,replace(replace(t1.grtetp,chr(13),''),chr(10),'') as grtetp
,putoutdate
,replace(replace(t1.pdrifd,chr(13),''),chr(10),'') as pdrifd
,replace(replace(t1.isdiscountflag,chr(13),''),chr(10),'') as isdiscountflag
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.cusid,chr(13),''),chr(10),'') as cusid
,replace(replace(t1.interestmethod,chr(13),''),chr(10),'') as interestmethod
,maturity
,replace(replace(t1.prcsna,chr(13),''),chr(10),'') as prcsna
,replace(replace(t1.acptno,chr(13),''),chr(10),'') as acptno
,replace(replace(t1.opertp,chr(13),''),chr(10),'') as opertp
,replace(replace(t1.termcd,chr(13),''),chr(10),'') as termcd
,replace(replace(t1.otfrsptp,chr(13),''),chr(10),'') as otfrsptp
,replace(replace(t1.otfzremk,chr(13),''),chr(10),'') as otfzremk
,initexchangedate
,businesssum
,replace(replace(t1.otrvacna,chr(13),''),chr(10),'') as otrvacna
,updatedate
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.otfrozsq,chr(13),''),chr(10),'') as otfrozsq
,replace(replace(t1.pdrifm,chr(13),''),chr(10),'') as pdrifm
,replace(replace(t1.inputtype,chr(13),''),chr(10),'') as inputtype
,replace(replace(t1.bailinterestmethod,chr(13),''),chr(10),'') as bailinterestmethod
,replace(replace(t1.deposittermtype,chr(13),''),chr(10),'') as deposittermtype
,depositterm
,bailinterestrate
,depositbaserate
,replace(replace(t1.bailterm,chr(13),''),chr(10),'') as bailterm
,bailbalanceamt
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,etl_timestamp

from ${iol_schema}.icms_deposit_apply_info t1
where 1 = 1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_deposit_apply_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
