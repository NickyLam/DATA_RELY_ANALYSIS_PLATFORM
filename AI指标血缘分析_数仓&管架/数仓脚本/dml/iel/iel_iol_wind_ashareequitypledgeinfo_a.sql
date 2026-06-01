: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareequitypledgeinfo_a
CreateDate: 20230822
FileName:   ${iel_data_path}/wind_ashareequitypledgeinfo.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.s_pledge_bgdate,chr(13),''),chr(10),'') as s_pledge_bgdate
,replace(replace(t1.s_pledge_enddate,chr(13),''),chr(10),'') as s_pledge_enddate
,replace(replace(t1.s_holder_name,chr(13),''),chr(10),'') as s_holder_name
,s_pledge_shares
,replace(replace(t1.s_pledgor,chr(13),''),chr(10),'') as s_pledgor
,replace(replace(t1.s_discharge_date,chr(13),''),chr(10),'') as s_discharge_date
,replace(replace(t1.s_remark,chr(13),''),chr(10),'') as s_remark
,is_discharge
,s_holder_type_code
,replace(replace(t1.s_holder_id,chr(13),''),chr(10),'') as s_holder_id
,s_pledgor_type_code
,replace(replace(t1.s_pledgor_id,chr(13),''),chr(10),'') as s_pledgor_id
,s_shr_category_code
,s_total_holding_shr
,s_total_pledge_shr
,s_pledge_shr_ratio
,s_total_holding_shr_ratio
,is_equity_pledge_repo

from ${iol_schema}.wind_ashareequitypledgeinfo t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareequitypledgeinfo.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
