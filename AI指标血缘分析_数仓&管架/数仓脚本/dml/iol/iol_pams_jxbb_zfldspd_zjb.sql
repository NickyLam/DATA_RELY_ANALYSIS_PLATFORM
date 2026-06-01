/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zfldspd_zjb
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
create table ${iol_schema}.pams_jxbb_zfldspd_zjb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxbb_zfldspd_zjb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_op purge;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zfldspd_zjb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zfldspd_zjb where 0=1;

create table ${iol_schema}.pams_jxbb_zfldspd_zjb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zfldspd_zjb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_zfldspd_zjb_cl(
            jxdxdh -- 绩效对象代号
            ,hykhdxdh -- 行员考核对象代号
            ,jgkhdxdh -- 机构考核对象代号
            ,ldpz -- 联动品种
            ,zqdm -- 债券代码
            ,zqmc -- 债券名称
            ,zqpmll -- 债券票面利率
            ,tzsyl -- 调整收益率
            ,tzje -- 调整金额
            ,khh -- 客户号
            ,tzfs -- 调整方式
            ,dyckzh -- 对应存款账号
            ,xnh -- 虚拟户
            ,tjrq -- 统计日期（即创建日期
            ,qx -- 期限
            ,zyr -- 质押日
            ,dqr -- 到期日
            ,ckje -- 存款金额
            ,zyzqlx -- 质押债券类型
            ,zyzqje -- 质押债券金额
            ,spzt -- 审批状态
            ,spdh -- 审批代号
            ,tzsj -- 调整时间(审批流的开始时间)
            ,ldywlx -- 联动业务类型（区分债券和质押）
            ,fsfs -- 发生方式
            ,tzrq -- 发生调整的日期
            ,sxrq -- 生效日期
            ,sjzt -- 数据状态
            ,taskid -- OA待办任务ID
            ,auditid -- 实际审批人
            ,jsrq -- 结束日期
            ,hth -- 合同号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_zfldspd_zjb_op(
            jxdxdh -- 绩效对象代号
            ,hykhdxdh -- 行员考核对象代号
            ,jgkhdxdh -- 机构考核对象代号
            ,ldpz -- 联动品种
            ,zqdm -- 债券代码
            ,zqmc -- 债券名称
            ,zqpmll -- 债券票面利率
            ,tzsyl -- 调整收益率
            ,tzje -- 调整金额
            ,khh -- 客户号
            ,tzfs -- 调整方式
            ,dyckzh -- 对应存款账号
            ,xnh -- 虚拟户
            ,tjrq -- 统计日期（即创建日期
            ,qx -- 期限
            ,zyr -- 质押日
            ,dqr -- 到期日
            ,ckje -- 存款金额
            ,zyzqlx -- 质押债券类型
            ,zyzqje -- 质押债券金额
            ,spzt -- 审批状态
            ,spdh -- 审批代号
            ,tzsj -- 调整时间(审批流的开始时间)
            ,ldywlx -- 联动业务类型（区分债券和质押）
            ,fsfs -- 发生方式
            ,tzrq -- 发生调整的日期
            ,sxrq -- 生效日期
            ,sjzt -- 数据状态
            ,taskid -- OA待办任务ID
            ,auditid -- 实际审批人
            ,jsrq -- 结束日期
            ,hth -- 合同号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.hykhdxdh, o.hykhdxdh) as hykhdxdh -- 行员考核对象代号
    ,nvl(n.jgkhdxdh, o.jgkhdxdh) as jgkhdxdh -- 机构考核对象代号
    ,nvl(n.ldpz, o.ldpz) as ldpz -- 联动品种
    ,nvl(n.zqdm, o.zqdm) as zqdm -- 债券代码
    ,nvl(n.zqmc, o.zqmc) as zqmc -- 债券名称
    ,nvl(n.zqpmll, o.zqpmll) as zqpmll -- 债券票面利率
    ,nvl(n.tzsyl, o.tzsyl) as tzsyl -- 调整收益率
    ,nvl(n.tzje, o.tzje) as tzje -- 调整金额
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.tzfs, o.tzfs) as tzfs -- 调整方式
    ,nvl(n.dyckzh, o.dyckzh) as dyckzh -- 对应存款账号
    ,nvl(n.xnh, o.xnh) as xnh -- 虚拟户
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期（即创建日期
    ,nvl(n.qx, o.qx) as qx -- 期限
    ,nvl(n.zyr, o.zyr) as zyr -- 质押日
    ,nvl(n.dqr, o.dqr) as dqr -- 到期日
    ,nvl(n.ckje, o.ckje) as ckje -- 存款金额
    ,nvl(n.zyzqlx, o.zyzqlx) as zyzqlx -- 质押债券类型
    ,nvl(n.zyzqje, o.zyzqje) as zyzqje -- 质押债券金额
    ,nvl(n.spzt, o.spzt) as spzt -- 审批状态
    ,nvl(n.spdh, o.spdh) as spdh -- 审批代号
    ,nvl(n.tzsj, o.tzsj) as tzsj -- 调整时间(审批流的开始时间)
    ,nvl(n.ldywlx, o.ldywlx) as ldywlx -- 联动业务类型（区分债券和质押）
    ,nvl(n.fsfs, o.fsfs) as fsfs -- 发生方式
    ,nvl(n.tzrq, o.tzrq) as tzrq -- 发生调整的日期
    ,nvl(n.sxrq, o.sxrq) as sxrq -- 生效日期
    ,nvl(n.sjzt, o.sjzt) as sjzt -- 数据状态
    ,nvl(n.taskid, o.taskid) as taskid -- OA待办任务ID
    ,nvl(n.auditid, o.auditid) as auditid -- 实际审批人
    ,nvl(n.jsrq, o.jsrq) as jsrq -- 结束日期
    ,nvl(n.hth, o.hth) as hth -- 合同号
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
from (select * from ${iol_schema}.pams_jxbb_zfldspd_zjb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxbb_zfldspd_zjb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.hykhdxdh <> n.hykhdxdh
        or o.jgkhdxdh <> n.jgkhdxdh
        or o.ldpz <> n.ldpz
        or o.zqdm <> n.zqdm
        or o.zqmc <> n.zqmc
        or o.zqpmll <> n.zqpmll
        or o.tzsyl <> n.tzsyl
        or o.tzje <> n.tzje
        or o.khh <> n.khh
        or o.tzfs <> n.tzfs
        or o.dyckzh <> n.dyckzh
        or o.xnh <> n.xnh
        or o.tjrq <> n.tjrq
        or o.qx <> n.qx
        or o.zyr <> n.zyr
        or o.dqr <> n.dqr
        or o.ckje <> n.ckje
        or o.zyzqlx <> n.zyzqlx
        or o.zyzqje <> n.zyzqje
        or o.spzt <> n.spzt
        or o.spdh <> n.spdh
        or o.tzsj <> n.tzsj
        or o.ldywlx <> n.ldywlx
        or o.fsfs <> n.fsfs
        or o.tzrq <> n.tzrq
        or o.sxrq <> n.sxrq
        or o.sjzt <> n.sjzt
        or o.taskid <> n.taskid
        or o.auditid <> n.auditid
        or o.jsrq <> n.jsrq
        or o.hth <> n.hth
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_zfldspd_zjb_cl(
            jxdxdh -- 绩效对象代号
            ,hykhdxdh -- 行员考核对象代号
            ,jgkhdxdh -- 机构考核对象代号
            ,ldpz -- 联动品种
            ,zqdm -- 债券代码
            ,zqmc -- 债券名称
            ,zqpmll -- 债券票面利率
            ,tzsyl -- 调整收益率
            ,tzje -- 调整金额
            ,khh -- 客户号
            ,tzfs -- 调整方式
            ,dyckzh -- 对应存款账号
            ,xnh -- 虚拟户
            ,tjrq -- 统计日期（即创建日期
            ,qx -- 期限
            ,zyr -- 质押日
            ,dqr -- 到期日
            ,ckje -- 存款金额
            ,zyzqlx -- 质押债券类型
            ,zyzqje -- 质押债券金额
            ,spzt -- 审批状态
            ,spdh -- 审批代号
            ,tzsj -- 调整时间(审批流的开始时间)
            ,ldywlx -- 联动业务类型（区分债券和质押）
            ,fsfs -- 发生方式
            ,tzrq -- 发生调整的日期
            ,sxrq -- 生效日期
            ,sjzt -- 数据状态
            ,taskid -- OA待办任务ID
            ,auditid -- 实际审批人
            ,jsrq -- 结束日期
            ,hth -- 合同号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_zfldspd_zjb_op(
            jxdxdh -- 绩效对象代号
            ,hykhdxdh -- 行员考核对象代号
            ,jgkhdxdh -- 机构考核对象代号
            ,ldpz -- 联动品种
            ,zqdm -- 债券代码
            ,zqmc -- 债券名称
            ,zqpmll -- 债券票面利率
            ,tzsyl -- 调整收益率
            ,tzje -- 调整金额
            ,khh -- 客户号
            ,tzfs -- 调整方式
            ,dyckzh -- 对应存款账号
            ,xnh -- 虚拟户
            ,tjrq -- 统计日期（即创建日期
            ,qx -- 期限
            ,zyr -- 质押日
            ,dqr -- 到期日
            ,ckje -- 存款金额
            ,zyzqlx -- 质押债券类型
            ,zyzqje -- 质押债券金额
            ,spzt -- 审批状态
            ,spdh -- 审批代号
            ,tzsj -- 调整时间(审批流的开始时间)
            ,ldywlx -- 联动业务类型（区分债券和质押）
            ,fsfs -- 发生方式
            ,tzrq -- 发生调整的日期
            ,sxrq -- 生效日期
            ,sjzt -- 数据状态
            ,taskid -- OA待办任务ID
            ,auditid -- 实际审批人
            ,jsrq -- 结束日期
            ,hth -- 合同号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.hykhdxdh -- 行员考核对象代号
    ,o.jgkhdxdh -- 机构考核对象代号
    ,o.ldpz -- 联动品种
    ,o.zqdm -- 债券代码
    ,o.zqmc -- 债券名称
    ,o.zqpmll -- 债券票面利率
    ,o.tzsyl -- 调整收益率
    ,o.tzje -- 调整金额
    ,o.khh -- 客户号
    ,o.tzfs -- 调整方式
    ,o.dyckzh -- 对应存款账号
    ,o.xnh -- 虚拟户
    ,o.tjrq -- 统计日期（即创建日期
    ,o.qx -- 期限
    ,o.zyr -- 质押日
    ,o.dqr -- 到期日
    ,o.ckje -- 存款金额
    ,o.zyzqlx -- 质押债券类型
    ,o.zyzqje -- 质押债券金额
    ,o.spzt -- 审批状态
    ,o.spdh -- 审批代号
    ,o.tzsj -- 调整时间(审批流的开始时间)
    ,o.ldywlx -- 联动业务类型（区分债券和质押）
    ,o.fsfs -- 发生方式
    ,o.tzrq -- 发生调整的日期
    ,o.sxrq -- 生效日期
    ,o.sjzt -- 数据状态
    ,o.taskid -- OA待办任务ID
    ,o.auditid -- 实际审批人
    ,o.jsrq -- 结束日期
    ,o.hth -- 合同号
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
from ${iol_schema}.pams_jxbb_zfldspd_zjb_bk o
    left join ${iol_schema}.pams_jxbb_zfldspd_zjb_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxbb_zfldspd_zjb_cl d
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
--truncate table ${iol_schema}.pams_jxbb_zfldspd_zjb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxbb_zfldspd_zjb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxbb_zfldspd_zjb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxbb_zfldspd_zjb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxbb_zfldspd_zjb exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_zfldspd_zjb_cl;
alter table ${iol_schema}.pams_jxbb_zfldspd_zjb exchange partition p_20991231 with table ${iol_schema}.pams_jxbb_zfldspd_zjb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_zfldspd_zjb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_op purge;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxbb_zfldspd_zjb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_zfldspd_zjb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
