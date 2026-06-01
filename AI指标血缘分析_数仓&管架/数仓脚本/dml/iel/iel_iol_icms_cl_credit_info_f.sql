: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_cl_credit_info_f
CreateDate: 20240314
FileName:   ${iel_data_path}/icms_cl_credit_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,loweroccupyupperexposureamount
,replace(replace(t1.additioncommand,chr(13),''),chr(10),'') as additioncommand
,availablelowriskexposuresum
,replace(replace(t1.createdway,chr(13),''),chr(10),'') as createdway
,reservedamount
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,adjustnominalamount
,replace(replace(t1.explain,chr(13),''),chr(10),'') as explain
,latestusedate
,replace(replace(t1.occurway,chr(13),''),chr(10),'') as occurway
,totalpayment
,replace(replace(t1.operateorgid,chr(13),''),chr(10),'') as operateorgid
,replace(replace(t1.reservedcustomerid,chr(13),''),chr(10),'') as reservedcustomerid
,nominalamount
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,riskexposuresum
,execexposureamount
,replace(replace(t1.freezestatus,chr(13),''),chr(10),'') as freezestatus
,singlebizmostamount
,assignoccupyupperexposureamoun
,replace(replace(t1.creditphase,chr(13),''),chr(10),'') as creditphase
,suboccupynominalbalance
,replace(replace(t1.operateuserid,chr(13),''),chr(10),'') as operateuserid
,leftprenominalamount
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.availablebusinesstype,chr(13),''),chr(10),'') as availablebusinesstype
,prenominalamount
,bizmostmortgagerate
,nominalbalance
,replace(replace(t1.dedicatedflag,chr(13),''),chr(10),'') as dedicatedflag
,availablereservedamount
,replace(replace(t1.currencyrange,chr(13),''),chr(10),'') as currencyrange
,replace(replace(t1.credittype,chr(13),''),chr(10),'') as credittype
,replace(replace(t1.sourcesystem,chr(13),''),chr(10),'') as sourcesystem
,businessoccupynominalamount
,replace(replace(t1.istrans,chr(13),''),chr(10),'') as istrans
,availableexposureamount
,latestartdateunderlowercredit
,availablenominalamount
,replace(replace(t1.slowreleaseexposurecurrency,chr(13),''),chr(10),'') as slowreleaseexposurecurrency
,loweroccupyuppernominalamount
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,exposureamount
,replace(replace(t1.occupyflag,chr(13),''),chr(10),'') as occupyflag
,suboccupyexposurebalance
,adjustexposureamount
,exposurebalance
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,maxperioddayunderlowercredit
,totalrepayment
,replace(replace(t1.lineclass,chr(13),''),chr(10),'') as lineclass
,leftpreexposureamount
,freezeexposureamount
,inputdate
,replace(replace(t1.ispubliccredit,chr(13),''),chr(10),'') as ispubliccredit
,availableriskexposuresum
,execnominalamount
,freezenominalamount
,replace(replace(t1.creditno,chr(13),''),chr(10),'') as creditno
,assignoccupyuppernominalamount
,lateexpiredateunderlowercredit
,businessoccupyexposureamount
,lowriskexposuresum
,timelimitmonth
,replace(replace(t1.recyclable,chr(13),''),chr(10),'') as recyclable
,actualexpiredate
,bizbailinitialrate
,preexposureamount
,effectivedate
,replace(replace(t1.lockflag,chr(13),''),chr(10),'') as lockflag
,timelimitday
,onlineamount
,replace(replace(t1.sourcecreditno,chr(13),''),chr(10),'') as sourcecreditno
,replace(replace(t1.manageuserid,chr(13),''),chr(10),'') as manageuserid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.manageorgid,chr(13),''),chr(10),'') as manageorgid
,earlystartdateunderlowercredit
,maxperiodmonthunderlowercredit
,replace(replace(t1.usableamountcalcflag,chr(13),''),chr(10),'') as usableamountcalcflag
,replace(replace(t1.guarantyway,chr(13),''),chr(10),'') as guarantyway
,updatedate
,execslowreleaseexposureamount
,slowreleaseexposureamount
,replace(replace(t1.canbeextractedundercredit,chr(13),''),chr(10),'') as canbeextractedundercredit
,expiredate
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,bizlowestfloatrate
,pledgesum
,replace(replace(t1.isexempt,chr(13),''),chr(10),'') as isexempt

from ${iol_schema}.icms_cl_credit_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_cl_credit_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
