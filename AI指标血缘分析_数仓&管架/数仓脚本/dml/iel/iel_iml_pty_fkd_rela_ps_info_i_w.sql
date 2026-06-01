: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_fkd_rela_ps_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_fkd_rela_ps_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.fkd_rela_ps_list_id,chr(13),''),chr(10),'') as fkd_rela_ps_list_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num 
,replace(replace(t1.rela_ps_type_cd,chr(13),''),chr(10),'') as rela_ps_type_cd 
,replace(replace(t1.rela_ps_name,chr(13),''),chr(10),'') as rela_ps_name 
,replace(replace(t1.rela_ps_mobile_no,chr(13),''),chr(10),'') as rela_ps_mobile_no 
,replace(replace(t1.rela_ps_cert_type_cd,chr(13),''),chr(10),'') as rela_ps_cert_type_cd 
,replace(replace(t1.rela_ps_cert_no,chr(13),''),chr(10),'') as rela_ps_cert_no 
,replace(replace(t1.and_main_brwer_rela_cd,chr(13),''),chr(10),'') as and_main_brwer_rela_cd 
,replace(replace(t1.rela_ps_resdnt_addr_city_cd,chr(13),''),chr(10),'') as rela_ps_resdnt_addr_city_cd 
,replace(replace(t1.rela_ps_resdnt_addr,chr(13),''),chr(10),'') as rela_ps_resdnt_addr 
,replace(replace(t1.rela_ps_marriage_situ_cd,chr(13),''),chr(10),'') as rela_ps_marriage_situ_cd 
,replace(replace(t1.rela_ps_spouse_name,chr(13),''),chr(10),'') as rela_ps_spouse_name 
,replace(replace(t1.rela_ps_spouse_mobile_no,chr(13),''),chr(10),'') as rela_ps_spouse_mobile_no 
,replace(replace(t1.rela_ps_spouse_cert_type_cd,chr(13),''),chr(10),'') as rela_ps_spouse_cert_type_cd 
,replace(replace(t1.rela_ps_spouse_cert_no,chr(13),''),chr(10),'') as rela_ps_spouse_cert_no 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.rev_fraud_rest,chr(13),''),chr(10),'') as rev_fraud_rest 
,replace(replace(t1.crdtc_rest,chr(13),''),chr(10),'') as crdtc_rest 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_fkd_rela_ps_info t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_fkd_rela_ps_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes