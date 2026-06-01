: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_bdms_dpc_draft_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_bdms_dpc_draft_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.bms_draft_id,chr(13),''),chr(10),'') as bms_draft_id
,replace(replace(t1.draft_number,chr(13),''),chr(10),'') as draft_number
,replace(replace(t1.draft_attr,chr(13),''),chr(10),'') as draft_attr
,replace(replace(t1.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t1.remit_date,chr(13),''),chr(10),'') as remit_date
,replace(replace(t1.maturity_date,chr(13),''),chr(10),'') as maturity_date
,t1.draft_amount as draft_amount
,replace(replace(t1.remitter_name,chr(13),''),chr(10),'') as remitter_name
,replace(replace(t1.remitter_account,chr(13),''),chr(10),'') as remitter_account
,replace(replace(t1.remitter_bank_no,chr(13),''),chr(10),'') as remitter_bank_no
,replace(replace(t1.remitter_bank_name,chr(13),''),chr(10),'') as remitter_bank_name
,replace(replace(t1.remitter_crt_no,chr(13),''),chr(10),'') as remitter_crt_no
,replace(replace(t1.acceptor_name,chr(13),''),chr(10),'') as acceptor_name
,replace(replace(t1.acceptor_account,chr(13),''),chr(10),'') as acceptor_account
,replace(replace(t1.acceptor_bank_no,chr(13),''),chr(10),'') as acceptor_bank_no
,replace(replace(t1.acceptor_bank_name,chr(13),''),chr(10),'') as acceptor_bank_name
,replace(replace(t1.acceptor_crt_no,chr(13),''),chr(10),'') as acceptor_crt_no
,replace(replace(t1.payee_name,chr(13),''),chr(10),'') as payee_name
,replace(replace(t1.payee_bank_name,chr(13),''),chr(10),'') as payee_bank_name
,replace(replace(t1.payee_account,chr(13),''),chr(10),'') as payee_account
,replace(replace(t1.payee_bank_no,chr(13),''),chr(10),'') as payee_bank_no
,replace(replace(t1.payee_crt_no,chr(13),''),chr(10),'') as payee_crt_no
,replace(replace(t1.drawee_bank_no,chr(13),''),chr(10),'') as drawee_bank_no
,replace(replace(t1.drawee_brh_no,chr(13),''),chr(10),'') as drawee_brh_no
,replace(replace(t1.drawee_bank_name,chr(13),''),chr(10),'') as drawee_bank_name
,replace(replace(t1.drawee_confirm_brh_no,chr(13),''),chr(10),'') as drawee_confirm_brh_no
,replace(replace(t1.guarantee_bank_name,chr(13),''),chr(10),'') as guarantee_bank_name
,replace(replace(t1.guarantee_brh_no,chr(13),''),chr(10),'') as guarantee_brh_no
,replace(replace(t1.gua_accept_bank_no,chr(13),''),chr(10),'') as gua_accept_bank_no
,replace(replace(t1.gua_accept_brh_no,chr(13),''),chr(10),'') as gua_accept_brh_no
,replace(replace(t1.gua_discnt_brh_no,chr(13),''),chr(10),'') as gua_discnt_brh_no
,replace(replace(t1.collection_bank_no,chr(13),''),chr(10),'') as collection_bank_no
,replace(replace(t1.holder_name,chr(13),''),chr(10),'') as holder_name
,replace(replace(t1.holder_crt_no,chr(13),''),chr(10),'') as holder_crt_no
,replace(replace(t1.holder_acct_no,chr(13),''),chr(10),'') as holder_acct_no
,replace(replace(t1.holder_brh_no,chr(13),''),chr(10),'') as holder_brh_no
,replace(replace(t1.holder_brh_name,chr(13),''),chr(10),'') as holder_brh_name
,t1.endorse_times as endorse_times
,replace(replace(t1.lock_flag,chr(13),''),chr(10),'') as lock_flag
,replace(replace(t1.report_of_loss_flag,chr(13),''),chr(10),'') as report_of_loss_flag
,replace(replace(t1.deduct_status,chr(13),''),chr(10),'') as deduct_status
,replace(replace(t1.risk_status,chr(13),''),chr(10),'') as risk_status
,replace(replace(t1.store_status,chr(13),''),chr(10),'') as store_status
,replace(replace(t1.src_type,chr(13),''),chr(10),'') as src_type
,replace(replace(t1.flow_status,chr(13),''),chr(10),'') as flow_status
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.com_status,chr(13),''),chr(10),'') as com_status
,replace(replace(t1.discount_brh_no,chr(13),''),chr(10),'') as discount_brh_no
,replace(replace(t1.discount_brh_name,chr(13),''),chr(10),'') as discount_brh_name
,replace(replace(t1.store_brh_no,chr(13),''),chr(10),'') as store_brh_no
,replace(replace(t1.init_brh_no,chr(13),''),chr(10),'') as init_brh_no
,replace(replace(t1.belong_branch_no,chr(13),''),chr(10),'') as belong_branch_no
,replace(replace(t1.top_branch_no,chr(13),''),chr(10),'') as top_branch_no
,replace(replace(t1.pay_confirm_flag,chr(13),''),chr(10),'') as pay_confirm_flag
,replace(replace(t1.settle_flag,chr(13),''),chr(10),'') as settle_flag
,replace(replace(t1.recovery_flag,chr(13),''),chr(10),'') as recovery_flag
,replace(replace(t1.last_upd_opr,chr(13),''),chr(10),'') as last_upd_opr
,replace(replace(t1.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t1.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t1.squared_destroy_flag,chr(13),''),chr(10),'') as squared_destroy_flag
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t1.reserve3,chr(13),''),chr(10),'') as reserve3
,replace(replace(t1.reserve4,chr(13),''),chr(10),'') as reserve4
,replace(replace(t1.reserve5,chr(13),''),chr(10),'') as reserve5
,replace(replace(t1.reserve6,chr(13),''),chr(10),'') as reserve6
,replace(replace(t1.disc_date,chr(13),''),chr(10),'') as disc_date
,replace(replace(t1.advance_flag,chr(13),''),chr(10),'') as advance_flag
,'' as data_date
from ${iol_schema}.bdms_dpc_draft_info t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_bdms_dpc_draft_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes