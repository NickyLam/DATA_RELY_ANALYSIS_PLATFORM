: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a1usetpsignacctinfo_f
CreateDate: 20250416
FileName:   ${iel_data_path}/mpcs_a1usetpsignacctinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.txn_dt,chr(13),''),chr(10),'') as txn_dt
,replace(replace(t1.txn_tms,chr(13),''),chr(10),'') as txn_tms
,replace(replace(t1.txn_cd,chr(13),''),chr(10),'') as txn_cd
,replace(replace(t1.trx_seq,chr(13),''),chr(10),'') as trx_seq
,replace(replace(t1.app_dt,chr(13),''),chr(10),'') as app_dt
,replace(replace(t1.app_tm,chr(13),''),chr(10),'') as app_tm
,replace(replace(t1.app_id,chr(13),''),chr(10),'') as app_id
,replace(replace(t1.app_ord_nbr,chr(13),''),chr(10),'') as app_ord_nbr
,replace(replace(t1.merch_status,chr(13),''),chr(10),'') as merch_status
,replace(replace(t1.aprv_status,chr(13),''),chr(10),'') as aprv_status
,replace(replace(t1.txn_typ,chr(13),''),chr(10),'') as txn_typ
,replace(replace(t1.merch_id,chr(13),''),chr(10),'') as merch_id
,replace(replace(t1.merch_name,chr(13),''),chr(10),'') as merch_name
,replace(replace(t1.regu_mode,chr(13),''),chr(10),'') as regu_mode
,replace(replace(t1.acct_typ,chr(13),''),chr(10),'') as acct_typ
,replace(replace(t1.regu_acct_num,chr(13),''),chr(10),'') as regu_acct_num
,replace(replace(t1.regu_act_nm,chr(13),''),chr(10),'') as regu_act_nm
,replace(replace(t1.regu_open_bk_name,chr(13),''),chr(10),'') as regu_open_bk_name
,replace(replace(t1.regu_open_bk_num,chr(13),''),chr(10),'') as regu_open_bk_num
,replace(replace(t1.acct_typ_cd,chr(13),''),chr(10),'') as acct_typ_cd
,replace(replace(t1.marg_acct_num,chr(13),''),chr(10),'') as marg_acct_num
,replace(replace(t1.marg_act_nm,chr(13),''),chr(10),'') as marg_act_nm
,replace(replace(t1.marg_open_bk_name,chr(13),''),chr(10),'') as marg_open_bk_name
,replace(replace(t1.marg_open_bk_num,chr(13),''),chr(10),'') as marg_open_bk_num
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.csld_soci_crdt_cd,chr(13),''),chr(10),'') as csld_soci_crdt_cd
,replace(replace(t1.corp_login_addr,chr(13),''),chr(10),'') as corp_login_addr
,replace(replace(t1.clog_addr,chr(13),''),chr(10),'') as clog_addr
,replace(replace(t1.corp_estab_dt,chr(13),''),chr(10),'') as corp_estab_dt
,replace(replace(t1.corp_tel_num,chr(13),''),chr(10),'') as corp_tel_num
,replace(replace(t1.oper_scope,chr(13),''),chr(10),'') as oper_scope
,replace(replace(t1.oper_licence_url,chr(13),''),chr(10),'') as oper_licence_url
,replace(replace(t1.qlfy_proof_url,chr(13),''),chr(10),'') as qlfy_proof_url
,replace(replace(t1.blng_bran_num,chr(13),''),chr(10),'') as blng_bran_num
,replace(replace(t1.blng_bran_name,chr(13),''),chr(10),'') as blng_bran_name
,replace(replace(t1.lp_name,chr(13),''),chr(10),'') as lp_name
,replace(replace(t1.lp_cert_typ,chr(13),''),chr(10),'') as lp_cert_typ
,replace(replace(t1.lp_iden_num,chr(13),''),chr(10),'') as lp_iden_num
,replace(replace(t1.lp_ceph_num,chr(13),''),chr(10),'') as lp_ceph_num
,replace(replace(t1.lp_iden_fro_url,chr(13),''),chr(10),'') as lp_iden_fro_url
,replace(replace(t1.lp_iden_obv_url,chr(13),''),chr(10),'') as lp_iden_obv_url
,replace(replace(t1.oprt_name,chr(13),''),chr(10),'') as oprt_name
,replace(replace(t1.oprt_ceph_num,chr(13),''),chr(10),'') as oprt_ceph_num
,replace(replace(t1.oprt_cert_typ,chr(13),''),chr(10),'') as oprt_cert_typ
,replace(replace(t1.oprt_cert_num,chr(13),''),chr(10),'') as oprt_cert_num
,replace(replace(t1.oprt_cert_url,chr(13),''),chr(10),'') as oprt_cert_url
,replace(replace(t1.oprt_cert_print_piece_url,chr(13),''),chr(10),'') as oprt_cert_print_piece_url
,replace(replace(t1.aprv_comnt,chr(13),''),chr(10),'') as aprv_comnt
,replace(replace(t1.input_tell_num,chr(13),''),chr(10),'') as input_tell_num
,replace(replace(t1.input_org_id,chr(13),''),chr(10),'') as input_org_id
,replace(replace(t1.check_tell_num,chr(13),''),chr(10),'') as check_tell_num
,replace(replace(t1.check_org_id,chr(13),''),chr(10),'') as check_org_id
,replace(replace(t1.apprv_tell_num,chr(13),''),chr(10),'') as apprv_tell_num
,replace(replace(t1.apprv_org_id,chr(13),''),chr(10),'') as apprv_org_id
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.bak1,chr(13),''),chr(10),'') as bak1
,replace(replace(t1.bak2,chr(13),''),chr(10),'') as bak2

from ${iol_schema}.mpcs_a1usetpsignacctinfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1usetpsignacctinfo.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
