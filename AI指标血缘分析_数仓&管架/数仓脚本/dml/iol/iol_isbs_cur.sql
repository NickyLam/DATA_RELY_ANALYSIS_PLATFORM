/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_cur
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
create table ${iol_schema}.isbs_cur_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_cur;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cur_op purge;
drop table ${iol_schema}.isbs_cur_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cur_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cur where 0=1;

create table ${iol_schema}.isbs_cur_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cur where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cur_cl(
            inr -- 唯一INR
            ,cod -- 货币种类
            ,newcur -- 自定义的货币种类
            ,altcod -- 可替换币种
            ,dec -- 货币小数位
            ,seq -- 利率录入操作列表
            ,acc1 -- 账户兑换币种
            ,acc2 -- 柜台账户兑换币种
            ,bsrmar -- 与中间价的差数
            ,sqrmar -- 与调整价的差数
            ,glbrat -- 账户平均汇率
            ,dif -- 汇率最大浮动值
            ,bas -- 基础汇率
            ,rndunt -- Rounding Unit of Currency
            ,begdat -- 开始时间
            ,enddat -- 结束时间
            ,odrintday -- 汇率插入日期
            ,dbtday -- 借贷起息日
            ,cdtday -- 信贷起息日
            ,maxcur -- 币种
            ,maxamt -- 最大金额
            ,ver -- 版本号
            ,etgextkey -- 实体组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cur_op(
            inr -- 唯一INR
            ,cod -- 货币种类
            ,newcur -- 自定义的货币种类
            ,altcod -- 可替换币种
            ,dec -- 货币小数位
            ,seq -- 利率录入操作列表
            ,acc1 -- 账户兑换币种
            ,acc2 -- 柜台账户兑换币种
            ,bsrmar -- 与中间价的差数
            ,sqrmar -- 与调整价的差数
            ,glbrat -- 账户平均汇率
            ,dif -- 汇率最大浮动值
            ,bas -- 基础汇率
            ,rndunt -- Rounding Unit of Currency
            ,begdat -- 开始时间
            ,enddat -- 结束时间
            ,odrintday -- 汇率插入日期
            ,dbtday -- 借贷起息日
            ,cdtday -- 信贷起息日
            ,maxcur -- 币种
            ,maxamt -- 最大金额
            ,ver -- 版本号
            ,etgextkey -- 实体组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 唯一INR
    ,nvl(n.cod, o.cod) as cod -- 货币种类
    ,nvl(n.newcur, o.newcur) as newcur -- 自定义的货币种类
    ,nvl(n.altcod, o.altcod) as altcod -- 可替换币种
    ,nvl(n.dec, o.dec) as dec -- 货币小数位
    ,nvl(n.seq, o.seq) as seq -- 利率录入操作列表
    ,nvl(n.acc1, o.acc1) as acc1 -- 账户兑换币种
    ,nvl(n.acc2, o.acc2) as acc2 -- 柜台账户兑换币种
    ,nvl(n.bsrmar, o.bsrmar) as bsrmar -- 与中间价的差数
    ,nvl(n.sqrmar, o.sqrmar) as sqrmar -- 与调整价的差数
    ,nvl(n.glbrat, o.glbrat) as glbrat -- 账户平均汇率
    ,nvl(n.dif, o.dif) as dif -- 汇率最大浮动值
    ,nvl(n.bas, o.bas) as bas -- 基础汇率
    ,nvl(n.rndunt, o.rndunt) as rndunt -- Rounding Unit of Currency
    ,nvl(n.begdat, o.begdat) as begdat -- 开始时间
    ,nvl(n.enddat, o.enddat) as enddat -- 结束时间
    ,nvl(n.odrintday, o.odrintday) as odrintday -- 汇率插入日期
    ,nvl(n.dbtday, o.dbtday) as dbtday -- 借贷起息日
    ,nvl(n.cdtday, o.cdtday) as cdtday -- 信贷起息日
    ,nvl(n.maxcur, o.maxcur) as maxcur -- 币种
    ,nvl(n.maxamt, o.maxamt) as maxamt -- 最大金额
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 实体组
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_cur_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_cur where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.cod <> n.cod
        or o.newcur <> n.newcur
        or o.altcod <> n.altcod
        or o.dec <> n.dec
        or o.seq <> n.seq
        or o.acc1 <> n.acc1
        or o.acc2 <> n.acc2
        or o.bsrmar <> n.bsrmar
        or o.sqrmar <> n.sqrmar
        or o.glbrat <> n.glbrat
        or o.dif <> n.dif
        or o.bas <> n.bas
        or o.rndunt <> n.rndunt
        or o.begdat <> n.begdat
        or o.enddat <> n.enddat
        or o.odrintday <> n.odrintday
        or o.dbtday <> n.dbtday
        or o.cdtday <> n.cdtday
        or o.maxcur <> n.maxcur
        or o.maxamt <> n.maxamt
        or o.ver <> n.ver
        or o.etgextkey <> n.etgextkey
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cur_cl(
            inr -- 唯一INR
            ,cod -- 货币种类
            ,newcur -- 自定义的货币种类
            ,altcod -- 可替换币种
            ,dec -- 货币小数位
            ,seq -- 利率录入操作列表
            ,acc1 -- 账户兑换币种
            ,acc2 -- 柜台账户兑换币种
            ,bsrmar -- 与中间价的差数
            ,sqrmar -- 与调整价的差数
            ,glbrat -- 账户平均汇率
            ,dif -- 汇率最大浮动值
            ,bas -- 基础汇率
            ,rndunt -- Rounding Unit of Currency
            ,begdat -- 开始时间
            ,enddat -- 结束时间
            ,odrintday -- 汇率插入日期
            ,dbtday -- 借贷起息日
            ,cdtday -- 信贷起息日
            ,maxcur -- 币种
            ,maxamt -- 最大金额
            ,ver -- 版本号
            ,etgextkey -- 实体组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cur_op(
            inr -- 唯一INR
            ,cod -- 货币种类
            ,newcur -- 自定义的货币种类
            ,altcod -- 可替换币种
            ,dec -- 货币小数位
            ,seq -- 利率录入操作列表
            ,acc1 -- 账户兑换币种
            ,acc2 -- 柜台账户兑换币种
            ,bsrmar -- 与中间价的差数
            ,sqrmar -- 与调整价的差数
            ,glbrat -- 账户平均汇率
            ,dif -- 汇率最大浮动值
            ,bas -- 基础汇率
            ,rndunt -- Rounding Unit of Currency
            ,begdat -- 开始时间
            ,enddat -- 结束时间
            ,odrintday -- 汇率插入日期
            ,dbtday -- 借贷起息日
            ,cdtday -- 信贷起息日
            ,maxcur -- 币种
            ,maxamt -- 最大金额
            ,ver -- 版本号
            ,etgextkey -- 实体组
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一INR
    ,o.cod -- 货币种类
    ,o.newcur -- 自定义的货币种类
    ,o.altcod -- 可替换币种
    ,o.dec -- 货币小数位
    ,o.seq -- 利率录入操作列表
    ,o.acc1 -- 账户兑换币种
    ,o.acc2 -- 柜台账户兑换币种
    ,o.bsrmar -- 与中间价的差数
    ,o.sqrmar -- 与调整价的差数
    ,o.glbrat -- 账户平均汇率
    ,o.dif -- 汇率最大浮动值
    ,o.bas -- 基础汇率
    ,o.rndunt -- Rounding Unit of Currency
    ,o.begdat -- 开始时间
    ,o.enddat -- 结束时间
    ,o.odrintday -- 汇率插入日期
    ,o.dbtday -- 借贷起息日
    ,o.cdtday -- 信贷起息日
    ,o.maxcur -- 币种
    ,o.maxamt -- 最大金额
    ,o.ver -- 版本号
    ,o.etgextkey -- 实体组
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_cur_bk o
    left join ${iol_schema}.isbs_cur_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_cur_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_cur;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_cur exchange partition p_19000101 with table ${iol_schema}.isbs_cur_cl;
alter table ${iol_schema}.isbs_cur exchange partition p_20991231 with table ${iol_schema}.isbs_cur_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_cur to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cur_op purge;
drop table ${iol_schema}.isbs_cur_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_cur_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_cur',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
