: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_upl_credit_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_upl_credit_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(creditsum,chr(10),''),chr(13),'') as creditsum
,replace(replace(creditbalance,chr(10),''),chr(13),'') as creditbalance
,replace(replace(usedcreditsum,chr(10),''),chr(13),'') as usedcreditsum
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(inputuser,chr(10),''),chr(13),'') as inputuser
,replace(replace(attribute1,chr(10),''),chr(13),'') as attribute1
,replace(replace(attribute2,chr(10),''),chr(13),'') as attribute2
,replace(replace(attribute3,chr(10),''),chr(13),'') as attribute3
,replace(replace(attribute4,chr(10),''),chr(13),'') as attribute4
,replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(frozcredit,chr(10),''),chr(13),'') as frozcredit
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(effectdate,chr(10),''),chr(13),'') as effectdate
,replace(replace(maturity,chr(10),''),chr(13),'') as maturity
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(cycleflag,chr(10),''),chr(13),'') as cycleflag
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(inputorg,chr(10),''),chr(13),'') as inputorg
,replace(replace(relativeserialno,chr(10),''),chr(13),'') as relativeserialno
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_upl_credit_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_upl_credit_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes