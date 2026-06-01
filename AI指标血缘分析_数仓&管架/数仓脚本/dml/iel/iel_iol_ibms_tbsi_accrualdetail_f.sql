: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbsi_accrualdetail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tbsi_accrualdetail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code 
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type 
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type 
,replace(replace(t1.tg_code,chr(13),''),chr(10),'') as tg_code 
,replace(replace(t1.ad_cfid,chr(13),''),chr(10),'') as ad_cfid 
,replace(replace(t1.stream_id,chr(13),''),chr(10),'') as stream_id 
,replace(replace(t1.ad_startdate,chr(13),''),chr(10),'') as ad_startdate 
,replace(replace(t1.ad_enddate,chr(13),''),chr(10),'') as ad_enddate 
,replace(replace(t1.ad_fixingdate,chr(13),''),chr(10),'') as ad_fixingdate 
,replace(replace(t1.self_id,chr(13),''),chr(10),'') as self_id 
,t1.ad_actualrate as ad_actualrate 
,t1.ad_yearfraction as ad_yearfraction 
,t1.ad_fixingrate as ad_fixingrate 
,t1.ad_spread as ad_spread 
,t1.ad_caprate as ad_caprate 
,t1.ad_floorrate as ad_floorrate 
,t1.ad_multiplier as ad_multiplier 
,replace(replace(t1.imp_time,chr(13),''),chr(10),'') as imp_time 
,replace(replace(t1.real_i_code,chr(13),''),chr(10),'') as real_i_code 
,replace(replace(t1.ad_paymentdate,chr(13),''),chr(10),'') as ad_paymentdate 
,t1.ad_interestamount as ad_interestamount 
,replace(replace(t1.pe_code,chr(13),''),chr(10),'') as pe_code 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.ibms_tbsi_accrualdetail t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbsi_accrualdetail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes