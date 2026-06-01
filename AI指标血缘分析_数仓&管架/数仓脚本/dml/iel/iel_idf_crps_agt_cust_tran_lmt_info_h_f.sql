: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_agt_cust_tran_lmt_info_h_f
CreateDate: 20250208
FileName:   ${iel_data_path}/crps_agt_cust_tran_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.lmt_code,chr(13),''),chr(10),'') as lmt_code
,replace(replace(t1.lmt_cate_cd,chr(13),''),chr(10),'') as lmt_cate_cd
,replace(replace(t1.lmt_set_rs_cd,chr(13),''),chr(10),'')  as lmt_set_rs_cd
,t1.tran_lmt_valid_dt as tran_lmt_valid_dt
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.amt_uplmi as amt_uplmi
,t1.amt_lolmi as amt_lolmi
,t1.cnt_limit as cnt_limit
,t1.tran_tm as tran_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt

from ${iml_schema}.agt_cust_tran_lmt_info_h t1
where 1 = 1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_agt_cust_tran_lmt_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
