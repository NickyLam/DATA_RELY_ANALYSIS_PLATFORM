: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_overdraftadjust_f
CreateDate: 20230404
FileName:   ${iel_data_path}/icms_overdraftadjust.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
,replace(replace(t1.maintp,chr(13),''),chr(10),'') as maintp
,trandt
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.loancn,chr(13),''),chr(10),'') as loancn
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,loanam
,ovdram
,newovdram
,ovdra1
,ovdra2
,loabdt
,newloabdt
,loaedt
,newloaedt
,replace(replace(t1.daynum,chr(13),''),chr(10),'') as daynum
,replace(replace(t1.loanbr,chr(13),''),chr(10),'') as loanbr
,replace(replace(t1.termcd,chr(13),''),chr(10),'') as termcd
,replace(replace(t1.rpcode,chr(13),''),chr(10),'') as rpcode
,replace(replace(t1.lnrttp,chr(13),''),chr(10),'') as lnrttp
,replace(replace(t1.newlnrttp,chr(13),''),chr(10),'') as newlnrttp
,baserate
,floart
,newfloart
,npflrt
,newnpflrt
,cntrir
,newcntrir
,ovduir
,newovduir
,replace(replace(t1.ipcode,chr(13),''),chr(10),'') as ipcode
,replace(replace(t1.newipcode,chr(13),''),chr(10),'') as newipcode
,lncmam
,ovdrmi
,replace(replace(t1.oblopt,chr(13),''),chr(10),'') as oblopt
,replace(replace(t1.bengdt,chr(13),''),chr(10),'') as bengdt
,replace(replace(t1.lontyp,chr(13),''),chr(10),'') as lontyp
,replace(replace(t1.custmg,chr(13),''),chr(10),'') as custmg
,replace(replace(t1.loans1,chr(13),''),chr(10),'') as loans1
,replace(replace(t1.loans2,chr(13),''),chr(10),'') as loans2
,avaibl
,replace(replace(t1.odrtfg,chr(13),''),chr(10),'') as odrtfg
,odrtam
,replace(replace(t1.msgcode,chr(13),''),chr(10),'') as msgcode
,replace(replace(t1.listnm,chr(13),''),chr(10),'') as listnm
,replace(replace(t1.ovmthf,chr(13),''),chr(10),'') as ovmthf
,replace(replace(t1.ovfind,chr(13),''),chr(10),'') as ovfind
,replace(replace(t1.flrttp,chr(13),''),chr(10),'') as flrttp
,replace(replace(t1.newflrttp,chr(13),''),chr(10),'') as newflrttp
,replace(replace(t1.tyflag,chr(13),''),chr(10),'') as tyflag
,feeivl
,newfeeivl
,agrbdt
,agredt
,replace(replace(t1.ovtype,chr(13),''),chr(10),'') as ovtype
,replace(replace(t1.newovtype,chr(13),''),chr(10),'') as newovtype
,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'') as tempsaveflag
,replace(replace(t1.newloans2,chr(13),''),chr(10),'') as newloans2
,replace(replace(t1.rategenre,chr(13),''),chr(10),'') as rategenre
,replace(replace(t1.newlontyp,chr(13),''),chr(10),'') as newlontyp
,replace(replace(t1.newbengdt,chr(13),''),chr(10),'') as newbengdt
,replace(replace(t1.newoblopt,chr(13),''),chr(10),'') as newoblopt
,newovdrmi
,replace(replace(t1.newrpcode,chr(13),''),chr(10),'') as newrpcode
,replace(replace(t1.artificialno,chr(13),''),chr(10),'') as artificialno
,replace(replace(t1.purpose,chr(13),''),chr(10),'') as purpose
,newlncmam
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputtime
,updatetime
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.overduefloatmodel,chr(13),''),chr(10),'') as overduefloatmodel
,replace(replace(t1.overduefloatcycle,chr(13),''),chr(10),'') as overduefloatcycle
,odrfreeinterest
,replace(replace(t1.sectionalinterest,chr(13),''),chr(10),'') as sectionalinterest
,replace(replace(t1.isfarming,chr(13),''),chr(10),'') as isfarming
,replace(replace(t1.farmingloantype,chr(13),''),chr(10),'') as farmingloantype
,replace(replace(t1.farmingloanuse,chr(13),''),chr(10),'') as farmingloanuse
,replace(replace(t1.iscareerguaranteeloan,chr(13),''),chr(10),'') as iscareerguaranteeloan
,replace(replace(t1.careerguaranteeloantype,chr(13),''),chr(10),'') as careerguaranteeloantype
,replace(replace(t1.platformpaycashsource,chr(13),''),chr(10),'') as platformpaycashsource
,replace(replace(t1.directionnew,chr(13),''),chr(10),'') as directionnew
,replace(replace(t1.loanhandlechannel,chr(13),''),chr(10),'') as loanhandlechannel
,replace(replace(t1.feemodel,chr(13),''),chr(10),'') as feemodel
,replace(replace(t1.feefrequency,chr(13),''),chr(10),'') as feefrequency
,replace(replace(t1.feedate,chr(13),''),chr(10),'') as feedate

from ${iol_schema}.icms_overdraftadjust t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_overdraftadjust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
