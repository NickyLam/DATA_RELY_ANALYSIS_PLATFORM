/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1btyhxzdj
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
create table ${iol_schema}.mpcs_a1btyhxzdj_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1btyhxzdj;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1btyhxzdj_op purge;
drop table ${iol_schema}.mpcs_a1btyhxzdj_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1btyhxzdj_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1btyhxzdj where 0=1;

create table ${iol_schema}.mpcs_a1btyhxzdj_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1btyhxzdj where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1btyhxzdj_cl(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,qqdbs -- 请求单标识
            ,rwlsh -- 任务流水号
            ,yrwlsh -- 原任务流水号
            ,djzhhz -- 冻结账户户主
            ,zzlxdm -- 证件类型代码
            ,zzhm -- 证件号码
            ,zh -- 冻结账卡号
            ,zhxh -- 账户序号
            ,djfs -- 冻结方式 01-限额内冻结 02-只收不付
            ,je -- 金额
            ,bz -- 币种
            ,kssj -- 开始时间
            ,jssj -- 结束时间
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
            ,tradetype -- 交易类型 1-冻结 2-续冻 3-解冻
            ,ischeck -- 分行以上是否已复核  0-否 1-是
            ,isprocess -- 是否已查询开户行   0-否 1-是
            ,tlrno -- 经办柜员
            ,ckbkus -- 授权柜员
            ,dealtm -- 处理时间
            ,errormsg -- 错误信息
            ,openbr -- 开户机构
            ,pckno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1btyhxzdj_op(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,qqdbs -- 请求单标识
            ,rwlsh -- 任务流水号
            ,yrwlsh -- 原任务流水号
            ,djzhhz -- 冻结账户户主
            ,zzlxdm -- 证件类型代码
            ,zzhm -- 证件号码
            ,zh -- 冻结账卡号
            ,zhxh -- 账户序号
            ,djfs -- 冻结方式 01-限额内冻结 02-只收不付
            ,je -- 金额
            ,bz -- 币种
            ,kssj -- 开始时间
            ,jssj -- 结束时间
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
            ,tradetype -- 交易类型 1-冻结 2-续冻 3-解冻
            ,ischeck -- 分行以上是否已复核  0-否 1-是
            ,isprocess -- 是否已查询开户行   0-否 1-是
            ,tlrno -- 经办柜员
            ,ckbkus -- 授权柜员
            ,dealtm -- 处理时间
            ,errormsg -- 错误信息
            ,openbr -- 开户机构
            ,pckno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transdt, o.transdt) as transdt -- 登记日期
    ,nvl(n.transtm, o.transtm) as transtm -- 登记时间
    ,nvl(n.qqdbs, o.qqdbs) as qqdbs -- 请求单标识
    ,nvl(n.rwlsh, o.rwlsh) as rwlsh -- 任务流水号
    ,nvl(n.yrwlsh, o.yrwlsh) as yrwlsh -- 原任务流水号
    ,nvl(n.djzhhz, o.djzhhz) as djzhhz -- 冻结账户户主
    ,nvl(n.zzlxdm, o.zzlxdm) as zzlxdm -- 证件类型代码
    ,nvl(n.zzhm, o.zzhm) as zzhm -- 证件号码
    ,nvl(n.zh, o.zh) as zh -- 冻结账卡号
    ,nvl(n.zhxh, o.zhxh) as zhxh -- 账户序号
    ,nvl(n.djfs, o.djfs) as djfs -- 冻结方式 01-限额内冻结 02-只收不付
    ,nvl(n.je, o.je) as je -- 金额
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.kssj, o.kssj) as kssj -- 开始时间
    ,nvl(n.jssj, o.jssj) as jssj -- 结束时间
    ,nvl(n.updttm, o.updttm) as updttm -- 更新时间
    ,nvl(n.result, o.result) as result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
    ,nvl(n.tradetype, o.tradetype) as tradetype -- 交易类型 1-冻结 2-续冻 3-解冻
    ,nvl(n.ischeck, o.ischeck) as ischeck -- 分行以上是否已复核  0-否 1-是
    ,nvl(n.isprocess, o.isprocess) as isprocess -- 是否已查询开户行   0-否 1-是
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 经办柜员
    ,nvl(n.ckbkus, o.ckbkus) as ckbkus -- 授权柜员
    ,nvl(n.dealtm, o.dealtm) as dealtm -- 处理时间
    ,nvl(n.errormsg, o.errormsg) as errormsg -- 错误信息
    ,nvl(n.openbr, o.openbr) as openbr -- 开户机构
    ,nvl(n.pckno, o.pckno) as pckno -- 
    ,case when
            n.qqdbs is null
            and n.rwlsh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.qqdbs is null
            and n.rwlsh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.qqdbs is null
            and n.rwlsh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1btyhxzdj_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1btyhxzdj where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.qqdbs = n.qqdbs
            and o.rwlsh = n.rwlsh
where (
        o.qqdbs is null
        and o.rwlsh is null
    )
    or (
        n.qqdbs is null
        and n.rwlsh is null
    )
    or (
        o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.yrwlsh <> n.yrwlsh
        or o.djzhhz <> n.djzhhz
        or o.zzlxdm <> n.zzlxdm
        or o.zzhm <> n.zzhm
        or o.zh <> n.zh
        or o.zhxh <> n.zhxh
        or o.djfs <> n.djfs
        or o.je <> n.je
        or o.bz <> n.bz
        or o.kssj <> n.kssj
        or o.jssj <> n.jssj
        or o.updttm <> n.updttm
        or o.result <> n.result
        or o.tradetype <> n.tradetype
        or o.ischeck <> n.ischeck
        or o.isprocess <> n.isprocess
        or o.tlrno <> n.tlrno
        or o.ckbkus <> n.ckbkus
        or o.dealtm <> n.dealtm
        or o.errormsg <> n.errormsg
        or o.openbr <> n.openbr
        or o.pckno <> n.pckno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1btyhxzdj_cl(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,qqdbs -- 请求单标识
            ,rwlsh -- 任务流水号
            ,yrwlsh -- 原任务流水号
            ,djzhhz -- 冻结账户户主
            ,zzlxdm -- 证件类型代码
            ,zzhm -- 证件号码
            ,zh -- 冻结账卡号
            ,zhxh -- 账户序号
            ,djfs -- 冻结方式 01-限额内冻结 02-只收不付
            ,je -- 金额
            ,bz -- 币种
            ,kssj -- 开始时间
            ,jssj -- 结束时间
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
            ,tradetype -- 交易类型 1-冻结 2-续冻 3-解冻
            ,ischeck -- 分行以上是否已复核  0-否 1-是
            ,isprocess -- 是否已查询开户行   0-否 1-是
            ,tlrno -- 经办柜员
            ,ckbkus -- 授权柜员
            ,dealtm -- 处理时间
            ,errormsg -- 错误信息
            ,openbr -- 开户机构
            ,pckno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1btyhxzdj_op(
            transdt -- 登记日期
            ,transtm -- 登记时间
            ,qqdbs -- 请求单标识
            ,rwlsh -- 任务流水号
            ,yrwlsh -- 原任务流水号
            ,djzhhz -- 冻结账户户主
            ,zzlxdm -- 证件类型代码
            ,zzhm -- 证件号码
            ,zh -- 冻结账卡号
            ,zhxh -- 账户序号
            ,djfs -- 冻结方式 01-限额内冻结 02-只收不付
            ,je -- 金额
            ,bz -- 币种
            ,kssj -- 开始时间
            ,jssj -- 结束时间
            ,updttm -- 更新时间
            ,result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
            ,tradetype -- 交易类型 1-冻结 2-续冻 3-解冻
            ,ischeck -- 分行以上是否已复核  0-否 1-是
            ,isprocess -- 是否已查询开户行   0-否 1-是
            ,tlrno -- 经办柜员
            ,ckbkus -- 授权柜员
            ,dealtm -- 处理时间
            ,errormsg -- 错误信息
            ,openbr -- 开户机构
            ,pckno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transdt -- 登记日期
    ,o.transtm -- 登记时间
    ,o.qqdbs -- 请求单标识
    ,o.rwlsh -- 任务流水号
    ,o.yrwlsh -- 原任务流水号
    ,o.djzhhz -- 冻结账户户主
    ,o.zzlxdm -- 证件类型代码
    ,o.zzhm -- 证件号码
    ,o.zh -- 冻结账卡号
    ,o.zhxh -- 账户序号
    ,o.djfs -- 冻结方式 01-限额内冻结 02-只收不付
    ,o.je -- 金额
    ,o.bz -- 币种
    ,o.kssj -- 开始时间
    ,o.jssj -- 结束时间
    ,o.updttm -- 更新时间
    ,o.result -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
    ,o.tradetype -- 交易类型 1-冻结 2-续冻 3-解冻
    ,o.ischeck -- 分行以上是否已复核  0-否 1-是
    ,o.isprocess -- 是否已查询开户行   0-否 1-是
    ,o.tlrno -- 经办柜员
    ,o.ckbkus -- 授权柜员
    ,o.dealtm -- 处理时间
    ,o.errormsg -- 错误信息
    ,o.openbr -- 开户机构
    ,o.pckno -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a1btyhxzdj_bk o
    left join ${iol_schema}.mpcs_a1btyhxzdj_op n
        on
            o.qqdbs = n.qqdbs
            and o.rwlsh = n.rwlsh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1btyhxzdj_cl d
        on
            o.qqdbs = d.qqdbs
            and o.rwlsh = d.rwlsh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a1btyhxzdj;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a1btyhxzdj exchange partition p_19000101 with table ${iol_schema}.mpcs_a1btyhxzdj_cl;
alter table ${iol_schema}.mpcs_a1btyhxzdj exchange partition p_20991231 with table ${iol_schema}.mpcs_a1btyhxzdj_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1btyhxzdj to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1btyhxzdj_op purge;
drop table ${iol_schema}.mpcs_a1btyhxzdj_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1btyhxzdj_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1btyhxzdj',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
