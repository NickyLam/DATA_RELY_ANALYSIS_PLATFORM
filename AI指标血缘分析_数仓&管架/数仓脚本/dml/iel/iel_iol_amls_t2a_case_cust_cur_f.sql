: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t2a_case_cust_cur_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t2a_case_cust_cur.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.ctrl_cert_invalid_dt as ctrl_cert_invalid_dt
    ,replace(replace(t.rsrv_04,chr(13),''),chr(10),'') as rsrv_04
    ,replace(replace(t.oth_hold_cert_type,chr(13),''),chr(10),'') as oth_hold_cert_type
    ,t.reg_fund_amt as reg_fund_amt
    ,replace(replace(t.legal_name,chr(13),''),chr(10),'') as legal_name
    ,replace(replace(t.addr,chr(13),''),chr(10),'') as addr
    ,replace(replace(t.reg_fund_curr_cd,chr(13),''),chr(10),'') as reg_fund_curr_cd
    ,replace(replace(t.othr_ctct2,chr(13),''),chr(10),'') as othr_ctct2
    ,replace(replace(t.bs_valid,chr(13),''),chr(10),'') as bs_valid
    ,replace(replace(t.ctrl_cert_no,chr(13),''),chr(10),'') as ctrl_cert_no
    ,replace(replace(t.hold_cert_type,chr(13),''),chr(10),'') as hold_cert_type
    ,replace(replace(t.bh_valid,chr(13),''),chr(10),'') as bh_valid
    ,t.due_dt as due_dt
    ,replace(replace(t.tel2,chr(13),''),chr(10),'') as tel2
    ,replace(replace(t.othr_ctct,chr(13),''),chr(10),'') as othr_ctct
    ,replace(replace(t.hold_name,chr(13),''),chr(10),'') as hold_name
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.ctrl_name,chr(13),''),chr(10),'') as ctrl_name
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.legal_cert_type,chr(13),''),chr(10),'') as legal_cert_type
    ,replace(replace(t.rsrv_01,chr(13),''),chr(10),'') as rsrv_01
    ,replace(replace(t.rsrv_02,chr(13),''),chr(10),'') as rsrv_02
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.pbc_cust_type,chr(13),''),chr(10),'') as pbc_cust_type
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,replace(replace(t.ctrl_cert_type,chr(13),''),chr(10),'') as ctrl_cert_type
    ,t.ctrl_cert_valid_dt as ctrl_cert_valid_dt
    ,replace(replace(t.hold_cert_no,chr(13),''),chr(10),'') as hold_cert_no
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.pbc_ocp,chr(13),''),chr(10),'') as pbc_ocp
    ,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
    ,replace(replace(t.bs_indus,chr(13),''),chr(10),'') as bs_indus
    ,replace(replace(t.addr2,chr(13),''),chr(10),'') as addr2
    ,replace(replace(t.pbc_indus,chr(13),''),chr(10),'') as pbc_indus
    ,replace(replace(t.oth_cert_type,chr(13),''),chr(10),'') as oth_cert_type
    ,replace(replace(t.oth_ctrl_cert_type,chr(13),''),chr(10),'') as oth_ctrl_cert_type
    ,replace(replace(t.tel,chr(13),''),chr(10),'') as tel
    ,replace(replace(t.oth_legal_cert_type,chr(13),''),chr(10),'') as oth_legal_cert_type
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.create_tm,chr(13),''),chr(10),'') as create_tm
    ,replace(replace(t.modify_tm,chr(13),''),chr(10),'') as modify_tm
    ,replace(replace(t.oth_opr_cert_type,chr(13),''),chr(10),'') as oth_opr_cert_type
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,replace(replace(t.cust_nat,chr(13),''),chr(10),'') as cust_nat
    ,replace(replace(t.legal_cert_no,chr(13),''),chr(10),'') as legal_cert_no
    ,replace(replace(t.rsrv_03,chr(13),''),chr(10),'') as rsrv_03
 from iol.amls_t2a_case_cust_cur t
where etl_dt = to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t2a_case_cust_cur.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes