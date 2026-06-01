: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_unite_wl_distr_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_unite_wl_distr_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_cert_type_cd,chr(13),''),chr(10),'') as cust_cert_type_cd
,replace(replace(t1.cust_cert_no,chr(13),''),chr(10),'') as cust_cert_no
,replace(replace(t1.crdt_id,chr(13),''),chr(10),'') as crdt_id
,replace(replace(t1.loan_appl_form_num,chr(13),''),chr(10),'') as loan_appl_form_num
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.loan_contr_no,chr(13),''),chr(10),'') as loan_contr_no
,replace(replace(t1.loan_status_cd,chr(13),''),chr(10),'') as loan_status_cd
,replace(replace(t1.loan_usage,chr(13),''),chr(10),'') as loan_usage
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.distr_amt as distr_amt
,t1.appl_dt as appl_dt
,t1.distr_dt as distr_dt
,t1.loan_pd_cnt as loan_pd_cnt
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,t1.grace_period_days as grace_period_days
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,t1.loan_day_int_rat as loan_day_int_rat
,t1.pric_repay_freq as pric_repay_freq
,t1.int_repay_freq as int_repay_freq
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
,replace(replace(t1.recvbl_num,chr(13),''),chr(10),'') as recvbl_num
,replace(replace(t1.recvbl_num_type_cd,chr(13),''),chr(10),'') as recvbl_num_type_cd
,replace(replace(t1.repay_num,chr(13),''),chr(10),'') as repay_num
,replace(replace(t1.repay_num_type_cd,chr(13),''),chr(10),'') as repay_num_type_cd
,replace(replace(t1.intnal_carr_idf,chr(13),''),chr(10),'') as intnal_carr_idf
from ${icl_schema}.cmm_unite_wl_distr_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')-1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_distr_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes