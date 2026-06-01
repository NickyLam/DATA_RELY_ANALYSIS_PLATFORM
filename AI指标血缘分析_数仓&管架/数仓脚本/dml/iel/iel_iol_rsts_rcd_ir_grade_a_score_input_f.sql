: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_grade_a_score_input_f
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_grade_a_score_input.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.data_time,chr(13),''),chr(10),'') as data_time
,a_ln_cm_cnt_npf_secure_p
,bill_repayment
,repayment
,a_cl_am_mob_nd_max
,a_cc_cm_cnt_urt100
,a_cl_am_delqfmth_l3m_m1
,a_cl_am_delqr_l24m_m1
,a_freq_query_6m_ca
,a_cl_cm_cnt_l6m_df_p
,a_ln_cm_cnt_mana_ndf_l12_p
,a_ln_cm_cnt_house
,a_cc_am_inm_max
,replace(replace(t1.marriage_sex,chr(13),''),chr(10),'') as marriage_sex
,age
,replace(replace(t1.industrytype,chr(13),''),chr(10),'') as industrytype
,replace(replace(t1.eduexperience,chr(13),''),chr(10),'') as eduexperience
,agv_utilization
,replace(replace(t1.residence_type,chr(13),''),chr(10),'') as residence_type
,a_cl_am_delqfmth_l24m_m1
,a_cl_am_delqm_l12m_max
,a_freq_query_12m_ca
,a_cc_cm_cnt_urt30_p
,a_cc_am_delqf_l12m_m1
,a_cl_cm_cnt_tot
,final_risk_coef

from ${iol_schema}.rsts_rcd_ir_grade_a_score_input t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_grade_a_score_input.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
