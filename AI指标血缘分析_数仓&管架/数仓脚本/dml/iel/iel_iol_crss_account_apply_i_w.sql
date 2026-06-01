: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_account_apply_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_account_apply_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(duebillno,chr(10),''),chr(13),'') as duebillno
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(accounttype,chr(10),''),chr(13),'') as accounttype
,replace(replace(businesscurrency,chr(10),''),chr(13),'') as businesscurrency
,replace(replace(businesssum,chr(10),''),chr(13),'') as businesssum
,replace(replace(balance,chr(10),''),chr(13),'') as balance
,replace(replace(applyexpain,chr(10),''),chr(13),'') as applyexpain
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(flag,chr(10),''),chr(13),'') as flag
,replace(replace(liquidatedsum,chr(10),''),chr(13),'') as liquidatedsum
,replace(replace(newdate,chr(10),''),chr(13),'') as newdate
,replace(replace(putoutno,chr(10),''),chr(13),'') as putoutno
,replace(replace(tradecustomer,chr(10),''),chr(13),'') as tradecustomer
,replace(replace(saleratio,chr(10),''),chr(13),'') as saleratio
,replace(replace(isdomeassetstype,chr(10),''),chr(13),'') as isdomeassetstype
,replace(replace(boughtsum,chr(10),''),chr(13),'') as boughtsum
,replace(replace(payaccountno,chr(10),''),chr(13),'') as payaccountno
,replace(replace(importcharges,chr(10),''),chr(13),'') as importcharges
,replace(replace(repaymentno,chr(10),''),chr(13),'') as repaymentno
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.crss_account_apply where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_account_apply_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes