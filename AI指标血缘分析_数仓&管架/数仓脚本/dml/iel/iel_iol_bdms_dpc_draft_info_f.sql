: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_dpc_draft_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_dpc_draft_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.bms_draft_id,chr(13),''),chr(10),'') as bms_draft_id
,replace(replace(t.draft_number,chr(13),''),chr(10),'') as draft_number
,replace(replace(t.draft_attr,chr(13),''),chr(10),'') as draft_attr
,replace(replace(t.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t.remit_date,chr(13),''),chr(10),'') as remit_date
,replace(replace(t.maturity_date,chr(13),''),chr(10),'') as maturity_date
,t.draft_amount as draft_amount
,replace(replace(t.remitter_name,chr(13),''),chr(10),'') as remitter_name
,replace(replace(t.remitter_account,chr(13),''),chr(10),'') as remitter_account
,replace(replace(t.remitter_bank_no,chr(13),''),chr(10),'') as remitter_bank_no
,replace(replace(t.remitter_bank_name,chr(13),''),chr(10),'') as remitter_bank_name
,replace(replace(t.remitter_crt_no,chr(13),''),chr(10),'') as remitter_crt_no
,replace(replace(t.acceptor_name,chr(13),''),chr(10),'') as acceptor_name
,replace(replace(t.acceptor_account,chr(13),''),chr(10),'') as acceptor_account
,replace(replace(t.acceptor_bank_no,chr(13),''),chr(10),'') as acceptor_bank_no
,replace(replace(t.acceptor_bank_name,chr(13),''),chr(10),'') as acceptor_bank_name
,replace(replace(t.acceptor_crt_no,chr(13),''),chr(10),'') as acceptor_crt_no
,replace(replace(t.payee_name,chr(13),''),chr(10),'') as payee_name
,replace(replace(t.payee_bank_name,chr(13),''),chr(10),'') as payee_bank_name
,replace(replace(t.payee_account,chr(13),''),chr(10),'') as payee_account
,replace(replace(t.payee_bank_no,chr(13),''),chr(10),'') as payee_bank_no
,replace(replace(t.payee_crt_no,chr(13),''),chr(10),'') as payee_crt_no
,replace(replace(t.drawee_bank_no,chr(13),''),chr(10),'') as drawee_bank_no
,replace(replace(t.drawee_brh_no,chr(13),''),chr(10),'') as drawee_brh_no
,replace(replace(t.drawee_bank_name,chr(13),''),chr(10),'') as drawee_bank_name
,replace(replace(t.drawee_confirm_brh_no,chr(13),''),chr(10),'') as drawee_confirm_brh_no
,replace(replace(t.guarantee_bank_name,chr(13),''),chr(10),'') as guarantee_bank_name
,replace(replace(t.guarantee_brh_no,chr(13),''),chr(10),'') as guarantee_brh_no
,replace(replace(t.gua_accept_bank_no,chr(13),''),chr(10),'') as gua_accept_bank_no
,replace(replace(t.gua_accept_brh_no,chr(13),''),chr(10),'') as gua_accept_brh_no
,replace(replace(t.gua_discnt_brh_no,chr(13),''),chr(10),'') as gua_discnt_brh_no
,replace(replace(t.collection_bank_no,chr(13),''),chr(10),'') as collection_bank_no
,replace(replace(t.holder_name,chr(13),''),chr(10),'') as holder_name
,replace(replace(t.holder_crt_no,chr(13),''),chr(10),'') as holder_crt_no
,replace(replace(t.holder_acct_no,chr(13),''),chr(10),'') as holder_acct_no
,replace(replace(t.holder_brh_no,chr(13),''),chr(10),'') as holder_brh_no
,replace(replace(t.holder_brh_name,chr(13),''),chr(10),'') as holder_brh_name
,t.endorse_times as endorse_times
,replace(replace(t.lock_flag,chr(13),''),chr(10),'') as lock_flag
,replace(replace(t.report_of_loss_flag,chr(13),''),chr(10),'') as report_of_loss_flag
,replace(replace(t.deduct_status,chr(13),''),chr(10),'') as deduct_status
,replace(replace(t.risk_status,chr(13),''),chr(10),'') as risk_status
,replace(replace(t.store_status,chr(13),''),chr(10),'') as store_status
,replace(replace(t.src_type,chr(13),''),chr(10),'') as src_type
,replace(replace(t.flow_status,chr(13),''),chr(10),'') as flow_status
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.com_status,chr(13),''),chr(10),'') as com_status
,replace(replace(t.discount_brh_no,chr(13),''),chr(10),'') as discount_brh_no
,replace(replace(t.discount_brh_name,chr(13),''),chr(10),'') as discount_brh_name
,replace(replace(t.store_brh_no,chr(13),''),chr(10),'') as store_brh_no
,replace(replace(t.init_brh_no,chr(13),''),chr(10),'') as init_brh_no
,replace(replace(t.belong_branch_no,chr(13),''),chr(10),'') as belong_branch_no
,replace(replace(t.top_branch_no,chr(13),''),chr(10),'') as top_branch_no
,replace(replace(t.pay_confirm_flag,chr(13),''),chr(10),'') as pay_confirm_flag
,replace(replace(t.settle_flag,chr(13),''),chr(10),'') as settle_flag
,replace(replace(t.recovery_flag,chr(13),''),chr(10),'') as recovery_flag
,replace(replace(t.last_upd_opr,chr(13),''),chr(10),'') as last_upd_opr
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t.squared_destroy_flag,chr(13),''),chr(10),'') as squared_destroy_flag
,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
,replace(replace(t.reserve4,chr(13),''),chr(10),'') as reserve4
,replace(replace(t.reserve5,chr(13),''),chr(10),'') as reserve5
,replace(replace(t.reserve6,chr(13),''),chr(10),'') as reserve6
,replace(replace(t.disc_date,chr(13),''),chr(10),'') as disc_date
,replace(replace(t.advance_flag,chr(13),''),chr(10),'') as advance_flag
,replace(replace(t.holder_bank_no,chr(13),''),chr(10),'') as holder_bank_no
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_dpc_draft_info t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_dpc_draft_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes