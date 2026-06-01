: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_corp_cust_rela_ps_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_corp_cust_rela_ps_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,cust_id
,rela_type_cd
,rela_ps_cust_id
,rela_ps_name
,rela_ps_nation_cd
,rela_ps_cert_type_cd
,rela_ps_cert_no
,rela_ps_cert_effect_dt
,rela_ps_cert_exp_dt
,rela_ps_higt_edu_cd
,rela_ps_post_cd
,rela_ps_senior_man_flg
,rela_ps_shard_flg
,legal_rep_flg
,rela_ps_tel_num
,rela_ps_tel_ext_num
,rela_ps_mobile_no
,rela_ps_work_unit_addr
,rela_ps_work_unit_tel_num
,rela_ps_en_last_name
,rela_ps_en_name
,rela_ps_stament_flg
,rela_ps_tax_red_idti_cd
,rela_ps_birth_dt
,rela_ps_cn_birth_addr
,rela_ps_en_birth_addr
,rela_ps_cn_resdnt_addr
,rela_ps_en_resdnt_addr
,ctrler_type_cd
,rela_ps_post_name
from ${idl_schema}.aml_cmm_corp_cust_rela_ps_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_corp_cust_rela_ps_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes