: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_guar_cont_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_guar_cont_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.guar_cont_type_cd as guar_cont_type_cd
,t1.guar_way_cd as guar_way_cd
,t1.cont_status_cd as cont_status_cd
,t1.cont_sign_dt as cont_sign_dt
,t1.cont_effect_dt as cont_effect_dt
,t1.cont_exp_dt as cont_exp_dt
,t1.cust_id as cust_id
,t1.guartor_cate_cd as guartor_cate_cd
,t1.guartor_id as guartor_id
,t1.guartor_name as guartor_name
,t1.guar_curr_cd as guar_curr_cd
,t1.guar_tot_amt as guar_tot_amt
,t1.other_espec_apot_descb as other_espec_apot_descb
,t1.guar_opinion_descb as guar_opinion_descb
,t1.check_guar_dt as check_guar_dt
,t1.guartor_cert_type_cd as guartor_cert_type_cd
,t1.guartor_cert_no as guartor_cert_no
,t1.guartor_loan_card_no as guartor_loan_card_no
,t1.guar_guar_form_cd as guar_guar_form_cd
,t1.rgst_org_id as rgst_org_id
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_dt as rgst_dt
,t1.update_org_id as update_org_id
,t1.update_teller_id as update_teller_id
,t1.modif_dt as modif_dt
,t1.lp_id as lp_id
,t1.auth_begin_dt as auth_begin_dt
,t1.rev_guar_measure_flg as rev_guar_measure_flg
,t1.nat_std_indus_dir_cd as nat_std_indus_dir_cd
,t1.corp_size_cd as corp_size_cd
,t1.natnal_econ_dept_type_cd as natnal_econ_dept_type_cd
,t1.rgst_dist_cd as rgst_dist_cd
,t1.dir_hxb_guar_flg as dir_hxb_guar_flg
,t1.obg_name as obg_name
,t1.obg_cust_id as obg_cust_id
,t1.gcust_flg as gcust_flg
,t1.resdnt_flg as resdnt_flg
,t1.rgst_cty_rg_cd as rgst_cty_rg_cd
,t1.guartor_net_asset as guartor_net_asset
,t1.matn_flg as matn_flg
,t1.lmt_cont_id as lmt_cont_id
,t1.ocup_guar_lmt_flg as ocup_guar_lmt_flg
,t1.file_dt as file_dt
,t1.guar_type_cls_cd as guar_type_cls_cd
,t1.guar_exp_dt as guar_exp_dt
,t1.guar_begin_dt as guar_begin_dt
,t1.guar_range_cd as guar_range_cd
,t1.pri_contr_id as pri_contr_id
,t1.brwer_name as brwer_name
,t1.text_cont_id as text_cont_id
,t1.ts_flg as ts_flg
,t1.elec_cont_type as elec_cont_type
,t1.main_guar_way_cd as main_guar_way_cd
,t1.margin_ratio as margin_ratio
,t1.credt_org_name as credt_org_name
,t1.credt_org_id as credt_org_id
,t1.guar_mon_tenor as guar_mon_tenor
,t1.aldy_guar_amt as aldy_guar_amt
,t1.aval_bal as aval_bal
,t1.auto_que_crdtc_rept_flg as auto_que_crdtc_rept_flg
,t1.crdtc_que_auth_id as crdtc_que_auth_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.guar_cont_id as guar_cont_id

from ${idl_schema}.oass_agt_guar_cont_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_guar_cont_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
