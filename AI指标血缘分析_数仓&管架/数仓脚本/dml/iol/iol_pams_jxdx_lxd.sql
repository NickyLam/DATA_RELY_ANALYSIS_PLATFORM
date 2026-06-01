/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_lxd
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
create table ${iol_schema}.pams_jxdx_lxd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_lxd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_lxd_op purge;
drop table ${iol_schema}.pams_jxdx_lxd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_lxd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_lxd where 0=1;

create table ${iol_schema}.pams_jxdx_lxd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_lxd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_lxd_cl(
            jxdxdh -- 绩效对象
            ,ywbh -- 业务编号
            ,wbzjzhbh -- 外部证券账户编号
            ,nbzjzhbh -- 内部证券账户编号
            ,jrgjbh -- 金融工具编号
            ,zclxbh -- 资产类型编号
            ,sclxbh -- 市场类型编号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,jydf -- 交易对手分类描述
            ,jyr -- 交易日期
            ,dqr -- 到期日期
            ,bz -- 币种
            ,tzje -- 交易金额
            ,qmye -- 当期余额
            ,ylj -- 月累计余额
            ,nlj -- 年累计余额
            ,yqsyl -- 票面利率
            ,jxfs -- 记息方式
            ,tzlx -- 资产类型名称
            ,khjg -- 开户机构
            ,ssfhhh -- 所属机构编号
            ,ssfh -- 所属分行
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_lxd_op(
            jxdxdh -- 绩效对象
            ,ywbh -- 业务编号
            ,wbzjzhbh -- 外部证券账户编号
            ,nbzjzhbh -- 内部证券账户编号
            ,jrgjbh -- 金融工具编号
            ,zclxbh -- 资产类型编号
            ,sclxbh -- 市场类型编号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,jydf -- 交易对手分类描述
            ,jyr -- 交易日期
            ,dqr -- 到期日期
            ,bz -- 币种
            ,tzje -- 交易金额
            ,qmye -- 当期余额
            ,ylj -- 月累计余额
            ,nlj -- 年累计余额
            ,yqsyl -- 票面利率
            ,jxfs -- 记息方式
            ,tzlx -- 资产类型名称
            ,khjg -- 开户机构
            ,ssfhhh -- 所属机构编号
            ,ssfh -- 所属分行
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象
    ,nvl(n.ywbh, o.ywbh) as ywbh -- 业务编号
    ,nvl(n.wbzjzhbh, o.wbzjzhbh) as wbzjzhbh -- 外部证券账户编号
    ,nvl(n.nbzjzhbh, o.nbzjzhbh) as nbzjzhbh -- 内部证券账户编号
    ,nvl(n.jrgjbh, o.jrgjbh) as jrgjbh -- 金融工具编号
    ,nvl(n.zclxbh, o.zclxbh) as zclxbh -- 资产类型编号
    ,nvl(n.sclxbh, o.sclxbh) as sclxbh -- 市场类型编号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.khmc, o.khmc) as khmc -- 客户名称
    ,nvl(n.jydf, o.jydf) as jydf -- 交易对手分类描述
    ,nvl(n.jyr, o.jyr) as jyr -- 交易日期
    ,nvl(n.dqr, o.dqr) as dqr -- 到期日期
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.tzje, o.tzje) as tzje -- 交易金额
    ,nvl(n.qmye, o.qmye) as qmye -- 当期余额
    ,nvl(n.ylj, o.ylj) as ylj -- 月累计余额
    ,nvl(n.nlj, o.nlj) as nlj -- 年累计余额
    ,nvl(n.yqsyl, o.yqsyl) as yqsyl -- 票面利率
    ,nvl(n.jxfs, o.jxfs) as jxfs -- 记息方式
    ,nvl(n.tzlx, o.tzlx) as tzlx -- 资产类型名称
    ,nvl(n.khjg, o.khjg) as khjg -- 开户机构
    ,nvl(n.ssfhhh, o.ssfhhh) as ssfhhh -- 所属机构编号
    ,nvl(n.ssfh, o.ssfh) as ssfh -- 所属分行
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
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
from (select * from ${iol_schema}.pams_jxdx_lxd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_lxd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.ywbh <> n.ywbh
        or o.wbzjzhbh <> n.wbzjzhbh
        or o.nbzjzhbh <> n.nbzjzhbh
        or o.jrgjbh <> n.jrgjbh
        or o.zclxbh <> n.zclxbh
        or o.sclxbh <> n.sclxbh
        or o.khh <> n.khh
        or o.khmc <> n.khmc
        or o.jydf <> n.jydf
        or o.jyr <> n.jyr
        or o.dqr <> n.dqr
        or o.bz <> n.bz
        or o.tzje <> n.tzje
        or o.qmye <> n.qmye
        or o.ylj <> n.ylj
        or o.nlj <> n.nlj
        or o.yqsyl <> n.yqsyl
        or o.jxfs <> n.jxfs
        or o.tzlx <> n.tzlx
        or o.khjg <> n.khjg
        or o.ssfhhh <> n.ssfhhh
        or o.ssfh <> n.ssfh
        or o.tjrq <> n.tjrq
        or o.gxhslx <> n.gxhslx
        or o.khdxdh <> n.khdxdh
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_lxd_cl(
            jxdxdh -- 绩效对象
            ,ywbh -- 业务编号
            ,wbzjzhbh -- 外部证券账户编号
            ,nbzjzhbh -- 内部证券账户编号
            ,jrgjbh -- 金融工具编号
            ,zclxbh -- 资产类型编号
            ,sclxbh -- 市场类型编号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,jydf -- 交易对手分类描述
            ,jyr -- 交易日期
            ,dqr -- 到期日期
            ,bz -- 币种
            ,tzje -- 交易金额
            ,qmye -- 当期余额
            ,ylj -- 月累计余额
            ,nlj -- 年累计余额
            ,yqsyl -- 票面利率
            ,jxfs -- 记息方式
            ,tzlx -- 资产类型名称
            ,khjg -- 开户机构
            ,ssfhhh -- 所属机构编号
            ,ssfh -- 所属分行
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_lxd_op(
            jxdxdh -- 绩效对象
            ,ywbh -- 业务编号
            ,wbzjzhbh -- 外部证券账户编号
            ,nbzjzhbh -- 内部证券账户编号
            ,jrgjbh -- 金融工具编号
            ,zclxbh -- 资产类型编号
            ,sclxbh -- 市场类型编号
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,jydf -- 交易对手分类描述
            ,jyr -- 交易日期
            ,dqr -- 到期日期
            ,bz -- 币种
            ,tzje -- 交易金额
            ,qmye -- 当期余额
            ,ylj -- 月累计余额
            ,nlj -- 年累计余额
            ,yqsyl -- 票面利率
            ,jxfs -- 记息方式
            ,tzlx -- 资产类型名称
            ,khjg -- 开户机构
            ,ssfhhh -- 所属机构编号
            ,ssfh -- 所属分行
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象
    ,o.ywbh -- 业务编号
    ,o.wbzjzhbh -- 外部证券账户编号
    ,o.nbzjzhbh -- 内部证券账户编号
    ,o.jrgjbh -- 金融工具编号
    ,o.zclxbh -- 资产类型编号
    ,o.sclxbh -- 市场类型编号
    ,o.khh -- 客户号
    ,o.khmc -- 客户名称
    ,o.jydf -- 交易对手分类描述
    ,o.jyr -- 交易日期
    ,o.dqr -- 到期日期
    ,o.bz -- 币种
    ,o.tzje -- 交易金额
    ,o.qmye -- 当期余额
    ,o.ylj -- 月累计余额
    ,o.nlj -- 年累计余额
    ,o.yqsyl -- 票面利率
    ,o.jxfs -- 记息方式
    ,o.tzlx -- 资产类型名称
    ,o.khjg -- 开户机构
    ,o.ssfhhh -- 所属机构编号
    ,o.ssfh -- 所属分行
    ,o.tjrq -- 统计日期
    ,o.gxhslx -- 关系函数类型
    ,o.khdxdh -- 考核对象代号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.pams_jxdx_lxd_bk o
    left join ${iol_schema}.pams_jxdx_lxd_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_lxd_cl d
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
-- truncate table ${iol_schema}.pams_jxdx_lxd;

-- 4.2 exchange partition
alter table ${iol_schema}.pams_jxdx_lxd exchange partition p_19000101 with table ${iol_schema}.pams_jxdx_lxd_cl;
alter table ${iol_schema}.pams_jxdx_lxd exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_lxd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_lxd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_lxd_op purge;
drop table ${iol_schema}.pams_jxdx_lxd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_lxd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_lxd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
