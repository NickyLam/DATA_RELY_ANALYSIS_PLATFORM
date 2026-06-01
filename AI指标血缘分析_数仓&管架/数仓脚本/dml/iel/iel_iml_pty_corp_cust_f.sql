: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_cust_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_corp_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(cust_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(sorc_sys_cd,chr(13),''),chr(10),'')
,replace(replace(corp_cust_type_cd,chr(13),''),chr(10),'')
,replace(replace(orgnz_cd,chr(13),''),chr(10),'')
,replace(replace(corp_name,chr(13),''),chr(10),'')
,replace(replace(org_type_cd,chr(13),''),chr(10),'')
,replace(replace(indus_type_cd,chr(13),''),chr(10),'')
,replace(replace(econ_type_cd,chr(13),''),chr(10),'')
,replace(replace(econ_orgnz_form_cd,chr(13),''),chr(10),'')
,replace(replace(oper_range,chr(13),''),chr(10),'')
,replace(replace(corp_size_cd,chr(13),''),chr(10),'')
,corp_found_dt
,emply_qtty
,replace(replace(high_new_tech_corp_flg,chr(13),''),chr(10),'')
,replace(replace(list_corp_flg,chr(13),''),chr(10),'')
,replace(replace(is_mx_mgmt_righ_flg,chr(13),''),chr(10),'')
,replace(replace(rela_group_type_cd,chr(13),''),chr(10),'')
,replace(replace(group_cust_flg,chr(13),''),chr(10),'')
,replace(replace(escp_debt_corp_flg,chr(13),''),chr(10),'')
,replace(replace(strtg_cust_flg,chr(13),''),chr(10),'')
,replace(replace(off_shore_cust_flg,chr(13),''),chr(10),'')
,replace(replace(cust_sev_ugd_cls_cd,chr(13),''),chr(10),'')
,replace(replace(weight_risk_asset_cust_cls_cd,chr(13),''),chr(10),'')
,replace(replace(crdt_strategy_cd,chr(13),''),chr(10),'')
,replace(replace(nb_corp_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_rela_tran_flg,chr(13),''),chr(10),'')
,replace(replace(mc_dept_mplize_cust_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_idtfy_small_bus_flg,chr(13),''),chr(10),'')
,replace(replace(bel_thi_flg,chr(13),''),chr(10),'')
,replace(replace(prit_etp_flg,chr(13),''),chr(10),'')
,replace(replace(cbrc_sb_flg,chr(13),''),chr(10),'')
,replace(replace(hold_type_cd,chr(13),''),chr(10),'')
,replace(replace(fin_subsidy_inco_src_cd,chr(13),''),chr(10),'')
,replace(replace(rela_party_flg,chr(13),''),chr(10),'')
,rgst_dt
,replace(replace(crdt_cust_flg,chr(13),''),chr(10),'')
,replace(replace(hxb_shard_flg,chr(13),''),chr(10),'')
,replace(replace(subj_org_name,chr(13),''),chr(10),'')
,replace(replace(cty_rg_cd,chr(13),''),chr(10),'')
,replace(replace(ctysd_corp_flg,chr(13),''),chr(10),'')
,replace(replace(ta_cust_size,chr(13),''),chr(10),'')
,replace(replace(ta_cust_indus_status,chr(13),''),chr(10),'')
,replace(replace(ins_adj_type_cd,chr(13),''),chr(10),'')
,replace(replace(itau_flg,chr(13),''),chr(10),'')
,replace(replace(strtg_new_indus_type_cd,chr(13),''),chr(10),'')
,replace(replace(list_corp_type_cd,chr(13),''),chr(10),'')
,replace(replace(is_mx_oper_item_flg,chr(13),''),chr(10),'')
,replace(replace(orgnz_type_subdv_cd,chr(13),''),chr(10),'')
,replace(replace(org_status_cd,chr(13),''),chr(10),'')
,replace(replace(orgnz_type_cd,chr(13),''),chr(10),'')
,replace(replace(soci_crdt_cd,chr(13),''),chr(10),'')
,replace(replace(strategy_camp_cust_no,chr(13),''),chr(10),'')
,single_lmt
,replace(replace(corp_size_cd_intnal,chr(13),''),chr(10),'')
,replace(replace(green_crdt_cust_flg,chr(13),''),chr(10),'')
,replace(replace(single_lp_flg,chr(13),''),chr(10),'')
,replace(replace(cust_ownsp_type_cd,chr(13),''),chr(10),'')
,replace(replace(belong_rela_group_id,chr(13),''),chr(10),'')
,replace(replace(araf_flg,chr(13),''),chr(10),'')
,replace(replace(prtcptr_cate_cd,chr(13),''),chr(10),'')
,rgst_cap
,replace(replace(bank_no,chr(13),''),chr(10),'')
,replace(replace(bank_lev_cd,chr(13),''),chr(10),'')
,replace(replace(ibank_no,chr(13),''),chr(10),'')
,replace(replace(cpes_corp_size_cd,chr(13),''),chr(10),'')
,replace(replace(cpes_indus_type_cd,chr(13),''),chr(10),'')
,replace(replace(edu_hea_flg,chr(13),''),chr(10),'')
,replace(replace(inc_flg,chr(13),''),chr(10),'')
,replace(replace(labor_inte_corp_flg,chr(13),''),chr(10),'')
,replace(replace(corp_grow_stage_cd,chr(13),''),chr(10),'')
,shard_stru_cors_dt
,create_dt
,update_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.pty_corp_cust t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
