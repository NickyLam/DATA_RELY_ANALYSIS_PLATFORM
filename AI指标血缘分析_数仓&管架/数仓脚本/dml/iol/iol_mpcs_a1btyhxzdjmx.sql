/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1btyhxzdjmx
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
create table ${iol_schema}.mpcs_a1btyhxzdjmx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1btyhxzdjmx;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1btyhxzdjmx_op purge;
drop table ${iol_schema}.mpcs_a1btyhxzdjmx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1btyhxzdjmx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1btyhxzdjmx where 0=1;

create table ${iol_schema}.mpcs_a1btyhxzdjmx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1btyhxzdjmx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1btyhxzdjmx_cl(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,rwlsh -- 任务流水号
            ,yrwlsh -- 原任务流水号
            ,zh -- 卡号
            ,zhzzh -- 账号子账号
            ,zzhye -- 子账号余额
            ,bz -- 币种
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入;1-已冻结/续冻/解冻;2-冻结/续冻/解冻失败;5-金额超限
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,zzhxh -- 子账号序号
            ,djkssj -- 冻结开始时间
            ,djjssj -- 冻结结束时间
            ,chbz -- 钞汇标志
            ,zxjg -- 执行结果
            ,zxjgyy -- 执行失败原因
            ,djjg -- 在先冻结机关
            ,zxdjje -- 在先冻结金额
            ,djjzrq -- 在先冻结到期日
            ,wdjje -- 未冻结金额
            ,djje -- 未冻结金额
            ,openbr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1btyhxzdjmx_op(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,rwlsh -- 任务流水号
            ,yrwlsh -- 原任务流水号
            ,zh -- 卡号
            ,zhzzh -- 账号子账号
            ,zzhye -- 子账号余额
            ,bz -- 币种
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入;1-已冻结/续冻/解冻;2-冻结/续冻/解冻失败;5-金额超限
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,zzhxh -- 子账号序号
            ,djkssj -- 冻结开始时间
            ,djjssj -- 冻结结束时间
            ,chbz -- 钞汇标志
            ,zxjg -- 执行结果
            ,zxjgyy -- 执行失败原因
            ,djjg -- 在先冻结机关
            ,zxdjje -- 在先冻结金额
            ,djjzrq -- 在先冻结到期日
            ,wdjje -- 未冻结金额
            ,djje -- 未冻结金额
            ,openbr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transdt, o.transdt) as transdt -- 登记日期
    ,nvl(n.transtm, o.transtm) as transtm -- 登记时间
    ,nvl(n.rwlsh, o.rwlsh) as rwlsh -- 任务流水号
    ,nvl(n.yrwlsh, o.yrwlsh) as yrwlsh -- 原任务流水号
    ,nvl(n.zh, o.zh) as zh -- 卡号
    ,nvl(n.zhzzh, o.zhzzh) as zhzzh -- 账号子账号
    ,nvl(n.zzhye, o.zzhye) as zzhye -- 子账号余额
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.updttm, o.updttm) as updttm -- 更新时间
    ,nvl(n.result, o.result) as result -- 处理结果 0-录入;1-已冻结/续冻/解冻;2-冻结/续冻/解冻失败;5-金额超限
    ,nvl(n.hostdt, o.hostdt) as hostdt -- 核心交易日期
    ,nvl(n.hostseqno, o.hostseqno) as hostseqno -- 核心交易流水
    ,nvl(n.dataid, o.dataid) as dataid -- 中台流水
    ,nvl(n.zzhxh, o.zzhxh) as zzhxh -- 子账号序号
    ,nvl(n.djkssj, o.djkssj) as djkssj -- 冻结开始时间
    ,nvl(n.djjssj, o.djjssj) as djjssj -- 冻结结束时间
    ,nvl(n.chbz, o.chbz) as chbz -- 钞汇标志
    ,nvl(n.zxjg, o.zxjg) as zxjg -- 执行结果
    ,nvl(n.zxjgyy, o.zxjgyy) as zxjgyy -- 执行失败原因
    ,nvl(n.djjg, o.djjg) as djjg -- 在先冻结机关
    ,nvl(n.zxdjje, o.zxdjje) as zxdjje -- 在先冻结金额
    ,nvl(n.djjzrq, o.djjzrq) as djjzrq -- 在先冻结到期日
    ,nvl(n.wdjje, o.wdjje) as wdjje -- 未冻结金额
    ,nvl(n.djje, o.djje) as djje -- 未冻结金额
    ,nvl(n.openbr, o.openbr) as openbr -- 
    ,case when
            n.rwlsh is null
            and n.zhzzh is null
            and n.zzhxh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rwlsh is null
            and n.zhzzh is null
            and n.zzhxh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rwlsh is null
            and n.zhzzh is null
            and n.zzhxh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1btyhxzdjmx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1btyhxzdjmx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rwlsh = n.rwlsh
            and o.zhzzh = n.zhzzh
            and o.zzhxh = n.zzhxh
where (
        o.rwlsh is null
        and o.zhzzh is null
        and o.zzhxh is null
    )
    or (
        n.rwlsh is null
        and n.zhzzh is null
        and n.zzhxh is null
    )
    or (
        o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.yrwlsh <> n.yrwlsh
        or o.zh <> n.zh
        or o.zzhye <> n.zzhye
        or o.bz <> n.bz
        or o.updttm <> n.updttm
        or o.result <> n.result
        or o.hostdt <> n.hostdt
        or o.hostseqno <> n.hostseqno
        or o.dataid <> n.dataid
        or o.djkssj <> n.djkssj
        or o.djjssj <> n.djjssj
        or o.chbz <> n.chbz
        or o.zxjg <> n.zxjg
        or o.zxjgyy <> n.zxjgyy
        or o.djjg <> n.djjg
        or o.zxdjje <> n.zxdjje
        or o.djjzrq <> n.djjzrq
        or o.wdjje <> n.wdjje
        or o.djje <> n.djje
        or o.openbr <> n.openbr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1btyhxzdjmx_cl(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,rwlsh -- 任务流水号
            ,yrwlsh -- 原任务流水号
            ,zh -- 卡号
            ,zhzzh -- 账号子账号
            ,zzhye -- 子账号余额
            ,bz -- 币种
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入;1-已冻结/续冻/解冻;2-冻结/续冻/解冻失败;5-金额超限
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,zzhxh -- 子账号序号
            ,djkssj -- 冻结开始时间
            ,djjssj -- 冻结结束时间
            ,chbz -- 钞汇标志
            ,zxjg -- 执行结果
            ,zxjgyy -- 执行失败原因
            ,djjg -- 在先冻结机关
            ,zxdjje -- 在先冻结金额
            ,djjzrq -- 在先冻结到期日
            ,wdjje -- 未冻结金额
            ,djje -- 未冻结金额
            ,openbr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1btyhxzdjmx_op(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,rwlsh -- 任务流水号
            ,yrwlsh -- 原任务流水号
            ,zh -- 卡号
            ,zhzzh -- 账号子账号
            ,zzhye -- 子账号余额
            ,bz -- 币种
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入;1-已冻结/续冻/解冻;2-冻结/续冻/解冻失败;5-金额超限
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,zzhxh -- 子账号序号
            ,djkssj -- 冻结开始时间
            ,djjssj -- 冻结结束时间
            ,chbz -- 钞汇标志
            ,zxjg -- 执行结果
            ,zxjgyy -- 执行失败原因
            ,djjg -- 在先冻结机关
            ,zxdjje -- 在先冻结金额
            ,djjzrq -- 在先冻结到期日
            ,wdjje -- 未冻结金额
            ,djje -- 未冻结金额
            ,openbr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transdt -- 登记日期
    ,o.transtm -- 登记时间
    ,o.rwlsh -- 任务流水号
    ,o.yrwlsh -- 原任务流水号
    ,o.zh -- 卡号
    ,o.zhzzh -- 账号子账号
    ,o.zzhye -- 子账号余额
    ,o.bz -- 币种
    ,o.updttm -- 更新时间
    ,o.result -- 处理结果 0-录入;1-已冻结/续冻/解冻;2-冻结/续冻/解冻失败;5-金额超限
    ,o.hostdt -- 核心交易日期
    ,o.hostseqno -- 核心交易流水
    ,o.dataid -- 中台流水
    ,o.zzhxh -- 子账号序号
    ,o.djkssj -- 冻结开始时间
    ,o.djjssj -- 冻结结束时间
    ,o.chbz -- 钞汇标志
    ,o.zxjg -- 执行结果
    ,o.zxjgyy -- 执行失败原因
    ,o.djjg -- 在先冻结机关
    ,o.zxdjje -- 在先冻结金额
    ,o.djjzrq -- 在先冻结到期日
    ,o.wdjje -- 未冻结金额
    ,o.djje -- 未冻结金额
    ,o.openbr -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a1btyhxzdjmx_bk o
    left join ${iol_schema}.mpcs_a1btyhxzdjmx_op n
        on
            o.rwlsh = n.rwlsh
            and o.zhzzh = n.zhzzh
            and o.zzhxh = n.zzhxh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1btyhxzdjmx_cl d
        on
            o.rwlsh = d.rwlsh
            and o.zhzzh = d.zhzzh
            and o.zzhxh = d.zzhxh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a1btyhxzdjmx;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a1btyhxzdjmx exchange partition p_19000101 with table ${iol_schema}.mpcs_a1btyhxzdjmx_cl;
alter table ${iol_schema}.mpcs_a1btyhxzdjmx exchange partition p_20991231 with table ${iol_schema}.mpcs_a1btyhxzdjmx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1btyhxzdjmx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1btyhxzdjmx_op purge;
drop table ${iol_schema}.mpcs_a1btyhxzdjmx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1btyhxzdjmx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1btyhxzdjmx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
