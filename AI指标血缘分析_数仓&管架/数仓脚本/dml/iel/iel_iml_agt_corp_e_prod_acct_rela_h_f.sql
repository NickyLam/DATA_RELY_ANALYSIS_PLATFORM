: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_corp_e_prod_acct_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_corp_e_prod_acct_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.acct_rela_id,chr(13),''),chr(10),'') as acct_rela_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id 
,replace(replace(t1.e_acct_id,chr(13),''),chr(10),'') as e_acct_id 
,replace(replace(t1.acct_sub_seq_num,chr(13),''),chr(10),'') as acct_sub_seq_num 
,replace(replace(t1.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id 
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.acct_role_type_cd,chr(13),''),chr(10),'') as acct_role_type_cd 
,t1.effect_tm as effect_tm 
,t1.invalid_tm as invalid_tm 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_corp_e_prod_acct_rela_h t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_e_prod_acct_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes