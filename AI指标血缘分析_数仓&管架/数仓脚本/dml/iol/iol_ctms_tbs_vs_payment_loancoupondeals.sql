/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_payment_loancoupondeals
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
create table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals where 0=1;

create table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,keepfolder_id -- 交易组别
            ,keepfolder_shortname -- 交易组别名称
            ,serial_number -- 关联主交易的交易序号
            ,seq -- 顺序号
            ,start_date -- 计息开始日
            ,end_date -- 计息截止日
            ,fixing_rate -- 指标利率值
            ,spread -- 点差
            ,rate -- 重设利率
            ,payment_date -- 支付日
            ,os_amount -- 计息金额
            ,interest -- 本期利息
            ,ostart_date -- 原始计息开始日
            ,oend_date -- 原始计息结束日
            ,ofixing_date -- 原始重设日
            ,opayment_date -- 原始支付日
            ,fixing_date -- 利息重设日
            ,is_fixing -- 利率是否已重设
            ,lastmodified -- 最终修改时间
            ,lastmodified_pay -- 实收付确认的修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,keepfolder_id -- 交易组别
            ,keepfolder_shortname -- 交易组别名称
            ,serial_number -- 关联主交易的交易序号
            ,seq -- 顺序号
            ,start_date -- 计息开始日
            ,end_date -- 计息截止日
            ,fixing_rate -- 指标利率值
            ,spread -- 点差
            ,rate -- 重设利率
            ,payment_date -- 支付日
            ,os_amount -- 计息金额
            ,interest -- 本期利息
            ,ostart_date -- 原始计息开始日
            ,oend_date -- 原始计息结束日
            ,ofixing_date -- 原始重设日
            ,opayment_date -- 原始支付日
            ,fixing_date -- 利息重设日
            ,is_fixing -- 利率是否已重设
            ,lastmodified -- 最终修改时间
            ,lastmodified_pay -- 实收付确认的修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_name, o.deal_name) as deal_name -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 交易组别
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 交易组别名称
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 关联主交易的交易序号
    ,nvl(n.seq, o.seq) as seq -- 顺序号
    ,nvl(n.start_date, o.start_date) as start_date -- 计息开始日
    ,nvl(n.end_date, o.end_date) as end_date -- 计息截止日
    ,nvl(n.fixing_rate, o.fixing_rate) as fixing_rate -- 指标利率值
    ,nvl(n.spread, o.spread) as spread -- 点差
    ,nvl(n.rate, o.rate) as rate -- 重设利率
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 支付日
    ,nvl(n.os_amount, o.os_amount) as os_amount -- 计息金额
    ,nvl(n.interest, o.interest) as interest -- 本期利息
    ,nvl(n.ostart_date, o.ostart_date) as ostart_date -- 原始计息开始日
    ,nvl(n.oend_date, o.oend_date) as oend_date -- 原始计息结束日
    ,nvl(n.ofixing_date, o.ofixing_date) as ofixing_date -- 原始重设日
    ,nvl(n.opayment_date, o.opayment_date) as opayment_date -- 原始支付日
    ,nvl(n.fixing_date, o.fixing_date) as fixing_date -- 利息重设日
    ,nvl(n.is_fixing, o.is_fixing) as is_fixing -- 利率是否已重设
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最终修改时间
    ,nvl(n.lastmodified_pay, o.lastmodified_pay) as lastmodified_pay -- 实收付确认的修改时间
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_payment_loancoupondeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
where (
        o.deal_id is null
        and o.deal_name is null
    )
    or (
        n.deal_id is null
        and n.deal_name is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.serial_number <> n.serial_number
        or o.seq <> n.seq
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.fixing_rate <> n.fixing_rate
        or o.spread <> n.spread
        or o.rate <> n.rate
        or o.payment_date <> n.payment_date
        or o.os_amount <> n.os_amount
        or o.interest <> n.interest
        or o.ostart_date <> n.ostart_date
        or o.oend_date <> n.oend_date
        or o.ofixing_date <> n.ofixing_date
        or o.opayment_date <> n.opayment_date
        or o.fixing_date <> n.fixing_date
        or o.is_fixing <> n.is_fixing
        or o.lastmodified <> n.lastmodified
        or o.lastmodified_pay <> n.lastmodified_pay
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,keepfolder_id -- 交易组别
            ,keepfolder_shortname -- 交易组别名称
            ,serial_number -- 关联主交易的交易序号
            ,seq -- 顺序号
            ,start_date -- 计息开始日
            ,end_date -- 计息截止日
            ,fixing_rate -- 指标利率值
            ,spread -- 点差
            ,rate -- 重设利率
            ,payment_date -- 支付日
            ,os_amount -- 计息金额
            ,interest -- 本期利息
            ,ostart_date -- 原始计息开始日
            ,oend_date -- 原始计息结束日
            ,ofixing_date -- 原始重设日
            ,opayment_date -- 原始支付日
            ,fixing_date -- 利息重设日
            ,is_fixing -- 利率是否已重设
            ,lastmodified -- 最终修改时间
            ,lastmodified_pay -- 实收付确认的修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,keepfolder_id -- 交易组别
            ,keepfolder_shortname -- 交易组别名称
            ,serial_number -- 关联主交易的交易序号
            ,seq -- 顺序号
            ,start_date -- 计息开始日
            ,end_date -- 计息截止日
            ,fixing_rate -- 指标利率值
            ,spread -- 点差
            ,rate -- 重设利率
            ,payment_date -- 支付日
            ,os_amount -- 计息金额
            ,interest -- 本期利息
            ,ostart_date -- 原始计息开始日
            ,oend_date -- 原始计息结束日
            ,ofixing_date -- 原始重设日
            ,opayment_date -- 原始支付日
            ,fixing_date -- 利息重设日
            ,is_fixing -- 利率是否已重设
            ,lastmodified -- 最终修改时间
            ,lastmodified_pay -- 实收付确认的修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_name -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.keepfolder_id -- 交易组别
    ,o.keepfolder_shortname -- 交易组别名称
    ,o.serial_number -- 关联主交易的交易序号
    ,o.seq -- 顺序号
    ,o.start_date -- 计息开始日
    ,o.end_date -- 计息截止日
    ,o.fixing_rate -- 指标利率值
    ,o.spread -- 点差
    ,o.rate -- 重设利率
    ,o.payment_date -- 支付日
    ,o.os_amount -- 计息金额
    ,o.interest -- 本期利息
    ,o.ostart_date -- 原始计息开始日
    ,o.oend_date -- 原始计息结束日
    ,o.ofixing_date -- 原始重设日
    ,o.opayment_date -- 原始支付日
    ,o.fixing_date -- 利息重设日
    ,o.is_fixing -- 利率是否已重设
    ,o.lastmodified -- 最终修改时间
    ,o.lastmodified_pay -- 实收付确认的修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_bk o
    left join ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_op n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_cl d
        on
            o.deal_id = d.deal_id
            and o.deal_name = d.deal_name
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_cl;
alter table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_payment_loancoupondeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_payment_loancoupondeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
