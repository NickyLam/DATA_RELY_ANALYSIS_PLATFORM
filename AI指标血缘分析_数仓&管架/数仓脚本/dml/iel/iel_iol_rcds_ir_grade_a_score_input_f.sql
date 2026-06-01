: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_grade_a_score_input_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_grade_a_score_input.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,t.a_ln_cm_cnt_npf_secure_p as a_ln_cm_cnt_npf_secure_p
    ,t.bill_repayment as bill_repayment
    ,t.repayment as repayment
    ,t.a_cl_am_mob_nd_max as a_cl_am_mob_nd_max
    ,t.a_cc_cm_cnt_urt100 as a_cc_cm_cnt_urt100
    ,t.a_cl_am_delqfmth_l3m_m1 as a_cl_am_delqfmth_l3m_m1
    ,t.a_cl_am_delqr_l24m_m1 as a_cl_am_delqr_l24m_m1
    ,t.a_freq_query_6m_ca as a_freq_query_6m_ca
    ,t.a_cl_cm_cnt_l6m_df_p as a_cl_cm_cnt_l6m_df_p
    ,t.a_ln_cm_cnt_mana_ndf_l12_p as a_ln_cm_cnt_mana_ndf_l12_p
    ,t.a_ln_cm_cnt_house as a_ln_cm_cnt_house
    ,t.a_cc_am_inm_max as a_cc_am_inm_max
    ,replace(replace(t.marriage_sex,chr(13),''),chr(10),'') as marriage_sex
    ,t.age as age
    ,replace(replace(t.industrytype,chr(13),''),chr(10),'') as industrytype
    ,replace(replace(t.eduexperience,chr(13),''),chr(10),'') as eduexperience
    ,t.agv_utilization as agv_utilization
    ,t.a_cl_am_delqfmth_l24m_m1 as a_cl_am_delqfmth_l24m_m1
    ,t.a_cl_am_delqm_l12m_max as a_cl_am_delqm_l12m_max
    ,t.a_freq_query_12m_ca as a_freq_query_12m_ca
    ,replace(replace(t.residence_type,chr(13),''),chr(10),'') as residence_type
    ,t.a_cc_cm_cnt_urt30_p as a_cc_cm_cnt_urt30_p
    ,t.a_cc_am_delqf_l12m_m1 as a_cc_am_delqf_l12m_m1
    ,t.a_cl_cm_cnt_tot as a_cl_cm_cnt_tot
    ,t.final_risk_coef as final_risk_coef
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_grade_a_score_input t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_grade_a_score_input.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes