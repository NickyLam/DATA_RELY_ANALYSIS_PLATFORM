: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_indv_cust_rela_ps_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_indv_cust_rela_ps_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,cust_id
,rela_ps_cust_id
,rela_type_cd
,rela_ps_name
,rela_ps_cert_type_cd
,rela_ps_cert_no
,rela_ps_gender_cd
,rela_ps_birth_dt
,rela_ps_nati_place
,rela_ps_nationty_cd
,rela_ps_nation_cd
,rela_ps_dist_cd
,rela_ps_marriage_situ_cd
,rela_ps_resd_status_cd
,rela_ps_politic_status_cd
,rela_ps_work_unit_cust_id
,rela_ps_work_unit_name
,rela_ps_tel_num
,rela_ps_tel_ext_num
,rela_ps_mobile_no
,rela_ps_work_unit_addr
,rela_ps_work_unit_tel
from ${idl_schema}.aml_cmm_indv_cust_rela_ps_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_indv_cust_rela_ps_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes