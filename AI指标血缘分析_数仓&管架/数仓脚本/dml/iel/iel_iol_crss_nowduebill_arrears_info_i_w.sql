: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_nowduebill_arrears_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_nowduebill_arrears_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(balanceserialno,chr(10),''),chr(13),'') as balanceserialno
,replace(replace(duebillno,chr(10),''),chr(13),'') as duebillno
,replace(replace(duebillflag,chr(10),''),chr(13),'') as duebillflag
,replace(replace(balancemoduletype,chr(10),''),chr(13),'') as balancemoduletype
,replace(replace(arrearsdate,chr(10),''),chr(13),'') as arrearsdate
,replace(replace(arrearssum,chr(10),''),chr(13),'') as arrearssum
,replace(replace(currentbalance,chr(10),''),chr(13),'') as currentbalance
,replace(replace(interesttype,chr(10),''),chr(13),'') as interesttype
,replace(replace(lastinterest,chr(10),''),chr(13),'') as lastinterest
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_nowduebill_arrears_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_nowduebill_arrears_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes