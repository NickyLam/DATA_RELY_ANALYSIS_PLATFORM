/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1atyhjjzfmx
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
create table ${iol_schema}.mpcs_a1atyhjjzfmx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1atyhjjzfmx;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1atyhjjzfmx_op purge;
drop table ${iol_schema}.mpcs_a1atyhjjzfmx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1atyhjjzfmx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1atyhjjzfmx where 0=1;

create table ${iol_schema}.mpcs_a1atyhjjzfmx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1atyhjjzfmx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1atyhjjzfmx_cl(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,rwlsh -- 任务流水号
            ,zh -- 账号
            ,zhzzh -- 账号子账号
            ,zzhye -- 子账号余额
            ,bz -- 币种
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已冻结 2-冻结失败 3-已解冻 4-解冻失败
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,zzhxh -- 子账号序号
            ,chbz -- 钞汇标志
            ,zfkssj -- 止付起始日期
            ,zfjssj -- 止付结束日期
            ,zxjg -- 执行结果
            ,zxjgyy -- 执行失败原因
            ,openbr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1atyhjjzfmx_op(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,rwlsh -- 任务流水号
            ,zh -- 账号
            ,zhzzh -- 账号子账号
            ,zzhye -- 子账号余额
            ,bz -- 币种
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已冻结 2-冻结失败 3-已解冻 4-解冻失败
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,zzhxh -- 子账号序号
            ,chbz -- 钞汇标志
            ,zfkssj -- 止付起始日期
            ,zfjssj -- 止付结束日期
            ,zxjg -- 执行结果
            ,zxjgyy -- 执行失败原因
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
    ,nvl(n.zh, o.zh) as zh -- 账号
    ,nvl(n.zhzzh, o.zhzzh) as zhzzh -- 账号子账号
    ,nvl(n.zzhye, o.zzhye) as zzhye -- 子账号余额
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.updttm, o.updttm) as updttm -- 更新时间
    ,nvl(n.result, o.result) as result -- 处理结果 0-录入 1-已冻结 2-冻结失败 3-已解冻 4-解冻失败
    ,nvl(n.hostdt, o.hostdt) as hostdt -- 核心交易日期
    ,nvl(n.hostseqno, o.hostseqno) as hostseqno -- 核心交易流水
    ,nvl(n.dataid, o.dataid) as dataid -- 中台流水
    ,nvl(n.zzhxh, o.zzhxh) as zzhxh -- 子账号序号
    ,nvl(n.chbz, o.chbz) as chbz -- 钞汇标志
    ,nvl(n.zfkssj, o.zfkssj) as zfkssj -- 止付起始日期
    ,nvl(n.zfjssj, o.zfjssj) as zfjssj -- 止付结束日期
    ,nvl(n.zxjg, o.zxjg) as zxjg -- 执行结果
    ,nvl(n.zxjgyy, o.zxjgyy) as zxjgyy -- 执行失败原因
    ,nvl(n.openbr, o.openbr) as openbr -- 
    ,case when
            n.rwlsh is null
            and n.zhzzh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rwlsh is null
            and n.zhzzh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rwlsh is null
            and n.zhzzh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1atyhjjzfmx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1atyhjjzfmx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rwlsh = n.rwlsh
            and o.zhzzh = n.zhzzh
where (
        o.rwlsh is null
        and o.zhzzh is null
    )
    or (
        n.rwlsh is null
        and n.zhzzh is null
    )
    or (
        o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.zh <> n.zh
        or o.zzhye <> n.zzhye
        or o.bz <> n.bz
        or o.updttm <> n.updttm
        or o.result <> n.result
        or o.hostdt <> n.hostdt
        or o.hostseqno <> n.hostseqno
        or o.dataid <> n.dataid
        or o.zzhxh <> n.zzhxh
        or o.chbz <> n.chbz
        or o.zfkssj <> n.zfkssj
        or o.zfjssj <> n.zfjssj
        or o.zxjg <> n.zxjg
        or o.zxjgyy <> n.zxjgyy
        or o.openbr <> n.openbr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1atyhjjzfmx_cl(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,rwlsh -- 任务流水号
            ,zh -- 账号
            ,zhzzh -- 账号子账号
            ,zzhye -- 子账号余额
            ,bz -- 币种
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已冻结 2-冻结失败 3-已解冻 4-解冻失败
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,zzhxh -- 子账号序号
            ,chbz -- 钞汇标志
            ,zfkssj -- 止付起始日期
            ,zfjssj -- 止付结束日期
            ,zxjg -- 执行结果
            ,zxjgyy -- 执行失败原因
            ,openbr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1atyhjjzfmx_op(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,rwlsh -- 任务流水号
            ,zh -- 账号
            ,zhzzh -- 账号子账号
            ,zzhye -- 子账号余额
            ,bz -- 币种
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已冻结 2-冻结失败 3-已解冻 4-解冻失败
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,zzhxh -- 子账号序号
            ,chbz -- 钞汇标志
            ,zfkssj -- 止付起始日期
            ,zfjssj -- 止付结束日期
            ,zxjg -- 执行结果
            ,zxjgyy -- 执行失败原因
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
    ,o.zh -- 账号
    ,o.zhzzh -- 账号子账号
    ,o.zzhye -- 子账号余额
    ,o.bz -- 币种
    ,o.updttm -- 更新时间
    ,o.result -- 处理结果 0-录入 1-已冻结 2-冻结失败 3-已解冻 4-解冻失败
    ,o.hostdt -- 核心交易日期
    ,o.hostseqno -- 核心交易流水
    ,o.dataid -- 中台流水
    ,o.zzhxh -- 子账号序号
    ,o.chbz -- 钞汇标志
    ,o.zfkssj -- 止付起始日期
    ,o.zfjssj -- 止付结束日期
    ,o.zxjg -- 执行结果
    ,o.zxjgyy -- 执行失败原因
    ,o.openbr -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a1atyhjjzfmx_bk o
    left join ${iol_schema}.mpcs_a1atyhjjzfmx_op n
        on
            o.rwlsh = n.rwlsh
            and o.zhzzh = n.zhzzh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1atyhjjzfmx_cl d
        on
            o.rwlsh = d.rwlsh
            and o.zhzzh = d.zhzzh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a1atyhjjzfmx;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a1atyhjjzfmx exchange partition p_19000101 with table ${iol_schema}.mpcs_a1atyhjjzfmx_cl;
alter table ${iol_schema}.mpcs_a1atyhjjzfmx exchange partition p_20991231 with table ${iol_schema}.mpcs_a1atyhjjzfmx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1atyhjjzfmx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1atyhjjzfmx_op purge;
drop table ${iol_schema}.mpcs_a1atyhjjzfmx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1atyhjjzfmx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1atyhjjzfmx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
