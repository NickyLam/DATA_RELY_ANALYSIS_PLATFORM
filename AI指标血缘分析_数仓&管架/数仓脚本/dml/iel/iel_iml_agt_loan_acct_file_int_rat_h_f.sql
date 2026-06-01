: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_acct_file_int_rat_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_acct_file_int_rat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,and_begin_day_diff_between_days
,invalid_dt
,acrs_mon_int_rat
,not_acrs_mon_int_rat

from ${iml_schema}.agt_loan_acct_file_int_rat_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_acct_file_int_rat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
