: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_bd_extend_detail_f
CreateDate: 20231024
FileName:   ${iel_data_path}/icms_bd_extend_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.reselltype,chr(13),''),chr(10),'') as reselltype
,ztrate
,replace(replace(t1.benefitcorpbank,chr(13),''),chr(10),'') as benefitcorpbank
,replace(replace(t1.nextperiodreturninterestdate,chr(13),''),chr(10),'') as nextperiodreturninterestdate
,replace(replace(t1.acceptbankid,chr(13),''),chr(10),'') as acceptbankid
,replace(replace(t1.billtype,chr(13),''),chr(10),'') as billtype
,replace(replace(t1.istran,chr(13),''),chr(10),'') as istran
,replace(replace(t1.tradeorgid,chr(13),''),chr(10),'') as tradeorgid
,replace(replace(t1.logoutdate,chr(13),''),chr(10),'') as logoutdate
,replace(replace(t1.openno,chr(13),''),chr(10),'') as openno
,replace(replace(t1.keyno,chr(13),''),chr(10),'') as keyno
,fixterm
,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'') as acceptinttype
,eacmprincipal
,replace(replace(t1.fixflag,chr(13),''),chr(10),'') as fixflag
,surplusphases
,replace(replace(t1.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t1.benefitcorpname,chr(13),''),chr(10),'') as benefitcorpname
,insum
,replace(replace(t1.reinforcechecker,chr(13),''),chr(10),'') as reinforcechecker
,replace(replace(t1.ztacceptbankname,chr(13),''),chr(10),'') as ztacceptbankname
,duebalance
,legal
,replace(replace(t1.datatype,chr(13),''),chr(10),'') as datatype
,replace(replace(t1.littlecreditbatchno,chr(13),''),chr(10),'') as littlecreditbatchno
,replace(replace(t1.loantype,chr(13),''),chr(10),'') as loantype
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t1.littlecreditstatus,chr(13),''),chr(10),'') as littlecreditstatus
,replace(replace(t1.billno,chr(13),''),chr(10),'') as billno
,replace(replace(t1.flag1,chr(13),''),chr(10),'') as flag1
,compensationsum
,replace(replace(t1.isinuse,chr(13),''),chr(10),'') as isinuse
,replace(replace(t1.ztacceptbankid,chr(13),''),chr(10),'') as ztacceptbankid
,replace(replace(t1.isteachhealth,chr(13),''),chr(10),'') as isteachhealth
,replace(replace(t1.benefitcorp,chr(13),''),chr(10),'') as benefitcorp
,replace(replace(t1.businessdept,chr(13),''),chr(10),'') as businessdept
,replace(replace(t1.aboutbankid2,chr(13),''),chr(10),'') as aboutbankid2
,advanceflagsum
,replace(replace(t1.nextperiodreturnprincipaldate,chr(13),''),chr(10),'') as nextperiodreturnprincipaldate
,nextperiodreturninterestsum
,replace(replace(t1.billkind,chr(13),''),chr(10),'') as billkind
,replace(replace(t1.ictype,chr(13),''),chr(10),'') as ictype
,replace(replace(t1.preinttype,chr(13),''),chr(10),'') as preinttype
,interestinsum
,replace(replace(t1.littlecreditbatchenddate,chr(13),''),chr(10),'') as littlecreditbatchenddate
,replace(replace(t1.accountcatagory,chr(13),''),chr(10),'') as accountcatagory
,replace(replace(t1.aboutbankname2,chr(13),''),chr(10),'') as aboutbankname2
,replace(replace(t1.logouttype,chr(13),''),chr(10),'') as logouttype
,premiumrate
,replace(replace(t1.acceptbankname,chr(13),''),chr(10),'') as acceptbankname
,replace(replace(t1.littlecreditlapsetime,chr(13),''),chr(10),'') as littlecreditlapsetime
,replace(replace(t1.deductdate,chr(13),''),chr(10),'') as deductdate
,replace(replace(t1.logoutno,chr(13),''),chr(10),'') as logoutno
,nextperiodreturnprincipalsum
,replace(replace(t1.assetno,chr(13),''),chr(10),'') as assetno
,actualbalance
,actualbusinesssum
,replace(replace(t1.actualcurrency,chr(13),''),chr(10),'') as actualcurrency
,exchangerate
,replace(replace(t1.ddno,chr(13),''),chr(10),'') as ddno
,replace(replace(t1.lender,chr(13),''),chr(10),'') as lender
,replace(replace(t1.objid,chr(13),''),chr(10),'') as objid
,naccountvalue
,naccrualinterest
,nbalance
,ninterestadjust
,npvvariation
,replace(replace(t1.interexpnum,chr(13),''),chr(10),'') as interexpnum
,replace(replace(t1.commexpnum,chr(13),''),chr(10),'') as commexpnum
,replace(replace(t1.sellstatus,chr(13),''),chr(10),'') as sellstatus

from ${iol_schema}.icms_bd_extend_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_bd_extend_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
