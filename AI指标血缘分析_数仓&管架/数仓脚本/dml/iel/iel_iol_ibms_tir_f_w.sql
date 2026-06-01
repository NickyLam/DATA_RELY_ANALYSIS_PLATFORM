: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tir_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tir_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(q_type,chr(10),''),chr(13),'') as q_type
,replace(replace(r_daycount,chr(10),''),chr(13),'') as r_daycount
,replace(replace(r_name,chr(10),''),chr(13),'') as r_name
,replace(replace(r_term,chr(10),''),chr(13),'') as r_term
,replace(replace(imp_date,chr(10),''),chr(13),'') as imp_date
,replace(replace(pipe_id,chr(10),''),chr(13),'') as pipe_id
,replace(replace(r_names_match,chr(10),''),chr(13),'') as r_names_match
,replace(replace(chinesespell,chr(10),''),chr(13),'') as chinesespell
,replace(replace(settle_days,chr(10),''),chr(13),'') as settle_days
,replace(replace(settle_bizday_conv,chr(10),''),chr(13),'') as settle_bizday_conv
,replace(replace(fixing_days,chr(10),''),chr(13),'') as fixing_days
,replace(replace(fixing_bizday_conv,chr(10),''),chr(13),'') as fixing_bizday_conv
,replace(replace(quote_scale,chr(10),''),chr(13),'') as quote_scale
,replace(replace(imp_time,chr(10),''),chr(13),'') as imp_time
,replace(replace(r_extsys_name,chr(10),''),chr(13),'') as r_extsys_name
,replace(replace(country,chr(10),''),chr(13),'') as country
,replace(replace(p_class,chr(10),''),chr(13),'') as p_class
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(acc_bizday_conv,chr(10),''),chr(13),'') as acc_bizday_conv
,replace(replace(endofmonth,chr(10),''),chr(13),'') as endofmonth
,replace(replace(mm_index,chr(10),''),chr(13),'') as mm_index
,replace(replace(s_type,chr(10),''),chr(13),'') as s_type
,replace(replace(fixing_calendar,chr(10),''),chr(13),'') as fixing_calendar
,replace(replace(financial_center_calendar,chr(10),''),chr(13),'') as financial_center_calendar
,replace(replace(financial_center,chr(10),''),chr(13),'') as financial_center
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_tir
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tir_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes