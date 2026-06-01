: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_customer_relative_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_customer_relative_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select customerid
   ,relativeid
   ,relationship
   ,customername
   ,certtype
   ,certid
   ,fictitiousperson
   ,currencytype
   ,investmentsum
   ,oughtsum
   ,investmentprop
   ,investdate
   ,stockcertno
   ,duty
   ,telephone
   ,effect
   ,whethen1
   ,whethen2
   ,whethen3
   ,whethen4
   ,whethen5
   ,describe
   ,inputorgid
   ,inputuserid
   ,inputdate
   ,updatedate
   ,remark
   ,sex
   ,birthday
   ,sino
   ,familyadd
   ,familyzip
   ,eduexperience
   ,investyield
   ,holddate
   ,engageterm
   ,holdstock
   ,loancardno
   ,effstatus
   ,customertype
   ,relationstate
   ,isbadcredit
   ,isdebt
   ,position
   ,monthincome
   ,worktel
   ,mobiletelephone
   ,remark1
   ,remark2
   ,actualcontroller
   ,creditinstitutioncode
   ,productionsum
   ,ratio
   ,settlenentmode
   ,production
   ,comoperiationyear
   ,isaffenterprises
   ,relatetype
   ,superorgname
   ,regedittype
   ,regeditcode
   ,corpid
   ,mainrelaname
   ,mainrelatype
   ,mainrelanum
   ,relativecompname
   ,expiredate
   ,shareholdertype
   ,societyinstitutioncode
from ${idl_schema}.odss_customer_relative
where etl_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_customer_relative_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes