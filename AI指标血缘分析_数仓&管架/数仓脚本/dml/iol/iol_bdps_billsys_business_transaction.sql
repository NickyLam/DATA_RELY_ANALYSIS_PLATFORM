/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_billsys_business_transaction
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
create table ${iol_schema}.bdps_billsys_business_transaction_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_billsys_business_transaction;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_billsys_business_transaction_op purge;
drop table ${iol_schema}.bdps_billsys_business_transaction_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_billsys_business_transaction_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_billsys_business_transaction where 0=1;

create table ${iol_schema}.bdps_billsys_business_transaction_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_billsys_business_transaction where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_billsys_business_transaction_cl(
            id -- 
            ,business_type -- 业务类型 1-代保管申请 2-代保管出库 4-代保管转质押 5-质押转代保管
            ,app_status -- 申请状态 1-申请中  2-驳回   3-审批中   4-审批完成
            ,draft_id -- 票据信息表ID
            ,draft_number -- 票号
            ,draft_attr -- 票据属性  1-纸票   2-电票
            ,draft_type -- 票据类型   1-银票 2-商票
            ,remit_date -- 出票日期
            ,maturity_date -- 票面到期日
            ,remitter_cmonid -- 出票人组织机构代码
            ,remitter_name -- 出票人名称
            ,remitter_bank_no -- 出票人开户行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_account -- 出票人账号
            ,acceptor -- 承兑人
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_actno -- 承兑人账号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 票面收款人名称
            ,payee_account -- 票面收款人账号
            ,payee_bank_no -- 票面收款人开户行号
            ,payee_bank_name -- 票面收款人开户行
            ,face_amount -- 票面金额
            ,end_or_sement_mk -- 人行可转让标志  EM00可再转让  EM01不得转让
            ,pledge_seq_no -- 质押流水号
            ,reason -- 驳回理由
            ,cust_no -- 客户号
            ,branch_id -- 所属机构
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,applock -- 任务锁  01-办理加锁 00-办理未加锁 (00为可挑选）
            ,int_tm -- 插入时间    初始插入时间戳   YYYY-MM-DD HH:MM:SS.0
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_billsys_business_transaction_op(
            id -- 
            ,business_type -- 业务类型 1-代保管申请 2-代保管出库 4-代保管转质押 5-质押转代保管
            ,app_status -- 申请状态 1-申请中  2-驳回   3-审批中   4-审批完成
            ,draft_id -- 票据信息表ID
            ,draft_number -- 票号
            ,draft_attr -- 票据属性  1-纸票   2-电票
            ,draft_type -- 票据类型   1-银票 2-商票
            ,remit_date -- 出票日期
            ,maturity_date -- 票面到期日
            ,remitter_cmonid -- 出票人组织机构代码
            ,remitter_name -- 出票人名称
            ,remitter_bank_no -- 出票人开户行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_account -- 出票人账号
            ,acceptor -- 承兑人
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_actno -- 承兑人账号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 票面收款人名称
            ,payee_account -- 票面收款人账号
            ,payee_bank_no -- 票面收款人开户行号
            ,payee_bank_name -- 票面收款人开户行
            ,face_amount -- 票面金额
            ,end_or_sement_mk -- 人行可转让标志  EM00可再转让  EM01不得转让
            ,pledge_seq_no -- 质押流水号
            ,reason -- 驳回理由
            ,cust_no -- 客户号
            ,branch_id -- 所属机构
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,applock -- 任务锁  01-办理加锁 00-办理未加锁 (00为可挑选）
            ,int_tm -- 插入时间    初始插入时间戳   YYYY-MM-DD HH:MM:SS.0
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.business_type, o.business_type) as business_type -- 业务类型 1-代保管申请 2-代保管出库 4-代保管转质押 5-质押转代保管
    ,nvl(n.app_status, o.app_status) as app_status -- 申请状态 1-申请中  2-驳回   3-审批中   4-审批完成
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据信息表ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票号
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性  1-纸票   2-电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型   1-银票 2-商票
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 票面到期日
    ,nvl(n.remitter_cmonid, o.remitter_cmonid) as remitter_cmonid -- 出票人组织机构代码
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人名称
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 出票人开户行号
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 出票人开户行名称
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 出票人账号
    ,nvl(n.acceptor, o.acceptor) as acceptor -- 承兑人
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行号
    ,nvl(n.acceptor_actno, o.acceptor_actno) as acceptor_actno -- 承兑人账号
    ,nvl(n.acceptor_bank_name, o.acceptor_bank_name) as acceptor_bank_name -- 承兑人开户行名称
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 票面收款人名称
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 票面收款人账号
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 票面收款人开户行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 票面收款人开户行
    ,nvl(n.face_amount, o.face_amount) as face_amount -- 票面金额
    ,nvl(n.end_or_sement_mk, o.end_or_sement_mk) as end_or_sement_mk -- 人行可转让标志  EM00可再转让  EM01不得转让
    ,nvl(n.pledge_seq_no, o.pledge_seq_no) as pledge_seq_no -- 质押流水号
    ,nvl(n.reason, o.reason) as reason -- 驳回理由
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 所属机构
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后修改操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.applock, o.applock) as applock -- 任务锁  01-办理加锁 00-办理未加锁 (00为可挑选）
    ,nvl(n.int_tm, o.int_tm) as int_tm -- 插入时间    初始插入时间戳   YYYY-MM-DD HH:MM:SS.0
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
from (select * from ${iol_schema}.bdps_billsys_business_transaction_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_billsys_business_transaction where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.business_type <> n.business_type
        or o.app_status <> n.app_status
        or o.draft_id <> n.draft_id
        or o.draft_number <> n.draft_number
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.remitter_cmonid <> n.remitter_cmonid
        or o.remitter_name <> n.remitter_name
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.remitter_account <> n.remitter_account
        or o.acceptor <> n.acceptor
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_actno <> n.acceptor_actno
        or o.acceptor_bank_name <> n.acceptor_bank_name
        or o.payee_name <> n.payee_name
        or o.payee_account <> n.payee_account
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.face_amount <> n.face_amount
        or o.end_or_sement_mk <> n.end_or_sement_mk
        or o.pledge_seq_no <> n.pledge_seq_no
        or o.reason <> n.reason
        or o.cust_no <> n.cust_no
        or o.branch_id <> n.branch_id
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.applock <> n.applock
        or o.int_tm <> n.int_tm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_billsys_business_transaction_cl(
            id -- 
            ,business_type -- 业务类型 1-代保管申请 2-代保管出库 4-代保管转质押 5-质押转代保管
            ,app_status -- 申请状态 1-申请中  2-驳回   3-审批中   4-审批完成
            ,draft_id -- 票据信息表ID
            ,draft_number -- 票号
            ,draft_attr -- 票据属性  1-纸票   2-电票
            ,draft_type -- 票据类型   1-银票 2-商票
            ,remit_date -- 出票日期
            ,maturity_date -- 票面到期日
            ,remitter_cmonid -- 出票人组织机构代码
            ,remitter_name -- 出票人名称
            ,remitter_bank_no -- 出票人开户行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_account -- 出票人账号
            ,acceptor -- 承兑人
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_actno -- 承兑人账号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 票面收款人名称
            ,payee_account -- 票面收款人账号
            ,payee_bank_no -- 票面收款人开户行号
            ,payee_bank_name -- 票面收款人开户行
            ,face_amount -- 票面金额
            ,end_or_sement_mk -- 人行可转让标志  EM00可再转让  EM01不得转让
            ,pledge_seq_no -- 质押流水号
            ,reason -- 驳回理由
            ,cust_no -- 客户号
            ,branch_id -- 所属机构
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,applock -- 任务锁  01-办理加锁 00-办理未加锁 (00为可挑选）
            ,int_tm -- 插入时间    初始插入时间戳   YYYY-MM-DD HH:MM:SS.0
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_billsys_business_transaction_op(
            id -- 
            ,business_type -- 业务类型 1-代保管申请 2-代保管出库 4-代保管转质押 5-质押转代保管
            ,app_status -- 申请状态 1-申请中  2-驳回   3-审批中   4-审批完成
            ,draft_id -- 票据信息表ID
            ,draft_number -- 票号
            ,draft_attr -- 票据属性  1-纸票   2-电票
            ,draft_type -- 票据类型   1-银票 2-商票
            ,remit_date -- 出票日期
            ,maturity_date -- 票面到期日
            ,remitter_cmonid -- 出票人组织机构代码
            ,remitter_name -- 出票人名称
            ,remitter_bank_no -- 出票人开户行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_account -- 出票人账号
            ,acceptor -- 承兑人
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_actno -- 承兑人账号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,payee_name -- 票面收款人名称
            ,payee_account -- 票面收款人账号
            ,payee_bank_no -- 票面收款人开户行号
            ,payee_bank_name -- 票面收款人开户行
            ,face_amount -- 票面金额
            ,end_or_sement_mk -- 人行可转让标志  EM00可再转让  EM01不得转让
            ,pledge_seq_no -- 质押流水号
            ,reason -- 驳回理由
            ,cust_no -- 客户号
            ,branch_id -- 所属机构
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,applock -- 任务锁  01-办理加锁 00-办理未加锁 (00为可挑选）
            ,int_tm -- 插入时间    初始插入时间戳   YYYY-MM-DD HH:MM:SS.0
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.business_type -- 业务类型 1-代保管申请 2-代保管出库 4-代保管转质押 5-质押转代保管
    ,o.app_status -- 申请状态 1-申请中  2-驳回   3-审批中   4-审批完成
    ,o.draft_id -- 票据信息表ID
    ,o.draft_number -- 票号
    ,o.draft_attr -- 票据属性  1-纸票   2-电票
    ,o.draft_type -- 票据类型   1-银票 2-商票
    ,o.remit_date -- 出票日期
    ,o.maturity_date -- 票面到期日
    ,o.remitter_cmonid -- 出票人组织机构代码
    ,o.remitter_name -- 出票人名称
    ,o.remitter_bank_no -- 出票人开户行号
    ,o.remitter_bank_name -- 出票人开户行名称
    ,o.remitter_account -- 出票人账号
    ,o.acceptor -- 承兑人
    ,o.acceptor_bank_no -- 承兑人开户行号
    ,o.acceptor_actno -- 承兑人账号
    ,o.acceptor_bank_name -- 承兑人开户行名称
    ,o.payee_name -- 票面收款人名称
    ,o.payee_account -- 票面收款人账号
    ,o.payee_bank_no -- 票面收款人开户行号
    ,o.payee_bank_name -- 票面收款人开户行
    ,o.face_amount -- 票面金额
    ,o.end_or_sement_mk -- 人行可转让标志  EM00可再转让  EM01不得转让
    ,o.pledge_seq_no -- 质押流水号
    ,o.reason -- 驳回理由
    ,o.cust_no -- 客户号
    ,o.branch_id -- 所属机构
    ,o.last_upd_oper_id -- 最后修改操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.applock -- 任务锁  01-办理加锁 00-办理未加锁 (00为可挑选）
    ,o.int_tm -- 插入时间    初始插入时间戳   YYYY-MM-DD HH:MM:SS.0
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_billsys_business_transaction_bk o
    left join ${iol_schema}.bdps_billsys_business_transaction_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_billsys_business_transaction_cl d
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
-- truncate table ${iol_schema}.bdps_billsys_business_transaction;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_billsys_business_transaction exchange partition p_19000101 with table ${iol_schema}.bdps_billsys_business_transaction_cl;
alter table ${iol_schema}.bdps_billsys_business_transaction exchange partition p_20991231 with table ${iol_schema}.bdps_billsys_business_transaction_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_billsys_business_transaction to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_billsys_business_transaction_op purge;
drop table ${iol_schema}.bdps_billsys_business_transaction_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_billsys_business_transaction_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_billsys_business_transaction',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
