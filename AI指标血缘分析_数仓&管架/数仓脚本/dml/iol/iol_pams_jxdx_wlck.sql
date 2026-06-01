/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_wlck
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
create table ${iol_schema}.pams_jxdx_wlck_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_wlck
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_wlck_op purge;
drop table ${iol_schema}.pams_jxdx_wlck_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_wlck_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_wlck where 0=1;

create table ${iol_schema}.pams_jxdx_wlck_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_wlck where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_wlck_cl(
            jxdxdh -- 绩效对象代号
            ,wcbh -- 网存编号
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,dqrq -- 到期日期
            ,zhye -- 账户余额
            ,cpbh -- 产品编号
            ,qxrq -- 起息日期
            ,qx -- 期限
            ,djbz -- 冻结标志
            ,djje -- 冻结金额
            ,dybz -- 抵质押标志
            ,dyje -- 抵质押金额
            ,nll -- 年利率
            ,dryjlx -- 当日月计利息
            ,tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_wlck_op(
            jxdxdh -- 绩效对象代号
            ,wcbh -- 网存编号
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,dqrq -- 到期日期
            ,zhye -- 账户余额
            ,cpbh -- 产品编号
            ,qxrq -- 起息日期
            ,qx -- 期限
            ,djbz -- 冻结标志
            ,djje -- 冻结金额
            ,dybz -- 抵质押标志
            ,dyje -- 抵质押金额
            ,nll -- 年利率
            ,dryjlx -- 当日月计利息
            ,tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.wcbh, o.wcbh) as wcbh -- 网存编号
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.khrq, o.khrq) as khrq -- 开户日期
    ,nvl(n.dqrq, o.dqrq) as dqrq -- 到期日期
    ,nvl(n.zhye, o.zhye) as zhye -- 账户余额
    ,nvl(n.cpbh, o.cpbh) as cpbh -- 产品编号
    ,nvl(n.qxrq, o.qxrq) as qxrq -- 起息日期
    ,nvl(n.qx, o.qx) as qx -- 期限
    ,nvl(n.djbz, o.djbz) as djbz -- 冻结标志
    ,nvl(n.djje, o.djje) as djje -- 冻结金额
    ,nvl(n.dybz, o.dybz) as dybz -- 抵质押标志
    ,nvl(n.dyje, o.dyje) as dyje -- 抵质押金额
    ,nvl(n.nll, o.nll) as nll -- 年利率
    ,nvl(n.dryjlx, o.dryjlx) as dryjlx -- 当日月计利息
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,case when
            n.jxdxdh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.jxdxdh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.jxdxdh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxdx_wlck_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_wlck where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.wcbh <> n.wcbh
        or o.bz <> n.bz
        or o.jgdh <> n.jgdh
        or o.kmh <> n.kmh
        or o.khrq <> n.khrq
        or o.dqrq <> n.dqrq
        or o.zhye <> n.zhye
        or o.cpbh <> n.cpbh
        or o.qxrq <> n.qxrq
        or o.qx <> n.qx
        or o.djbz <> n.djbz
        or o.djje <> n.djje
        or o.dybz <> n.dybz
        or o.dyje <> n.dyje
        or o.nll <> n.nll
        or o.dryjlx <> n.dryjlx
        or o.tjrq <> n.tjrq
        or o.khdxdh <> n.khdxdh
        or o.gxhslx <> n.gxhslx
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_wlck_cl(
            jxdxdh -- 绩效对象代号
            ,wcbh -- 网存编号
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,dqrq -- 到期日期
            ,zhye -- 账户余额
            ,cpbh -- 产品编号
            ,qxrq -- 起息日期
            ,qx -- 期限
            ,djbz -- 冻结标志
            ,djje -- 冻结金额
            ,dybz -- 抵质押标志
            ,dyje -- 抵质押金额
            ,nll -- 年利率
            ,dryjlx -- 当日月计利息
            ,tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_wlck_op(
            jxdxdh -- 绩效对象代号
            ,wcbh -- 网存编号
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,dqrq -- 到期日期
            ,zhye -- 账户余额
            ,cpbh -- 产品编号
            ,qxrq -- 起息日期
            ,qx -- 期限
            ,djbz -- 冻结标志
            ,djje -- 冻结金额
            ,dybz -- 抵质押标志
            ,dyje -- 抵质押金额
            ,nll -- 年利率
            ,dryjlx -- 当日月计利息
            ,tjrq -- 统计日期
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.wcbh -- 网存编号
    ,o.bz -- 币种
    ,o.jgdh -- 机构代号
    ,o.kmh -- 科目号
    ,o.khrq -- 开户日期
    ,o.dqrq -- 到期日期
    ,o.zhye -- 账户余额
    ,o.cpbh -- 产品编号
    ,o.qxrq -- 起息日期
    ,o.qx -- 期限
    ,o.djbz -- 冻结标志
    ,o.djje -- 冻结金额
    ,o.dybz -- 抵质押标志
    ,o.dyje -- 抵质押金额
    ,o.nll -- 年利率
    ,o.dryjlx -- 当日月计利息
    ,o.tjrq -- 统计日期
    ,o.khdxdh -- 考核对象代号
    ,o.gxhslx -- 关系函数类型
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
from ${iol_schema}.pams_jxdx_wlck_bk o
    left join ${iol_schema}.pams_jxdx_wlck_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_wlck_cl d
        on
            o.jxdxdh = d.jxdxdh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxdx_wlck;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_wlck') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_wlck drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_wlck add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_wlck exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_wlck_cl;
alter table ${iol_schema}.pams_jxdx_wlck exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_wlck_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_wlck to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_wlck_op purge;
drop table ${iol_schema}.pams_jxdx_wlck_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_wlck_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_wlck',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
