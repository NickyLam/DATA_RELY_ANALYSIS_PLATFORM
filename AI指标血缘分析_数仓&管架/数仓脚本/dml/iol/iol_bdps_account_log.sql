/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_account_log
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
create table ${iol_schema}.bdps_account_log_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_account_log
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_account_log_op purge;
drop table ${iol_schema}.bdps_account_log_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_account_log_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_account_log where 0=1;

create table ${iol_schema}.bdps_account_log_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_account_log where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_account_log_cl(
            id -- 
            ,traceno -- `
            ,subno -- 
            ,txdate -- 
            ,txnto -- 
            ,txno -- 
            ,branch_no -- 
            ,operator_id -- 
            ,trmid -- 
            ,bsseq -- 
            ,trmtype -- 
            ,svcnm -- 
            ,hcode -- 
            ,seqno -- 
            ,origtxno -- 
            ,isagnstat -- 
            ,sndstat -- 
            ,sndcnt -- 
            ,errcd -- 
            ,errrsn -- 
            ,biz_type -- 
            ,detail_id -- 
            ,act_dtl_id -- 
            ,draft_id -- 
            ,contract_id -- 
            ,prodprop -- 
            ,misc -- 
            ,auth_id -- 
            ,account_mode -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,rcv_seqno -- 
            ,stmt_flg -- 
            ,dataid -- 第三方系统标识号
            ,hostdate -- 核心返回交易日期
            ,tran_amount -- 交易金额
            ,tglsstat -- 核算中台记账状态00-未记账01-记账中02-记账成功03-已抹账
            ,tglscnt -- 核算中台重发次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_account_log_op(
            id -- 
            ,traceno -- `
            ,subno -- 
            ,txdate -- 
            ,txnto -- 
            ,txno -- 
            ,branch_no -- 
            ,operator_id -- 
            ,trmid -- 
            ,bsseq -- 
            ,trmtype -- 
            ,svcnm -- 
            ,hcode -- 
            ,seqno -- 
            ,origtxno -- 
            ,isagnstat -- 
            ,sndstat -- 
            ,sndcnt -- 
            ,errcd -- 
            ,errrsn -- 
            ,biz_type -- 
            ,detail_id -- 
            ,act_dtl_id -- 
            ,draft_id -- 
            ,contract_id -- 
            ,prodprop -- 
            ,misc -- 
            ,auth_id -- 
            ,account_mode -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,rcv_seqno -- 
            ,stmt_flg -- 
            ,dataid -- 第三方系统标识号
            ,hostdate -- 核心返回交易日期
            ,tran_amount -- 交易金额
            ,tglsstat -- 核算中台记账状态00-未记账01-记账中02-记账成功03-已抹账
            ,tglscnt -- 核算中台重发次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.traceno, o.traceno) as traceno -- `
    ,nvl(n.subno, o.subno) as subno -- 
    ,nvl(n.txdate, o.txdate) as txdate -- 
    ,nvl(n.txnto, o.txnto) as txnto -- 
    ,nvl(n.txno, o.txno) as txno -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.operator_id, o.operator_id) as operator_id -- 
    ,nvl(n.trmid, o.trmid) as trmid -- 
    ,nvl(n.bsseq, o.bsseq) as bsseq -- 
    ,nvl(n.trmtype, o.trmtype) as trmtype -- 
    ,nvl(n.svcnm, o.svcnm) as svcnm -- 
    ,nvl(n.hcode, o.hcode) as hcode -- 
    ,nvl(n.seqno, o.seqno) as seqno -- 
    ,nvl(n.origtxno, o.origtxno) as origtxno -- 
    ,nvl(n.isagnstat, o.isagnstat) as isagnstat -- 
    ,nvl(n.sndstat, o.sndstat) as sndstat -- 
    ,nvl(n.sndcnt, o.sndcnt) as sndcnt -- 
    ,nvl(n.errcd, o.errcd) as errcd -- 
    ,nvl(n.errrsn, o.errrsn) as errrsn -- 
    ,nvl(n.biz_type, o.biz_type) as biz_type -- 
    ,nvl(n.detail_id, o.detail_id) as detail_id -- 
    ,nvl(n.act_dtl_id, o.act_dtl_id) as act_dtl_id -- 
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 
    ,nvl(n.prodprop, o.prodprop) as prodprop -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.auth_id, o.auth_id) as auth_id -- 
    ,nvl(n.account_mode, o.account_mode) as account_mode -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.rcv_seqno, o.rcv_seqno) as rcv_seqno -- 
    ,nvl(n.stmt_flg, o.stmt_flg) as stmt_flg -- 
    ,nvl(n.dataid, o.dataid) as dataid -- 第三方系统标识号
    ,nvl(n.hostdate, o.hostdate) as hostdate -- 核心返回交易日期
    ,nvl(n.tran_amount, o.tran_amount) as tran_amount -- 交易金额
    ,nvl(n.tglsstat, o.tglsstat) as tglsstat -- 核算中台记账状态00-未记账01-记账中02-记账成功03-已抹账
    ,nvl(n.tglscnt, o.tglscnt) as tglscnt -- 核算中台重发次数
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
from (select * from ${iol_schema}.bdps_account_log_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_account_log where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.traceno <> n.traceno
        or o.subno <> n.subno
        or o.txdate <> n.txdate
        or o.txnto <> n.txnto
        or o.txno <> n.txno
        or o.branch_no <> n.branch_no
        or o.operator_id <> n.operator_id
        or o.trmid <> n.trmid
        or o.bsseq <> n.bsseq
        or o.trmtype <> n.trmtype
        or o.svcnm <> n.svcnm
        or o.hcode <> n.hcode
        or o.seqno <> n.seqno
        or o.origtxno <> n.origtxno
        or o.isagnstat <> n.isagnstat
        or o.sndstat <> n.sndstat
        or o.sndcnt <> n.sndcnt
        or o.errcd <> n.errcd
        or o.errrsn <> n.errrsn
        or o.biz_type <> n.biz_type
        or o.detail_id <> n.detail_id
        or o.act_dtl_id <> n.act_dtl_id
        or o.draft_id <> n.draft_id
        or o.contract_id <> n.contract_id
        or o.prodprop <> n.prodprop
        or o.misc <> n.misc
        or o.auth_id <> n.auth_id
        or o.account_mode <> n.account_mode
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.rcv_seqno <> n.rcv_seqno
        or o.stmt_flg <> n.stmt_flg
        or o.dataid <> n.dataid
        or o.hostdate <> n.hostdate
        or o.tran_amount <> n.tran_amount
        or o.tglsstat <> n.tglsstat
        or o.tglscnt <> n.tglscnt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_account_log_cl(
            id -- 
            ,traceno -- `
            ,subno -- 
            ,txdate -- 
            ,txnto -- 
            ,txno -- 
            ,branch_no -- 
            ,operator_id -- 
            ,trmid -- 
            ,bsseq -- 
            ,trmtype -- 
            ,svcnm -- 
            ,hcode -- 
            ,seqno -- 
            ,origtxno -- 
            ,isagnstat -- 
            ,sndstat -- 
            ,sndcnt -- 
            ,errcd -- 
            ,errrsn -- 
            ,biz_type -- 
            ,detail_id -- 
            ,act_dtl_id -- 
            ,draft_id -- 
            ,contract_id -- 
            ,prodprop -- 
            ,misc -- 
            ,auth_id -- 
            ,account_mode -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,rcv_seqno -- 
            ,stmt_flg -- 
            ,dataid -- 第三方系统标识号
            ,hostdate -- 核心返回交易日期
            ,tran_amount -- 交易金额
            ,tglsstat -- 核算中台记账状态00-未记账01-记账中02-记账成功03-已抹账
            ,tglscnt -- 核算中台重发次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_account_log_op(
            id -- 
            ,traceno -- `
            ,subno -- 
            ,txdate -- 
            ,txnto -- 
            ,txno -- 
            ,branch_no -- 
            ,operator_id -- 
            ,trmid -- 
            ,bsseq -- 
            ,trmtype -- 
            ,svcnm -- 
            ,hcode -- 
            ,seqno -- 
            ,origtxno -- 
            ,isagnstat -- 
            ,sndstat -- 
            ,sndcnt -- 
            ,errcd -- 
            ,errrsn -- 
            ,biz_type -- 
            ,detail_id -- 
            ,act_dtl_id -- 
            ,draft_id -- 
            ,contract_id -- 
            ,prodprop -- 
            ,misc -- 
            ,auth_id -- 
            ,account_mode -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,rcv_seqno -- 
            ,stmt_flg -- 
            ,dataid -- 第三方系统标识号
            ,hostdate -- 核心返回交易日期
            ,tran_amount -- 交易金额
            ,tglsstat -- 核算中台记账状态00-未记账01-记账中02-记账成功03-已抹账
            ,tglscnt -- 核算中台重发次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.traceno -- `
    ,o.subno -- 
    ,o.txdate -- 
    ,o.txnto -- 
    ,o.txno -- 
    ,o.branch_no -- 
    ,o.operator_id -- 
    ,o.trmid -- 
    ,o.bsseq -- 
    ,o.trmtype -- 
    ,o.svcnm -- 
    ,o.hcode -- 
    ,o.seqno -- 
    ,o.origtxno -- 
    ,o.isagnstat -- 
    ,o.sndstat -- 
    ,o.sndcnt -- 
    ,o.errcd -- 
    ,o.errrsn -- 
    ,o.biz_type -- 
    ,o.detail_id -- 
    ,o.act_dtl_id -- 
    ,o.draft_id -- 
    ,o.contract_id -- 
    ,o.prodprop -- 
    ,o.misc -- 
    ,o.auth_id -- 
    ,o.account_mode -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.rcv_seqno -- 
    ,o.stmt_flg -- 
    ,o.dataid -- 第三方系统标识号
    ,o.hostdate -- 核心返回交易日期
    ,o.tran_amount -- 交易金额
    ,o.tglsstat -- 核算中台记账状态00-未记账01-记账中02-记账成功03-已抹账
    ,o.tglscnt -- 核算中台重发次数
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_account_log_bk o
    left join ${iol_schema}.bdps_account_log_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_account_log_cl d
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
--truncate table ${iol_schema}.bdps_account_log;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_account_log') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_account_log drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_account_log add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_account_log exchange partition p_${batch_date} with table ${iol_schema}.bdps_account_log_cl;
alter table ${iol_schema}.bdps_account_log exchange partition p_20991231 with table ${iol_schema}.bdps_account_log_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_account_log to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_account_log_op purge;
drop table ${iol_schema}.bdps_account_log_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_account_log_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_account_log',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
