: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_opinion_split_i_w
CreateDate: 20200630
FileName:   ${iel_data_path}/crss_opinion_split_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(businesstype,chr(10),''),chr(13),'') as businesstype
,replace(replace(rotative,chr(10),''),chr(13),'') as rotative
,replace(replace(bailratio,chr(10),''),chr(13),'') as bailratio
,replace(replace(guarantytype,chr(10),''),chr(13),'') as guarantytype
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(businesssum,chr(10),''),chr(13),'') as businesssum
,replace(replace(totalsum,chr(10),''),chr(13),'') as totalsum
,replace(replace(maturity,chr(10),''),chr(13),'') as maturity
,replace(replace(inputorg,chr(10),''),chr(13),'') as inputorg
,replace(replace(inputuser,chr(10),''),chr(13),'') as inputuser
,replace(replace(inputtime,chr(10),''),chr(13),'') as inputtime
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,replace(replace(ifexclusivecredit,chr(10),''),chr(13),'') as ifexclusivecredit
,replace(replace(iscontrolledbyzj,chr(10),''),chr(13),'') as iscontrolledbyzj
,replace(replace(onlineamount,chr(10),''),chr(13),'') as onlineamount
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_opinion_split 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_opinion_split_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes