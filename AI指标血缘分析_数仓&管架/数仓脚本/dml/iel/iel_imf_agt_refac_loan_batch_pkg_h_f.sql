: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_refac_loan_batch_pkg_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_refac_loan_batch_pkg_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_pkg_id,chr(13),''),chr(10),'') as batch_pkg_id
,replace(replace(t1.batch_pkg_name,chr(13),''),chr(10),'') as batch_pkg_name
,replace(replace(t1.use_request_descb,chr(13),''),chr(10),'') as use_request_descb
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,t1.refac_amt as refac_amt
,t1.surp_lmt as surp_lmt
,replace(replace(t1.refac_cont_id,chr(13),''),chr(10),'') as refac_cont_id
,t1.refac_distr_dt as refac_distr_dt
,t1.refac_exp_dt as refac_exp_dt
,replace(replace(t1.refac_distr_mode_cd,chr(13),''),chr(10),'') as refac_distr_mode_cd
,t1.use_int_rat as use_int_rat
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.batch_pkg_idf_cd,chr(13),''),chr(10),'') as batch_pkg_idf_cd
,replace(replace(t1.rela_batch_pkg_name,chr(13),''),chr(10),'') as rela_batch_pkg_name
,replace(replace(t1.rela_batch_pkg_id,chr(13),''),chr(10),'') as rela_batch_pkg_id
,replace(replace(t1.int_accr_way_descb,chr(13),''),chr(10),'') as int_accr_way_descb
,t1.pmo_amt_evltion_tot as pmo_amt_evltion_tot
,t1.cred_rht_bal as cred_rht_bal
,replace(replace(t1.refac_kind_descb,chr(13),''),chr(10),'') as refac_kind_descb
,replace(replace(t1.cap_enter_acct_id,chr(13),''),chr(10),'') as cap_enter_acct_id
,replace(replace(t1.cap_out_acct_id,chr(13),''),chr(10),'') as cap_out_acct_id
,replace(replace(t1.pbc_doc_name,chr(13),''),chr(10),'') as pbc_doc_name
,t1.pbc_lmt as pbc_lmt
,replace(replace(t1.pbc_doc_id,chr(13),''),chr(10),'') as pbc_doc_id
,t1.pbc_doc_doc_dt as pbc_doc_doc_dt
,replace(replace(t1.bl_pbc_corp_princ_name,chr(13),''),chr(10),'') as bl_pbc_corp_princ_name
,replace(replace(t1.bl_pbc_name,chr(13),''),chr(10),'') as bl_pbc_name
,replace(replace(t1.bl_pbc_fin_inst_code,chr(13),''),chr(10),'') as bl_pbc_fin_inst_code
,replace(replace(t1.bl_pbc_bond_type_descb,chr(13),''),chr(10),'') as bl_pbc_bond_type_descb
,replace(replace(t1.corp_phone_num,chr(13),''),chr(10),'') as corp_phone_num
,replace(replace(t1.corp_addr,chr(13),''),chr(10),'') as corp_addr
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,t1.rgst_dt as rgst_dt
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
from ${iml_schema}.agt_refac_loan_batch_pkg_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_refac_loan_batch_pkg_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes