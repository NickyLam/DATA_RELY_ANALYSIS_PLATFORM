/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_salary_batch_detail
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
create table ${iol_schema}.tbps_cpr_salary_batch_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_salary_batch_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_salary_batch_detail_op purge;
drop table ${iol_schema}.tbps_cpr_salary_batch_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_salary_batch_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_salary_batch_detail where 0=1;

create table ${iol_schema}.tbps_cpr_salary_batch_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_salary_batch_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_salary_batch_detail_cl(
            sbd_batchno -- 批次号
            ,sbd_seqno -- 序号
            ,sbd_staffno -- 员工号
            ,sbd_payeracno -- 付款账号
            ,sbd_payeracname -- 付款账号户名
            ,sbd_payeeacno -- 收款账号
            ,sbd_payeeacname -- 收款账号户名
            ,sbd_amount -- 金额
            ,sbd_currency -- 币种
            ,sbd_notecode -- 付款用途
            ,sbd_remark -- 返回码
            ,sbd_salarydate -- 返回信息
            ,sbd_salarytime -- 交易时间
            ,sbd_detailstate -- 处理状态
            ,sbd_returncode -- 返回码
            ,sbd_returnmsg -- 返回信息
            ,sbd_hostjnldate -- 核心日期
            ,sbd_hostjnlno -- 核心流水号
            ,sbd_hostbatchno -- 核心批次号
            ,sbd_errormsg -- 错误信息
            ,sbd_userno -- 用户顺序号
            ,sbd_ecifno -- 全行统一客户号
            ,sbd_uniondeptid -- 收款方联行号
            ,sbd_uniondeptname -- 收款方开户网点
            ,sbd_mobilephone -- 手机号
            ,sbd_sysflag -- 0：行内；1：行外
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_salary_batch_detail_op(
            sbd_batchno -- 批次号
            ,sbd_seqno -- 序号
            ,sbd_staffno -- 员工号
            ,sbd_payeracno -- 付款账号
            ,sbd_payeracname -- 付款账号户名
            ,sbd_payeeacno -- 收款账号
            ,sbd_payeeacname -- 收款账号户名
            ,sbd_amount -- 金额
            ,sbd_currency -- 币种
            ,sbd_notecode -- 付款用途
            ,sbd_remark -- 返回码
            ,sbd_salarydate -- 返回信息
            ,sbd_salarytime -- 交易时间
            ,sbd_detailstate -- 处理状态
            ,sbd_returncode -- 返回码
            ,sbd_returnmsg -- 返回信息
            ,sbd_hostjnldate -- 核心日期
            ,sbd_hostjnlno -- 核心流水号
            ,sbd_hostbatchno -- 核心批次号
            ,sbd_errormsg -- 错误信息
            ,sbd_userno -- 用户顺序号
            ,sbd_ecifno -- 全行统一客户号
            ,sbd_uniondeptid -- 收款方联行号
            ,sbd_uniondeptname -- 收款方开户网点
            ,sbd_mobilephone -- 手机号
            ,sbd_sysflag -- 0：行内；1：行外
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sbd_batchno, o.sbd_batchno) as sbd_batchno -- 批次号
    ,nvl(n.sbd_seqno, o.sbd_seqno) as sbd_seqno -- 序号
    ,nvl(n.sbd_staffno, o.sbd_staffno) as sbd_staffno -- 员工号
    ,nvl(n.sbd_payeracno, o.sbd_payeracno) as sbd_payeracno -- 付款账号
    ,nvl(n.sbd_payeracname, o.sbd_payeracname) as sbd_payeracname -- 付款账号户名
    ,nvl(n.sbd_payeeacno, o.sbd_payeeacno) as sbd_payeeacno -- 收款账号
    ,nvl(n.sbd_payeeacname, o.sbd_payeeacname) as sbd_payeeacname -- 收款账号户名
    ,nvl(n.sbd_amount, o.sbd_amount) as sbd_amount -- 金额
    ,nvl(n.sbd_currency, o.sbd_currency) as sbd_currency -- 币种
    ,nvl(n.sbd_notecode, o.sbd_notecode) as sbd_notecode -- 付款用途
    ,nvl(n.sbd_remark, o.sbd_remark) as sbd_remark -- 返回码
    ,nvl(n.sbd_salarydate, o.sbd_salarydate) as sbd_salarydate -- 返回信息
    ,nvl(n.sbd_salarytime, o.sbd_salarytime) as sbd_salarytime -- 交易时间
    ,nvl(n.sbd_detailstate, o.sbd_detailstate) as sbd_detailstate -- 处理状态
    ,nvl(n.sbd_returncode, o.sbd_returncode) as sbd_returncode -- 返回码
    ,nvl(n.sbd_returnmsg, o.sbd_returnmsg) as sbd_returnmsg -- 返回信息
    ,nvl(n.sbd_hostjnldate, o.sbd_hostjnldate) as sbd_hostjnldate -- 核心日期
    ,nvl(n.sbd_hostjnlno, o.sbd_hostjnlno) as sbd_hostjnlno -- 核心流水号
    ,nvl(n.sbd_hostbatchno, o.sbd_hostbatchno) as sbd_hostbatchno -- 核心批次号
    ,nvl(n.sbd_errormsg, o.sbd_errormsg) as sbd_errormsg -- 错误信息
    ,nvl(n.sbd_userno, o.sbd_userno) as sbd_userno -- 用户顺序号
    ,nvl(n.sbd_ecifno, o.sbd_ecifno) as sbd_ecifno -- 全行统一客户号
    ,nvl(n.sbd_uniondeptid, o.sbd_uniondeptid) as sbd_uniondeptid -- 收款方联行号
    ,nvl(n.sbd_uniondeptname, o.sbd_uniondeptname) as sbd_uniondeptname -- 收款方开户网点
    ,nvl(n.sbd_mobilephone, o.sbd_mobilephone) as sbd_mobilephone -- 手机号
    ,nvl(n.sbd_sysflag, o.sbd_sysflag) as sbd_sysflag -- 0：行内；1：行外
    ,case when
            n.sbd_batchno is null
            and n.sbd_seqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sbd_batchno is null
            and n.sbd_seqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sbd_batchno is null
            and n.sbd_seqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_salary_batch_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_salary_batch_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sbd_batchno = n.sbd_batchno
            and o.sbd_seqno = n.sbd_seqno
where (
        o.sbd_batchno is null
        and o.sbd_seqno is null
    )
    or (
        n.sbd_batchno is null
        and n.sbd_seqno is null
    )
    or (
        o.sbd_staffno <> n.sbd_staffno
        or o.sbd_payeracno <> n.sbd_payeracno
        or o.sbd_payeracname <> n.sbd_payeracname
        or o.sbd_payeeacno <> n.sbd_payeeacno
        or o.sbd_payeeacname <> n.sbd_payeeacname
        or o.sbd_amount <> n.sbd_amount
        or o.sbd_currency <> n.sbd_currency
        or o.sbd_notecode <> n.sbd_notecode
        or o.sbd_remark <> n.sbd_remark
        or o.sbd_salarydate <> n.sbd_salarydate
        or o.sbd_salarytime <> n.sbd_salarytime
        or o.sbd_detailstate <> n.sbd_detailstate
        or o.sbd_returncode <> n.sbd_returncode
        or o.sbd_returnmsg <> n.sbd_returnmsg
        or o.sbd_hostjnldate <> n.sbd_hostjnldate
        or o.sbd_hostjnlno <> n.sbd_hostjnlno
        or o.sbd_hostbatchno <> n.sbd_hostbatchno
        or o.sbd_errormsg <> n.sbd_errormsg
        or o.sbd_userno <> n.sbd_userno
        or o.sbd_ecifno <> n.sbd_ecifno
        or o.sbd_uniondeptid <> n.sbd_uniondeptid
        or o.sbd_uniondeptname <> n.sbd_uniondeptname
        or o.sbd_mobilephone <> n.sbd_mobilephone
        or o.sbd_sysflag <> n.sbd_sysflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_salary_batch_detail_cl(
            sbd_batchno -- 批次号
            ,sbd_seqno -- 序号
            ,sbd_staffno -- 员工号
            ,sbd_payeracno -- 付款账号
            ,sbd_payeracname -- 付款账号户名
            ,sbd_payeeacno -- 收款账号
            ,sbd_payeeacname -- 收款账号户名
            ,sbd_amount -- 金额
            ,sbd_currency -- 币种
            ,sbd_notecode -- 付款用途
            ,sbd_remark -- 返回码
            ,sbd_salarydate -- 返回信息
            ,sbd_salarytime -- 交易时间
            ,sbd_detailstate -- 处理状态
            ,sbd_returncode -- 返回码
            ,sbd_returnmsg -- 返回信息
            ,sbd_hostjnldate -- 核心日期
            ,sbd_hostjnlno -- 核心流水号
            ,sbd_hostbatchno -- 核心批次号
            ,sbd_errormsg -- 错误信息
            ,sbd_userno -- 用户顺序号
            ,sbd_ecifno -- 全行统一客户号
            ,sbd_uniondeptid -- 收款方联行号
            ,sbd_uniondeptname -- 收款方开户网点
            ,sbd_mobilephone -- 手机号
            ,sbd_sysflag -- 0：行内；1：行外
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_salary_batch_detail_op(
            sbd_batchno -- 批次号
            ,sbd_seqno -- 序号
            ,sbd_staffno -- 员工号
            ,sbd_payeracno -- 付款账号
            ,sbd_payeracname -- 付款账号户名
            ,sbd_payeeacno -- 收款账号
            ,sbd_payeeacname -- 收款账号户名
            ,sbd_amount -- 金额
            ,sbd_currency -- 币种
            ,sbd_notecode -- 付款用途
            ,sbd_remark -- 返回码
            ,sbd_salarydate -- 返回信息
            ,sbd_salarytime -- 交易时间
            ,sbd_detailstate -- 处理状态
            ,sbd_returncode -- 返回码
            ,sbd_returnmsg -- 返回信息
            ,sbd_hostjnldate -- 核心日期
            ,sbd_hostjnlno -- 核心流水号
            ,sbd_hostbatchno -- 核心批次号
            ,sbd_errormsg -- 错误信息
            ,sbd_userno -- 用户顺序号
            ,sbd_ecifno -- 全行统一客户号
            ,sbd_uniondeptid -- 收款方联行号
            ,sbd_uniondeptname -- 收款方开户网点
            ,sbd_mobilephone -- 手机号
            ,sbd_sysflag -- 0：行内；1：行外
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sbd_batchno -- 批次号
    ,o.sbd_seqno -- 序号
    ,o.sbd_staffno -- 员工号
    ,o.sbd_payeracno -- 付款账号
    ,o.sbd_payeracname -- 付款账号户名
    ,o.sbd_payeeacno -- 收款账号
    ,o.sbd_payeeacname -- 收款账号户名
    ,o.sbd_amount -- 金额
    ,o.sbd_currency -- 币种
    ,o.sbd_notecode -- 付款用途
    ,o.sbd_remark -- 返回码
    ,o.sbd_salarydate -- 返回信息
    ,o.sbd_salarytime -- 交易时间
    ,o.sbd_detailstate -- 处理状态
    ,o.sbd_returncode -- 返回码
    ,o.sbd_returnmsg -- 返回信息
    ,o.sbd_hostjnldate -- 核心日期
    ,o.sbd_hostjnlno -- 核心流水号
    ,o.sbd_hostbatchno -- 核心批次号
    ,o.sbd_errormsg -- 错误信息
    ,o.sbd_userno -- 用户顺序号
    ,o.sbd_ecifno -- 全行统一客户号
    ,o.sbd_uniondeptid -- 收款方联行号
    ,o.sbd_uniondeptname -- 收款方开户网点
    ,o.sbd_mobilephone -- 手机号
    ,o.sbd_sysflag -- 0：行内；1：行外
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
from ${iol_schema}.tbps_cpr_salary_batch_detail_bk o
    left join ${iol_schema}.tbps_cpr_salary_batch_detail_op n
        on
            o.sbd_batchno = n.sbd_batchno
            and o.sbd_seqno = n.sbd_seqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_salary_batch_detail_cl d
        on
            o.sbd_batchno = d.sbd_batchno
            and o.sbd_seqno = d.sbd_seqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tbps_cpr_salary_batch_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tbps_cpr_salary_batch_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tbps_cpr_salary_batch_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tbps_cpr_salary_batch_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tbps_cpr_salary_batch_detail exchange partition p_${batch_date} with table ${iol_schema}.tbps_cpr_salary_batch_detail_cl;
alter table ${iol_schema}.tbps_cpr_salary_batch_detail exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_salary_batch_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_salary_batch_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_salary_batch_detail_op purge;
drop table ${iol_schema}.tbps_cpr_salary_batch_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_salary_batch_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_salary_batch_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
