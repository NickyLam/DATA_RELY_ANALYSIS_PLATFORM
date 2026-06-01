: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_indv_cust_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_indv_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.sorc_sys_cd as sorc_sys_cd
,t1.gender_cd as gender_cd
,t1.birth_dt as birth_dt
,t1.nationty_cd as nationty_cd
,t1.nati_place as nati_place
,t1.politic_status_cd as politic_status_cd
,t1.marriage_situ_cd as marriage_situ_cd
,t1.emply_flg as emply_flg
,t1.age as age
,t1.resdnt_flg as resdnt_flg
,t1.nation_cd as nation_cd
,t1.dist_cd as dist_cd
,t1.hxb_shard_flg as hxb_shard_flg
,t1.owner_type_cd as owner_type_cd
,t1.ctysd_rpr_flg as ctysd_rpr_flg
,t1.hxb_rela_party_flg as hxb_rela_party_flg
,t1.hxb_trast_inter_bus_flg as hxb_trast_inter_bus_flg
,t1.hxb_payoff_sal_acct_flg as hxb_payoff_sal_acct_flg
,t1.hxb_reg_cust_flg as hxb_reg_cust_flg
,t1.hxb_finc_cust_flg as hxb_finc_cust_flg
,t1.hxb_vip_cust_idf as hxb_vip_cust_idf
,t1.spouse_child_img_flg as spouse_child_img_flg
,t1.enjoy_cty_prefr_policy_flg as enjoy_cty_prefr_policy_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.open_acct_teller_id as open_acct_teller_id
,t1.open_acct_org_id as open_acct_org_id
,t1.open_acct_dt as open_acct_dt
,t1.grad_sch as grad_sch
,t1.grad_year as grad_year
,t1.e_mail as e_mail
,t1.cust_id as cust_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_indv_cust t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_indv_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
