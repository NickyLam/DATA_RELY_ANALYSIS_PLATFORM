: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_apply_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_apply_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,t.businesssum_or_apply_amount as businesssum_or_apply_amount
    ,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
    ,replace(replace(t.chanel,chr(13),''),chr(10),'') as chanel
    ,replace(replace(t.businesstype_or_biz_type,chr(13),''),chr(10),'') as businesstype_or_biz_type
    ,replace(replace(t.marriage_status_cd,chr(13),''),chr(10),'') as marriage_status_cd
    ,replace(replace(t.gender_cd,chr(13),''),chr(10),'') as gender_cd
    ,replace(replace(t.edu_degree_cd,chr(13),''),chr(10),'') as edu_degree_cd
    ,replace(replace(t.birth_date,chr(13),''),chr(10),'') as birth_date
    ,replace(replace(t.indu_typ_cd,chr(13),''),chr(10),'') as indu_typ_cd
    ,replace(replace(t.obiligate1,chr(13),''),chr(10),'') as obiligate1
    ,replace(replace(t.obiligate2,chr(13),''),chr(10),'') as obiligate2
    ,replace(replace(t.obiligate3,chr(13),''),chr(10),'') as obiligate3
    ,replace(replace(t.obiligate4,chr(13),''),chr(10),'') as obiligate4
    ,replace(replace(t.obiligate5,chr(13),''),chr(10),'') as obiligate5
    ,replace(replace(t.obiligate6,chr(13),''),chr(10),'') as obiligate6
    ,replace(replace(t.obiligate7,chr(13),''),chr(10),'') as obiligate7
    ,replace(replace(t.obiligate8,chr(13),''),chr(10),'') as obiligate8
    ,replace(replace(t.obiligate9,chr(13),''),chr(10),'') as obiligate9
    ,replace(replace(t.obiligate10,chr(13),''),chr(10),'') as obiligate10
    ,replace(replace(t.obiligate11,chr(13),''),chr(10),'') as obiligate11
    ,replace(replace(t.obiligate12,chr(13),''),chr(10),'') as obiligate12
    ,replace(replace(t.obiligate13,chr(13),''),chr(10),'') as obiligate13
    ,replace(replace(t.obiligate14,chr(13),''),chr(10),'') as obiligate14
    ,replace(replace(t.obiligate15,chr(13),''),chr(10),'') as obiligate15
    ,replace(replace(t.obiligate16,chr(13),''),chr(10),'') as obiligate16
    ,replace(replace(t.obiligate17,chr(13),''),chr(10),'') as obiligate17
    ,replace(replace(t.obiligate18,chr(13),''),chr(10),'') as obiligate18
    ,replace(replace(t.obiligate19,chr(13),''),chr(10),'') as obiligate19
    ,replace(replace(t.obiligate20,chr(13),''),chr(10),'') as obiligate20
    ,replace(replace(t.rep_id,chr(13),''),chr(10),'') as rep_id
    ,replace(replace(t.non_loan_sum_cnt,chr(13),''),chr(10),'') as non_loan_sum_cnt
    ,replace(replace(t.house_loan_cnt,chr(13),''),chr(10),'') as house_loan_cnt
    ,replace(replace(t.marriage_status_cd_std,chr(13),''),chr(10),'') as marriage_status_cd_std
    ,replace(replace(t.gender_cd_std,chr(13),''),chr(10),'') as gender_cd_std
    ,replace(replace(t.edu_degree_cd_std,chr(13),''),chr(10),'') as edu_degree_cd_std
    ,replace(replace(t.indu_typ_cd_std,chr(13),''),chr(10),'') as indu_typ_cd_std
    ,replace(replace(t.childflag2,chr(13),''),chr(10),'') as childflag2
    ,replace(replace(t.dummy_mobile_no,chr(13),''),chr(10),'') as dummy_mobile_no
    ,replace(replace(t.emp_status,chr(13),''),chr(10),'') as emp_status
    ,replace(replace(t.emp_status_std,chr(13),''),chr(10),'') as emp_status_std
    ,replace(replace(t.residence_type,chr(13),''),chr(10),'') as residence_type
    ,replace(replace(t.residence_type_std,chr(13),''),chr(10),'') as residence_type_std
    ,replace(replace(t.house_flag1,chr(13),''),chr(10),'') as house_flag1
    ,replace(replace(t.house_value,chr(13),''),chr(10),'') as house_value
    ,replace(replace(t.industryage,chr(13),''),chr(10),'') as industryage
    ,replace(replace(t.months_curr_address_raw,chr(13),''),chr(10),'') as months_curr_address_raw
    ,replace(replace(t.months_curr_employer,chr(13),''),chr(10),'') as months_curr_employer
    ,replace(replace(t.profsn_title_cd,chr(13),''),chr(10),'') as profsn_title_cd
    ,replace(replace(t.profsn_title_cd_std,chr(13),''),chr(10),'') as profsn_title_cd_std
    ,replace(replace(t.verified_income_all,chr(13),''),chr(10),'') as verified_income_all
    ,replace(replace(t.worknature,chr(13),''),chr(10),'') as worknature
    ,replace(replace(t.worknature_std,chr(13),''),chr(10),'') as worknature_std
    ,replace(replace(t.businesssum,chr(13),''),chr(10),'') as businesssum
    ,replace(replace(t.businessrate,chr(13),''),chr(10),'') as businessrate
    ,replace(replace(t.termmonth,chr(13),''),chr(10),'') as termmonth
    ,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
    ,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
    ,replace(replace(t.loan_cur,chr(13),''),chr(10),'') as loan_cur
    ,replace(replace(t.repay_mode,chr(13),''),chr(10),'') as repay_mode
    ,replace(replace(t.loan_purpose,chr(13),''),chr(10),'') as loan_purpose
    ,replace(replace(t.prod_type_raw,chr(13),''),chr(10),'') as prod_type_raw
    ,replace(replace(t.cus_manager,chr(13),''),chr(10),'') as cus_manager
    ,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t.cus_mobile,chr(13),''),chr(10),'') as cus_mobile
    ,replace(replace(t.cus_home_tel,chr(13),''),chr(10),'') as cus_home_tel
    ,replace(replace(t.cus_corp_name,chr(13),''),chr(10),'') as cus_corp_name
    ,replace(replace(t.cus_corp_tel,chr(13),''),chr(10),'') as cus_corp_tel
    ,replace(replace(t.cus_home_ad,chr(13),''),chr(10),'') as cus_home_ad
    ,replace(replace(t.cus_reg_ad,chr(13),''),chr(10),'') as cus_reg_ad
    ,replace(replace(t.cus_post_ad,chr(13),''),chr(10),'') as cus_post_ad
    ,replace(replace(t.cus_corp_ad,chr(13),''),chr(10),'') as cus_corp_ad
    ,replace(replace(t.cus_email,chr(13),''),chr(10),'') as cus_email
    ,replace(replace(t.emergencontact_name,chr(13),''),chr(10),'') as emergencontact_name
    ,replace(replace(t.emergencontact_id,chr(13),''),chr(10),'') as emergencontact_id
    ,replace(replace(t.emergencontact_mobile,chr(13),''),chr(10),'') as emergencontact_mobile
    ,replace(replace(t.ent_name,chr(13),''),chr(10),'') as ent_name
    ,replace(replace(t.ent_id,chr(13),''),chr(10),'') as ent_id
    ,replace(replace(t.ent_est_date,chr(13),''),chr(10),'') as ent_est_date
    ,replace(replace(t.ent_legal_name,chr(13),''),chr(10),'') as ent_legal_name
    ,replace(replace(t.ent_tel,chr(13),''),chr(10),'') as ent_tel
    ,replace(replace(t.end_reg_ad,chr(13),''),chr(10),'') as end_reg_ad
    ,replace(replace(t.ent_office_ad,chr(13),''),chr(10),'') as ent_office_ad
    ,replace(replace(t.ent_reg_capital,chr(13),''),chr(10),'') as ent_reg_capital
    ,replace(replace(t.ent_real_capital,chr(13),''),chr(10),'') as ent_real_capital
    ,replace(replace(t.ent_emp_num,chr(13),''),chr(10),'') as ent_emp_num
    ,replace(replace(t.ent_cus_relation,chr(13),''),chr(10),'') as ent_cus_relation
    ,replace(replace(t.ent_cus_share,chr(13),''),chr(10),'') as ent_cus_share
    ,replace(replace(t.repay_mode_std,chr(13),''),chr(10),'') as repay_mode_std
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_apply_base_info t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_apply_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes