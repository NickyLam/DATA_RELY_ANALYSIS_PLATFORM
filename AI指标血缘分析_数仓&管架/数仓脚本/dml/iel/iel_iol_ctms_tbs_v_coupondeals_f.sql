: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_coupondeals_f
CreateDate: 20250416
FileName:   ${iel_data_path}/ctms_tbs_v_coupondeals.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,deal_id
,replace(replace(t1.deal_name,chr(13),''),chr(10),'') as deal_name
,aspclient_id
,balance_id
,paydate
,keepfolder_id
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.bondscode,chr(13),''),chr(10),'') as bondscode
,replace(replace(t1.coupontype,chr(13),''),chr(10),'') as coupontype
,principalamount
,interestamount
,lastmodified
,act_paydate

from ${iol_schema}.ctms_tbs_v_coupondeals t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_coupondeals.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
