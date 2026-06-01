: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_coupondeals_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_coupondeals_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(deal_id,chr(10),''),chr(13),'') as deal_id
,replace(replace(deal_name,chr(10),''),chr(13),'') as deal_name
,replace(replace(aspclient_id,chr(10),''),chr(13),'') as aspclient_id
,replace(replace(balance_id,chr(10),''),chr(13),'') as balance_id
,replace(replace(paydate,chr(10),''),chr(13),'') as paydate
,replace(replace(keepfolder_id,chr(10),''),chr(13),'') as keepfolder_id
,replace(replace(assettype,chr(10),''),chr(13),'') as assettype
,replace(replace(bondscode,chr(10),''),chr(13),'') as bondscode
,replace(replace(coupontype,chr(10),''),chr(13),'') as coupontype
,replace(replace(principalamount,chr(10),''),chr(13),'') as principalamount
,replace(replace(interestamount,chr(10),''),chr(13),'') as interestamount
,replace(replace(lastmodified,chr(10),''),chr(13),'') as lastmodified
,replace(replace(act_paydate,chr(10),''),chr(13),'') as act_paydate
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_v_coupondeals
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_coupondeals_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes