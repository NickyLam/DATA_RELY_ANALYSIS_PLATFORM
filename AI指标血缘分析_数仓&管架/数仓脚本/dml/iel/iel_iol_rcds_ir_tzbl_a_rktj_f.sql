: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_tzbl_a_rktj_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_tzbl_a_rktj.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
    ,t.age_raw as age_raw
    ,replace(replace(t.business_code,chr(13),''),chr(10),'') as business_code
    ,replace(replace(t.childflag2,chr(13),''),chr(10),'') as childflag2
    ,replace(replace(t.dummy_employer,chr(13),''),chr(10),'') as dummy_employer
    ,replace(replace(t.dummy_home_address,chr(13),''),chr(10),'') as dummy_home_address
    ,replace(replace(t.dummy_work_address,chr(13),''),chr(10),'') as dummy_work_address
    ,replace(replace(t.dummy_mobile_no,chr(13),''),chr(10),'') as dummy_mobile_no
    ,replace(replace(t.dummy_work_phone_no,chr(13),''),chr(10),'') as dummy_work_phone_no
    ,replace(replace(t.education,chr(13),''),chr(10),'') as education
    ,replace(replace(t.emp_status,chr(13),''),chr(10),'') as emp_status
    ,replace(replace(t.gender,chr(13),''),chr(10),'') as gender
    ,replace(replace(t.marriage_status,chr(13),''),chr(10),'') as marriage_status
    ,replace(replace(t.residence_type,chr(13),''),chr(10),'') as residence_type
    ,t.house_value as house_value
    ,replace(replace(t.house_flag1,chr(13),''),chr(10),'') as house_flag1
    ,t.industryage as industryage
    ,t.months_curr_address_raw as months_curr_address_raw
    ,t.months_curr_employer as months_curr_employer
    ,replace(replace(t.gender_marital,chr(13),''),chr(10),'') as gender_marital
    ,replace(replace(t.gender_residence,chr(13),''),chr(10),'') as gender_residence
    ,replace(replace(t.residence_marital,chr(13),''),chr(10),'') as residence_marital
    ,replace(replace(t.profsn_title_cd,chr(13),''),chr(10),'') as profsn_title_cd
    ,t.verified_income_all as verified_income_all
    ,replace(replace(t.worknature,chr(13),''),chr(10),'') as worknature
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_tzbl_a_rktj t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_tzbl_a_rktj.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes