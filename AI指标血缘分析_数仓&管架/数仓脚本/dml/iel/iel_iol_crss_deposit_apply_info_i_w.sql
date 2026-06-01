: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_deposit_apply_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_deposit_apply_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(cusname,chr(10),''),chr(13),'') as cusname
,replace(replace(cusid,chr(10),''),chr(13),'') as cusid
,replace(replace(contractno,chr(10),''),chr(13),'') as contractno
,replace(replace(putoutno,chr(10),''),chr(13),'') as putoutno
,replace(replace(opertp,chr(10),''),chr(13),'') as opertp
,replace(replace(cntrtp,chr(10),''),chr(13),'') as cntrtp
,replace(replace(dataid,chr(10),''),chr(13),'') as dataid
,replace(replace(grtetp,chr(10),''),chr(13),'') as grtetp
,replace(replace(acptno,chr(10),''),chr(13),'') as acptno
,replace(replace(acctno,chr(10),''),chr(13),'') as acctno
,replace(replace(tranam,chr(10),''),chr(13),'') as tranam
,replace(replace(grteac,chr(10),''),chr(13),'') as grteac
,replace(replace(termcd,chr(10),''),chr(13),'') as termcd
,replace(replace(matudt,chr(10),''),chr(13),'') as matudt
,replace(replace(pigeonholedate,chr(10),''),chr(13),'') as pigeonholedate
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(subaccount,chr(10),''),chr(13),'') as subaccount
,replace(replace(exchangedate,chr(10),''),chr(13),'') as exchangedate
,replace(replace(exchangeserialno,chr(10),''),chr(13),'') as exchangeserialno
,replace(replace(initexchangedate,chr(10),''),chr(13),'') as initexchangedate
,replace(replace(initexchangeserialno,chr(10),''),chr(13),'') as initexchangeserialno
,replace(replace(businesstype,chr(10),''),chr(13),'') as businesstype
,replace(replace(crcycd,chr(10),''),chr(13),'') as crcycd
,replace(replace(exchangestate,chr(10),''),chr(13),'') as exchangestate
,replace(replace(exchangetime,chr(10),''),chr(13),'') as exchangetime
,replace(replace(hascancel,chr(10),''),chr(13),'') as hascancel
,replace(replace(isopen,chr(10),''),chr(13),'') as isopen
,replace(replace(interestmethod,chr(10),''),chr(13),'') as interestmethod
,replace(replace(interestrate,chr(10),''),chr(13),'') as interestrate
,replace(replace(putoutdate,chr(10),''),chr(13),'') as putoutdate
,replace(replace(maturity,chr(10),''),chr(13),'') as maturity
,replace(replace(businesssum,chr(10),''),chr(13),'') as businesssum
,replace(replace(bailsum,chr(10),''),chr(13),'') as bailsum
,replace(replace(otrvacno,chr(10),''),chr(13),'') as otrvacno
,replace(replace(otrvacna,chr(10),''),chr(13),'') as otrvacna
,replace(replace(otrvbldn,chr(10),''),chr(13),'') as otrvbldn
,replace(replace(prcsna,chr(10),''),chr(13),'') as prcsna
,replace(replace(otfrozsq,chr(10),''),chr(13),'') as otfrozsq
,replace(replace(otfrsptp,chr(10),''),chr(13),'') as otfrsptp
,replace(replace(otsusbtp,chr(10),''),chr(13),'') as otsusbtp
,replace(replace(otfzremk,chr(10),''),chr(13),'') as otfzremk
,replace(replace(fxfltp,chr(10),''),chr(13),'') as fxfltp
,replace(replace(pdrifd,chr(10),''),chr(13),'') as pdrifd
,replace(replace(pdrifm,chr(10),''),chr(13),'') as pdrifm
,replace(replace(pdrifv,chr(10),''),chr(13),'') as pdrifv
,replace(replace(balance,chr(10),''),chr(13),'') as balance
,replace(replace(batchserialno,chr(10),''),chr(13),'') as batchserialno
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_deposit_apply_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_deposit_apply_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes