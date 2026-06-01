/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_khdx_hy
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
create table ${iol_schema}.pams_khdx_hy_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_khdx_hy;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_khdx_hy_op purge;
drop table ${iol_schema}.pams_khdx_hy_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_khdx_hy_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_khdx_hy where 0=1;

create table ${iol_schema}.pams_khdx_hy_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_khdx_hy where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_khdx_hy_cl(
            khdxdh -- 考核对象代号
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,xl -- 学历
            ,lxdh -- 联系电话
            ,sfz -- 身份证号码
            ,yxrybz -- 营销人员标志
            ,xnhybz -- 虚拟行员标志
            ,dlmc -- 登录名称
            ,dlmm -- 登录密码
            ,aqjb -- 安全级别
            ,zxzt -- 注销状态
            ,scdl -- 首次登陆
            ,zpxx -- 照片信息
            ,czybh -- 操作员编号
            ,zxrq -- 注销日期
            ,csrq -- 出生日期
            ,gzrq -- 工作日期
            ,rhrq -- 入行日期
            ,fgbz -- 风格标志
            ,pxbz -- 排序标志
            ,xgmmrq -- 修改密码日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_khdx_hy_op(
            khdxdh -- 考核对象代号
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,xl -- 学历
            ,lxdh -- 联系电话
            ,sfz -- 身份证号码
            ,yxrybz -- 营销人员标志
            ,xnhybz -- 虚拟行员标志
            ,dlmc -- 登录名称
            ,dlmm -- 登录密码
            ,aqjb -- 安全级别
            ,zxzt -- 注销状态
            ,scdl -- 首次登陆
            ,zpxx -- 照片信息
            ,czybh -- 操作员编号
            ,zxrq -- 注销日期
            ,csrq -- 出生日期
            ,gzrq -- 工作日期
            ,rhrq -- 入行日期
            ,fgbz -- 风格标志
            ,pxbz -- 排序标志
            ,xgmmrq -- 修改密码日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.hymc, o.hymc) as hymc -- 行员名称
    ,nvl(n.xl, o.xl) as xl -- 学历
    ,nvl(n.lxdh, o.lxdh) as lxdh -- 联系电话
    ,nvl(n.sfz, o.sfz) as sfz -- 身份证号码
    ,nvl(n.yxrybz, o.yxrybz) as yxrybz -- 营销人员标志
    ,nvl(n.xnhybz, o.xnhybz) as xnhybz -- 虚拟行员标志
    ,nvl(n.dlmc, o.dlmc) as dlmc -- 登录名称
    ,nvl(n.dlmm, o.dlmm) as dlmm -- 登录密码
    ,nvl(n.aqjb, o.aqjb) as aqjb -- 安全级别
    ,nvl(n.zxzt, o.zxzt) as zxzt -- 注销状态
    ,nvl(n.scdl, o.scdl) as scdl -- 首次登陆
    ,nvl(n.zpxx, o.zpxx) as zpxx -- 照片信息
    ,nvl(n.czybh, o.czybh) as czybh -- 操作员编号
    ,nvl(n.zxrq, o.zxrq) as zxrq -- 注销日期
    ,nvl(n.csrq, o.csrq) as csrq -- 出生日期
    ,nvl(n.gzrq, o.gzrq) as gzrq -- 工作日期
    ,nvl(n.rhrq, o.rhrq) as rhrq -- 入行日期
    ,nvl(n.fgbz, o.fgbz) as fgbz -- 风格标志
    ,nvl(n.pxbz, o.pxbz) as pxbz -- 排序标志
    ,nvl(n.xgmmrq, o.xgmmrq) as xgmmrq -- 修改密码日期
    ,case when
            n.khdxdh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.khdxdh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.khdxdh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_khdx_hy_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_khdx_hy where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.khdxdh = n.khdxdh
where (
        o.khdxdh is null
    )
    or (
        n.khdxdh is null
    )
    or (
        o.hydh <> n.hydh
        or o.hymc <> n.hymc
        or o.xl <> n.xl
        or o.lxdh <> n.lxdh
        or o.sfz <> n.sfz
        or o.yxrybz <> n.yxrybz
        or o.xnhybz <> n.xnhybz
        or o.dlmc <> n.dlmc
        or o.dlmm <> n.dlmm
        or o.aqjb <> n.aqjb
        or o.zxzt <> n.zxzt
        or o.scdl <> n.scdl
        or o.zpxx <> n.zpxx
        or o.czybh <> n.czybh
        or o.zxrq <> n.zxrq
        or o.csrq <> n.csrq
        or o.gzrq <> n.gzrq
        or o.rhrq <> n.rhrq
        or o.fgbz <> n.fgbz
        or o.pxbz <> n.pxbz
        or o.xgmmrq <> n.xgmmrq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_khdx_hy_cl(
            khdxdh -- 考核对象代号
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,xl -- 学历
            ,lxdh -- 联系电话
            ,sfz -- 身份证号码
            ,yxrybz -- 营销人员标志
            ,xnhybz -- 虚拟行员标志
            ,dlmc -- 登录名称
            ,dlmm -- 登录密码
            ,aqjb -- 安全级别
            ,zxzt -- 注销状态
            ,scdl -- 首次登陆
            ,zpxx -- 照片信息
            ,czybh -- 操作员编号
            ,zxrq -- 注销日期
            ,csrq -- 出生日期
            ,gzrq -- 工作日期
            ,rhrq -- 入行日期
            ,fgbz -- 风格标志
            ,pxbz -- 排序标志
            ,xgmmrq -- 修改密码日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_khdx_hy_op(
            khdxdh -- 考核对象代号
            ,hydh -- 行员代号
            ,hymc -- 行员名称
            ,xl -- 学历
            ,lxdh -- 联系电话
            ,sfz -- 身份证号码
            ,yxrybz -- 营销人员标志
            ,xnhybz -- 虚拟行员标志
            ,dlmc -- 登录名称
            ,dlmm -- 登录密码
            ,aqjb -- 安全级别
            ,zxzt -- 注销状态
            ,scdl -- 首次登陆
            ,zpxx -- 照片信息
            ,czybh -- 操作员编号
            ,zxrq -- 注销日期
            ,csrq -- 出生日期
            ,gzrq -- 工作日期
            ,rhrq -- 入行日期
            ,fgbz -- 风格标志
            ,pxbz -- 排序标志
            ,xgmmrq -- 修改密码日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.khdxdh -- 考核对象代号
    ,o.hydh -- 行员代号
    ,o.hymc -- 行员名称
    ,o.xl -- 学历
    ,o.lxdh -- 联系电话
    ,o.sfz -- 身份证号码
    ,o.yxrybz -- 营销人员标志
    ,o.xnhybz -- 虚拟行员标志
    ,o.dlmc -- 登录名称
    ,o.dlmm -- 登录密码
    ,o.aqjb -- 安全级别
    ,o.zxzt -- 注销状态
    ,o.scdl -- 首次登陆
    ,o.zpxx -- 照片信息
    ,o.czybh -- 操作员编号
    ,o.zxrq -- 注销日期
    ,o.csrq -- 出生日期
    ,o.gzrq -- 工作日期
    ,o.rhrq -- 入行日期
    ,o.fgbz -- 风格标志
    ,o.pxbz -- 排序标志
    ,o.xgmmrq -- 修改密码日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_khdx_hy_bk o
    left join ${iol_schema}.pams_khdx_hy_op n
        on
            o.khdxdh = n.khdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_khdx_hy_cl d
        on
            o.khdxdh = d.khdxdh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.pams_khdx_hy;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_khdx_hy exchange partition p_19000101 with table ${iol_schema}.pams_khdx_hy_cl;
alter table ${iol_schema}.pams_khdx_hy exchange partition p_20991231 with table ${iol_schema}.pams_khdx_hy_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_khdx_hy to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_khdx_hy_op purge;
drop table ${iol_schema}.pams_khdx_hy_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_khdx_hy_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_khdx_hy',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
