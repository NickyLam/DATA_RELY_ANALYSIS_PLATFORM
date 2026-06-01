: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_intnal_acct_f
CreateDate: 20241031
FileName:   ${iel_data_path}/cmm_intnal_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.accting_cd,chr(13),''),chr(10),'') as accting_cd
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,open_acct_dt
,clos_acct_dt
,replace(replace(t1.in_out_tab_flg,chr(13),''),chr(10),'') as in_out_tab_flg
,replace(replace(t1.bus_code_ser_num,chr(13),''),chr(10),'') as bus_code_ser_num
,replace(replace(t1.gl_acct_flg,chr(13),''),chr(10),'') as gl_acct_flg
,acct_bal
,cl_curr_acct_bal
,ear_d_bal
,ear_m_bal
,ear_s_bal
,ear_y_bal
,m_acm_bal
,s_acm_bal
,y_acm_bal
,cl_curr_ear_d_bal
,cl_curr_ear_m_bal
,cl_curr_ear_s_bal
,cl_curr_ear_y_bal
,cl_curr_y_acm_bal
,cl_curr_ear_d_y_acm_bal
,cl_curr_ear_m_y_acm_bal
,cl_curr_ear_s_y_acm_bal
,cl_curr_ear_y_y_acm_bal
,cl_curr_s_acm_bal
,cl_curr_ear_d_s_acm_bal
,cl_curr_ear_s_s_acm_bal
,cl_curr_ear_y_s_acm_bal
,cl_curr_m_acm_bal
,cl_curr_ear_d_m_acm_bal
,cl_curr_ear_m_m_acm_bal
,cl_curr_ear_y_m_acm_bal
,y_avg_bal
,q_avg_bal
,m_avg_bal
,cl_curr_y_avg_bal
,cl_curr_q_avg_bal
,cl_curr_m_avg_bal
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.acct_card_no,chr(13),''),chr(10),'') as acct_card_no
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.open_flow_num,chr(13),''),chr(10),'') as open_flow_num
,replace(replace(t1.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num
,last_tran_dt
,replace(replace(t1.last_tran_flow_num,chr(13),''),chr(10),'') as last_tran_flow_num
,replace(replace(t1.intnal_acct_char_cd,chr(13),''),chr(10),'') as intnal_acct_char_cd
,replace(replace(t1.old_acct_id,chr(13),''),chr(10),'') as old_acct_id
,replace(replace(t1.old_sub_acct_num,chr(13),''),chr(10),'') as old_sub_acct_num
,replace(replace(t1.suspd_wrtoff_flg,chr(13),''),chr(10),'') as suspd_wrtoff_flg
,replace(replace(t1.on_acct_tenor,chr(13),''),chr(10),'') as on_acct_tenor
,replace(replace(t1.wrtoff_way_cd,chr(13),''),chr(10),'') as wrtoff_way_cd
,replace(replace(t1.cap_char_cd,chr(13),''),chr(10),'') as cap_char_cd
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd
,replace(replace(t1.open_acct_chn_type_cd,chr(13),''),chr(10),'') as open_acct_chn_type_cd
,replace(replace(t1.reg_acct_type_cd,chr(13),''),chr(10),'') as reg_acct_type_cd
,replace(replace(t1.bus_mgmt_cls_cd,chr(13),''),chr(10),'') as bus_mgmt_cls_cd
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,replace(replace(t1.last_modif_teller_id,chr(13),''),chr(10),'') as last_modif_teller_id
,currt_acru_int
,replace(replace(t1.travel_card_acct_flg,chr(13),''),chr(10),'') as travel_card_acct_flg

from ${icl_schema}.cmm_intnal_acct t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_intnal_acct.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
