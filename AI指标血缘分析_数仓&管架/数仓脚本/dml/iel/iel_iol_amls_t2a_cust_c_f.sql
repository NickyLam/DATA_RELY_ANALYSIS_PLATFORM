: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t2a_cust_c_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t2a_cust_c.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,t.create_dt as create_dt
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_en_name,chr(13),''),chr(10),'') as cust_en_name
    ,replace(replace(t.cust_sts,chr(13),''),chr(10),'') as cust_sts
    ,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
    ,replace(replace(t.aml_cust_type,chr(13),''),chr(10),'') as aml_cust_type
    ,replace(replace(t.pbc_cust_type,chr(13),''),chr(10),'') as pbc_cust_type
    ,replace(replace(t.pbc_indus,chr(13),''),chr(10),'') as pbc_indus
    ,replace(replace(t.s_indus,chr(13),''),chr(10),'') as s_indus
    ,replace(replace(t.cust_nat,chr(13),''),chr(10),'') as cust_nat
    ,replace(replace(t.cust_area,chr(13),''),chr(10),'') as cust_area
    ,replace(replace(t.reg_addr,chr(13),''),chr(10),'') as reg_addr
    ,replace(replace(t.biz_addr,chr(13),''),chr(10),'') as biz_addr
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.s_cert_type,chr(13),''),chr(10),'') as s_cert_type
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,t.cert_valid_dt as cert_valid_dt
    ,t.cert_invalid_dt as cert_invalid_dt
    ,replace(replace(t.cert_addr,chr(13),''),chr(10),'') as cert_addr
    ,t.corp_estb_dt as corp_estb_dt
    ,replace(replace(t.corp_type,chr(13),''),chr(10),'') as corp_type
    ,replace(replace(t.corp_reg_type,chr(13),''),chr(10),'') as corp_reg_type
    ,t.reg_fund_amt as reg_fund_amt
    ,replace(replace(t.reg_fund_curr_cd,chr(13),''),chr(10),'') as reg_fund_curr_cd
    ,replace(replace(t.office_tel,chr(13),''),chr(10),'') as office_tel
    ,replace(replace(t.website,chr(13),''),chr(10),'') as website
    ,replace(replace(t.email,chr(13),''),chr(10),'') as email
    ,replace(replace(t.legal_name,chr(13),''),chr(10),'') as legal_name
    ,replace(replace(t.legal_cert_type,chr(13),''),chr(10),'') as legal_cert_type
    ,replace(replace(t.legal_cert_no,chr(13),''),chr(10),'') as legal_cert_no
    ,t.legal_cert_valid_dt as legal_cert_valid_dt
    ,t.legal_cert_invalid_dt as legal_cert_invalid_dt
    ,replace(replace(t.legal_cust_id,chr(13),''),chr(10),'') as legal_cust_id
    ,replace(replace(t.legal_tel,chr(13),''),chr(10),'') as legal_tel
    ,replace(replace(t.legal_addr,chr(13),''),chr(10),'') as legal_addr
    ,replace(replace(t.is_group_cust,chr(13),''),chr(10),'') as is_group_cust
    ,replace(replace(t.credit_no,chr(13),''),chr(10),'') as credit_no
    ,t.credit_valid_dt as credit_valid_dt
    ,t.credit_invalid_dt as credit_invalid_dt
    ,replace(replace(t.organ_code,chr(13),''),chr(10),'') as organ_code
    ,t.organ_code_valid_dt as organ_code_valid_dt
    ,t.organ_code_invalid_dt as organ_code_invalid_dt
    ,replace(replace(t.biz_lic_no,chr(13),''),chr(10),'') as biz_lic_no
    ,t.biz_lic_no_valid_dt as biz_lic_no_valid_dt
    ,t.biz_lic_no_invalid_dt as biz_lic_no_invalid_dt
    ,replace(replace(t.biz_scope,chr(13),''),chr(10),'') as biz_scope
    ,replace(replace(t.main_biz,chr(13),''),chr(10),'') as main_biz
    ,replace(replace(t.mgr_id,chr(13),''),chr(10),'') as mgr_id
    ,replace(replace(t.mgr_name,chr(13),''),chr(10),'') as mgr_name
    ,replace(replace(t.ctrl_name,chr(13),''),chr(10),'') as ctrl_name
    ,replace(replace(t.ctrl_cert_type,chr(13),''),chr(10),'') as ctrl_cert_type
    ,replace(replace(t.ctrl_cert_no,chr(13),''),chr(10),'') as ctrl_cert_no
    ,t.ctrl_cert_valid_dt as ctrl_cert_valid_dt
    ,t.ctrl_cert_invalid_dt as ctrl_cert_invalid_dt
    ,replace(replace(t.corp_lkm_name,chr(13),''),chr(10),'') as corp_lkm_name
    ,replace(replace(t.corp_lkm_tel,chr(13),''),chr(10),'') as corp_lkm_tel
    ,replace(replace(t.hold_name,chr(13),''),chr(10),'') as hold_name
    ,replace(replace(t.hold_cert_type,chr(13),''),chr(10),'') as hold_cert_type
    ,replace(replace(t.hold_cert_no,chr(13),''),chr(10),'') as hold_cert_no
    ,t.hold_cert_valid_dt as hold_cert_valid_dt
    ,t.hold_cert_invalid_dt as hold_cert_invalid_dt
    ,replace(replace(t.rsrv_01,chr(13),''),chr(10),'') as rsrv_01
    ,replace(replace(t.rsrv_02,chr(13),''),chr(10),'') as rsrv_02
    ,replace(replace(t.rsrv_03,chr(13),''),chr(10),'') as rsrv_03
    ,replace(replace(t.rsrv_04,chr(13),''),chr(10),'') as rsrv_04
    ,replace(replace(t.is_ebank,chr(13),''),chr(10),'') as is_ebank
    ,replace(replace(t.is_loan,chr(13),''),chr(10),'') as is_loan
    ,replace(replace(t.create_channel,chr(13),''),chr(10),'') as create_channel
    ,replace(replace(t.is_free_trade,chr(13),''),chr(10),'') as is_free_trade
    ,replace(replace(t.remarks,chr(13),''),chr(10),'') as remarks
    ,replace(replace(t.tax_id,chr(13),''),chr(10),'') as tax_id
    ,replace(replace(t.opr_name,chr(13),''),chr(10),'') as opr_name
    ,replace(replace(t.opr_cert_type,chr(13),''),chr(10),'') as opr_cert_type
    ,replace(replace(t.opr_cert_no,chr(13),''),chr(10),'') as opr_cert_no
    ,t.opr_cert_invalid_dt as opr_cert_invalid_dt
    ,replace(replace(t.is_pos,chr(13),''),chr(10),'') as is_pos
    ,replace(replace(t.oth_cert_type,chr(13),''),chr(10),'') as oth_cert_type
    ,replace(replace(t.oth_legal_cert_type,chr(13),''),chr(10),'') as oth_legal_cert_type
    ,replace(replace(t.oth_ctrl_cert_type,chr(13),''),chr(10),'') as oth_ctrl_cert_type
    ,replace(replace(t.oth_hold_cert_type,chr(13),''),chr(10),'') as oth_hold_cert_type
    ,replace(replace(t.oth_opr_cert_type,chr(13),''),chr(10),'') as oth_opr_cert_type
    ,replace(replace(t.close_dt,chr(13),''),chr(10),'') as close_dt
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amls_t2a_cust_c t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t2a_cust_c.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes