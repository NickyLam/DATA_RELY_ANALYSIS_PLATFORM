: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_indv_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_indv.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.pbc_cust_num,chr(13),''),chr(10),'') as pbc_cust_num
    ,replace(replace(t.indv_en_name,chr(13),''),chr(10),'') as indv_en_name
    ,t.birth_dt as birth_dt
    ,replace(replace(t.birth_addr,chr(13),''),chr(10),'') as birth_addr
    ,replace(replace(t.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd
    ,replace(replace(t.party_name,chr(13),''),chr(10),'') as party_name
    ,replace(replace(t.indv_bus_flg,chr(13),''),chr(10),'') as indv_bus_flg
    ,replace(replace(t.indv_bus_cert_no,chr(13),''),chr(10),'') as indv_bus_cert_no
    ,replace(replace(t.nation_cd,chr(13),''),chr(10),'') as nation_cd
    ,replace(replace(t.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd
    ,replace(replace(t.nati_place_cd,chr(13),''),chr(10),'') as nati_place_cd
    ,replace(replace(t.resd_status_cd,chr(13),''),chr(10),'') as resd_status_cd
    ,replace(replace(t.nationty_cd,chr(13),''),chr(10),'') as nationty_cd
    ,replace(replace(t.taxpayer_idtfy_num,chr(13),''),chr(10),'') as taxpayer_idtfy_num
    ,replace(replace(t.real_name_flg,chr(13),''),chr(10),'') as real_name_flg
    ,replace(replace(t.tax_resdnt_cty_cd,chr(13),''),chr(10),'') as tax_resdnt_cty_cd
    ,replace(replace(t.tax_resdnt_idti_type_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_type_cd
    ,replace(replace(t.sm_bus_owner_flg,chr(13),''),chr(10),'') as sm_bus_owner_flg
    ,replace(replace(t.sm_bus_owner_cert_no,chr(13),''),chr(10),'') as sm_bus_owner_cert_no
    ,replace(replace(t.sm_bus_owner_cert_type_cd,chr(13),''),chr(10),'') as sm_bus_owner_cert_type_cd
    ,replace(replace(t.gender_cd,chr(13),''),chr(10),'') as gender_cd
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.degree_cd,chr(13),''),chr(10),'') as degree_cd
    ,replace(replace(t.blood_type_cd,chr(13),''),chr(10),'') as blood_type_cd
    ,replace(replace(t.ctysd_contr_oper_acct_flg,chr(13),''),chr(10),'') as ctysd_contr_oper_acct_flg
    ,replace(replace(t.farm_flg,chr(13),''),chr(10),'') as farm_flg
    ,replace(replace(t.have_work_unit_flg,chr(13),''),chr(10),'') as have_work_unit_flg
    ,replace(replace(t.post_cd,chr(13),''),chr(10),'') as post_cd
    ,replace(replace(t.title_cd,chr(13),''),chr(10),'') as title_cd
    ,replace(replace(t.resdnt_char_cd,chr(13),''),chr(10),'') as resdnt_char_cd
    ,replace(replace(t.rg_cd,chr(13),''),chr(10),'') as rg_cd
    ,replace(replace(t.emply_flg,chr(13),''),chr(10),'') as emply_flg
    ,replace(replace(t.dist_cd,chr(13),''),chr(10),'') as dist_cd
    ,replace(replace(t.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg
    ,replace(replace(t.nati_place,chr(13),''),chr(10),'') as nati_place
    ,t.age as age
    ,replace(replace(t.owner_type_cd,chr(13),''),chr(10),'') as owner_type_cd
    ,replace(replace(t.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd
    ,replace(replace(t.ghb_rela_peop_flg,chr(13),''),chr(10),'') as ghb_rela_peop_flg
    ,replace(replace(t.health_status_cd,chr(13),''),chr(10),'') as health_status_cd
    ,replace(replace(t.spoken,chr(13),''),chr(10),'') as spoken
    ,replace(replace(t.sys_in_cust_flg,chr(13),''),chr(10),'') as sys_in_cust_flg
    ,replace(replace(t.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd
    ,replace(replace(t.tax_stament_flg,chr(13),''),chr(10),'') as tax_stament_flg
    ,replace(replace(t.indv_party_type_cd,chr(13),''),chr(10),'') as indv_party_type_cd
    ,replace(replace(t.hxb_post_type_cd,chr(13),''),chr(10),'') as hxb_post_type_cd
    ,replace(replace(t.grad_school,chr(13),''),chr(10),'') as grad_school
    ,replace(replace(t.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg
    ,replace(replace(t.main_type_cd,chr(13),''),chr(10),'') as main_type_cd
    ,replace(replace(t.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb
    ,replace(replace(t.indv_bus_cert_type_cd,chr(13),''),chr(10),'') as indv_bus_cert_type_cd
    ,replace(replace(t.loan_card_no,chr(13),''),chr(10),'') as loan_card_no
    ,replace(replace(t.soci_secu_card_no,chr(13),''),chr(10),'') as soci_secu_card_no
    ,replace(replace(t.provi_fund_acct_num,chr(13),''),chr(10),'') as provi_fund_acct_num
    ,replace(replace(t.agent_open_flg,chr(13),''),chr(10),'') as agent_open_flg
    ,replace(replace(t.referrer_type_cd,chr(13),''),chr(10),'') as referrer_type_cd
    ,replace(replace(t.referrer_num,chr(13),''),chr(10),'') as referrer_num
    ,replace(replace(t.obtain_emply_situ_cd,chr(13),''),chr(10),'') as obtain_emply_situ_cd
    ,replace(replace(t.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
    ,replace(replace(t.legal_en_last_name,chr(13),''),chr(10),'') as legal_en_last_name
    ,replace(replace(t.legal_en_mdl_name,chr(13),''),chr(10),'') as legal_en_mdl_name
    ,replace(replace(t.legal_en_name,chr(13),''),chr(10),'') as legal_en_name
    ,replace(replace(t.career_cd,chr(13),''),chr(10),'') as career_cd
    ,replace(replace(t.other_career_name,chr(13),''),chr(10),'') as other_career_name
    ,t.share_ratio as share_ratio
    ,replace(replace(t.shard_type_cd,chr(13),''),chr(10),'') as shard_type_cd
    ,replace(replace(t.ctrler_type_cd,chr(13),''),chr(10),'') as ctrler_type_cd
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from iml.pty_indv t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_indv.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes