: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_indv_cust_rela_ps_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_indv_cust_rela_ps_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.rela_ps_cust_id,chr(13),''),chr(10),'') as rela_ps_cust_id
,replace(replace(t1.rela_type_cd,chr(13),''),chr(10),'') as rela_type_cd
,replace(replace(t1.rela_ps_name,chr(13),''),chr(10),'') as rela_ps_name
,replace(replace(t1.rela_ps_cert_type_cd,chr(13),''),chr(10),'') as rela_ps_cert_type_cd
,replace(replace(t1.rela_ps_cert_no,chr(13),''),chr(10),'') as rela_ps_cert_no
,replace(replace(t1.rela_ps_gender_cd,chr(13),''),chr(10),'') as rela_ps_gender_cd
,t1.rela_ps_birth_dt as rela_ps_birth_dt
,replace(replace(t1.rela_ps_nati_place,chr(13),''),chr(10),'') as rela_ps_nati_place
,replace(replace(t1.rela_ps_nationty_cd,chr(13),''),chr(10),'') as rela_ps_nationty_cd
,replace(replace(t1.rela_ps_nation_cd,chr(13),''),chr(10),'') as rela_ps_nation_cd
,replace(replace(t1.rela_ps_dist_cd,chr(13),''),chr(10),'') as rela_ps_dist_cd
,replace(replace(t1.rela_ps_marriage_situ_cd,chr(13),''),chr(10),'') as rela_ps_marriage_situ_cd
,replace(replace(t1.rela_ps_resd_status_cd,chr(13),''),chr(10),'') as rela_ps_resd_status_cd
,replace(replace(t1.rela_ps_politic_status_cd,chr(13),''),chr(10),'') as rela_ps_politic_status_cd
,replace(replace(t1.rela_ps_work_unit_cust_id,chr(13),''),chr(10),'') as rela_ps_work_unit_cust_id
,replace(replace(t1.rela_ps_work_unit_name,chr(13),''),chr(10),'') as rela_ps_work_unit_name
,replace(replace(t1.rela_ps_tel_num,chr(13),''),chr(10),'') as rela_ps_tel_num
,replace(replace(t1.rela_ps_tel_ext_num,chr(13),''),chr(10),'') as rela_ps_tel_ext_num
,replace(replace(t1.rela_ps_mobile_no,chr(13),''),chr(10),'') as rela_ps_mobile_no
,replace(replace(t1.rela_ps_work_unit_addr,chr(13),''),chr(10),'') as rela_ps_work_unit_addr
,replace(replace(t1.rela_ps_work_unit_tel,chr(13),''),chr(10),'') as rela_ps_work_unit_tel
,replace(replace(t1.rela_ps_id,chr(13),''),chr(10),'') as rela_ps_id
from ${icl_schema}.cmm_indv_cust_rela_ps_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_indv_cust_rela_ps_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes