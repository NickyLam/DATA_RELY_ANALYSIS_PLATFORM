: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_draft_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_draft_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.draft_number,chr(13),''),chr(10),'') as draft_number
,replace(replace(t.voucher_no,chr(13),''),chr(10),'') as voucher_no
,replace(replace(t.draft_class,chr(13),''),chr(10),'') as draft_class
,replace(replace(t.draft_term,chr(13),''),chr(10),'') as draft_term
,replace(replace(t.dfcls_ctl,chr(13),''),chr(10),'') as dfcls_ctl
,replace(replace(t.src_type,chr(13),''),chr(10),'') as src_type
,t.buy_contract_id as buy_contract_id
,replace(replace(t.end_or_sement_mk,chr(13),''),chr(10),'') as end_or_sement_mk
,replace(replace(t.draft_attr,chr(13),''),chr(10),'') as draft_attr
,replace(replace(t.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t.remit_date,chr(13),''),chr(10),'') as remit_date
,replace(replace(t.maturity_date,chr(13),''),chr(10),'') as maturity_date
,t.remitter_id as remitter_id
,replace(replace(t.remitter_role,chr(13),''),chr(10),'') as remitter_role
,replace(replace(t.remitter_cmonid,chr(13),''),chr(10),'') as remitter_cmonid
,replace(replace(t.remitter_name,chr(13),''),chr(10),'') as remitter_name
,replace(replace(t.remitter_account,chr(13),''),chr(10),'') as remitter_account
,t.remitter_bank_id as remitter_bank_id
,replace(replace(t.remitter_bank_name,chr(13),''),chr(10),'') as remitter_bank_name
,replace(replace(t.acceptor_role,chr(13),''),chr(10),'') as acceptor_role
,replace(replace(t.acceptor,chr(13),''),chr(10),'') as acceptor
,t.acceptor_bank_id as acceptor_bank_id
,replace(replace(t.acceptor_actno,chr(13),''),chr(10),'') as acceptor_actno
,replace(replace(t.acceptor_bank_name,chr(13),''),chr(10),'') as acceptor_bank_name
,replace(replace(t.payee_name,chr(13),''),chr(10),'') as payee_name
,replace(replace(t.payee_account,chr(13),''),chr(10),'') as payee_account
,t.payee_bank_id as payee_bank_id
,replace(replace(t.payee_bank_name,chr(13),''),chr(10),'') as payee_bank_name
,t.payee_id as payee_id
,replace(replace(t.payee_organ_code,chr(13),''),chr(10),'') as payee_organ_code
,t.face_amount as face_amount
,replace(replace(t.drawer_bank_flag,chr(13),''),chr(10),'') as drawer_bank_flag
,t.belong_branch_id as belong_branch_id
,replace(replace(t.store_status,chr(13),''),chr(10),'') as store_status
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.tmp_status,chr(13),''),chr(10),'') as tmp_status
,replace(replace(t.collztn_status,chr(13),''),chr(10),'') as collztn_status
,t.collztn_id as collztn_id
,replace(replace(t.loss_status,chr(13),''),chr(10),'') as loss_status
,t.rploss_id as rploss_id
,replace(replace(t.debit_order,chr(13),''),chr(10),'') as debit_order
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.drft_remark,chr(13),''),chr(10),'') as drft_remark
,replace(replace(t.df_drwr_cdtratgs,chr(13),''),chr(10),'') as df_drwr_cdtratgs
,replace(replace(t.df_drwr_cdtratgsagcy,chr(13),''),chr(10),'') as df_drwr_cdtratgsagcy
,replace(replace(t.df_drwr_cdtratgduedt,chr(13),''),chr(10),'') as df_drwr_cdtratgduedt
,replace(replace(t.payee_bank_no,chr(13),''),chr(10),'') as payee_bank_no
,replace(replace(t.oner_brid,chr(13),''),chr(10),'') as oner_brid
,replace(replace(t.rp_status,chr(13),''),chr(10),'') as rp_status
,replace(replace(t.draft_number_rp,chr(13),''),chr(10),'') as draft_number_rp
,t.dk_bank_id as dk_bank_id
,replace(replace(t.accept_flag,chr(13),''),chr(10),'') as accept_flag
,replace(replace(t.discount_flag,chr(13),''),chr(10),'') as discount_flag
,replace(replace(t.acceptor_code,chr(13),''),chr(10),'') as acceptor_code
,replace(replace(t.remitter_code,chr(13),''),chr(10),'') as remitter_code
,replace(replace(t.payee_code,chr(13),''),chr(10),'') as payee_code
,replace(replace(t.settle_flag,chr(13),''),chr(10),'') as settle_flag
,replace(replace(t.is_receipt,chr(13),''),chr(10),'') as is_receipt
,replace(replace(t.stock_status,chr(13),''),chr(10),'') as stock_status
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_draft_info t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_draft_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes