: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ibms_tfnd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ibms_tfnd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.i_code
,t1.a_type
,t1.m_type
,t1.l_code
,t1.currency
,t1.country
,t1.q_type
,t1.f_name
,t1.p_class
,t1.f_date
,t1.f_opendate
,t1.f_manager
,t1.f_trustee
,t1.imp_date
,t1.pipe_id
,t1.p_type
,t1.chinesespell
,t1.state
,t1.user_id
,t1.user_name
,t1.update_time
,t1.f_manager_code
,t1.f_trustee_code
,t1.issuer_id
,t1.f_invest_type
,t1.f_setupdate
,t1.f_manager_name
,t1.i_id
,t1.is_idx
,t1.huge_redemption_ratio
,t1.compounding_method
,t1.s_type
,t1.f_mtrdate
,t1.inv_order_id
,t1.par_value
,t1.pay_freq
,t1.f_grade_type
,t1.f_fullname
,t1.sales_channel
,t1.open_type
,t1.start_open_date
,t1.end_open_date
,t1.f_name_full
,t1.pay_month
,t1.pay_day
,t1.run_term
,t1.p_i_code
,t1.p_a_type
,t1.p_m_type
,t1.manager_id
,t1.manager_value
,t1.redemption_date
,t1.management_model
,t1.mitigation_freq
,t1.is_pub_offer
,t1.carry_forword_type
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_ibms_tfnd t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ibms_tfnd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes