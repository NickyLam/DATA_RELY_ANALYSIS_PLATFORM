: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_customer_relative_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_customer_relative_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select replace(replace(customerid, chr(10), ''), chr(13), '') as customerid,
       replace(replace(relativeid, chr(10), ''), chr(13), '') as relativeid,
       replace(replace(relationship, chr(10), ''), chr(13), '') as relationship,
       replace(replace(customername, chr(10), ''), chr(13), '') as customername,
       replace(replace(certtype, chr(10), ''), chr(13), '') as certtype,
       replace(replace(certid, chr(10), ''), chr(13), '') as certid,
       replace(replace(fictitiousperson, chr(10), ''), chr(13), '') as fictitiousperson,
       replace(replace(currencytype, chr(10), ''), chr(13), '') as currencytype,
       replace(replace(investmentsum, chr(10), ''), chr(13), '') as investmentsum,
       replace(replace(oughtsum, chr(10), ''), chr(13), '') as oughtsum,
       replace(replace(investmentprop, chr(10), ''), chr(13), '') as investmentprop,
       replace(replace(investdate, chr(10), ''), chr(13), '') as investdate,
       replace(replace(stockcertno, chr(10), ''), chr(13), '') as stockcertno,
       replace(replace(duty, chr(10), ''), chr(13), '') as duty,
       replace(replace(telephone, chr(10), ''), chr(13), '') as telephone,
       replace(replace(effect, chr(10), ''), chr(13), '') as effect,
       replace(replace(whethen1, chr(10), ''), chr(13), '') as whethen1,
       replace(replace(whethen2, chr(10), ''), chr(13), '') as whethen2,
       replace(replace(whethen3, chr(10), ''), chr(13), '') as whethen3,
       replace(replace(whethen4, chr(10), ''), chr(13), '') as whethen4,
       replace(replace(whethen5, chr(10), ''), chr(13), '') as whethen5,
       replace(replace(describe, chr(10), ''), chr(13), '') as describe,
       replace(replace(inputorgid, chr(10), ''), chr(13), '') as inputorgid,
       replace(replace(inputuserid, chr(10), ''), chr(13), '') as inputuserid,
       replace(replace(inputdate, chr(10), ''), chr(13), '') as inputdate,
       replace(replace(updatedate, chr(10), ''), chr(13), '') as updatedate,
       replace(replace(remark, chr(10), ''), chr(13), '') as remark,
       replace(replace(sex, chr(10), ''), chr(13), '') as sex,
       replace(replace(birthday, chr(10), ''), chr(13), '') as birthday,
       replace(replace(sino, chr(10), ''), chr(13), '') as sino,
       replace(replace(familyadd, chr(10), ''), chr(13), '') as familyadd,
       replace(replace(familyzip, chr(10), ''), chr(13), '') as familyzip,
       replace(replace(eduexperience, chr(10), ''), chr(13), '') as eduexperience,
       replace(replace(investyield, chr(10), ''), chr(13), '') as investyield,
       replace(replace(holddate, chr(10), ''), chr(13), '') as holddate,
       replace(replace(engageterm, chr(10), ''), chr(13), '') as engageterm,
       replace(replace(holdstock, chr(10), ''), chr(13), '') as holdstock,
       replace(replace(loancardno, chr(10), ''), chr(13), '') as loancardno,
       replace(replace(effstatus, chr(10), ''), chr(13), '') as effstatus,
       replace(replace(customertype, chr(10), ''), chr(13), '') as customertype,
       replace(replace(relationstate, chr(10), ''), chr(13), '') as relationstate,
       replace(replace(isbadcredit, chr(10), ''), chr(13), '') as isbadcredit,
       replace(replace(isdebt, chr(10), ''), chr(13), '') as isdebt,
       replace(replace(position, chr(10), ''), chr(13), '') as position,
       replace(replace(monthincome, chr(10), ''), chr(13), '') as monthincome,
       replace(replace(worktel, chr(10), ''), chr(13), '') as worktel,
       replace(replace(mobiletelephone, chr(10), ''), chr(13), '') as mobiletelephone,
       replace(replace(remark1, chr(10), ''), chr(13), '') as remark1,
       replace(replace(remark2, chr(10), ''), chr(13), '') as remark2,
       replace(replace(actualcontroller, chr(10), ''), chr(13), '') as actualcontroller,
       replace(replace(productionsum, chr(10), ''), chr(13), '') as productionsum,
       replace(replace(ratio, chr(10), ''), chr(13), '') as ratio,
       replace(replace(settlenentmode, chr(10), ''), chr(13), '') as settlenentmode,
       replace(replace(production, chr(10), ''), chr(13), '') as production,
       replace(replace(comoperiationyear, chr(10), ''), chr(13), '') as comoperiationyear,
       replace(replace(isaffenterprises, chr(10), ''), chr(13), '') as isaffenterprises,
       replace(replace(creditinstitutioncode, chr(10), ''), chr(13), '') as creditinstitutioncode,
       replace(replace(relatetype, chr(10), ''), chr(13), '') as relatetype,
       replace(replace(superorgname, chr(10), ''), chr(13), '') as superorgname,
       replace(replace(regedittype, chr(10), ''), chr(13), '') as regedittype,
       replace(replace(regeditcode, chr(10), ''), chr(13), '') as regeditcode,
       replace(replace(corpid, chr(10), ''), chr(13), '') as corpid,
       replace(replace(mainrelaname, chr(10), ''), chr(13), '') as mainrelaname,
       replace(replace(mainrelatype, chr(10), ''), chr(13), '') as mainrelatype,
       replace(replace(mainrelanum, chr(10), ''), chr(13), '') as mainrelanum,
       replace(replace(relativecompname, chr(10), ''), chr(13), '') as relativecompname,
       replace(replace(expiredate, chr(10), ''), chr(13), '') as expiredate,
       replace(replace(shareholdertype, chr(10), ''), chr(13), '') as shareholdertype,
       replace(replace(societyinstitutioncode, chr(10), ''), chr(13), '') as societyinstitutioncode,
       replace(replace(commercialregno, chr(10), ''), chr(13), '') as commercialregno,
       replace(replace(isinuse, chr(10), ''), chr(13), '') as isinuse,
       start_dt,
       end_dt,
       id_mark,
       etl_timestamp
  from iol.crss_customer_relative
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_customer_relative_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes