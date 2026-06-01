: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_crss_nowduebill_arrears_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_crss_nowduebill_arrears_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.balanceserialno,chr(13),''),chr(10),'') as balanceserialno
,replace(replace(t1.duebillno,chr(13),''),chr(10),'') as duebillno
,replace(replace(t1.duebillflag,chr(13),''),chr(10),'') as duebillflag
,replace(replace(t1.balancemoduletype,chr(13),''),chr(10),'') as balancemoduletype
,replace(replace(t1.arrearsdate,chr(13),''),chr(10),'') as arrearsdate
,t1.arrearssum as arrearssum
,t1.currentbalance as currentbalance
,replace(replace(t1.interesttype,chr(13),''),chr(10),'') as interesttype
,t1.lastinterest as lastinterest
from ${iol_schema}.crss_nowduebill_arrears_info t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_crss_nowduebill_arrears_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes