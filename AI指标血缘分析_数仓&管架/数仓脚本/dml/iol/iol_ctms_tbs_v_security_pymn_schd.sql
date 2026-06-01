/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_security_pymn_schd
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
create table ${iol_schema}.ctms_tbs_v_security_pymn_schd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_security_pymn_schd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_schd_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_schd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_pymn_schd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_pymn_schd where 0=1;

create table ${iol_schema}.ctms_tbs_v_security_pymn_schd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_pymn_schd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_pymn_schd_cl(
            security_code -- 债券代码
            ,seq -- 付息次序
            ,payment_date -- 付息日期
            ,call_date -- 发行人赎回日期
            ,put_date -- 投资人回售日期
            ,coupon_amt -- 付息金额
            ,back_amt -- 还本金额
            ,last_amt -- 剩余本金额
            ,modify_date -- 修改时间
            ,call_price -- 发行人赎回价格
            ,put_price -- 投资人回售价格
            ,convert_date -- 转换日期
            ,convert_security_code -- 转换债券代码
            ,back_announce_date -- 还本公告日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_pymn_schd_op(
            security_code -- 债券代码
            ,seq -- 付息次序
            ,payment_date -- 付息日期
            ,call_date -- 发行人赎回日期
            ,put_date -- 投资人回售日期
            ,coupon_amt -- 付息金额
            ,back_amt -- 还本金额
            ,last_amt -- 剩余本金额
            ,modify_date -- 修改时间
            ,call_price -- 发行人赎回价格
            ,put_price -- 投资人回售价格
            ,convert_date -- 转换日期
            ,convert_security_code -- 转换债券代码
            ,back_announce_date -- 还本公告日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.seq, o.seq) as seq -- 付息次序
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 付息日期
    ,nvl(n.call_date, o.call_date) as call_date -- 发行人赎回日期
    ,nvl(n.put_date, o.put_date) as put_date -- 投资人回售日期
    ,nvl(n.coupon_amt, o.coupon_amt) as coupon_amt -- 付息金额
    ,nvl(n.back_amt, o.back_amt) as back_amt -- 还本金额
    ,nvl(n.last_amt, o.last_amt) as last_amt -- 剩余本金额
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 修改时间
    ,nvl(n.call_price, o.call_price) as call_price -- 发行人赎回价格
    ,nvl(n.put_price, o.put_price) as put_price -- 投资人回售价格
    ,nvl(n.convert_date, o.convert_date) as convert_date -- 转换日期
    ,nvl(n.convert_security_code, o.convert_security_code) as convert_security_code -- 转换债券代码
    ,nvl(n.back_announce_date, o.back_announce_date) as back_announce_date -- 还本公告日期
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
from (select * from ${iol_schema}.ctms_tbs_v_security_pymn_schd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_security_pymn_schd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        o.payment_date <> n.payment_date
        or o.call_date <> n.call_date
        or o.put_date <> n.put_date
        or o.coupon_amt <> n.coupon_amt
        or o.back_amt <> n.back_amt
        or o.last_amt <> n.last_amt
        or o.modify_date <> n.modify_date
        or o.call_price <> n.call_price
        or o.put_price <> n.put_price
        or o.convert_date <> n.convert_date
        or o.convert_security_code <> n.convert_security_code
        or o.back_announce_date <> n.back_announce_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_pymn_schd_cl(
            security_code -- 债券代码
            ,seq -- 付息次序
            ,payment_date -- 付息日期
            ,call_date -- 发行人赎回日期
            ,put_date -- 投资人回售日期
            ,coupon_amt -- 付息金额
            ,back_amt -- 还本金额
            ,last_amt -- 剩余本金额
            ,modify_date -- 修改时间
            ,call_price -- 发行人赎回价格
            ,put_price -- 投资人回售价格
            ,convert_date -- 转换日期
            ,convert_security_code -- 转换债券代码
            ,back_announce_date -- 还本公告日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_pymn_schd_op(
            security_code -- 债券代码
            ,seq -- 付息次序
            ,payment_date -- 付息日期
            ,call_date -- 发行人赎回日期
            ,put_date -- 投资人回售日期
            ,coupon_amt -- 付息金额
            ,back_amt -- 还本金额
            ,last_amt -- 剩余本金额
            ,modify_date -- 修改时间
            ,call_price -- 发行人赎回价格
            ,put_price -- 投资人回售价格
            ,convert_date -- 转换日期
            ,convert_security_code -- 转换债券代码
            ,back_announce_date -- 还本公告日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.security_code -- 债券代码
    ,o.seq -- 付息次序
    ,o.payment_date -- 付息日期
    ,o.call_date -- 发行人赎回日期
    ,o.put_date -- 投资人回售日期
    ,o.coupon_amt -- 付息金额
    ,o.back_amt -- 还本金额
    ,o.last_amt -- 剩余本金额
    ,o.modify_date -- 修改时间
    ,o.call_price -- 发行人赎回价格
    ,o.put_price -- 投资人回售价格
    ,o.convert_date -- 转换日期
    ,o.convert_security_code -- 转换债券代码
    ,o.back_announce_date -- 还本公告日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_security_pymn_schd_bk o
    left join ${iol_schema}.ctms_tbs_v_security_pymn_schd_op n
        on
            o.security_code = n.security_code
            and o.seq = n.seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_security_pymn_schd_cl d
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
-- truncate table ${iol_schema}.ctms_tbs_v_security_pymn_schd;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_security_pymn_schd exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_security_pymn_schd_cl;
alter table ${iol_schema}.ctms_tbs_v_security_pymn_schd exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_security_pymn_schd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_security_pymn_schd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_schd_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_schd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_security_pymn_schd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_security_pymn_schd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
