: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_corp_cust_rela_ps_info_f
CreateDate: 20241014
FileName:   ${iel_data_path}/cmm_corp_cust_rela_ps_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.rela_type_cd,chr(13),''),chr(10),'') as rela_type_cd
,replace(replace(t1.rela_ps_cust_id,chr(13),''),chr(10),'') as rela_ps_cust_id
,replace(replace(t1.rela_ps_name,chr(13),''),chr(10),'') as rela_ps_name
,replace(replace(t1.rela_ps_nation_cd,chr(13),''),chr(10),'') as rela_ps_nation_cd
,replace(replace(t1.rela_ps_cert_type_cd,chr(13),''),chr(10),'') as rela_ps_cert_type_cd
,replace(replace(t1.rela_ps_cert_no,chr(13),''),chr(10),'') as rela_ps_cert_no
,rela_ps_cert_effect_dt
,rela_ps_cert_exp_dt
,replace(replace(t1.rela_ps_higt_edu_cd,chr(13),''),chr(10),'') as rela_ps_higt_edu_cd
,replace(replace(t1.rela_ps_post_cd,chr(13),''),chr(10),'') as rela_ps_post_cd
,replace(replace(t1.rela_ps_senior_man_flg,chr(13),''),chr(10),'') as rela_ps_senior_man_flg
,replace(replace(t1.rela_ps_shard_flg,chr(13),''),chr(10),'') as rela_ps_shard_flg
,replace(replace(t1.legal_rep_flg,chr(13),''),chr(10),'') as legal_rep_flg
,replace(replace(t1.rela_ps_tel_num,chr(13),''),chr(10),'') as rela_ps_tel_num
,replace(replace(t1.rela_ps_tel_ext_num,chr(13),''),chr(10),'') as rela_ps_tel_ext_num
,replace(replace(t1.rela_ps_mobile_no,chr(13),''),chr(10),'') as rela_ps_mobile_no
,replace(replace(t1.rela_ps_work_unit_addr,chr(13),''),chr(10),'') as rela_ps_work_unit_addr
,replace(replace(t1.rela_ps_work_unit_tel_num,chr(13),''),chr(10),'') as rela_ps_work_unit_tel_num
,replace(replace(t1.rela_ps_en_last_name,chr(13),''),chr(10),'') as rela_ps_en_last_name
,replace(replace(t1.rela_ps_en_name,chr(13),''),chr(10),'') as rela_ps_en_name
,replace(replace(t1.rela_ps_stament_flg,chr(13),''),chr(10),'') as rela_ps_stament_flg
,replace(replace(t1.rela_ps_tax_red_idti_cd,chr(13),''),chr(10),'') as rela_ps_tax_red_idti_cd
,rela_ps_birth_dt
,replace(replace(t1.rela_ps_cn_birth_addr,chr(13),''),chr(10),'') as rela_ps_cn_birth_addr
,replace(replace(t1.rela_ps_en_birth_addr,chr(13),''),chr(10),'') as rela_ps_en_birth_addr
,replace(replace(t1.rela_ps_cn_resdnt_addr,chr(13),''),chr(10),'') as rela_ps_cn_resdnt_addr
,replace(replace(t1.rela_ps_en_resdnt_addr,chr(13),''),chr(10),'') as rela_ps_en_resdnt_addr
,replace(replace(t1.ctrler_type_cd,chr(13),''),chr(10),'') as ctrler_type_cd
,replace(replace(t1.rela_ps_post_name,chr(13),''),chr(10),'') as rela_ps_post_name
,replace(replace(t1.rela_ps_id,chr(13),''),chr(10),'') as rela_ps_id
,replace(replace(t1.ctrler_tax_null_rs_descb,chr(13),''),chr(10),'') as ctrler_tax_null_rs_descb
,replace(replace(t1.ctrler_tax_num,chr(13),''),chr(10),'') as ctrler_tax_num
,replace(replace(t1.ctrler_tax_red_cty,chr(13),''),chr(10),'') as ctrler_tax_red_cty
,rela_ps_latest_update_tm
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.rela_ps_latest_update_teller_no,chr(13),''),chr(10),'') as rela_ps_latest_update_teller_no
,replace(replace(t1.rela_ps_latest_update_org_no,chr(13),''),chr(10),'') as rela_ps_latest_update_org_no
,replace(replace(t1.rela_ps_latest_update_chn_cd,chr(13),''),chr(10),'') as rela_ps_latest_update_chn_cd
,replace(replace(t1.rela_ps_cont_addr,chr(13),''),chr(10),'') as rela_ps_cont_addr
,replace(replace(t1.rela_ps_gender_cd,chr(13),''),chr(10),'') as rela_ps_gender_cd
,replace(replace(t1.rela_ps_career_cd,chr(13),''),chr(10),'') as rela_ps_career_cd
,replace(replace(t1.rela_ps_work_unit_name,chr(13),''),chr(10),'') as rela_ps_work_unit_name
,replace(replace(t1.rela_ps_work_unit_char_cd,chr(13),''),chr(10),'') as rela_ps_work_unit_char_cd
,replace(replace(t1.rela_ps_title_level_cd,chr(13),''),chr(10),'') as rela_ps_title_level_cd
,replace(replace(t1.rela_ps_other_career_descb,chr(13),''),chr(10),'') as rela_ps_other_career_descb
,rela_ps_mon_inco
,replace(replace(t1.rela_ps_open_acct_lics,chr(13),''),chr(10),'') as rela_ps_open_acct_lics
,replace(replace(t1.rela_ps_belong_group_num,chr(13),''),chr(10),'') as rela_ps_belong_group_num
,replace(replace(t1.rela_ps_mang_tenor,chr(13),''),chr(10),'') as rela_ps_mang_tenor
,replace(replace(t1.rela_ps_super_org_orgnz_cd,chr(13),''),chr(10),'') as rela_ps_super_org_orgnz_cd
,replace(replace(t1.rela_ps_super_org_unify_soci_crdt_cd,chr(13),''),chr(10),'') as rela_ps_super_org_unify_soci_crdt_cd
,replace(replace(t1.rela_ps_director_corp_rgst_curr_cd,chr(13),''),chr(10),'') as rela_ps_director_corp_rgst_curr_cd
,rela_ps_director_corp_rgst_amt

from ${icl_schema}.cmm_corp_cust_rela_ps_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_cust_rela_ps_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
