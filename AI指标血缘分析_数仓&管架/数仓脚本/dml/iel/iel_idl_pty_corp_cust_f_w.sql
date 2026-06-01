: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pty_corp_cust_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_corp_cust_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,t1.cust_id as cust_id 
,t1.lp_id as lp_id 
,t1.sorc_sys_cd as sorc_sys_cd 
,t1.corp_cust_type_cd as corp_cust_type_cd 
,t1.orgnz_cd as orgnz_cd 
,t1.corp_name as corp_name 
,t1.org_type_cd as org_type_cd 
,t1.indus_type_cd as indus_type_cd 
,t1.econ_type_cd as econ_type_cd 
,t1.econ_orgnz_form_cd as econ_orgnz_form_cd 
,t1.oper_range as oper_range 
,t1.corp_size_cd as corp_size_cd 
,t1.corp_found_dt as corp_found_dt 
,t1.emply_qtty as emply_qtty 
,t1.high_new_tech_corp_flg as high_new_tech_corp_flg 
,t1.list_corp_flg as list_corp_flg 
,t1.is_mx_mgmt_righ_flg as is_mx_mgmt_righ_flg 
,t1.rela_group_type_cd as rela_group_type_cd 
,t1.group_cust_flg as group_cust_flg 
,t1.escp_debt_corp_flg as escp_debt_corp_flg 
,t1.strtg_cust_flg as strtg_cust_flg 
,t1.off_shore_cust_flg as off_shore_cust_flg 
,t1.cust_sev_ugd_cls_cd as cust_sev_ugd_cls_cd 
,t1.weight_risk_asset_cust_cls_cd as weight_risk_asset_cust_cls_cd 
,t1.crdt_strategy_cd as crdt_strategy_cd 
,t1.nb_corp_flg as nb_corp_flg 
,t1.hxb_rela_tran_flg as hxb_rela_tran_flg 
,t1.mc_dept_mplize_cust_flg as mc_dept_mplize_cust_flg 
,t1.hxb_idtfy_small_bus_flg as hxb_idtfy_small_bus_flg 
,t1.bel_thi_flg as bel_thi_flg 
,t1.prit_etp_flg as prit_etp_flg 
,t1.cbrc_sb_flg as cbrc_sb_flg 
,t1.hold_type_cd as hold_type_cd 
,t1.fin_subsidy_inco_src_cd as fin_subsidy_inco_src_cd 
,t1.rela_party_flg as rela_party_flg 
,t1.rgst_dt as rgst_dt 
,t1.crdt_cust_flg as crdt_cust_flg 
,t1.hxb_shard_flg as hxb_shard_flg 
,t1.subj_org_name as subj_org_name 
,t1.cty_rg_cd as cty_rg_cd 
,t1.ctysd_corp_flg as ctysd_corp_flg 
,t1.ta_cust_size as ta_cust_size 
,t1.ta_cust_indus_status as ta_cust_indus_status 
,t1.ins_adj_type_cd as ins_adj_type_cd 
,t1.itau_flg as itau_flg 
,t1.strtg_new_indus_type_cd as strtg_new_indus_type_cd 
,t1.list_corp_type_cd as list_corp_type_cd 
,t1.is_mx_oper_item_flg as is_mx_oper_item_flg 
,t1.orgnz_type_subdv_cd as orgnz_type_subdv_cd 
,t1.org_status_cd as org_status_cd 
,t1.orgnz_type_cd as orgnz_type_cd 
,t1.soci_crdt_cd as soci_crdt_cd 
,t1.strategy_camp_cust_no as strategy_camp_cust_no 
,t1.single_lmt as single_lmt 
,t1.corp_size_cd_intnal as corp_size_cd_intnal 
,t1.green_crdt_cust_flg as green_crdt_cust_flg 
,t1.single_lp_flg as single_lp_flg 
,t1.cust_ownsp_type_cd as cust_ownsp_type_cd 
,t1.belong_rela_group_id as belong_rela_group_id 
,t1.araf_flg as araf_flg 
,t1.prtcptr_cate_cd as prtcptr_cate_cd 
,t1.rgst_cap as rgst_cap 
,t1.bank_no as bank_no 
,t1.bank_lev_cd as bank_lev_cd 
,t1.ibank_no as ibank_no 
,t1.cpes_corp_size_cd as cpes_corp_size_cd 
,t1.cpes_indus_type_cd as cpes_indus_type_cd 
,t1.edu_hea_flg as edu_hea_flg 
,t1.inc_flg as inc_flg 
,t1.labor_inte_corp_flg as labor_inte_corp_flg 
,t1.corp_grow_stage_cd as corp_grow_stage_cd 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,t1.id_mark as id_mark 
,t1.job_cd
from ${idl_schema}.pty_corp_cust t1 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_cust_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes