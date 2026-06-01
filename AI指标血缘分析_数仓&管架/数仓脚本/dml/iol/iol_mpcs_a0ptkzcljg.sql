/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ptkzcljg
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
create table ${iol_schema}.mpcs_a0ptkzcljg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ptkzcljg;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ptkzcljg_op purge;
drop table ${iol_schema}.mpcs_a0ptkzcljg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ptkzcljg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ptkzcljg where 0=1;

create table ${iol_schema}.mpcs_a0ptkzcljg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ptkzcljg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ptkzcljg_cl(
            bdhm -- 控制请求单号
            ,ccxh -- 序号
            ,khzh -- 开户账号
            ,kznr -- 控制内容 1-资金  2-账户
            ,kzzt -- 控制结果 1-已控  2-未控
            ,ye -- 账户余额
            ,kyye -- 可用余额
            ,csksrq -- 措施始期
            ,csjsrq -- 措施终期
            ,djxe -- 冻结限额
            ,skje -- 实际控制可用金额
            ,ceskje -- 超额控制金额
            ,wnkzyy -- 未能控制原因
            ,beiz -- 备注
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,openbr -- 开立机构
            ,diskno -- 批次号
            ,lcseqno -- 中台发送流水
            ,lcdate -- 理财冻结日期
            ,jrcpbh -- 金融产品编号
            ,lczh -- 理财账号
            ,skse -- 理财控制金额
            ,serialno -- 理财控制流水
            ,assoserial -- 理财原控制流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ptkzcljg_op(
            bdhm -- 控制请求单号
            ,ccxh -- 序号
            ,khzh -- 开户账号
            ,kznr -- 控制内容 1-资金  2-账户
            ,kzzt -- 控制结果 1-已控  2-未控
            ,ye -- 账户余额
            ,kyye -- 可用余额
            ,csksrq -- 措施始期
            ,csjsrq -- 措施终期
            ,djxe -- 冻结限额
            ,skje -- 实际控制可用金额
            ,ceskje -- 超额控制金额
            ,wnkzyy -- 未能控制原因
            ,beiz -- 备注
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,openbr -- 开立机构
            ,diskno -- 批次号
            ,lcseqno -- 中台发送流水
            ,lcdate -- 理财冻结日期
            ,jrcpbh -- 金融产品编号
            ,lczh -- 理财账号
            ,skse -- 理财控制金额
            ,serialno -- 理财控制流水
            ,assoserial -- 理财原控制流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bdhm, o.bdhm) as bdhm -- 控制请求单号
    ,nvl(n.ccxh, o.ccxh) as ccxh -- 序号
    ,nvl(n.khzh, o.khzh) as khzh -- 开户账号
    ,nvl(n.kznr, o.kznr) as kznr -- 控制内容 1-资金  2-账户
    ,nvl(n.kzzt, o.kzzt) as kzzt -- 控制结果 1-已控  2-未控
    ,nvl(n.ye, o.ye) as ye -- 账户余额
    ,nvl(n.kyye, o.kyye) as kyye -- 可用余额
    ,nvl(n.csksrq, o.csksrq) as csksrq -- 措施始期
    ,nvl(n.csjsrq, o.csjsrq) as csjsrq -- 措施终期
    ,nvl(n.djxe, o.djxe) as djxe -- 冻结限额
    ,nvl(n.skje, o.skje) as skje -- 实际控制可用金额
    ,nvl(n.ceskje, o.ceskje) as ceskje -- 超额控制金额
    ,nvl(n.wnkzyy, o.wnkzyy) as wnkzyy -- 未能控制原因
    ,nvl(n.beiz, o.beiz) as beiz -- 备注
    ,nvl(n.hostdt, o.hostdt) as hostdt -- 核心交易日期
    ,nvl(n.hostseqno, o.hostseqno) as hostseqno -- 核心交易流水
    ,nvl(n.dataid, o.dataid) as dataid -- 中台流水
    ,nvl(n.openbr, o.openbr) as openbr -- 开立机构
    ,nvl(n.diskno, o.diskno) as diskno -- 批次号
    ,nvl(n.lcseqno, o.lcseqno) as lcseqno -- 中台发送流水
    ,nvl(n.lcdate, o.lcdate) as lcdate -- 理财冻结日期
    ,nvl(n.jrcpbh, o.jrcpbh) as jrcpbh -- 金融产品编号
    ,nvl(n.lczh, o.lczh) as lczh -- 理财账号
    ,nvl(n.skse, o.skse) as skse -- 理财控制金额
    ,nvl(n.serialno, o.serialno) as serialno -- 理财控制流水
    ,nvl(n.assoserial, o.assoserial) as assoserial -- 理财原控制流水
    ,case when
            n.bdhm is null
            and n.ccxh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bdhm is null
            and n.ccxh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bdhm is null
            and n.ccxh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0ptkzcljg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0ptkzcljg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bdhm = n.bdhm
            and o.ccxh = n.ccxh
where (
        o.bdhm is null
        and o.ccxh is null
    )
    or (
        n.bdhm is null
        and n.ccxh is null
    )
    or (
        o.khzh <> n.khzh
        or o.kznr <> n.kznr
        or o.kzzt <> n.kzzt
        or o.ye <> n.ye
        or o.kyye <> n.kyye
        or o.csksrq <> n.csksrq
        or o.csjsrq <> n.csjsrq
        or o.djxe <> n.djxe
        or o.skje <> n.skje
        or o.ceskje <> n.ceskje
        or o.wnkzyy <> n.wnkzyy
        or o.beiz <> n.beiz
        or o.hostdt <> n.hostdt
        or o.hostseqno <> n.hostseqno
        or o.dataid <> n.dataid
        or o.openbr <> n.openbr
        or o.diskno <> n.diskno
        or o.lcseqno <> n.lcseqno
        or o.lcdate <> n.lcdate
        or o.jrcpbh <> n.jrcpbh
        or o.lczh <> n.lczh
        or o.skse <> n.skse
        or o.serialno <> n.serialno
        or o.assoserial <> n.assoserial
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ptkzcljg_cl(
            bdhm -- 控制请求单号
            ,ccxh -- 序号
            ,khzh -- 开户账号
            ,kznr -- 控制内容 1-资金  2-账户
            ,kzzt -- 控制结果 1-已控  2-未控
            ,ye -- 账户余额
            ,kyye -- 可用余额
            ,csksrq -- 措施始期
            ,csjsrq -- 措施终期
            ,djxe -- 冻结限额
            ,skje -- 实际控制可用金额
            ,ceskje -- 超额控制金额
            ,wnkzyy -- 未能控制原因
            ,beiz -- 备注
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,openbr -- 开立机构
            ,diskno -- 批次号
            ,lcseqno -- 中台发送流水
            ,lcdate -- 理财冻结日期
            ,jrcpbh -- 金融产品编号
            ,lczh -- 理财账号
            ,skse -- 理财控制金额
            ,serialno -- 理财控制流水
            ,assoserial -- 理财原控制流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ptkzcljg_op(
            bdhm -- 控制请求单号
            ,ccxh -- 序号
            ,khzh -- 开户账号
            ,kznr -- 控制内容 1-资金  2-账户
            ,kzzt -- 控制结果 1-已控  2-未控
            ,ye -- 账户余额
            ,kyye -- 可用余额
            ,csksrq -- 措施始期
            ,csjsrq -- 措施终期
            ,djxe -- 冻结限额
            ,skje -- 实际控制可用金额
            ,ceskje -- 超额控制金额
            ,wnkzyy -- 未能控制原因
            ,beiz -- 备注
            ,hostdt -- 核心交易日期
            ,hostseqno -- 核心交易流水
            ,dataid -- 中台流水
            ,openbr -- 开立机构
            ,diskno -- 批次号
            ,lcseqno -- 中台发送流水
            ,lcdate -- 理财冻结日期
            ,jrcpbh -- 金融产品编号
            ,lczh -- 理财账号
            ,skse -- 理财控制金额
            ,serialno -- 理财控制流水
            ,assoserial -- 理财原控制流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bdhm -- 控制请求单号
    ,o.ccxh -- 序号
    ,o.khzh -- 开户账号
    ,o.kznr -- 控制内容 1-资金  2-账户
    ,o.kzzt -- 控制结果 1-已控  2-未控
    ,o.ye -- 账户余额
    ,o.kyye -- 可用余额
    ,o.csksrq -- 措施始期
    ,o.csjsrq -- 措施终期
    ,o.djxe -- 冻结限额
    ,o.skje -- 实际控制可用金额
    ,o.ceskje -- 超额控制金额
    ,o.wnkzyy -- 未能控制原因
    ,o.beiz -- 备注
    ,o.hostdt -- 核心交易日期
    ,o.hostseqno -- 核心交易流水
    ,o.dataid -- 中台流水
    ,o.openbr -- 开立机构
    ,o.diskno -- 批次号
    ,o.lcseqno -- 中台发送流水
    ,o.lcdate -- 理财冻结日期
    ,o.jrcpbh -- 金融产品编号
    ,o.lczh -- 理财账号
    ,o.skse -- 理财控制金额
    ,o.serialno -- 理财控制流水
    ,o.assoserial -- 理财原控制流水
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0ptkzcljg_bk o
    left join ${iol_schema}.mpcs_a0ptkzcljg_op n
        on
            o.bdhm = n.bdhm
            and o.ccxh = n.ccxh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0ptkzcljg_cl d
        on
            o.bdhm = d.bdhm
            and o.ccxh = d.ccxh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a0ptkzcljg;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0ptkzcljg exchange partition p_19000101 with table ${iol_schema}.mpcs_a0ptkzcljg_cl;
alter table ${iol_schema}.mpcs_a0ptkzcljg exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ptkzcljg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ptkzcljg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ptkzcljg_op purge;
drop table ${iol_schema}.mpcs_a0ptkzcljg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ptkzcljg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ptkzcljg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
