/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_tycd
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
create table ${iol_schema}.pams_jxdx_tycd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_tycd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_tycd_op purge;
drop table ${iol_schema}.pams_jxdx_tycd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_tycd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_tycd where 0=1;

create table ${iol_schema}.pams_jxdx_tycd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_tycd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_tycd_cl(
            jxdxdh -- 绩效对象代号
            ,wbbh -- 外部账号编号
            ,nbbh -- 内部编号
            ,jrgjbh -- 金融工具编号
            ,sclxbh -- 市场类型编号
            ,ywbh -- 业务编号
            ,cddm -- 存单代码
            ,cdjc -- 存单简称
            ,kmh -- 科目号
            ,zhmc -- 账户名称
            ,fxr -- 发行日
            ,qxr -- 起息日
            ,dqr -- 到期日期
            ,dfr -- 兑付日
            ,qx -- 期限
            ,jxts -- 计息天数
            ,fxjg -- 发行机构
            ,nll -- 年利率
            ,fxl -- 发行量(元)
            ,fxje -- 发行金额(元)
            ,bqye -- 本期余额(元)
            ,sjtzrkhh -- 实际投资人客户号
            ,sjtzrqc -- 实际投资人全称
            ,sjtzrkhfl -- 实际投资人客户分类
            ,sjtzrjglx -- 实际投资人机构类型
            ,fxjgmc -- 发行机构
            ,cdgsjgdh -- 归属机构
            ,xsjgmc -- 销售机构
            ,bz -- 币种
            ,cdmz -- 存单面值(元)
            ,tzrtzmz -- 投资人投资面值(元)
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,ftpll -- 准备金ftp利率
            ,xsjgmczh -- 销售机构名称组合
            ,xsjgmczb -- 销售机构占比说明
            ,gsjgmczh -- 归属机构名称组合
            ,gsjgmczb -- 归属机构占比说明
            ,cpdm -- 产品代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_tycd_op(
            jxdxdh -- 绩效对象代号
            ,wbbh -- 外部账号编号
            ,nbbh -- 内部编号
            ,jrgjbh -- 金融工具编号
            ,sclxbh -- 市场类型编号
            ,ywbh -- 业务编号
            ,cddm -- 存单代码
            ,cdjc -- 存单简称
            ,kmh -- 科目号
            ,zhmc -- 账户名称
            ,fxr -- 发行日
            ,qxr -- 起息日
            ,dqr -- 到期日期
            ,dfr -- 兑付日
            ,qx -- 期限
            ,jxts -- 计息天数
            ,fxjg -- 发行机构
            ,nll -- 年利率
            ,fxl -- 发行量(元)
            ,fxje -- 发行金额(元)
            ,bqye -- 本期余额(元)
            ,sjtzrkhh -- 实际投资人客户号
            ,sjtzrqc -- 实际投资人全称
            ,sjtzrkhfl -- 实际投资人客户分类
            ,sjtzrjglx -- 实际投资人机构类型
            ,fxjgmc -- 发行机构
            ,cdgsjgdh -- 归属机构
            ,xsjgmc -- 销售机构
            ,bz -- 币种
            ,cdmz -- 存单面值(元)
            ,tzrtzmz -- 投资人投资面值(元)
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,ftpll -- 准备金ftp利率
            ,xsjgmczh -- 销售机构名称组合
            ,xsjgmczb -- 销售机构占比说明
            ,gsjgmczh -- 归属机构名称组合
            ,gsjgmczb -- 归属机构占比说明
            ,cpdm -- 产品代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.wbbh, o.wbbh) as wbbh -- 外部账号编号
    ,nvl(n.nbbh, o.nbbh) as nbbh -- 内部编号
    ,nvl(n.jrgjbh, o.jrgjbh) as jrgjbh -- 金融工具编号
    ,nvl(n.sclxbh, o.sclxbh) as sclxbh -- 市场类型编号
    ,nvl(n.ywbh, o.ywbh) as ywbh -- 业务编号
    ,nvl(n.cddm, o.cddm) as cddm -- 存单代码
    ,nvl(n.cdjc, o.cdjc) as cdjc -- 存单简称
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.zhmc, o.zhmc) as zhmc -- 账户名称
    ,nvl(n.fxr, o.fxr) as fxr -- 发行日
    ,nvl(n.qxr, o.qxr) as qxr -- 起息日
    ,nvl(n.dqr, o.dqr) as dqr -- 到期日期
    ,nvl(n.dfr, o.dfr) as dfr -- 兑付日
    ,nvl(n.qx, o.qx) as qx -- 期限
    ,nvl(n.jxts, o.jxts) as jxts -- 计息天数
    ,nvl(n.fxjg, o.fxjg) as fxjg -- 发行机构
    ,nvl(n.nll, o.nll) as nll -- 年利率
    ,nvl(n.fxl, o.fxl) as fxl -- 发行量(元)
    ,nvl(n.fxje, o.fxje) as fxje -- 发行金额(元)
    ,nvl(n.bqye, o.bqye) as bqye -- 本期余额(元)
    ,nvl(n.sjtzrkhh, o.sjtzrkhh) as sjtzrkhh -- 实际投资人客户号
    ,nvl(n.sjtzrqc, o.sjtzrqc) as sjtzrqc -- 实际投资人全称
    ,nvl(n.sjtzrkhfl, o.sjtzrkhfl) as sjtzrkhfl -- 实际投资人客户分类
    ,nvl(n.sjtzrjglx, o.sjtzrjglx) as sjtzrjglx -- 实际投资人机构类型
    ,nvl(n.fxjgmc, o.fxjgmc) as fxjgmc -- 发行机构
    ,nvl(n.cdgsjgdh, o.cdgsjgdh) as cdgsjgdh -- 归属机构
    ,nvl(n.xsjgmc, o.xsjgmc) as xsjgmc -- 销售机构
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.cdmz, o.cdmz) as cdmz -- 存单面值(元)
    ,nvl(n.tzrtzmz, o.tzrtzmz) as tzrtzmz -- 投资人投资面值(元)
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.ftpll, o.ftpll) as ftpll -- 准备金ftp利率
    ,nvl(n.xsjgmczh, o.xsjgmczh) as xsjgmczh -- 销售机构名称组合
    ,nvl(n.xsjgmczb, o.xsjgmczb) as xsjgmczb -- 销售机构占比说明
    ,nvl(n.gsjgmczh, o.gsjgmczh) as gsjgmczh -- 归属机构名称组合
    ,nvl(n.gsjgmczb, o.gsjgmczb) as gsjgmczb -- 归属机构占比说明
    ,nvl(n.cpdm, o.cpdm) as cpdm -- 产品代码
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
from (select * from ${iol_schema}.pams_jxdx_tycd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_tycd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.wbbh <> n.wbbh
        or o.nbbh <> n.nbbh
        or o.jrgjbh <> n.jrgjbh
        or o.sclxbh <> n.sclxbh
        or o.ywbh <> n.ywbh
        or o.cddm <> n.cddm
        or o.cdjc <> n.cdjc
        or o.kmh <> n.kmh
        or o.zhmc <> n.zhmc
        or o.fxr <> n.fxr
        or o.qxr <> n.qxr
        or o.dqr <> n.dqr
        or o.dfr <> n.dfr
        or o.qx <> n.qx
        or o.jxts <> n.jxts
        or o.fxjg <> n.fxjg
        or o.nll <> n.nll
        or o.fxl <> n.fxl
        or o.fxje <> n.fxje
        or o.bqye <> n.bqye
        or o.sjtzrkhh <> n.sjtzrkhh
        or o.sjtzrqc <> n.sjtzrqc
        or o.sjtzrkhfl <> n.sjtzrkhfl
        or o.sjtzrjglx <> n.sjtzrjglx
        or o.fxjgmc <> n.fxjgmc
        or o.cdgsjgdh <> n.cdgsjgdh
        or o.xsjgmc <> n.xsjgmc
        or o.bz <> n.bz
        or o.cdmz <> n.cdmz
        or o.tzrtzmz <> n.tzrtzmz
        or o.khdxdh <> n.khdxdh
        or o.tjrq <> n.tjrq
        or o.gxhslx <> n.gxhslx
        or o.ftpll <> n.ftpll
        or o.xsjgmczh <> n.xsjgmczh
        or o.xsjgmczb <> n.xsjgmczb
        or o.gsjgmczh <> n.gsjgmczh
        or o.gsjgmczb <> n.gsjgmczb
        or o.cpdm <> n.cpdm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_tycd_cl(
            jxdxdh -- 绩效对象代号
            ,wbbh -- 外部账号编号
            ,nbbh -- 内部编号
            ,jrgjbh -- 金融工具编号
            ,sclxbh -- 市场类型编号
            ,ywbh -- 业务编号
            ,cddm -- 存单代码
            ,cdjc -- 存单简称
            ,kmh -- 科目号
            ,zhmc -- 账户名称
            ,fxr -- 发行日
            ,qxr -- 起息日
            ,dqr -- 到期日期
            ,dfr -- 兑付日
            ,qx -- 期限
            ,jxts -- 计息天数
            ,fxjg -- 发行机构
            ,nll -- 年利率
            ,fxl -- 发行量(元)
            ,fxje -- 发行金额(元)
            ,bqye -- 本期余额(元)
            ,sjtzrkhh -- 实际投资人客户号
            ,sjtzrqc -- 实际投资人全称
            ,sjtzrkhfl -- 实际投资人客户分类
            ,sjtzrjglx -- 实际投资人机构类型
            ,fxjgmc -- 发行机构
            ,cdgsjgdh -- 归属机构
            ,xsjgmc -- 销售机构
            ,bz -- 币种
            ,cdmz -- 存单面值(元)
            ,tzrtzmz -- 投资人投资面值(元)
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,ftpll -- 准备金ftp利率
            ,xsjgmczh -- 销售机构名称组合
            ,xsjgmczb -- 销售机构占比说明
            ,gsjgmczh -- 归属机构名称组合
            ,gsjgmczb -- 归属机构占比说明
            ,cpdm -- 产品代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_tycd_op(
            jxdxdh -- 绩效对象代号
            ,wbbh -- 外部账号编号
            ,nbbh -- 内部编号
            ,jrgjbh -- 金融工具编号
            ,sclxbh -- 市场类型编号
            ,ywbh -- 业务编号
            ,cddm -- 存单代码
            ,cdjc -- 存单简称
            ,kmh -- 科目号
            ,zhmc -- 账户名称
            ,fxr -- 发行日
            ,qxr -- 起息日
            ,dqr -- 到期日期
            ,dfr -- 兑付日
            ,qx -- 期限
            ,jxts -- 计息天数
            ,fxjg -- 发行机构
            ,nll -- 年利率
            ,fxl -- 发行量(元)
            ,fxje -- 发行金额(元)
            ,bqye -- 本期余额(元)
            ,sjtzrkhh -- 实际投资人客户号
            ,sjtzrqc -- 实际投资人全称
            ,sjtzrkhfl -- 实际投资人客户分类
            ,sjtzrjglx -- 实际投资人机构类型
            ,fxjgmc -- 发行机构
            ,cdgsjgdh -- 归属机构
            ,xsjgmc -- 销售机构
            ,bz -- 币种
            ,cdmz -- 存单面值(元)
            ,tzrtzmz -- 投资人投资面值(元)
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,gxhslx -- 关系函数类型
            ,ftpll -- 准备金ftp利率
            ,xsjgmczh -- 销售机构名称组合
            ,xsjgmczb -- 销售机构占比说明
            ,gsjgmczh -- 归属机构名称组合
            ,gsjgmczb -- 归属机构占比说明
            ,cpdm -- 产品代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.wbbh -- 外部账号编号
    ,o.nbbh -- 内部编号
    ,o.jrgjbh -- 金融工具编号
    ,o.sclxbh -- 市场类型编号
    ,o.ywbh -- 业务编号
    ,o.cddm -- 存单代码
    ,o.cdjc -- 存单简称
    ,o.kmh -- 科目号
    ,o.zhmc -- 账户名称
    ,o.fxr -- 发行日
    ,o.qxr -- 起息日
    ,o.dqr -- 到期日期
    ,o.dfr -- 兑付日
    ,o.qx -- 期限
    ,o.jxts -- 计息天数
    ,o.fxjg -- 发行机构
    ,o.nll -- 年利率
    ,o.fxl -- 发行量(元)
    ,o.fxje -- 发行金额(元)
    ,o.bqye -- 本期余额(元)
    ,o.sjtzrkhh -- 实际投资人客户号
    ,o.sjtzrqc -- 实际投资人全称
    ,o.sjtzrkhfl -- 实际投资人客户分类
    ,o.sjtzrjglx -- 实际投资人机构类型
    ,o.fxjgmc -- 发行机构
    ,o.cdgsjgdh -- 归属机构
    ,o.xsjgmc -- 销售机构
    ,o.bz -- 币种
    ,o.cdmz -- 存单面值(元)
    ,o.tzrtzmz -- 投资人投资面值(元)
    ,o.khdxdh -- 考核对象代号
    ,o.tjrq -- 统计日期
    ,o.gxhslx -- 关系函数类型
    ,o.ftpll -- 准备金ftp利率
    ,o.xsjgmczh -- 销售机构名称组合
    ,o.xsjgmczb -- 销售机构占比说明
    ,o.gsjgmczh -- 归属机构名称组合
    ,o.gsjgmczb -- 归属机构占比说明
    ,o.cpdm -- 产品代码
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
from ${iol_schema}.pams_jxdx_tycd_bk o
    left join ${iol_schema}.pams_jxdx_tycd_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_tycd_cl d
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
--truncate table ${iol_schema}.pams_jxdx_tycd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_tycd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_tycd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_tycd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_tycd exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_tycd_cl;
alter table ${iol_schema}.pams_jxdx_tycd exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_tycd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_tycd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_tycd_op purge;
drop table ${iol_schema}.pams_jxdx_tycd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_tycd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_tycd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
