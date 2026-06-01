: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_business_fatou_putout_f
CreateDate: 20230316
FileName:   ${iel_data_path}/icms_business_fatou_putout.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,businessrate
,replace(replace(t1.lontyp,chr(13),''),chr(10),'') as lontyp
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,odrputoutdate
,loanam
,odrmaturity
,replace(replace(t1.contractsum,chr(13),''),chr(10),'') as contractsum
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid
,overduefloat
,lncmam
,replace(replace(t1.odrnextmonth,chr(13),''),chr(10),'') as odrnextmonth
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.lendingorgid,chr(13),''),chr(10),'') as lendingorgid
,replace(replace(t1.rategenre,chr(13),''),chr(10),'') as rategenre
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t1.farmingloanuse,chr(13),''),chr(10),'') as farmingloanuse
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.careerguaranteeloantype,chr(13),''),chr(10),'') as careerguaranteeloantype
,ratefloat
,replace(replace(t1.oblopt,chr(13),''),chr(10),'') as oblopt
,replace(replace(t1.isputout,chr(13),''),chr(10),'') as isputout
,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,replace(replace(t1.iscareerguaranteeloan,chr(13),''),chr(10),'') as iscareerguaranteeloan
,replace(replace(t1.directionnew,chr(13),''),chr(10),'') as directionnew
,replace(replace(t1.farmingloantype,chr(13),''),chr(10),'') as farmingloantype
,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'') as tempsaveflag
,replace(replace(t1.accountno1,chr(13),''),chr(10),'') as accountno1
,baserate
,operatedate
,replace(replace(t1.lprtype,chr(13),''),chr(10),'') as lprtype
,updatedate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.directionrs,chr(13),''),chr(10),'') as directionrs
,replace(replace(t1.isfarming,chr(13),''),chr(10),'') as isfarming
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,replace(replace(t1.bengdt,chr(13),''),chr(10),'') as bengdt
,daynum
,overduerate
,ovdrmi
,odrfreeinterest
,replace(replace(t1.platformpaycashsource,chr(13),''),chr(10),'') as platformpaycashsource
,replace(replace(t1.loanhandlechannel,chr(13),''),chr(10),'') as loanhandlechannel
,inputdate
,replace(replace(t1.acceptinttype,chr(13),''),chr(10),'') as acceptinttype
,replace(replace(t1.whitelist,chr(13),''),chr(10),'') as whitelist
,replace(replace(t1.sectionalinterest,chr(13),''),chr(10),'') as sectionalinterest
,replace(replace(t1.frecharger,chr(13),''),chr(10),'') as frecharger
,replace(replace(t1.binllingday,chr(13),''),chr(10),'') as binllingday
,replace(replace(t1.artificialno,chr(13),''),chr(10),'') as artificialno
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t1.maintp,chr(13),''),chr(10),'') as maintp
,agrbdt
,agredt
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose
,replace(replace(t1.ovtype,chr(13),''),chr(10),'') as ovtype
,replace(replace(t1.flrttp,chr(13),''),chr(10),'') as flrttp
,feeivl
,replace(replace(t1.tyflag,chr(13),''),chr(10),'') as tyflag
,replace(replace(t1.tzrate,chr(13),''),chr(10),'') as tzrate
,replace(replace(t1.agreementid,chr(13),''),chr(10),'') as agreementid
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.feedate,chr(13),''),chr(10),'') as feedate
,replace(replace(t1.overduefloatcycle,chr(13),''),chr(10),'') as overduefloatcycle
,replace(replace(t1.overduefloatmodel,chr(13),''),chr(10),'') as overduefloatmodel
,replace(replace(t1.feefrequency,chr(13),''),chr(10),'') as feefrequency
,replace(replace(t1.feemodel,chr(13),''),chr(10),'') as feemodel
,feerate

from ${iol_schema}.icms_business_fatou_putout t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_business_fatou_putout.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
