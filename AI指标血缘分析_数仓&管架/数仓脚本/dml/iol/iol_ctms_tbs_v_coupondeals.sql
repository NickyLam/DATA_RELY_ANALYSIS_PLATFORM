/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_coupondeals
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
create table ${iol_schema}.ctms_tbs_v_coupondeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_coupondeals;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_coupondeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_coupondeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_coupondeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_coupondeals where 0=1;

create table ${iol_schema}.ctms_tbs_v_coupondeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_coupondeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_coupondeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,balance_id -- 引用表2ID
            ,paydate -- 还本付息日期
            ,keepfolder_id -- 账户ID
            ,assettype -- 资产类别
            ,bondscode -- 债券代码
            ,coupontype -- 本息类型
            ,principalamount -- 还本金额
            ,interestamount -- 付息金额
            ,lastmodified -- 最后修改时间
            ,act_paydate -- 实际支付日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_coupondeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,balance_id -- 引用表2ID
            ,paydate -- 还本付息日期
            ,keepfolder_id -- 账户ID
            ,assettype -- 资产类别
            ,bondscode -- 债券代码
            ,coupontype -- 本息类型
            ,principalamount -- 还本金额
            ,interestamount -- 付息金额
            ,lastmodified -- 最后修改时间
            ,act_paydate -- 实际支付日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_name, o.deal_name) as deal_name -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.balance_id, o.balance_id) as balance_id -- 引用表2ID
    ,nvl(n.paydate, o.paydate) as paydate -- 还本付息日期
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类别
    ,nvl(n.bondscode, o.bondscode) as bondscode -- 债券代码
    ,nvl(n.coupontype, o.coupontype) as coupontype -- 本息类型
    ,nvl(n.principalamount, o.principalamount) as principalamount -- 还本金额
    ,nvl(n.interestamount, o.interestamount) as interestamount -- 付息金额
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.act_paydate, o.act_paydate) as act_paydate -- 实际支付日
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
from (select * from ${iol_schema}.ctms_tbs_v_coupondeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_coupondeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.balance_id <> n.balance_id
        or o.paydate <> n.paydate
        or o.keepfolder_id <> n.keepfolder_id
        or o.assettype <> n.assettype
        or o.bondscode <> n.bondscode
        or o.coupontype <> n.coupontype
        or o.principalamount <> n.principalamount
        or o.interestamount <> n.interestamount
        or o.lastmodified <> n.lastmodified
        or o.act_paydate <> n.act_paydate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_coupondeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,balance_id -- 引用表2ID
            ,paydate -- 还本付息日期
            ,keepfolder_id -- 账户ID
            ,assettype -- 资产类别
            ,bondscode -- 债券代码
            ,coupontype -- 本息类型
            ,principalamount -- 还本金额
            ,interestamount -- 付息金额
            ,lastmodified -- 最后修改时间
            ,act_paydate -- 实际支付日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_coupondeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,balance_id -- 引用表2ID
            ,paydate -- 还本付息日期
            ,keepfolder_id -- 账户ID
            ,assettype -- 资产类别
            ,bondscode -- 债券代码
            ,coupontype -- 本息类型
            ,principalamount -- 还本金额
            ,interestamount -- 付息金额
            ,lastmodified -- 最后修改时间
            ,act_paydate -- 实际支付日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_name -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.balance_id -- 引用表2ID
    ,o.paydate -- 还本付息日期
    ,o.keepfolder_id -- 账户ID
    ,o.assettype -- 资产类别
    ,o.bondscode -- 债券代码
    ,o.coupontype -- 本息类型
    ,o.principalamount -- 还本金额
    ,o.interestamount -- 付息金额
    ,o.lastmodified -- 最后修改时间
    ,o.act_paydate -- 实际支付日
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_coupondeals_bk o
    left join ${iol_schema}.ctms_tbs_v_coupondeals_op n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_coupondeals_cl d
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
-- truncate table ${iol_schema}.ctms_tbs_v_coupondeals;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_coupondeals exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_coupondeals_cl;
alter table ${iol_schema}.ctms_tbs_v_coupondeals exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_coupondeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_coupondeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_coupondeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_coupondeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_coupondeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_coupondeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
