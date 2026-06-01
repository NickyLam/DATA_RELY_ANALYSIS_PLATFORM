: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_indv_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_indv.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.pbc_cust_num as pbc_cust_num
,t1.indv_en_name as indv_en_name
,t1.birth_dt as birth_dt
,t1.birth_addr as birth_addr
,t1.depositr_cate_cd as depositr_cate_cd
,t1.party_name as party_name
,t1.indv_bus_flg as indv_bus_flg
,t1.indv_bus_cert_no as indv_bus_cert_no
,t1.nation_cd as nation_cd
,t1.marriage_situ_cd as marriage_situ_cd
,t1.nati_place_cd as nati_place_cd
,t1.resd_status_cd as resd_status_cd
,t1.nationty_cd as nationty_cd
,t1.taxpayer_idtfy_num as taxpayer_idtfy_num
,t1.real_name_flg as real_name_flg
,t1.tax_resdnt_cty_cd as tax_resdnt_cty_cd
,t1.tax_resdnt_idti_type_cd as tax_resdnt_idti_type_cd
,t1.sm_bus_owner_flg as sm_bus_owner_flg
,t1.sm_bus_owner_cert_no as sm_bus_owner_cert_no
,t1.sm_bus_owner_cert_type_cd as sm_bus_owner_cert_type_cd
,t1.gender_cd as gender_cd
,t1.name as name
,t1.degree_cd as degree_cd
,t1.blood_type_cd as blood_type_cd
,t1.ctysd_contr_oper_acct_flg as ctysd_contr_oper_acct_flg
,t1.farm_flg as farm_flg
,t1.have_work_unit_flg as have_work_unit_flg
,t1.post_cd as post_cd
,t1.title_cd as title_cd
,t1.resdnt_char_cd as resdnt_char_cd
,t1.rg_cd as rg_cd
,t1.emply_flg as emply_flg
,t1.dist_cd as dist_cd
,t1.resdnt_flg as resdnt_flg
,t1.nati_place as nati_place
,t1.age as age
,t1.owner_type_cd as owner_type_cd
,t1.politic_status_cd as politic_status_cd
,t1.ghb_rela_peop_flg as ghb_rela_peop_flg
,t1.health_status_cd as health_status_cd
,t1.spoken as spoken
,t1.sys_in_cust_flg as sys_in_cust_flg
,t1.cust_lev_cd as cust_lev_cd
,t1.tax_stament_flg as tax_stament_flg
,t1.indv_party_type_cd as indv_party_type_cd
,t1.hxb_post_type_cd as hxb_post_type_cd
,t1.grad_school as grad_school
,t1.crdt_cust_flg as crdt_cust_flg
,t1.main_type_cd as main_type_cd
,t1.tax_num_null_rs_descb as tax_num_null_rs_descb
,t1.indv_bus_cert_type_cd as indv_bus_cert_type_cd
,t1.loan_card_no as loan_card_no
,t1.soci_secu_card_no as soci_secu_card_no
,t1.provi_fund_acct_num as provi_fund_acct_num
,t1.agent_open_flg as agent_open_flg
,t1.referrer_type_cd as referrer_type_cd
,t1.referrer_num as referrer_num
,t1.obtain_emply_situ_cd as obtain_emply_situ_cd
,t1.open_acct_chn_cd as open_acct_chn_cd
,t1.legal_en_last_name as legal_en_last_name
,t1.legal_en_mdl_name as legal_en_mdl_name
,t1.legal_en_name as legal_en_name
,t1.career_cd as career_cd
,t1.other_career_name as other_career_name
,t1.share_ratio as share_ratio
,t1.shard_type_cd as shard_type_cd
,t1.ctrler_type_cd as ctrler_type_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_indv t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_indv.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
