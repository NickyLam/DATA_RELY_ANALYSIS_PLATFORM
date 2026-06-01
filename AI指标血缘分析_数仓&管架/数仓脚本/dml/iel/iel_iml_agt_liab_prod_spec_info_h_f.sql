: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_liab_prod_spec_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_liab_prod_spec_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id 
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id 
,replace(replace(t1.liab_acct_num,chr(13),''),chr(10),'') as liab_acct_num 
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name 
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd 
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd 
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id 
,t1.rec_tm as rec_tm
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_liab_prod_spec_info_h t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_liab_prod_spec_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes