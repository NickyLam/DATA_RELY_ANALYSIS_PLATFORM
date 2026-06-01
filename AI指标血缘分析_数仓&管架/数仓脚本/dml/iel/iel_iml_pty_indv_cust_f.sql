: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_indv_cust_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_indv_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(cust_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(sorc_sys_cd,chr(13),''),chr(10),'')
,replace(replace(gender_cd,chr(13),''),chr(10),'')
,birth_dt
,replace(replace(nationty_cd,chr(13),''),chr(10),'')
,replace(replace(nati_place,chr(13),''),chr(10),'')
,replace(replace(politic_status_cd,chr(13),''),chr(10),'')
,replace(replace(marriage_situ_cd,chr(13),''),chr(10),'')
,replace(replace(emply_flg,chr(13),''),chr(10),'')
,age
,replace(replace(resdnt_flg,chr(13),''),chr(10),'')
,replace(replace(nation_cd,chr(13),''),chr(10),'')
,replace(replace(dist_cd,chr(13),''),chr(10),'')
,replace(replace(hxb_shard_flg,chr(13),''),chr(10),'')
,replace(replace(owner_type_cd,chr(13),''),chr(10),'')
,replace(replace(ctysd_rpr_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_rela_party_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_trast_inter_bus_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_payoff_sal_acct_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_reg_cust_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_finc_cust_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_vip_cust_idf,chr(13),''),chr(10),'')
,replace(replace(spouse_child_img_flg,chr(13),''),chr(10),'')
,replace(replace(enjoy_cty_prefr_policy_flg,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')
,replace(replace(e_mail,chr(13),''),chr(10),'')
,replace(replace(open_acct_teller_id,chr(13),''),chr(10),'')
,replace(replace(open_acct_org_id,chr(13),''),chr(10),'')
,open_acct_dt
,replace(replace(grad_sch,chr(13),''),chr(10),'')
,grad_year

from ${iml_schema}.pty_indv_cust t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_indv_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
