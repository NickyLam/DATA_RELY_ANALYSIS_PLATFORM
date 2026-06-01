: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_ibms_tfnd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_ibms_tfnd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.l_code,chr(13),''),chr(10),'') as l_code
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.q_type,chr(13),''),chr(10),'') as q_type
,replace(replace(t1.f_name,chr(13),''),chr(10),'') as f_name
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.f_date,chr(13),''),chr(10),'') as f_date
,replace(replace(t1.f_opendate,chr(13),''),chr(10),'') as f_opendate
,replace(replace(t1.f_manager,chr(13),''),chr(10),'') as f_manager
,replace(replace(t1.f_trustee,chr(13),''),chr(10),'') as f_trustee
,replace(replace(t1.imp_date,chr(13),''),chr(10),'') as imp_date
,t1.pipe_id as pipe_id
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,replace(replace(t1.chinesespell,chr(13),''),chr(10),'') as chinesespell
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,t1.user_id as user_id
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.f_manager_code,chr(13),''),chr(10),'') as f_manager_code
,replace(replace(t1.f_trustee_code,chr(13),''),chr(10),'') as f_trustee_code
,t1.issuer_id as issuer_id
,replace(replace(t1.f_invest_type,chr(13),''),chr(10),'') as f_invest_type
,replace(replace(t1.f_setupdate,chr(13),''),chr(10),'') as f_setupdate
,replace(replace(t1.f_manager_name,chr(13),''),chr(10),'') as f_manager_name
,t1.i_id as i_id
,replace(replace(t1.is_idx,chr(13),''),chr(10),'') as is_idx
,t1.huge_redemption_ratio as huge_redemption_ratio
,t1.compounding_method as compounding_method
,replace(replace(t1.s_type,chr(13),''),chr(10),'') as s_type
,replace(replace(t1.f_mtrdate,chr(13),''),chr(10),'') as f_mtrdate
,replace(replace(t1.inv_order_id,chr(13),''),chr(10),'') as inv_order_id
,t1.par_value as par_value
,replace(replace(t1.pay_freq,chr(13),''),chr(10),'') as pay_freq
,t1.f_grade_type as f_grade_type
,replace(replace(t1.f_fullname,chr(13),''),chr(10),'') as f_fullname
,replace(replace(t1.sales_channel,chr(13),''),chr(10),'') as sales_channel
,replace(replace(t1.open_type,chr(13),''),chr(10),'') as open_type
,replace(replace(t1.start_open_date,chr(13),''),chr(10),'') as start_open_date
,replace(replace(t1.end_open_date,chr(13),''),chr(10),'') as end_open_date
,replace(replace(t1.f_name_full,chr(13),''),chr(10),'') as f_name_full
,replace(replace(t1.pay_month,chr(13),''),chr(10),'') as pay_month
,replace(replace(t1.pay_day,chr(13),''),chr(10),'') as pay_day
,replace(replace(t1.run_term,chr(13),''),chr(10),'') as run_term
,replace(replace(t1.p_i_code,chr(13),''),chr(10),'') as p_i_code
,replace(replace(t1.p_a_type,chr(13),''),chr(10),'') as p_a_type
,replace(replace(t1.p_m_type,chr(13),''),chr(10),'') as p_m_type
,t1.manager_id as manager_id
,replace(replace(t1.manager_value,chr(13),''),chr(10),'') as manager_value
,replace(replace(t1.redemption_date,chr(13),''),chr(10),'') as redemption_date
,replace(replace(t1.management_model,chr(13),''),chr(10),'') as management_model
,replace(replace(t1.mitigation_freq,chr(13),''),chr(10),'') as mitigation_freq
,replace(replace(t1.is_pub_offer,chr(13),''),chr(10),'') as is_pub_offer
 from iol.ibms_tfnd T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_ibms_tfnd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes