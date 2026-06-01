: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_cust_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_corp_cust_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t1.corp_cust_type_cd,chr(13),''),chr(10),'') as corp_cust_type_cd
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.org_type_cd,chr(13),''),chr(10),'') as org_type_cd
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.econ_type_cd,chr(13),''),chr(10),'') as econ_type_cd
,replace(replace(t1.econ_orgnz_form_cd,chr(13),''),chr(10),'') as econ_orgnz_form_cd
,replace(replace(t1.oper_range,chr(13),''),chr(10),'') as oper_range
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,t1.corp_found_dt as corp_found_dt
,t1.emply_qtty as emply_qtty
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg
,replace(replace(t1.list_corp_flg,chr(13),''),chr(10),'') as list_corp_flg
,replace(replace(t1.is_mx_mgmt_righ_flg,chr(13),''),chr(10),'') as is_mx_mgmt_righ_flg
,replace(replace(t1.rela_group_type_cd,chr(13),''),chr(10),'') as rela_group_type_cd
,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg
,replace(replace(t1.escp_debt_corp_flg,chr(13),''),chr(10),'') as escp_debt_corp_flg
,replace(replace(t1.strtg_cust_flg,chr(13),''),chr(10),'') as strtg_cust_flg
,replace(replace(t1.off_shore_cust_flg,chr(13),''),chr(10),'') as off_shore_cust_flg
,replace(replace(t1.cust_sev_ugd_cls_cd,chr(13),''),chr(10),'') as cust_sev_ugd_cls_cd
,replace(replace(t1.weight_risk_asset_cust_cls_cd,chr(13),''),chr(10),'') as weight_risk_asset_cust_cls_cd
,replace(replace(t1.crdt_strategy_cd,chr(13),''),chr(10),'') as crdt_strategy_cd
,replace(replace(t1.nb_corp_flg,chr(13),''),chr(10),'') as nb_corp_flg
,replace(replace(t1.hxb_rela_tran_flg,chr(13),''),chr(10),'') as hxb_rela_tran_flg
,replace(replace(t1.mc_dept_mplize_cust_flg,chr(13),''),chr(10),'') as mc_dept_mplize_cust_flg
,replace(replace(t1.hxb_idtfy_small_bus_flg,chr(13),''),chr(10),'') as hxb_idtfy_small_bus_flg
,replace(replace(t1.bel_thi_flg,chr(13),''),chr(10),'') as bel_thi_flg
,replace(replace(t1.prit_etp_flg,chr(13),''),chr(10),'') as prit_etp_flg
,replace(replace(t1.cbrc_sb_flg,chr(13),''),chr(10),'') as cbrc_sb_flg
,replace(replace(t1.hold_type_cd,chr(13),''),chr(10),'') as hold_type_cd
,replace(replace(t1.fin_subsidy_inco_src_cd,chr(13),''),chr(10),'') as fin_subsidy_inco_src_cd
,replace(replace(t1.rela_party_flg,chr(13),''),chr(10),'') as rela_party_flg
,t1.rgst_dt as rgst_dt
,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg
,replace(replace(t1.hxb_shard_flg,chr(13),''),chr(10),'') as hxb_shard_flg
,replace(replace(t1.subj_org_name,chr(13),''),chr(10),'') as subj_org_name
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
,replace(replace(t1.ctysd_corp_flg,chr(13),''),chr(10),'') as ctysd_corp_flg
,replace(replace(t1.ta_cust_size,chr(13),''),chr(10),'') as ta_cust_size
,replace(replace(t1.ta_cust_indus_status,chr(13),''),chr(10),'') as ta_cust_indus_status
,replace(replace(t1.ins_adj_type_cd,chr(13),''),chr(10),'') as ins_adj_type_cd
,replace(replace(t1.itau_flg,chr(13),''),chr(10),'') as itau_flg
,replace(replace(t1.strtg_new_indus_type_cd,chr(13),''),chr(10),'') as strtg_new_indus_type_cd
,replace(replace(t1.list_corp_type_cd,chr(13),''),chr(10),'') as list_corp_type_cd
,replace(replace(t1.is_mx_oper_item_flg,chr(13),''),chr(10),'') as is_mx_oper_item_flg
,replace(replace(t1.orgnz_type_subdv_cd,chr(13),''),chr(10),'') as orgnz_type_subdv_cd
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd
,replace(replace(t1.orgnz_type_cd,chr(13),''),chr(10),'') as orgnz_type_cd
,replace(replace(t1.soci_crdt_cd,chr(13),''),chr(10),'') as soci_crdt_cd
,replace(replace(t1.strategy_camp_cust_no,chr(13),''),chr(10),'') as strategy_camp_cust_no
,t1.single_lmt as single_lmt
,replace(replace(t1.corp_size_cd_intnal,chr(13),''),chr(10),'') as corp_size_cd_intnal
,replace(replace(t1.green_crdt_cust_flg,chr(13),''),chr(10),'') as green_crdt_cust_flg
,replace(replace(t1.single_lp_flg,chr(13),''),chr(10),'') as single_lp_flg
,replace(replace(t1.cust_ownsp_type_cd,chr(13),''),chr(10),'') as cust_ownsp_type_cd
,replace(replace(t1.belong_rela_group_id,chr(13),''),chr(10),'') as belong_rela_group_id
,replace(replace(t1.araf_flg,chr(13),''),chr(10),'') as araf_flg
,replace(replace(t1.prtcptr_cate_cd,chr(13),''),chr(10),'') as prtcptr_cate_cd
,t1.rgst_cap as rgst_cap
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.bank_lev_cd,chr(13),''),chr(10),'') as bank_lev_cd
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.cpes_corp_size_cd,chr(13),''),chr(10),'') as cpes_corp_size_cd
,replace(replace(t1.cpes_indus_type_cd,chr(13),''),chr(10),'') as cpes_indus_type_cd
,replace(replace(t1.edu_hea_flg,chr(13),''),chr(10),'') as edu_hea_flg
,replace(replace(t1.inc_flg,chr(13),''),chr(10),'') as inc_flg
,replace(replace(t1.labor_inte_corp_flg,chr(13),''),chr(10),'') as labor_inte_corp_flg
,replace(replace(t1.corp_grow_stage_cd,chr(13),''),chr(10),'') as corp_grow_stage_cd
,t1.shard_stru_cors_dt as shard_stru_cors_dt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.pty_corp_cust t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_cust_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes