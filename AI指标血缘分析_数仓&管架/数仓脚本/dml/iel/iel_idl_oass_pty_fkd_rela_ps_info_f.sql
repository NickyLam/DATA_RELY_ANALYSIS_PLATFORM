: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_fkd_rela_ps_info_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_fkd_rela_ps_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.bus_flow_num as bus_flow_num
,t1.rela_ps_type_cd as rela_ps_type_cd
,t1.rela_ps_name as rela_ps_name
,t1.rela_ps_mobile_no as rela_ps_mobile_no
,t1.rela_ps_cert_type_cd as rela_ps_cert_type_cd
,t1.rela_ps_cert_no as rela_ps_cert_no
,t1.and_main_brwer_rela_cd as and_main_brwer_rela_cd
,t1.rela_ps_resdnt_addr_city_cd as rela_ps_resdnt_addr_city_cd
,t1.rela_ps_resdnt_addr as rela_ps_resdnt_addr
,t1.rela_ps_marriage_situ_cd as rela_ps_marriage_situ_cd
,t1.rela_ps_spouse_name as rela_ps_spouse_name
,t1.rela_ps_spouse_mobile_no as rela_ps_spouse_mobile_no
,t1.rela_ps_spouse_cert_type_cd as rela_ps_spouse_cert_type_cd
,t1.rela_ps_spouse_cert_no as rela_ps_spouse_cert_no
,t1.rela_ps_cert_exp_dt as rela_ps_cert_exp_dt
,t1.cust_id as cust_id
,t1.rev_fraud_rest as rev_fraud_rest
,t1.crdtc_rest as crdtc_rest
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.fkd_rela_ps_list_id as fkd_rela_ps_list_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_fkd_rela_ps_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_fkd_rela_ps_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
