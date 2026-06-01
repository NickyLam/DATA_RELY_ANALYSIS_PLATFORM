: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tfnd_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tfnd_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(l_code,chr(10),''),chr(13),'') as l_code
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(country,chr(10),''),chr(13),'') as country
,replace(replace(q_type,chr(10),''),chr(13),'') as q_type
,replace(replace(f_name,chr(10),''),chr(13),'') as f_name
,replace(replace(p_class,chr(10),''),chr(13),'') as p_class
,replace(replace(f_date,chr(10),''),chr(13),'') as f_date
,replace(replace(f_opendate,chr(10),''),chr(13),'') as f_opendate
,replace(replace(f_manager,chr(10),''),chr(13),'') as f_manager
,replace(replace(f_trustee,chr(10),''),chr(13),'') as f_trustee
,replace(replace(imp_date,chr(10),''),chr(13),'') as imp_date
,replace(replace(pipe_id,chr(10),''),chr(13),'') as pipe_id
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(chinesespell,chr(10),''),chr(13),'') as chinesespell
,replace(replace(state,chr(10),''),chr(13),'') as state
,replace(replace(user_id,chr(10),''),chr(13),'') as user_id
,replace(replace(user_name,chr(10),''),chr(13),'') as user_name
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(f_manager_code,chr(10),''),chr(13),'') as f_manager_code
,replace(replace(f_trustee_code,chr(10),''),chr(13),'') as f_trustee_code
,replace(replace(issuer_id,chr(10),''),chr(13),'') as issuer_id
,replace(replace(f_invest_type,chr(10),''),chr(13),'') as f_invest_type
,replace(replace(f_setupdate,chr(10),''),chr(13),'') as f_setupdate
,replace(replace(f_manager_name,chr(10),''),chr(13),'') as f_manager_name
,replace(replace(i_id,chr(10),''),chr(13),'') as i_id
,replace(replace(is_idx,chr(10),''),chr(13),'') as is_idx
,replace(replace(huge_redemption_ratio,chr(10),''),chr(13),'') as huge_redemption_ratio
,replace(replace(compounding_method,chr(10),''),chr(13),'') as compounding_method
,replace(replace(s_type,chr(10),''),chr(13),'') as s_type
,replace(replace(f_mtrdate,chr(10),''),chr(13),'') as f_mtrdate
,replace(replace(carry_forword_type,chr(10),''),chr(13),'') as carry_forword_type
,replace(replace(inv_order_id,chr(10),''),chr(13),'') as inv_order_id
,replace(replace(par_value,chr(10),''),chr(13),'') as par_value
,replace(replace(pay_freq,chr(10),''),chr(13),'') as pay_freq
,replace(replace(f_grade_type,chr(10),''),chr(13),'') as f_grade_type
,replace(replace(f_fullname,chr(10),''),chr(13),'') as f_fullname
,replace(replace(sales_channel,chr(10),''),chr(13),'') as sales_channel
,replace(replace(open_type,chr(10),''),chr(13),'') as open_type
,replace(replace(start_open_date,chr(10),''),chr(13),'') as start_open_date
,replace(replace(end_open_date,chr(10),''),chr(13),'') as end_open_date
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_tfnd
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tfnd_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes