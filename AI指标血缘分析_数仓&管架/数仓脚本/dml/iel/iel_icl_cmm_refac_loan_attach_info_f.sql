: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_refac_loan_attach_info_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_refac_loan_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.level1_batch_pkg_id,chr(13),''),chr(10),'') as level1_batch_pkg_id
,replace(replace(t1.level1_batch_pkg_name,chr(13),''),chr(10),'') as level1_batch_pkg_name
,replace(replace(t1.level2_batch_pkg_id,chr(13),''),chr(10),'') as level2_batch_pkg_id
,replace(replace(t1.level2_batch_pkg_name,chr(13),''),chr(10),'') as level2_batch_pkg_name
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.corp_number,chr(13),''),chr(10),'') as corp_number
,replace(replace(t1.last_year_bus_inco,chr(13),''),chr(10),'') as last_year_bus_inco
,corp_asset_tot
,replace(replace(t1.mang_main_name,chr(13),''),chr(10),'') as mang_main_name
,replace(replace(t1.mang_main_crdt_cd_descb,chr(13),''),chr(10),'') as mang_main_crdt_cd_descb
,replace(replace(t1.check_sheet_flg,chr(13),''),chr(10),'') as check_sheet_flg
,replace(replace(t1.backup_dubil_flg,chr(13),''),chr(10),'') as backup_dubil_flg
,replace(replace(t1.loan_usage_descb,chr(13),''),chr(10),'') as loan_usage_descb
,replace(replace(t1.pbc_doc_num,chr(13),''),chr(10),'') as pbc_doc_num
,replace(replace(t1.pbc_doc_name,chr(13),''),chr(10),'') as pbc_doc_name
,pbc_doc_doc_day
,pbc_lmt
,appl_tm
,replace(replace(t1.applit_id,chr(13),''),chr(10),'') as applit_id
,replace(replace(t1.appl_org_id,chr(13),''),chr(10),'') as appl_org_id
,replace(replace(t1.refac_status_cd,chr(13),''),chr(10),'') as refac_status_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.batch_pkg_status_cd,chr(13),''),chr(10),'') as batch_pkg_status_cd
,refac_amt
,surp_lmt
,replace(replace(t1.refac_cont_id,chr(13),''),chr(10),'') as refac_cont_id
,refac_distr_dt
,refac_exp_dt
,replace(replace(t1.refac_distr_mode_descb,chr(13),''),chr(10),'') as refac_distr_mode_descb
,use_int_rat
,replace(replace(t1.int_accr_way_descb,chr(13),''),chr(10),'') as int_accr_way_descb
,replace(replace(t1.belong_land_pbc_fin_inst_code,chr(13),''),chr(10),'') as belong_land_pbc_fin_inst_code
,replace(replace(t1.belong_land_pbc_name,chr(13),''),chr(10),'') as belong_land_pbc_name
,replace(replace(t1.belong_land_pbc_corp_princ_name,chr(13),''),chr(10),'') as belong_land_pbc_corp_princ_name
,replace(replace(t1.corp_phone_num,chr(13),''),chr(10),'') as corp_phone_num
,replace(replace(t1.corp_addr,chr(13),''),chr(10),'') as corp_addr
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.pbc_cred_rht_type_descb,chr(13),''),chr(10),'') as pbc_cred_rht_type_descb
,replace(replace(t1.pmo_type_cd,chr(13),''),chr(10),'') as pmo_type_cd
,replace(replace(t1.pmo_cont_id,chr(13),''),chr(10),'') as pmo_cont_id
,pmo_amt_evltion
,pmo_amt_evltion_tot
,cred_rht_bal
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.refac_kind_descb,chr(13),''),chr(10),'') as refac_kind_descb
,replace(replace(t1.refac_indus_type_cd,chr(13),''),chr(10),'') as refac_indus_type_cd
,actl_loan_termnt_dt
,actl_loan_distr_dt
,replace(replace(t1.pbc_pay_acct_id,chr(13),''),chr(10),'') as pbc_pay_acct_id

from ${icl_schema}.cmm_refac_loan_attach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_refac_loan_attach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
