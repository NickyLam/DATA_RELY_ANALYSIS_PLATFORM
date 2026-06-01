: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tir_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_tir.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.q_type,chr(13),''),chr(10),'') as q_type
,replace(replace(t1.r_daycount,chr(13),''),chr(10),'') as r_daycount
,replace(replace(t1.r_name,chr(13),''),chr(10),'') as r_name
,replace(replace(t1.r_term,chr(13),''),chr(10),'') as r_term
,replace(replace(t1.imp_date,chr(13),''),chr(10),'') as imp_date
,t1.pipe_id as pipe_id
,replace(replace(t1.r_names_match,chr(13),''),chr(10),'') as r_names_match
,replace(replace(t1.chinesespell,chr(13),''),chr(10),'') as chinesespell
,t1.settle_days as settle_days
,replace(replace(t1.settle_bizday_conv,chr(13),''),chr(10),'') as settle_bizday_conv
,t1.fixing_days as fixing_days
,replace(replace(t1.fixing_bizday_conv,chr(13),''),chr(10),'') as fixing_bizday_conv
,t1.quote_scale as quote_scale
,replace(replace(t1.imp_time,chr(13),''),chr(10),'') as imp_time
,replace(replace(t1.r_extsys_name,chr(13),''),chr(10),'') as r_extsys_name
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,replace(replace(t1.acc_bizday_conv,chr(13),''),chr(10),'') as acc_bizday_conv
,replace(replace(t1.endofmonth,chr(13),''),chr(10),'') as endofmonth
,replace(replace(t1.mm_index,chr(13),''),chr(10),'') as mm_index
,replace(replace(t1.s_type,chr(13),''),chr(10),'') as s_type
,replace(replace(t1.fixing_calendar,chr(13),''),chr(10),'') as fixing_calendar
,replace(replace(t1.financial_center_calendar,chr(13),''),chr(10),'') as financial_center_calendar
,replace(replace(t1.financial_center,chr(13),''),chr(10),'') as financial_center

from ${iol_schema}.ibms_tir t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tir.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
