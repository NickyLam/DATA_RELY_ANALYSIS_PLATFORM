: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_lx_business_duebill_f
CreateDate: 20250804
FileName:   ${iel_data_path}/icms_lx_business_duebill.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.capitalloanno,chr(13),''),chr(10),'') as capitalloanno
,replace(replace(t1.putoutserialno,chr(13),''),chr(10),'') as putoutserialno
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.termmonth,chr(13),''),chr(10),'') as termmonth
,replace(replace(t1.ratemodel,chr(13),''),chr(10),'') as ratemodel
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,baserate
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,executerate
,overduerate
,replace(replace(t1.rateadjusttype,chr(13),''),chr(10),'') as rateadjusttype
,replace(replace(t1.rateadjustfrequency,chr(13),''),chr(10),'') as rateadjustfrequency
,floatrange
,replace(replace(t1.overdueratefloattype,chr(13),''),chr(10),'') as overdueratefloattype
,overdueratefloatvalue
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,replace(replace(t1.applydate,chr(13),''),chr(10),'') as applydate
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,overduedate
,replace(replace(t1.cleardate,chr(13),''),chr(10),'') as cleardate
,encashamt
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.repaymode,chr(13),''),chr(10),'') as repaymode
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle
,totalterms
,curterm
,repayday
,graceday
,replace(replace(t1.loanstatus,chr(13),''),chr(10),'') as loanstatus
,replace(replace(t1.loanform,chr(13),''),chr(10),'') as loanform
,printotal
,prinrepay
,prinbal
,ovdprinbal
,intplan
,inttotal
,intrepay
,intdiscount
,intbal
,ovdintbal
,pnltinttotal
,pnltintrepay
,pnltintdiscount
,pnltintbal
,prepmtfeerepay
,replace(replace(t1.outloanchannelno,chr(13),''),chr(10),'') as outloanchannelno
,daysovd
,replace(replace(t1.interesttransferstatus,chr(13),''),chr(10),'') as interesttransferstatus
,replace(replace(t1.loanresponsetime,chr(13),''),chr(10),'') as loanresponsetime
,replace(replace(t1.writeoffstatus,chr(13),''),chr(10),'') as writeoffstatus
,replace(replace(t1.writeofftime,chr(13),''),chr(10),'') as writeofftime
,inputdate
,updatedate
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.startterm,chr(13),''),chr(10),'') as startterm
,replace(replace(t1.endterm,chr(13),''),chr(10),'') as endterm
,replace(replace(t1.intrate,chr(13),''),chr(10),'') as intrate
,replace(replace(t1.intrateunit,chr(13),''),chr(10),'') as intrateunit
,replace(replace(t1.ovdrate,chr(13),''),chr(10),'') as ovdrate
,replace(replace(t1.ovdrateunit,chr(13),''),chr(10),'') as ovdrateunit
,replace(replace(t1.prepmtfeerate,chr(13),''),chr(10),'') as prepmtfeerate
,replace(replace(t1.remart,chr(13),''),chr(10),'') as remart
,dailyint
,dailypnltint
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.repaynum,chr(13),''),chr(10),'') as repaynum
,replace(replace(t1.repaynumtype,chr(13),''),chr(10),'') as repaynumtype
,replace(replace(t1.paymentnum,chr(13),''),chr(10),'') as paymentnum
,replace(replace(t1.paymentnumtype,chr(13),''),chr(10),'') as paymentnumtype
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid
,replace(replace(t1.putoutorgid,chr(13),''),chr(10),'') as putoutorgid
,replace(replace(t1.manageorgid,chr(13),''),chr(10),'') as manageorgid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.loanpurpose,chr(13),''),chr(10),'') as loanpurpose
,replace(replace(t1.interesttype,chr(13),''),chr(10),'') as interesttype
,replace(replace(t1.bankproportion,chr(13),''),chr(10),'') as bankproportion
,replace(replace(t1.fivecateadjdate,chr(13),''),chr(10),'') as fivecateadjdate

from ${iol_schema}.icms_lx_business_duebill t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_lx_business_duebill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
