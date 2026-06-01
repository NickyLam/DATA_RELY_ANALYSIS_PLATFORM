: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_fkd_iqp_loan_app_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_fkd_iqp_loan_app.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t.ctrl_org,chr(13),''),chr(10),'') as ctrl_org
,replace(replace(t.ctrl_branch,chr(13),''),chr(10),'') as ctrl_branch
,replace(replace(t.app_channel,chr(13),''),chr(10),'') as app_channel
,replace(replace(t.channel_no,chr(13),''),chr(10),'') as channel_no
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t.app_advice,chr(13),''),chr(10),'') as app_advice
,replace(replace(t.app_conclusion,chr(13),''),chr(10),'') as app_conclusion
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t.iss_authority,chr(13),''),chr(10),'') as iss_authority
,replace(replace(t.iss_country,chr(13),''),chr(10),'') as iss_country
,replace(replace(t.iss_date,chr(13),''),chr(10),'') as iss_date
,replace(replace(t.expiry_date,chr(13),''),chr(10),'') as expiry_date
,replace(replace(t.bank_ind,chr(13),''),chr(10),'') as bank_ind
,replace(replace(t.has_house_ind,chr(13),''),chr(10),'') as has_house_ind
,t.house_count as house_count
,replace(replace(t.purpors,chr(13),''),chr(10),'') as purpors
,replace(replace(t.concrete_purpose,chr(13),''),chr(10),'') as concrete_purpose
,replace(replace(t.pay_sourcen,chr(13),''),chr(10),'') as pay_sourcen
,replace(replace(t.partner_coowner_ind,chr(13),''),chr(10),'') as partner_coowner_ind
,replace(replace(t.partnerrel_ind,chr(13),''),chr(10),'') as partnerrel_ind
,replace(replace(t.marriage_date,chr(13),''),chr(10),'') as marriage_date
,replace(replace(t.business_type,chr(13),''),chr(10),'') as business_type
,replace(replace(t.merchant_name,chr(13),''),chr(10),'') as merchant_name
,replace(replace(t.business_addr_type,chr(13),''),chr(10),'') as business_addr_type
,replace(replace(t.business_addr,chr(13),''),chr(10),'') as business_addr
,replace(replace(t.bsopt_name,chr(13),''),chr(10),'') as bsopt_name
,replace(replace(t.actualcontroler,chr(13),''),chr(10),'') as actualcontroler
,replace(replace(t.business_scope,chr(13),''),chr(10),'') as business_scope
,replace(replace(t.enterprise_name,chr(13),''),chr(10),'') as enterprise_name
,replace(replace(t.unify_social_credit_num,chr(13),''),chr(10),'') as unify_social_credit_num
,replace(replace(t.org_institude_code,chr(13),''),chr(10),'') as org_institude_code
,replace(replace(t.ent_loan_account,chr(13),''),chr(10),'') as ent_loan_account
,replace(replace(t.ent_legal_person_name,chr(13),''),chr(10),'') as ent_legal_person_name
,replace(replace(t.ent_legal_person_id_no,chr(13),''),chr(10),'') as ent_legal_person_id_no
,replace(replace(t.borrower_identity,chr(13),''),chr(10),'') as borrower_identity
,replace(replace(t.regist_address,chr(13),''),chr(10),'') as regist_address
,t.regist_assets as regist_assets
,replace(replace(t.validite_date,chr(13),''),chr(10),'') as validite_date
,replace(replace(t.regist_date,chr(13),''),chr(10),'') as regist_date
,replace(replace(t.cptype,chr(13),''),chr(10),'') as cptype
,replace(replace(t.bs_start_date,chr(13),''),chr(10),'') as bs_start_date
,replace(replace(t.bs_end_date,chr(13),''),chr(10),'') as bs_end_date
,replace(replace(t.pract_years,chr(13),''),chr(10),'') as pract_years
,replace(replace(t.license_name,chr(13),''),chr(10),'') as license_name
,replace(replace(t.license_no,chr(13),''),chr(10),'') as license_no
,t.company_year as company_year
,t.user_business_sum as user_business_sum
,replace(replace(t.user_limit_term,chr(13),''),chr(10),'') as user_limit_term
,replace(replace(t.recommend_type,chr(13),''),chr(10),'') as recommend_type
,replace(replace(t.recommend_agency,chr(13),''),chr(10),'') as recommend_agency
,t.apply_amt as apply_amt
,t.credit_amt as credit_amt
,replace(replace(t.coop_no,chr(13),''),chr(10),'') as coop_no
,replace(replace(t.input_date,chr(13),''),chr(10),'') as input_date
,replace(replace(t.input_time,chr(13),''),chr(10),'') as input_time
,replace(replace(t.auto_score,chr(13),''),chr(10),'') as auto_score
,replace(replace(t.approve_status,chr(13),''),chr(10),'') as approve_status
,replace(replace(t.is_collect_credit,chr(13),''),chr(10),'') as is_collect_credit
,replace(replace(t.inform_flag,chr(13),''),chr(10),'') as inform_flag
,replace(replace(t.loan_inform_flag,chr(13),''),chr(10),'') as loan_inform_flag
,replace(replace(t.fail_reason,chr(13),''),chr(10),'') as fail_reason
,t.final_apply_amount as final_apply_amount
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.fina_br_id,chr(13),''),chr(10),'') as fina_br_id
,replace(replace(t.detail_addr,chr(13),''),chr(10),'') as detail_addr
,replace(replace(t.work_nature,chr(13),''),chr(10),'') as work_nature
,replace(replace(t.input_br_id,chr(13),''),chr(10),'') as input_br_id
,replace(replace(t.is_bank_rel,chr(13),''),chr(10),'') as is_bank_rel
,replace(replace(t.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t.appr_end_time,chr(13),''),chr(10),'') as appr_end_time
,replace(replace(t.is_emoji,chr(13),''),chr(10),'') as is_emoji
,replace(replace(t.input_id,chr(13),''),chr(10),'') as input_id
,replace(replace(t.is_overdue_main,chr(13),''),chr(10),'') as is_overdue_main
,replace(replace(t.is_overdue_maincp,chr(13),''),chr(10),'') as is_overdue_maincp
,replace(replace(t.loan_term,chr(13),''),chr(10),'') as loan_term
,replace(replace(t.seq_id,chr(13),''),chr(10),'') as seq_id
,replace(replace(t.com_no,chr(13),''),chr(10),'') as com_no
,replace(replace(t.com_name,chr(13),''),chr(10),'') as com_name
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_fkd_iqp_loan_app t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_fkd_iqp_loan_app.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes