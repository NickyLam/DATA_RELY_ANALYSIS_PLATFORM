: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_fkd_rela_ps_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_fkd_rela_ps_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(fkd_rela_ps_list_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(bus_flow_num,chr(13),''),chr(10),'')
,replace(replace(rela_ps_type_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_name,chr(13),''),chr(10),'')
,replace(replace(rela_ps_mobile_no,chr(13),''),chr(10),'')
,replace(replace(rela_ps_cert_type_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_cert_no,chr(13),''),chr(10),'')
,replace(replace(and_main_brwer_rela_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_resdnt_addr_city_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_resdnt_addr,chr(13),''),chr(10),'')
,replace(replace(rela_ps_marriage_situ_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_spouse_name,chr(13),''),chr(10),'')
,replace(replace(rela_ps_spouse_mobile_no,chr(13),''),chr(10),'')
,replace(replace(rela_ps_spouse_cert_type_cd,chr(13),''),chr(10),'')
,replace(replace(rela_ps_spouse_cert_no,chr(13),''),chr(10),'')
,replace(replace(cust_id,chr(13),''),chr(10),'')
,replace(replace(rev_fraud_rest,chr(13),''),chr(10),'')
,replace(replace(crdtc_rest,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')
,rela_ps_cert_exp_dt

from ${iml_schema}.pty_fkd_rela_ps_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_fkd_rela_ps_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
