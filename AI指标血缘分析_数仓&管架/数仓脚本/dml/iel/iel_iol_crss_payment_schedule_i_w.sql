: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_payment_schedule_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_payment_schedule_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(putoutno,chr(10),''),chr(13),'') as putoutno
,replace(replace(duebillno,chr(10),''),chr(13),'') as duebillno
,replace(replace(adjusttype,chr(10),''),chr(13),'') as adjusttype
,replace(replace(seqid,chr(10),''),chr(13),'') as seqid
,replace(replace(repaymentdate,chr(10),''),chr(13),'') as repaymentdate
,replace(replace(realinterest,chr(10),''),chr(13),'') as realinterest
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(corpusamount,chr(10),''),chr(13),'') as corpusamount
,replace(replace(repaycorpus,chr(10),''),chr(13),'') as repaycorpus
,replace(replace(repayinterest,chr(10),''),chr(13),'') as repayinterest
,replace(replace(discountcharges,chr(10),''),chr(13),'') as discountcharges
,replace(replace(finishinterest,chr(10),''),chr(13),'') as finishinterest
,replace(replace(accountmanageobjectno,chr(10),''),chr(13),'') as accountmanageobjectno
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_payment_schedule 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_payment_schedule_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes