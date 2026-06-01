/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_dibet_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.bdps_dibet_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_dibet_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_dibet_info_op purge;
drop table ${iol_schema}.bdps_dibet_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_dibet_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_dibet_info where 0=1;

create table ${iol_schema}.bdps_dibet_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_dibet_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_dibet_info_cl(
            id -- 
            ,contract_no -- 
            ,loan_seq -- 
            ,txn_type -- 
            ,maturity_date -- 
            ,remitter_date -- 
            ,loan_status -- 
            ,remitter_amt -- 
            ,bail_amt -- 开票保证金金额
            ,exposure_amt -- 
            ,dibet_pro_account -- 
            ,remark -- 
            ,is_draft -- 
            ,draft_id -- 
            ,app_no -- 
            ,source_flag -- 
            ,audit_status -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,ref_no -- 
            ,outloan_brh_no -- 
            ,brh_no -- 
            ,lncurcd -- 
            ,curcdrate -- 
            ,exhibition_date -- 
            ,appseq -- 
            ,lntype -- 
            ,loan_appno -- 
            ,lncustno -- 
            ,rate -- 利率
            ,is_clear -- 0-未结清 1-已结清
            ,guarno -- 押品编号
            ,draft_number -- 票据号码
            ,draft_maturity_date -- 票据到期日
            ,face_amount -- 票面金额
            ,draft_key -- 票据唯一标识
            ,paragraph_amt -- 已追备款金额
            ,par_status -- 备款状态 0-备款失败 1-止付失败  2-已成功  null-未备款
            ,err_remarks -- 异常信息备注
            ,para_date -- 备款日期
            ,should_para_amt -- 应追加备款金额
            ,batch_no -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_dibet_info_op(
            id -- 
            ,contract_no -- 
            ,loan_seq -- 
            ,txn_type -- 
            ,maturity_date -- 
            ,remitter_date -- 
            ,loan_status -- 
            ,remitter_amt -- 
            ,bail_amt -- 开票保证金金额
            ,exposure_amt -- 
            ,dibet_pro_account -- 
            ,remark -- 
            ,is_draft -- 
            ,draft_id -- 
            ,app_no -- 
            ,source_flag -- 
            ,audit_status -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,ref_no -- 
            ,outloan_brh_no -- 
            ,brh_no -- 
            ,lncurcd -- 
            ,curcdrate -- 
            ,exhibition_date -- 
            ,appseq -- 
            ,lntype -- 
            ,loan_appno -- 
            ,lncustno -- 
            ,rate -- 利率
            ,is_clear -- 0-未结清 1-已结清
            ,guarno -- 押品编号
            ,draft_number -- 票据号码
            ,draft_maturity_date -- 票据到期日
            ,face_amount -- 票面金额
            ,draft_key -- 票据唯一标识
            ,paragraph_amt -- 已追备款金额
            ,par_status -- 备款状态 0-备款失败 1-止付失败  2-已成功  null-未备款
            ,err_remarks -- 异常信息备注
            ,para_date -- 备款日期
            ,should_para_amt -- 应追加备款金额
            ,batch_no -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 
    ,nvl(n.loan_seq, o.loan_seq) as loan_seq -- 
    ,nvl(n.txn_type, o.txn_type) as txn_type -- 
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 
    ,nvl(n.remitter_date, o.remitter_date) as remitter_date -- 
    ,nvl(n.loan_status, o.loan_status) as loan_status -- 
    ,nvl(n.remitter_amt, o.remitter_amt) as remitter_amt -- 
    ,nvl(n.bail_amt, o.bail_amt) as bail_amt -- 开票保证金金额
    ,nvl(n.exposure_amt, o.exposure_amt) as exposure_amt -- 
    ,nvl(n.dibet_pro_account, o.dibet_pro_account) as dibet_pro_account -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.is_draft, o.is_draft) as is_draft -- 
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 
    ,nvl(n.app_no, o.app_no) as app_no -- 
    ,nvl(n.source_flag, o.source_flag) as source_flag -- 
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.ref_no, o.ref_no) as ref_no -- 
    ,nvl(n.outloan_brh_no, o.outloan_brh_no) as outloan_brh_no -- 
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 
    ,nvl(n.lncurcd, o.lncurcd) as lncurcd -- 
    ,nvl(n.curcdrate, o.curcdrate) as curcdrate -- 
    ,nvl(n.exhibition_date, o.exhibition_date) as exhibition_date -- 
    ,nvl(n.appseq, o.appseq) as appseq -- 
    ,nvl(n.lntype, o.lntype) as lntype -- 
    ,nvl(n.loan_appno, o.loan_appno) as loan_appno -- 
    ,nvl(n.lncustno, o.lncustno) as lncustno -- 
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.is_clear, o.is_clear) as is_clear -- 0-未结清 1-已结清
    ,nvl(n.guarno, o.guarno) as guarno -- 押品编号
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.draft_maturity_date, o.draft_maturity_date) as draft_maturity_date -- 票据到期日
    ,nvl(n.face_amount, o.face_amount) as face_amount -- 票面金额
    ,nvl(n.draft_key, o.draft_key) as draft_key -- 票据唯一标识
    ,nvl(n.paragraph_amt, o.paragraph_amt) as paragraph_amt -- 已追备款金额
    ,nvl(n.par_status, o.par_status) as par_status -- 备款状态 0-备款失败 1-止付失败  2-已成功  null-未备款
    ,nvl(n.err_remarks, o.err_remarks) as err_remarks -- 异常信息备注
    ,nvl(n.para_date, o.para_date) as para_date -- 备款日期
    ,nvl(n.should_para_amt, o.should_para_amt) as should_para_amt -- 应追加备款金额
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_dibet_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_dibet_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_no <> n.contract_no
        or o.loan_seq <> n.loan_seq
        or o.txn_type <> n.txn_type
        or o.maturity_date <> n.maturity_date
        or o.remitter_date <> n.remitter_date
        or o.loan_status <> n.loan_status
        or o.remitter_amt <> n.remitter_amt
        or o.bail_amt <> n.bail_amt
        or o.exposure_amt <> n.exposure_amt
        or o.dibet_pro_account <> n.dibet_pro_account
        or o.remark <> n.remark
        or o.is_draft <> n.is_draft
        or o.draft_id <> n.draft_id
        or o.app_no <> n.app_no
        or o.source_flag <> n.source_flag
        or o.audit_status <> n.audit_status
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.ref_no <> n.ref_no
        or o.outloan_brh_no <> n.outloan_brh_no
        or o.brh_no <> n.brh_no
        or o.lncurcd <> n.lncurcd
        or o.curcdrate <> n.curcdrate
        or o.exhibition_date <> n.exhibition_date
        or o.appseq <> n.appseq
        or o.lntype <> n.lntype
        or o.loan_appno <> n.loan_appno
        or o.lncustno <> n.lncustno
        or o.rate <> n.rate
        or o.is_clear <> n.is_clear
        or o.guarno <> n.guarno
        or o.draft_number <> n.draft_number
        or o.draft_maturity_date <> n.draft_maturity_date
        or o.face_amount <> n.face_amount
        or o.draft_key <> n.draft_key
        or o.paragraph_amt <> n.paragraph_amt
        or o.par_status <> n.par_status
        or o.err_remarks <> n.err_remarks
        or o.para_date <> n.para_date
        or o.should_para_amt <> n.should_para_amt
        or o.batch_no <> n.batch_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_dibet_info_cl(
            id -- 
            ,contract_no -- 
            ,loan_seq -- 
            ,txn_type -- 
            ,maturity_date -- 
            ,remitter_date -- 
            ,loan_status -- 
            ,remitter_amt -- 
            ,bail_amt -- 开票保证金金额
            ,exposure_amt -- 
            ,dibet_pro_account -- 
            ,remark -- 
            ,is_draft -- 
            ,draft_id -- 
            ,app_no -- 
            ,source_flag -- 
            ,audit_status -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,ref_no -- 
            ,outloan_brh_no -- 
            ,brh_no -- 
            ,lncurcd -- 
            ,curcdrate -- 
            ,exhibition_date -- 
            ,appseq -- 
            ,lntype -- 
            ,loan_appno -- 
            ,lncustno -- 
            ,rate -- 利率
            ,is_clear -- 0-未结清 1-已结清
            ,guarno -- 押品编号
            ,draft_number -- 票据号码
            ,draft_maturity_date -- 票据到期日
            ,face_amount -- 票面金额
            ,draft_key -- 票据唯一标识
            ,paragraph_amt -- 已追备款金额
            ,par_status -- 备款状态 0-备款失败 1-止付失败  2-已成功  null-未备款
            ,err_remarks -- 异常信息备注
            ,para_date -- 备款日期
            ,should_para_amt -- 应追加备款金额
            ,batch_no -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_dibet_info_op(
            id -- 
            ,contract_no -- 
            ,loan_seq -- 
            ,txn_type -- 
            ,maturity_date -- 
            ,remitter_date -- 
            ,loan_status -- 
            ,remitter_amt -- 
            ,bail_amt -- 开票保证金金额
            ,exposure_amt -- 
            ,dibet_pro_account -- 
            ,remark -- 
            ,is_draft -- 
            ,draft_id -- 
            ,app_no -- 
            ,source_flag -- 
            ,audit_status -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,ref_no -- 
            ,outloan_brh_no -- 
            ,brh_no -- 
            ,lncurcd -- 
            ,curcdrate -- 
            ,exhibition_date -- 
            ,appseq -- 
            ,lntype -- 
            ,loan_appno -- 
            ,lncustno -- 
            ,rate -- 利率
            ,is_clear -- 0-未结清 1-已结清
            ,guarno -- 押品编号
            ,draft_number -- 票据号码
            ,draft_maturity_date -- 票据到期日
            ,face_amount -- 票面金额
            ,draft_key -- 票据唯一标识
            ,paragraph_amt -- 已追备款金额
            ,par_status -- 备款状态 0-备款失败 1-止付失败  2-已成功  null-未备款
            ,err_remarks -- 异常信息备注
            ,para_date -- 备款日期
            ,should_para_amt -- 应追加备款金额
            ,batch_no -- 批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_no -- 
    ,o.loan_seq -- 
    ,o.txn_type -- 
    ,o.maturity_date -- 
    ,o.remitter_date -- 
    ,o.loan_status -- 
    ,o.remitter_amt -- 
    ,o.bail_amt -- 开票保证金金额
    ,o.exposure_amt -- 
    ,o.dibet_pro_account -- 
    ,o.remark -- 
    ,o.is_draft -- 
    ,o.draft_id -- 
    ,o.app_no -- 
    ,o.source_flag -- 
    ,o.audit_status -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.ref_no -- 
    ,o.outloan_brh_no -- 
    ,o.brh_no -- 
    ,o.lncurcd -- 
    ,o.curcdrate -- 
    ,o.exhibition_date -- 
    ,o.appseq -- 
    ,o.lntype -- 
    ,o.loan_appno -- 
    ,o.lncustno -- 
    ,o.rate -- 利率
    ,o.is_clear -- 0-未结清 1-已结清
    ,o.guarno -- 押品编号
    ,o.draft_number -- 票据号码
    ,o.draft_maturity_date -- 票据到期日
    ,o.face_amount -- 票面金额
    ,o.draft_key -- 票据唯一标识
    ,o.paragraph_amt -- 已追备款金额
    ,o.par_status -- 备款状态 0-备款失败 1-止付失败  2-已成功  null-未备款
    ,o.err_remarks -- 异常信息备注
    ,o.para_date -- 备款日期
    ,o.should_para_amt -- 应追加备款金额
    ,o.batch_no -- 批次号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_dibet_info_bk o
    left join ${iol_schema}.bdps_dibet_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_dibet_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdps_dibet_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_dibet_info exchange partition p_19000101 with table ${iol_schema}.bdps_dibet_info_cl;
alter table ${iol_schema}.bdps_dibet_info exchange partition p_20991231 with table ${iol_schema}.bdps_dibet_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_dibet_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_dibet_info_op purge;
drop table ${iol_schema}.bdps_dibet_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_dibet_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_dibet_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
