: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdps_draft_pool_contract_f
CreateDate: 20240919
FileName:   ${iel_data_path}/bdps_draft_pool_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,replace(replace(t1.protocol_no,chr(13),''),chr(10),'') as protocol_no
,replace(replace(t1.contract_type,chr(13),''),chr(10),'') as contract_type
,replace(replace(t1.draft_attr,chr(13),''),chr(10),'') as draft_attr
,replace(replace(t1.draft_type,chr(13),''),chr(10),'') as draft_type
,branch_id
,operator_id
,app_cust_id
,replace(replace(t1.txn_date,chr(13),''),chr(10),'') as txn_date
,bail_acct_id
,replace(replace(t1.contract_status,chr(13),''),chr(10),'') as contract_status
,replace(replace(t1.audit_status,chr(13),''),chr(10),'') as audit_status
,replace(replace(t1.logic_check_status,chr(13),''),chr(10),'') as logic_check_status
,replace(replace(t1.credit_check_status,chr(13),''),chr(10),'') as credit_check_status
,manager_id
,depart_id
,replace(replace(t1.appno,chr(13),''),chr(10),'') as appno
,replace(replace(t1.misc,chr(13),''),chr(10),'') as misc
,draft_amount_rate
,replace(replace(t1.is_collztn_draft_pool,chr(13),''),chr(10),'') as is_collztn_draft_pool
,replace(replace(t1.draft_src_type,chr(13),''),chr(10),'') as draft_src_type
,last_upd_oper_id
,replace(replace(t1.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t1.ebank_apply,chr(13),''),chr(10),'') as ebank_apply
,replace(replace(t1.gbba_cust_oper_nm,chr(13),''),chr(10),'') as gbba_cust_oper_nm
,replace(replace(t1.gbba_cust_oper_idtyp,chr(13),''),chr(10),'') as gbba_cust_oper_idtyp
,replace(replace(t1.gbba_cust_oper_idnum,chr(13),''),chr(10),'') as gbba_cust_oper_idnum
,replace(replace(t1.gbba_cust_oper_com,chr(13),''),chr(10),'') as gbba_cust_oper_com
,replace(replace(t1.gbba_endorse_com,chr(13),''),chr(10),'') as gbba_endorse_com
,replace(replace(t1.ref_txn_type,chr(13),''),chr(10),'') as ref_txn_type
,replace(replace(t1.ebank_oper_no,chr(13),''),chr(10),'') as ebank_oper_no
,replace(replace(t1.ebank_oper_name,chr(13),''),chr(10),'') as ebank_oper_name
,dis_brhid
,replace(replace(t1.pay_type,chr(13),''),chr(10),'') as pay_type
,intrst_rate
,income_brhid
,replace(replace(t1.income_accno,chr(13),''),chr(10),'') as income_accno
,account_id
,register_status
,replace(replace(t1.bsnssq,chr(13),''),chr(10),'') as bsnssq
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq

from ${iol_schema}.bdps_draft_pool_contract t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdps_draft_pool_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
