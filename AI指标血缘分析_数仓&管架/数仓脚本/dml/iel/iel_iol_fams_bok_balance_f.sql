: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_balance_f
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_bok_balance.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bookset_id,chr(13),''),chr(10),'') as bookset_id
,balance_date
,replace(replace(t1.subject_no,chr(13),''),chr(10),'') as subject_no
,replace(replace(t1.fsubject_no,chr(13),''),chr(10),'') as fsubject_no
,subject_level
,replace(replace(t1.bal_flag,chr(13),''),chr(10),'') as bal_flag
,replace(replace(t1.bal_co_flag,chr(13),''),chr(10),'') as bal_co_flag
,replace(replace(t1.o_ccy,chr(13),''),chr(10),'') as o_ccy
,o_amt
,o_c_amt
,o_d_amt
,o_co_amt
,o_co_c_amt
,o_co_d_amt
,replace(replace(t1.b_ccy,chr(13),''),chr(10),'') as b_ccy
,b_amt
,b_c_amt
,b_co_amt
,b_co_c_amt
,b_co_d_amt
,b_d_amt
,tdy_o_amt
,tdy_o_c_amt
,tdy_o_d_amt
,tdy_o_co_amt
,tdy_o_co_c_amt
,tdy_o_co_d_amt
,tdy_b_amt
,tdy_b_c_amt
,tdy_b_d_amt
,tdy_b_co_amt
,tdy_b_co_c_amt
,tdy_b_co_d_amt
,replace(replace(t1.is_leaf,chr(13),''),chr(10),'') as is_leaf
,num_amt
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.tdy_amt_flag,chr(13),''),chr(10),'') as tdy_amt_flag
,replace(replace(t1.tdy_co_flag,chr(13),''),chr(10),'') as tdy_co_flag
,tdy_pur_o_d_ulamt
,tdy_red_o_d_ulamt
,tdy_pur_o_c_ulamt
,tdy_red_o_c_ulamt
,tdy_pur_b_d_ulamt
,tdy_red_b_d_ulamt
,tdy_pur_b_c_ulamt
,tdy_red_b_c_ulamt

from ${iol_schema}.fams_bok_balance t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_balance.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
