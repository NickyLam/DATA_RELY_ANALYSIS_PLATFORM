: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_corp_cust_basic_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_corp_cust_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,cust_id
,cust_name
,cust_en_name
,cust_kind_cd
,open_acct_dt
,belong_org_id
,open_acct_teller_id
,open_acct_chn_cd
,cust_mgr_id
,cust_type_cd
,cust_lev_cd
,depositr_cate_cd
,bal_pay_way_cd
,cust_status_cd
,corp_anl_inco
,corp_year_bus_lmt
,corp_found_dt
,corp_size_cd
,indus_type_cd
,indus_type_cd_crdtc
,phone_crdtc
,corp_type_cd
,cty_rg_cd
,rg_cd
,econ_char_cd
,econ_type_cd
,orgnz_cd
,orgnz_type_cd
,natnal_econ_dept_type_cd
,indus_level5_cls_cd
,indus_crdt_rating_cd
,soci_crdt_cd
,bus_lics_num
,bus_lics_exp_dt
,nation_tax_rgst_cert_num
,local_tax_rgst_cert_num
,fin_lics_num
,econ_orgnz_form_cd
,oper_range
,emply_qtty
,curr_cd
,rgst_cap
,rgst_addr
,rgst_dt
,rgstion_cd
,mang_field_prop_cd
,corp_rgstion_type
,paid_in_capital
,paid_in_capital_curr_cd
,invtor_cty_cd
,mang_field_area
,asset_tot
,net_asset_tot
,single_lp_flg
,high_new_tech_corp_flg
,rela_party_flg
,rela_group_type_cd
,group_cust_flg
,cbrc_sb_flg
,hold_type_cd
,off_shore_cust_flg
,prit_etp_flg
,ctysd_corp_flg
,list_corp_type_cd
,list_corp_flg
,open_cap
,crdt_cust_flg
,stament_flg
,tax_org_cate_cd
,tax_resdnt_cty_cd
,tax_resdnt_idti_cd
,tax_num
,tax_num_null_rs_descb
,bel_thi_flg
,trast_tax_regi_cert_flg
,cty_key_enterp_flg
,group_corp_flg
,group_cust_id
,group_parent_corp_id
,lmt_or_encrge_indus_cd
,have_bod_flg
,green_crdt_cust_flg
,araf_flg
,is_mx_mgmt_righ_flg
,escp_debt_corp_flg
,is_mx_oper_item_flg
,resdnt_flg
,work_addr
,work_addr_zip_cd
,posta_addr
,posta_addr_zip_cd
,open_acct_org_id
,prod_mang_addr
,sel_sup_cust_flg_cd
,crdt_cust_flg_cd
,guar_cust_flg_cd
,anti_mon_lau_belong_org_id
from idl.aml_cmm_corp_cust_basic_info   
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_corp_cust_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes