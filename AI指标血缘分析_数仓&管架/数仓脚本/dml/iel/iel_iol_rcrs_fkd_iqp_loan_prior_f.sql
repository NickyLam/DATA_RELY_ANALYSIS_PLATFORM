: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_fkd_iqp_loan_prior_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_fkd_iqp_loan_prior.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t.is_get_cus_code,chr(13),''),chr(10),'') as is_get_cus_code
,t.is_check_inspect as is_check_inspect
,replace(replace(t.ctrl_org,chr(13),''),chr(10),'') as ctrl_org
,replace(replace(t.ctrl_branch,chr(13),''),chr(10),'') as ctrl_branch
,replace(replace(t.app_channel,chr(13),''),chr(10),'') as app_channel
,replace(replace(t.channel_no,chr(13),''),chr(10),'') as channel_no
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.purpors,chr(13),''),chr(10),'') as purpors
,replace(replace(t.phone,chr(13),''),chr(10),'') as phone
,t.credit_amt as credit_amt
,replace(replace(t.coop_no,chr(13),''),chr(10),'') as coop_no
,replace(replace(t.input_date,chr(13),''),chr(10),'') as input_date
,replace(replace(t.input_time,chr(13),''),chr(10),'') as input_time
,replace(replace(t.auto_score,chr(13),''),chr(10),'') as auto_score
,replace(replace(t.approve_status,chr(13),''),chr(10),'') as approve_status
,replace(replace(t.is_collect_credit,chr(13),''),chr(10),'') as is_collect_credit
,replace(replace(t.inform_flag,chr(13),''),chr(10),'') as inform_flag
,replace(replace(t.fail_reason,chr(13),''),chr(10),'') as fail_reason
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.fina_br_id,chr(13),''),chr(10),'') as fina_br_id
,replace(replace(t.input_br_id,chr(13),''),chr(10),'') as input_br_id
,replace(replace(t.appr_end_time,chr(13),''),chr(10),'') as appr_end_time
,replace(replace(t.is_emoji,chr(13),''),chr(10),'') as is_emoji
,replace(replace(t.input_id,chr(13),''),chr(10),'') as input_id
,replace(replace(t.is_bank_rel,chr(13),''),chr(10),'') as is_bank_rel
,replace(replace(t.is_overdue_main,chr(13),''),chr(10),'') as is_overdue_main
,replace(replace(t.city_name,chr(13),''),chr(10),'') as city_name
,replace(replace(t.detail_addr,chr(13),''),chr(10),'') as detail_addr
,t.room_size as room_size
,t.room_price as room_price
,replace(replace(t.project_name,chr(13),''),chr(10),'') as project_name
,replace(replace(t.city_area_code,chr(13),''),chr(10),'') as city_area_code
,replace(replace(t.seq_id,chr(13),''),chr(10),'') as seq_id
,replace(replace(t.com_no,chr(13),''),chr(10),'') as com_no
,replace(replace(t.com_name,chr(13),''),chr(10),'') as com_name
,replace(replace(t.ms_flag,chr(13),''),chr(10),'') as ms_flag
,t.ms_credit_amt as ms_credit_amt
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_fkd_iqp_loan_prior t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_fkd_iqp_loan_prior.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes