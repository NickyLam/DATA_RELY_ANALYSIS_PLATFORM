/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_tyffzck
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
create table ${iol_schema}.pams_jxdx_tyffzck_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_tyffzck
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_tyffzck_op purge;
drop table ${iol_schema}.pams_jxdx_tyffzck_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_tyffzck_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_tyffzck where 0=1;

create table ${iol_schema}.pams_jxdx_tyffzck_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_tyffzck where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_tyffzck_cl(
            jxdxdh -- 绩效对象代号
            ,ywbh -- 业务编号
            ,wbbh -- 外部账户编号
            ,nbbh -- 内部账户编号
            ,zclxbh -- 资产类型编号
            ,sclxbh -- 市场类型编号
            ,jrgjdm -- 金融工具代码
            ,jrgjmc -- 金融工具名称
            ,kjfl -- 会计分类
            ,cplx -- 产品类型
            ,jyssjgdh -- 交易所属机构
            ,jyrq -- 交易日期
            ,jydskhh -- 交易对手客户号
            ,jyds -- 交易对手
            ,jydslx -- 交易对手客户分类
            ,sjrzrkhh -- 发行人/实际融资人客户号
            ,sjrzr -- 发行人/实际融资人
            ,sjrzrlx -- 实际融资人客户分类
            ,bz -- 币种
            ,tzbj -- 投资本金(元)
            ,zxll -- 执行利率
            ,qxr -- 起息日
            ,dqr -- 到期日期
            ,scfxrq -- 首次付息日期
            ,fxpl -- 付息频率
            ,jxjz -- 计息基准
            ,tzye -- 投资余额
            ,zmye -- 账面余额
            ,bjkmh -- 本金科目号
            ,ftpll -- 准备金ftp利率
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,xplx -- 息票类型
            ,sjly -- 数据来源
            ,czcdm -- 次资产代码
            ,ywlbmc -- 业务类别名称
            ,zclbmc -- 资产类别名称
            ,jjcf -- 经济成分
            ,txhy -- 投向行业
            ,ssdq -- 所属地区
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_tyffzck_op(
            jxdxdh -- 绩效对象代号
            ,ywbh -- 业务编号
            ,wbbh -- 外部账户编号
            ,nbbh -- 内部账户编号
            ,zclxbh -- 资产类型编号
            ,sclxbh -- 市场类型编号
            ,jrgjdm -- 金融工具代码
            ,jrgjmc -- 金融工具名称
            ,kjfl -- 会计分类
            ,cplx -- 产品类型
            ,jyssjgdh -- 交易所属机构
            ,jyrq -- 交易日期
            ,jydskhh -- 交易对手客户号
            ,jyds -- 交易对手
            ,jydslx -- 交易对手客户分类
            ,sjrzrkhh -- 发行人/实际融资人客户号
            ,sjrzr -- 发行人/实际融资人
            ,sjrzrlx -- 实际融资人客户分类
            ,bz -- 币种
            ,tzbj -- 投资本金(元)
            ,zxll -- 执行利率
            ,qxr -- 起息日
            ,dqr -- 到期日期
            ,scfxrq -- 首次付息日期
            ,fxpl -- 付息频率
            ,jxjz -- 计息基准
            ,tzye -- 投资余额
            ,zmye -- 账面余额
            ,bjkmh -- 本金科目号
            ,ftpll -- 准备金ftp利率
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,xplx -- 息票类型
            ,sjly -- 数据来源
            ,czcdm -- 次资产代码
            ,ywlbmc -- 业务类别名称
            ,zclbmc -- 资产类别名称
            ,jjcf -- 经济成分
            ,txhy -- 投向行业
            ,ssdq -- 所属地区
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.ywbh, o.ywbh) as ywbh -- 业务编号
    ,nvl(n.wbbh, o.wbbh) as wbbh -- 外部账户编号
    ,nvl(n.nbbh, o.nbbh) as nbbh -- 内部账户编号
    ,nvl(n.zclxbh, o.zclxbh) as zclxbh -- 资产类型编号
    ,nvl(n.sclxbh, o.sclxbh) as sclxbh -- 市场类型编号
    ,nvl(n.jrgjdm, o.jrgjdm) as jrgjdm -- 金融工具代码
    ,nvl(n.jrgjmc, o.jrgjmc) as jrgjmc -- 金融工具名称
    ,nvl(n.kjfl, o.kjfl) as kjfl -- 会计分类
    ,nvl(n.cplx, o.cplx) as cplx -- 产品类型
    ,nvl(n.jyssjgdh, o.jyssjgdh) as jyssjgdh -- 交易所属机构
    ,nvl(n.jyrq, o.jyrq) as jyrq -- 交易日期
    ,nvl(n.jydskhh, o.jydskhh) as jydskhh -- 交易对手客户号
    ,nvl(n.jyds, o.jyds) as jyds -- 交易对手
    ,nvl(n.jydslx, o.jydslx) as jydslx -- 交易对手客户分类
    ,nvl(n.sjrzrkhh, o.sjrzrkhh) as sjrzrkhh -- 发行人/实际融资人客户号
    ,nvl(n.sjrzr, o.sjrzr) as sjrzr -- 发行人/实际融资人
    ,nvl(n.sjrzrlx, o.sjrzrlx) as sjrzrlx -- 实际融资人客户分类
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.tzbj, o.tzbj) as tzbj -- 投资本金(元)
    ,nvl(n.zxll, o.zxll) as zxll -- 执行利率
    ,nvl(n.qxr, o.qxr) as qxr -- 起息日
    ,nvl(n.dqr, o.dqr) as dqr -- 到期日期
    ,nvl(n.scfxrq, o.scfxrq) as scfxrq -- 首次付息日期
    ,nvl(n.fxpl, o.fxpl) as fxpl -- 付息频率
    ,nvl(n.jxjz, o.jxjz) as jxjz -- 计息基准
    ,nvl(n.tzye, o.tzye) as tzye -- 投资余额
    ,nvl(n.zmye, o.zmye) as zmye -- 账面余额
    ,nvl(n.bjkmh, o.bjkmh) as bjkmh -- 本金科目号
    ,nvl(n.ftpll, o.ftpll) as ftpll -- 准备金ftp利率
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.xplx, o.xplx) as xplx -- 息票类型
    ,nvl(n.sjly, o.sjly) as sjly -- 数据来源
    ,nvl(n.czcdm, o.czcdm) as czcdm -- 次资产代码
    ,nvl(n.ywlbmc, o.ywlbmc) as ywlbmc -- 业务类别名称
    ,nvl(n.zclbmc, o.zclbmc) as zclbmc -- 资产类别名称
    ,nvl(n.jjcf, o.jjcf) as jjcf -- 经济成分
    ,nvl(n.txhy, o.txhy) as txhy -- 投向行业
    ,nvl(n.ssdq, o.ssdq) as ssdq -- 所属地区
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
from (select * from ${iol_schema}.pams_jxdx_tyffzck_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_tyffzck where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.wbbh <> n.wbbh
        or o.nbbh <> n.nbbh
        or o.zclxbh <> n.zclxbh
        or o.sclxbh <> n.sclxbh
        or o.jrgjdm <> n.jrgjdm
        or o.jrgjmc <> n.jrgjmc
        or o.kjfl <> n.kjfl
        or o.cplx <> n.cplx
        or o.jyssjgdh <> n.jyssjgdh
        or o.jyrq <> n.jyrq
        or o.jydskhh <> n.jydskhh
        or o.jyds <> n.jyds
        or o.jydslx <> n.jydslx
        or o.sjrzrkhh <> n.sjrzrkhh
        or o.sjrzr <> n.sjrzr
        or o.sjrzrlx <> n.sjrzrlx
        or o.bz <> n.bz
        or o.tzbj <> n.tzbj
        or o.zxll <> n.zxll
        or o.qxr <> n.qxr
        or o.dqr <> n.dqr
        or o.scfxrq <> n.scfxrq
        or o.fxpl <> n.fxpl
        or o.jxjz <> n.jxjz
        or o.tzye <> n.tzye
        or o.zmye <> n.zmye
        or o.bjkmh <> n.bjkmh
        or o.ftpll <> n.ftpll
        or o.gxhslx <> n.gxhslx
        or o.khdxdh <> n.khdxdh
        or o.tjrq <> n.tjrq
        or o.xplx <> n.xplx
        or o.sjly <> n.sjly
        or o.czcdm <> n.czcdm
        or o.ywlbmc <> n.ywlbmc
        or o.zclbmc <> n.zclbmc
        or o.jjcf <> n.jjcf
        or o.txhy <> n.txhy
        or o.ssdq <> n.ssdq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_tyffzck_cl(
            jxdxdh -- 绩效对象代号
            ,ywbh -- 业务编号
            ,wbbh -- 外部账户编号
            ,nbbh -- 内部账户编号
            ,zclxbh -- 资产类型编号
            ,sclxbh -- 市场类型编号
            ,jrgjdm -- 金融工具代码
            ,jrgjmc -- 金融工具名称
            ,kjfl -- 会计分类
            ,cplx -- 产品类型
            ,jyssjgdh -- 交易所属机构
            ,jyrq -- 交易日期
            ,jydskhh -- 交易对手客户号
            ,jyds -- 交易对手
            ,jydslx -- 交易对手客户分类
            ,sjrzrkhh -- 发行人/实际融资人客户号
            ,sjrzr -- 发行人/实际融资人
            ,sjrzrlx -- 实际融资人客户分类
            ,bz -- 币种
            ,tzbj -- 投资本金(元)
            ,zxll -- 执行利率
            ,qxr -- 起息日
            ,dqr -- 到期日期
            ,scfxrq -- 首次付息日期
            ,fxpl -- 付息频率
            ,jxjz -- 计息基准
            ,tzye -- 投资余额
            ,zmye -- 账面余额
            ,bjkmh -- 本金科目号
            ,ftpll -- 准备金ftp利率
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,xplx -- 息票类型
            ,sjly -- 数据来源
            ,czcdm -- 次资产代码
            ,ywlbmc -- 业务类别名称
            ,zclbmc -- 资产类别名称
            ,jjcf -- 经济成分
            ,txhy -- 投向行业
            ,ssdq -- 所属地区
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_tyffzck_op(
            jxdxdh -- 绩效对象代号
            ,ywbh -- 业务编号
            ,wbbh -- 外部账户编号
            ,nbbh -- 内部账户编号
            ,zclxbh -- 资产类型编号
            ,sclxbh -- 市场类型编号
            ,jrgjdm -- 金融工具代码
            ,jrgjmc -- 金融工具名称
            ,kjfl -- 会计分类
            ,cplx -- 产品类型
            ,jyssjgdh -- 交易所属机构
            ,jyrq -- 交易日期
            ,jydskhh -- 交易对手客户号
            ,jyds -- 交易对手
            ,jydslx -- 交易对手客户分类
            ,sjrzrkhh -- 发行人/实际融资人客户号
            ,sjrzr -- 发行人/实际融资人
            ,sjrzrlx -- 实际融资人客户分类
            ,bz -- 币种
            ,tzbj -- 投资本金(元)
            ,zxll -- 执行利率
            ,qxr -- 起息日
            ,dqr -- 到期日期
            ,scfxrq -- 首次付息日期
            ,fxpl -- 付息频率
            ,jxjz -- 计息基准
            ,tzye -- 投资余额
            ,zmye -- 账面余额
            ,bjkmh -- 本金科目号
            ,ftpll -- 准备金ftp利率
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,tjrq -- 统计日期
            ,xplx -- 息票类型
            ,sjly -- 数据来源
            ,czcdm -- 次资产代码
            ,ywlbmc -- 业务类别名称
            ,zclbmc -- 资产类别名称
            ,jjcf -- 经济成分
            ,txhy -- 投向行业
            ,ssdq -- 所属地区
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.ywbh -- 业务编号
    ,o.wbbh -- 外部账户编号
    ,o.nbbh -- 内部账户编号
    ,o.zclxbh -- 资产类型编号
    ,o.sclxbh -- 市场类型编号
    ,o.jrgjdm -- 金融工具代码
    ,o.jrgjmc -- 金融工具名称
    ,o.kjfl -- 会计分类
    ,o.cplx -- 产品类型
    ,o.jyssjgdh -- 交易所属机构
    ,o.jyrq -- 交易日期
    ,o.jydskhh -- 交易对手客户号
    ,o.jyds -- 交易对手
    ,o.jydslx -- 交易对手客户分类
    ,o.sjrzrkhh -- 发行人/实际融资人客户号
    ,o.sjrzr -- 发行人/实际融资人
    ,o.sjrzrlx -- 实际融资人客户分类
    ,o.bz -- 币种
    ,o.tzbj -- 投资本金(元)
    ,o.zxll -- 执行利率
    ,o.qxr -- 起息日
    ,o.dqr -- 到期日期
    ,o.scfxrq -- 首次付息日期
    ,o.fxpl -- 付息频率
    ,o.jxjz -- 计息基准
    ,o.tzye -- 投资余额
    ,o.zmye -- 账面余额
    ,o.bjkmh -- 本金科目号
    ,o.ftpll -- 准备金ftp利率
    ,o.gxhslx -- 关系函数类型
    ,o.khdxdh -- 考核对象代号
    ,o.tjrq -- 统计日期
    ,o.xplx -- 息票类型
    ,o.sjly -- 数据来源
    ,o.czcdm -- 次资产代码
    ,o.ywlbmc -- 业务类别名称
    ,o.zclbmc -- 资产类别名称
    ,o.jjcf -- 经济成分
    ,o.txhy -- 投向行业
    ,o.ssdq -- 所属地区
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
from ${iol_schema}.pams_jxdx_tyffzck_bk o
    left join ${iol_schema}.pams_jxdx_tyffzck_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_tyffzck_cl d
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
--truncate table ${iol_schema}.pams_jxdx_tyffzck;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_tyffzck') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_tyffzck drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_tyffzck add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_tyffzck exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_tyffzck_cl;
alter table ${iol_schema}.pams_jxdx_tyffzck exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_tyffzck_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_tyffzck to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_tyffzck_op purge;
drop table ${iol_schema}.pams_jxdx_tyffzck_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_tyffzck_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_tyffzck',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
