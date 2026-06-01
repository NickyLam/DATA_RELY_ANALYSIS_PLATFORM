/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_kzl
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
create table ${iol_schema}.pams_jxdx_kzl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_kzl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_kzl_op purge;
drop table ${iol_schema}.pams_jxdx_kzl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_kzl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_kzl where 0=1;

create table ${iol_schema}.pams_jxdx_kzl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_kzl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_kzl_cl(
            jxdxdh -- 绩效对象代号
            ,kh -- 卡号
            ,fhdh -- 分行代号
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,zh -- 账户
            ,zjlb -- 证件类别
            ,zjhm -- 证件号码
            ,kl -- 卡类
            ,kjz -- 卡介质
            ,kdj -- 卡等级
            ,kztbz -- 卡状态标志
            ,kyyzt -- 卡应用状态
            ,fkrq -- 发卡日期
            ,kkrq -- 开卡日期
            ,jhrq -- 激活日期
            ,xkrq -- 销卡日期
            ,zfkbz -- 主副卡标志
            ,hydh -- 行员代号
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,zhbs -- 账户标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_kzl_op(
            jxdxdh -- 绩效对象代号
            ,kh -- 卡号
            ,fhdh -- 分行代号
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,zh -- 账户
            ,zjlb -- 证件类别
            ,zjhm -- 证件号码
            ,kl -- 卡类
            ,kjz -- 卡介质
            ,kdj -- 卡等级
            ,kztbz -- 卡状态标志
            ,kyyzt -- 卡应用状态
            ,fkrq -- 发卡日期
            ,kkrq -- 开卡日期
            ,jhrq -- 激活日期
            ,xkrq -- 销卡日期
            ,zfkbz -- 主副卡标志
            ,hydh -- 行员代号
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,zhbs -- 账户标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.kh, o.kh) as kh -- 卡号
    ,nvl(n.fhdh, o.fhdh) as fhdh -- 分行代号
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.khmc, o.khmc) as khmc -- 客户名称
    ,nvl(n.zh, o.zh) as zh -- 账户
    ,nvl(n.zjlb, o.zjlb) as zjlb -- 证件类别
    ,nvl(n.zjhm, o.zjhm) as zjhm -- 证件号码
    ,nvl(n.kl, o.kl) as kl -- 卡类
    ,nvl(n.kjz, o.kjz) as kjz -- 卡介质
    ,nvl(n.kdj, o.kdj) as kdj -- 卡等级
    ,nvl(n.kztbz, o.kztbz) as kztbz -- 卡状态标志
    ,nvl(n.kyyzt, o.kyyzt) as kyyzt -- 卡应用状态
    ,nvl(n.fkrq, o.fkrq) as fkrq -- 发卡日期
    ,nvl(n.kkrq, o.kkrq) as kkrq -- 开卡日期
    ,nvl(n.jhrq, o.jhrq) as jhrq -- 激活日期
    ,nvl(n.xkrq, o.xkrq) as xkrq -- 销卡日期
    ,nvl(n.zfkbz, o.zfkbz) as zfkbz -- 主副卡标志
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.zhbs, o.zhbs) as zhbs -- 账户标识
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
from (select * from ${iol_schema}.pams_jxdx_kzl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_kzl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.kh <> n.kh
        or o.fhdh <> n.fhdh
        or o.jgdh <> n.jgdh
        or o.khh <> n.khh
        or o.khmc <> n.khmc
        or o.zh <> n.zh
        or o.zjlb <> n.zjlb
        or o.zjhm <> n.zjhm
        or o.kl <> n.kl
        or o.kjz <> n.kjz
        or o.kdj <> n.kdj
        or o.kztbz <> n.kztbz
        or o.kyyzt <> n.kyyzt
        or o.fkrq <> n.fkrq
        or o.kkrq <> n.kkrq
        or o.jhrq <> n.jhrq
        or o.xkrq <> n.xkrq
        or o.zfkbz <> n.zfkbz
        or o.hydh <> n.hydh
        or o.gxhslx <> n.gxhslx
        or o.khdxdh <> n.khdxdh
        or o.zhbs <> n.zhbs
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_kzl_cl(
            jxdxdh -- 绩效对象代号
            ,kh -- 卡号
            ,fhdh -- 分行代号
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,zh -- 账户
            ,zjlb -- 证件类别
            ,zjhm -- 证件号码
            ,kl -- 卡类
            ,kjz -- 卡介质
            ,kdj -- 卡等级
            ,kztbz -- 卡状态标志
            ,kyyzt -- 卡应用状态
            ,fkrq -- 发卡日期
            ,kkrq -- 开卡日期
            ,jhrq -- 激活日期
            ,xkrq -- 销卡日期
            ,zfkbz -- 主副卡标志
            ,hydh -- 行员代号
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,zhbs -- 账户标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_kzl_op(
            jxdxdh -- 绩效对象代号
            ,kh -- 卡号
            ,fhdh -- 分行代号
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,zh -- 账户
            ,zjlb -- 证件类别
            ,zjhm -- 证件号码
            ,kl -- 卡类
            ,kjz -- 卡介质
            ,kdj -- 卡等级
            ,kztbz -- 卡状态标志
            ,kyyzt -- 卡应用状态
            ,fkrq -- 发卡日期
            ,kkrq -- 开卡日期
            ,jhrq -- 激活日期
            ,xkrq -- 销卡日期
            ,zfkbz -- 主副卡标志
            ,hydh -- 行员代号
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,zhbs -- 账户标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.kh -- 卡号
    ,o.fhdh -- 分行代号
    ,o.jgdh -- 机构代号
    ,o.khh -- 客户号
    ,o.khmc -- 客户名称
    ,o.zh -- 账户
    ,o.zjlb -- 证件类别
    ,o.zjhm -- 证件号码
    ,o.kl -- 卡类
    ,o.kjz -- 卡介质
    ,o.kdj -- 卡等级
    ,o.kztbz -- 卡状态标志
    ,o.kyyzt -- 卡应用状态
    ,o.fkrq -- 发卡日期
    ,o.kkrq -- 开卡日期
    ,o.jhrq -- 激活日期
    ,o.xkrq -- 销卡日期
    ,o.zfkbz -- 主副卡标志
    ,o.hydh -- 行员代号
    ,o.gxhslx -- 关系函数类型
    ,o.khdxdh -- 考核对象代号
    ,o.zhbs -- 账户标识
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
from ${iol_schema}.pams_jxdx_kzl_bk o
    left join ${iol_schema}.pams_jxdx_kzl_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_kzl_cl d
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
--truncate table ${iol_schema}.pams_jxdx_kzl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_kzl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_kzl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_kzl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_kzl exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_kzl_cl;
alter table ${iol_schema}.pams_jxdx_kzl exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_kzl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_kzl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_kzl_op purge;
drop table ${iol_schema}.pams_jxdx_kzl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_kzl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_kzl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
