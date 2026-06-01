: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_zhiya_jiezhi_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_zhiya_jiezhi_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(zhifuno,chr(10),''),chr(13),'') as zhifuno
,replace(replace(zhiyawuno,chr(10),''),chr(13),'') as zhiyawuno
,replace(replace(crcycd,chr(10),''),chr(13),'') as crcycd
,replace(replace(acctno,chr(10),''),chr(13),'') as acctno
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(sttsdt,chr(10),''),chr(13),'') as sttsdt
,replace(replace(sttssq,chr(10),''),chr(13),'') as sttssq
,replace(replace(contractno,chr(10),''),chr(13),'') as contractno
,replace(replace(contractassureno,chr(10),''),chr(13),'') as contractassureno
,replace(replace(guarantytype,chr(10),''),chr(13),'') as guarantytype
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_zhiya_jiezhi_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_zhiya_jiezhi_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes