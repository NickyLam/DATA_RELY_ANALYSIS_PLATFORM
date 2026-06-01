/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_khrl
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
create table ${iol_schema}.pams_jxdx_khrl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_khrl;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_khrl_op purge;
drop table ${iol_schema}.pams_jxdx_khrl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_khrl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_khrl where 0=1;

create table ${iol_schema}.pams_jxdx_khrl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_khrl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_khrl_cl(
            jxdxdh -- 绩效对象代号
            ,khh -- 客户号
            ,khlx -- 客户类型
            ,jgdh -- 机构代号
            ,khmc -- 客户名称
            ,zjlb -- 证件类别
            ,zjhm -- 证件号码
            ,khjjxz -- 客户经济性质
            ,khhylb -- 客户行员类别
            ,qygm -- 企业规模
            ,txdz -- 通讯地址
            ,dwdh -- 单位电话
            ,dzyj -- 电子邮件
            ,lxdh -- 联系电话
            ,khzt -- 客户状态
            ,khrq -- 客户日期
            ,zczb -- 注册资本
            ,csrq -- 出生日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_khrl_op(
            jxdxdh -- 绩效对象代号
            ,khh -- 客户号
            ,khlx -- 客户类型
            ,jgdh -- 机构代号
            ,khmc -- 客户名称
            ,zjlb -- 证件类别
            ,zjhm -- 证件号码
            ,khjjxz -- 客户经济性质
            ,khhylb -- 客户行员类别
            ,qygm -- 企业规模
            ,txdz -- 通讯地址
            ,dwdh -- 单位电话
            ,dzyj -- 电子邮件
            ,lxdh -- 联系电话
            ,khzt -- 客户状态
            ,khrq -- 客户日期
            ,zczb -- 注册资本
            ,csrq -- 出生日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.khlx, o.khlx) as khlx -- 客户类型
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.khmc, o.khmc) as khmc -- 客户名称
    ,nvl(n.zjlb, o.zjlb) as zjlb -- 证件类别
    ,nvl(n.zjhm, o.zjhm) as zjhm -- 证件号码
    ,nvl(n.khjjxz, o.khjjxz) as khjjxz -- 客户经济性质
    ,nvl(n.khhylb, o.khhylb) as khhylb -- 客户行员类别
    ,nvl(n.qygm, o.qygm) as qygm -- 企业规模
    ,nvl(n.txdz, o.txdz) as txdz -- 通讯地址
    ,nvl(n.dwdh, o.dwdh) as dwdh -- 单位电话
    ,nvl(n.dzyj, o.dzyj) as dzyj -- 电子邮件
    ,nvl(n.lxdh, o.lxdh) as lxdh -- 联系电话
    ,nvl(n.khzt, o.khzt) as khzt -- 客户状态
    ,nvl(n.khrq, o.khrq) as khrq -- 客户日期
    ,nvl(n.zczb, o.zczb) as zczb -- 注册资本
    ,nvl(n.csrq, o.csrq) as csrq -- 出生日期
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
from (select * from ${iol_schema}.pams_jxdx_khrl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_khrl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.khh <> n.khh
        or o.khlx <> n.khlx
        or o.jgdh <> n.jgdh
        or o.khmc <> n.khmc
        or o.zjlb <> n.zjlb
        or o.zjhm <> n.zjhm
        or o.khjjxz <> n.khjjxz
        or o.khhylb <> n.khhylb
        or o.qygm <> n.qygm
        or o.txdz <> n.txdz
        or o.dwdh <> n.dwdh
        or o.dzyj <> n.dzyj
        or o.lxdh <> n.lxdh
        or o.khzt <> n.khzt
        or o.khrq <> n.khrq
        or o.zczb <> n.zczb
        or o.csrq <> n.csrq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_khrl_cl(
            jxdxdh -- 绩效对象代号
            ,khh -- 客户号
            ,khlx -- 客户类型
            ,jgdh -- 机构代号
            ,khmc -- 客户名称
            ,zjlb -- 证件类别
            ,zjhm -- 证件号码
            ,khjjxz -- 客户经济性质
            ,khhylb -- 客户行员类别
            ,qygm -- 企业规模
            ,txdz -- 通讯地址
            ,dwdh -- 单位电话
            ,dzyj -- 电子邮件
            ,lxdh -- 联系电话
            ,khzt -- 客户状态
            ,khrq -- 客户日期
            ,zczb -- 注册资本
            ,csrq -- 出生日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_khrl_op(
            jxdxdh -- 绩效对象代号
            ,khh -- 客户号
            ,khlx -- 客户类型
            ,jgdh -- 机构代号
            ,khmc -- 客户名称
            ,zjlb -- 证件类别
            ,zjhm -- 证件号码
            ,khjjxz -- 客户经济性质
            ,khhylb -- 客户行员类别
            ,qygm -- 企业规模
            ,txdz -- 通讯地址
            ,dwdh -- 单位电话
            ,dzyj -- 电子邮件
            ,lxdh -- 联系电话
            ,khzt -- 客户状态
            ,khrq -- 客户日期
            ,zczb -- 注册资本
            ,csrq -- 出生日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.khh -- 客户号
    ,o.khlx -- 客户类型
    ,o.jgdh -- 机构代号
    ,o.khmc -- 客户名称
    ,o.zjlb -- 证件类别
    ,o.zjhm -- 证件号码
    ,o.khjjxz -- 客户经济性质
    ,o.khhylb -- 客户行员类别
    ,o.qygm -- 企业规模
    ,o.txdz -- 通讯地址
    ,o.dwdh -- 单位电话
    ,o.dzyj -- 电子邮件
    ,o.lxdh -- 联系电话
    ,o.khzt -- 客户状态
    ,o.khrq -- 客户日期
    ,o.zczb -- 注册资本
    ,o.csrq -- 出生日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_jxdx_khrl_bk o
    left join ${iol_schema}.pams_jxdx_khrl_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_khrl_cl d
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
-- truncate table ${iol_schema}.pams_jxdx_khrl;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_jxdx_khrl exchange partition p_19000101 with table ${iol_schema}.pams_jxdx_khrl_cl;
alter table ${iol_schema}.pams_jxdx_khrl exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_khrl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_khrl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_khrl_op purge;
drop table ${iol_schema}.pams_jxdx_khrl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_khrl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_khrl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
