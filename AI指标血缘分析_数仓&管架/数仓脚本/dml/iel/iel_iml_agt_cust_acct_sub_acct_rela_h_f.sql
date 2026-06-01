: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cust_acct_sub_acct_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cust_acct_sub_acct_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.agt_rela_type_cd,chr(13),''),chr(10),'') as agt_rela_type_cd 
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num 
,replace(replace(t1.rela_agt_id,chr(13),''),chr(10),'') as rela_agt_id 
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t1.acct_sub_acct_id,chr(13),''),chr(10),'') as acct_sub_acct_id 
,replace(replace(t1.stand_b_type_cd,chr(13),''),chr(10),'') as stand_b_type_cd 
,replace(replace(t1.dep_basic_acct_flg,chr(13),''),chr(10),'') as dep_basic_acct_flg 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg 
,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id 
,replace(replace(t1.intnal_prod_id,chr(13),''),chr(10),'') as intnal_prod_id 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd 
from ${iml_schema}.agt_cust_acct_sub_acct_rela_h t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cust_acct_sub_acct_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes