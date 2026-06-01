: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_lx_business_contract_f
CreateDate: 20250804
FileName:   ${iel_data_path}/icms_lx_business_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.baserialno,chr(13),''),chr(10),'') as baserialno
,replace(replace(t1.relacontractno,chr(13),''),chr(10),'') as relacontractno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.businessflag,chr(13),''),chr(10),'') as businessflag
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,occurdate
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,businesssum
,putoutsum
,putoutdate
,termmonth
,termday
,startdate
,maturity
,replace(replace(t1.iscycle,chr(13),''),chr(10),'') as iscycle
,replace(replace(t1.risktype,chr(13),''),chr(10),'') as risktype
,replace(replace(t1.ratemodel,chr(13),''),chr(10),'') as ratemodel
,fixedrate
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,baserate
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype
,floatrange
,executerate
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle
,repaydate
,replace(replace(t1.settlementaccount,chr(13),''),chr(10),'') as settlementaccount
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype
,balance
,normalbalance
,overduebalance
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,finishdate
,replace(replace(t1.finishtype,chr(13),''),chr(10),'') as finishtype
,replace(replace(t1.finishflag,chr(13),''),chr(10),'') as finishflag
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.creditno,chr(13),''),chr(10),'') as creditno
,replace(replace(t1.applyid,chr(13),''),chr(10),'') as applyid
,availablecontractamt

from ${iol_schema}.icms_lx_business_contract t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_lx_business_contract.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
