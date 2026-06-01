: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icps_afa_jzck_freandstopdetail_f
CreateDate: 20250523
FileName:   ${iel_data_path}/icps_afa_jzck_freandstopdetail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.productcode,chr(13),''),chr(10),'') as productcode
,replace(replace(t1.workdate,chr(13),''),chr(10),'') as workdate
,replace(replace(t1.agentserialno,chr(13),''),chr(10),'') as agentserialno
,replace(replace(t1.worktime,chr(13),''),chr(10),'') as worktime
,replace(replace(t1.transserialnumber,chr(13),''),chr(10),'') as transserialnumber
,replace(replace(t1.applicationid,chr(13),''),chr(10),'') as applicationid
,replace(replace(t1.opttype,chr(13),''),chr(10),'') as opttype
,replace(replace(t1.cardnumber,chr(13),''),chr(10),'') as cardnumber
,replace(replace(t1.accountnumber,chr(13),''),chr(10),'') as accountnumber
,replace(replace(t1.accountserial,chr(13),''),chr(10),'') as accountserial
,replace(replace(t1.starttime,chr(13),''),chr(10),'') as starttime
,replace(replace(t1.endtime,chr(13),''),chr(10),'') as endtime
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.cashremit,chr(13),''),chr(10),'') as cashremit
,replace(replace(t1.formerapplicationdepartment,chr(13),''),chr(10),'') as formerapplicationdepartment
,replace(replace(t1.formerfrozenbalance,chr(13),''),chr(10),'') as formerfrozenbalance
,replace(replace(t1.formerfrozenexpiretime,chr(13),''),chr(10),'') as formerfrozenexpiretime
,replace(replace(t1.frozedbalance,chr(13),''),chr(10),'') as frozedbalance
,replace(replace(t1.accountbalance,chr(13),''),chr(10),'') as accountbalance
,replace(replace(t1.accountavaiablebalance,chr(13),''),chr(10),'') as accountavaiablebalance
,replace(replace(t1.hostfreezeserial,chr(13),''),chr(10),'') as hostfreezeserial
,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate
,replace(replace(t1.unfrozedbalance,chr(13),''),chr(10),'') as unfrozedbalance
,replace(replace(t1.freezetype,chr(13),''),chr(10),'') as freezetype
,replace(replace(t1.tradestatus,chr(13),''),chr(10),'') as tradestatus
,replace(replace(t1.dealmsg,chr(13),''),chr(10),'') as dealmsg
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.restraint_seq_no,chr(13),''),chr(10),'') as restraint_seq_no
,replace(replace(t1.globalseqno,chr(13),''),chr(10),'') as globalseqno
,replace(replace(t1.upddate,chr(13),''),chr(10),'') as upddate
,replace(replace(t1.updtime,chr(13),''),chr(10),'') as updtime
,replace(replace(t1.brno,chr(13),''),chr(10),'') as brno
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno
,replace(replace(t1.frozedtype,chr(13),''),chr(10),'') as frozedtype
,replace(replace(t1.unfrozedtype,chr(13),''),chr(10),'') as unfrozedtype
,replace(replace(t1.iswait,chr(13),''),chr(10),'') as iswait
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.isfrozed,chr(13),''),chr(10),'') as isfrozed
,replace(replace(t1.frozedamount,chr(13),''),chr(10),'') as frozedamount
,replace(replace(t1.acctstatus,chr(13),''),chr(10),'') as acctstatus
,replace(replace(t1.frozeno,chr(13),''),chr(10),'') as frozeno
,replace(replace(t1.hosttype,chr(13),''),chr(10),'') as hosttype
,replace(replace(t1.pre_freeze_amount,chr(13),''),chr(10),'') as pre_freeze_amount
,replace(replace(t1.init_froz_flow,chr(13),''),chr(10),'') as init_froz_flow
,replace(replace(t1.init_froz_dt,chr(13),''),chr(10),'') as init_froz_dt
,replace(replace(t1.init_freeze_due_date,chr(13),''),chr(10),'') as init_freeze_due_date
,replace(replace(t1.init_freeze_amount,chr(13),''),chr(10),'') as init_freeze_amount
,replace(replace(t1.deduct_doc_type,chr(13),''),chr(10),'') as deduct_doc_type
,replace(replace(t1.deduct_doc_code,chr(13),''),chr(10),'') as deduct_doc_code
,replace(replace(t1.inner_account_no,chr(13),''),chr(10),'') as inner_account_no
,replace(replace(t1.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t1.authorizer,chr(13),''),chr(10),'') as authorizer
,replace(replace(t1.exec_org_cd,chr(13),''),chr(10),'') as exec_org_cd
,replace(replace(t1.executor,chr(13),''),chr(10),'') as executor
,replace(replace(t1.certificate_type_one,chr(13),''),chr(10),'') as certificate_type_one
,replace(replace(t1.certificate_no_one,chr(13),''),chr(10),'') as certificate_no_one
,replace(replace(t1.certificate_type_two,chr(13),''),chr(10),'') as certificate_type_two
,replace(replace(t1.certificate_no_two,chr(13),''),chr(10),'') as certificate_no_two
,replace(replace(t1.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t1.law_enforce_type,chr(13),''),chr(10),'') as law_enforce_type
,replace(replace(t1.law_enforce_name,chr(13),''),chr(10),'') as law_enforce_name
,replace(replace(t1.prove_type_id,chr(13),''),chr(10),'') as prove_type_id
,replace(replace(t1.prove_no,chr(13),''),chr(10),'') as prove_no
,replace(replace(t1.remit_way,chr(13),''),chr(10),'') as remit_way
,replace(replace(t1.formerfrozendate,chr(13),''),chr(10),'') as formerfrozendate
,replace(replace(t1.formerfrozenserno,chr(13),''),chr(10),'') as formerfrozenserno
,replace(replace(t1.dealstatus,chr(13),''),chr(10),'') as dealstatus
,replace(replace(t1.busiserno,chr(13),''),chr(10),'') as busiserno
,replace(replace(t1.acct_lvl,chr(13),''),chr(10),'') as acct_lvl
,replace(replace(t1.busidate,chr(13),''),chr(10),'') as busidate
,replace(replace(t1.restraint_date,chr(13),''),chr(10),'') as restraint_date
,replace(replace(t1.dealdate,chr(13),''),chr(10),'') as dealdate
,replace(replace(t1.dealtime,chr(13),''),chr(10),'') as dealtime

from ${iol_schema}.icps_afa_jzck_freandstopdetail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icps_afa_jzck_freandstopdetail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
