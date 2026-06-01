/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_security_pymn_extra
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
create table ${iol_schema}.ctms_tbs_v_security_pymn_extra_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_security_pymn_extra;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_extra_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_extra_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_pymn_extra_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_pymn_extra where 0=1;

create table ${iol_schema}.ctms_tbs_v_security_pymn_extra_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_pymn_extra where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_pymn_extra_cl(
            security_code -- 债券代码
            ,seq -- 序号
            ,real_payment_date -- 付息日
            ,define_interest -- 是否自定义利息
            ,delay_payment -- 是否延迟付款
            ,coupon_amt -- 每万元付息金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_pymn_extra_op(
            security_code -- 债券代码
            ,seq -- 序号
            ,real_payment_date -- 付息日
            ,define_interest -- 是否自定义利息
            ,delay_payment -- 是否延迟付款
            ,coupon_amt -- 每万元付息金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.seq, o.seq) as seq -- 序号
    ,nvl(n.real_payment_date, o.real_payment_date) as real_payment_date -- 付息日
    ,nvl(n.define_interest, o.define_interest) as define_interest -- 是否自定义利息
    ,nvl(n.delay_payment, o.delay_payment) as delay_payment -- 是否延迟付款
    ,nvl(n.coupon_amt, o.coupon_amt) as coupon_amt -- 每万元付息金额
    ,case when
            n.security_code is null
            and n.seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.security_code is null
            and n.seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.security_code is null
            and n.seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_security_pymn_extra_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_security_pymn_extra where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.security_code = n.security_code
            and o.seq = n.seq
where (
        o.security_code is null
        and o.seq is null
    )
    or (
        n.security_code is null
        and n.seq is null
    )
    or (
        o.real_payment_date <> n.real_payment_date
        or o.define_interest <> n.define_interest
        or o.delay_payment <> n.delay_payment
        or o.coupon_amt <> n.coupon_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_pymn_extra_cl(
            security_code -- 债券代码
            ,seq -- 序号
            ,real_payment_date -- 付息日
            ,define_interest -- 是否自定义利息
            ,delay_payment -- 是否延迟付款
            ,coupon_amt -- 每万元付息金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_pymn_extra_op(
            security_code -- 债券代码
            ,seq -- 序号
            ,real_payment_date -- 付息日
            ,define_interest -- 是否自定义利息
            ,delay_payment -- 是否延迟付款
            ,coupon_amt -- 每万元付息金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.security_code -- 债券代码
    ,o.seq -- 序号
    ,o.real_payment_date -- 付息日
    ,o.define_interest -- 是否自定义利息
    ,o.delay_payment -- 是否延迟付款
    ,o.coupon_amt -- 每万元付息金额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_security_pymn_extra_bk o
    left join ${iol_schema}.ctms_tbs_v_security_pymn_extra_op n
        on
            o.security_code = n.security_code
            and o.seq = n.seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_security_pymn_extra_cl d
        on
            o.security_code = d.security_code
            and o.seq = d.seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_security_pymn_extra;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_security_pymn_extra exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_security_pymn_extra_cl;
alter table ${iol_schema}.ctms_tbs_v_security_pymn_extra exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_security_pymn_extra_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_security_pymn_extra to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_extra_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_extra_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_extra_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_security_pymn_extra',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
