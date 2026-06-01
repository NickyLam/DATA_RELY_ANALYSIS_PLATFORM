: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_business_extension_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_business_extension_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(relativeserialno,chr(10),''),chr(13),'') as relativeserialno
,replace(replace(transactionflag,chr(10),''),chr(13),'') as transactionflag
,replace(replace(occurdate,chr(10),''),chr(13),'') as occurdate
,replace(replace(occurtime,chr(10),''),chr(13),'') as occurtime
,replace(replace(lastrate,chr(10),''),chr(13),'') as lastrate
,replace(replace(lastmaturity,chr(10),''),chr(13),'') as lastmaturity
,replace(replace(extensionsum,chr(10),''),chr(13),'') as extensionsum
,replace(replace(lastsum,chr(10),''),chr(13),'') as lastsum
,replace(replace(extendtermyear,chr(10),''),chr(13),'') as extendtermyear
,replace(replace(extendtermmonth,chr(10),''),chr(13),'') as extendtermmonth
,replace(replace(extendtermday,chr(10),''),chr(13),'') as extendtermday
,replace(replace(extendrate,chr(10),''),chr(13),'') as extendrate
,replace(replace(extendmaturity,chr(10),''),chr(13),'') as extendmaturity
,replace(replace(voucherno,chr(10),''),chr(13),'') as voucherno
,replace(replace(orgid,chr(10),''),chr(13),'') as orgid
,replace(replace(userid,chr(10),''),chr(13),'') as userid
,replace(replace(extendflag,chr(10),''),chr(13),'') as extendflag
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(rategenre,chr(10),''),chr(13),'') as rategenre
,replace(replace(overduefloat,chr(10),''),chr(13),'') as overduefloat
,replace(replace(overduerate,chr(10),''),chr(13),'') as overduerate
,replace(replace(businessrate,chr(10),''),chr(13),'') as businessrate
,replace(replace(baseratetype,chr(10),''),chr(13),'') as baseratetype
,replace(replace(baserate,chr(10),''),chr(13),'') as baserate
,replace(replace(ratefloat,chr(10),''),chr(13),'') as ratefloat
,replace(replace(lastputoutdate,chr(10),''),chr(13),'') as lastputoutdate
,replace(replace(extendputoutdate,chr(10),''),chr(13),'') as extendputoutdate
,replace(replace(contractno,chr(10),''),chr(13),'') as contractno
,replace(replace(putoutno,chr(10),''),chr(13),'') as putoutno
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_business_extension 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_business_extension_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes