/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_lczh
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
create table ${iol_schema}.pams_jxdx_lczh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_lczh
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_lczh_op purge;
drop table ${iol_schema}.pams_jxdx_lczh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_lczh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_lczh where 0=1;

create table ${iol_schema}.pams_jxdx_lczh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_lczh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_lczh_cl(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账号
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,xhrq -- 销户日期
            ,cpdm -- 产品代码
            ,cplb -- 产品类别
            ,cpmc -- 产品名称
            ,mjksr -- 募集开始日
            ,mjjsr -- 募集结束日
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,zhzt -- 账户状态
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,qxrq -- 起息日期
            ,zxrq -- 注销日期
            ,yqnhsyl -- 年化收益率
            ,cpyzsj -- 产品运作时间
            ,mrjehz -- 买入金额汇总
            ,cyfe -- 持有份额
            ,mjje -- 募集金额
            ,zjjszh -- 资金结算账户
            ,xssdm -- 销售商代码
            ,yhbh -- 银行编号
            ,zhbh -- 账户编号
            ,cplbzs -- 产品类别展示
            ,yqsylms -- 预期收益率描述
            ,lcywlx -- 理财业务类型
            ,nextkfqsrq -- 下一个开放起始日期
            ,nextkfjsrq1 -- 下一个开放结束日期
            ,fxjg -- 发行机构
            ,cpxldm -- 产品小类代码
            ,xsfl -- 销售费率
            ,cjfl -- 差价费率
            ,jz -- 净值
            ,mbbh -- 模板编号
            ,ztbz -- 在途标志：0-否，1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_lczh_op(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账号
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,xhrq -- 销户日期
            ,cpdm -- 产品代码
            ,cplb -- 产品类别
            ,cpmc -- 产品名称
            ,mjksr -- 募集开始日
            ,mjjsr -- 募集结束日
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,zhzt -- 账户状态
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,qxrq -- 起息日期
            ,zxrq -- 注销日期
            ,yqnhsyl -- 年化收益率
            ,cpyzsj -- 产品运作时间
            ,mrjehz -- 买入金额汇总
            ,cyfe -- 持有份额
            ,mjje -- 募集金额
            ,zjjszh -- 资金结算账户
            ,xssdm -- 销售商代码
            ,yhbh -- 银行编号
            ,zhbh -- 账户编号
            ,cplbzs -- 产品类别展示
            ,yqsylms -- 预期收益率描述
            ,lcywlx -- 理财业务类型
            ,nextkfqsrq -- 下一个开放起始日期
            ,nextkfjsrq1 -- 下一个开放结束日期
            ,fxjg -- 发行机构
            ,cpxldm -- 产品小类代码
            ,xsfl -- 销售费率
            ,cjfl -- 差价费率
            ,jz -- 净值
            ,mbbh -- 模板编号
            ,ztbz -- 在途标志：0-否，1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.zhdh, o.zhdh) as zhdh -- 账号
    ,nvl(n.zhhm, o.zhhm) as zhhm -- 账户户名
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.khrq, o.khrq) as khrq -- 开户日期
    ,nvl(n.xhrq, o.xhrq) as xhrq -- 销户日期
    ,nvl(n.cpdm, o.cpdm) as cpdm -- 产品代码
    ,nvl(n.cplb, o.cplb) as cplb -- 产品类别
    ,nvl(n.cpmc, o.cpmc) as cpmc -- 产品名称
    ,nvl(n.mjksr, o.mjksr) as mjksr -- 募集开始日
    ,nvl(n.mjjsr, o.mjjsr) as mjjsr -- 募集结束日
    ,nvl(n.nll, o.nll) as nll -- 年利率
    ,nvl(n.zhye, o.zhye) as zhye -- 账户余额
    ,nvl(n.zhbs, o.zhbs) as zhbs -- 账户标识
    ,nvl(n.zhzt, o.zhzt) as zhzt -- 账户状态
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.qxrq, o.qxrq) as qxrq -- 起息日期
    ,nvl(n.zxrq, o.zxrq) as zxrq -- 注销日期
    ,nvl(n.yqnhsyl, o.yqnhsyl) as yqnhsyl -- 年化收益率
    ,nvl(n.cpyzsj, o.cpyzsj) as cpyzsj -- 产品运作时间
    ,nvl(n.mrjehz, o.mrjehz) as mrjehz -- 买入金额汇总
    ,nvl(n.cyfe, o.cyfe) as cyfe -- 持有份额
    ,nvl(n.mjje, o.mjje) as mjje -- 募集金额
    ,nvl(n.zjjszh, o.zjjszh) as zjjszh -- 资金结算账户
    ,nvl(n.xssdm, o.xssdm) as xssdm -- 销售商代码
    ,nvl(n.yhbh, o.yhbh) as yhbh -- 银行编号
    ,nvl(n.zhbh, o.zhbh) as zhbh -- 账户编号
    ,nvl(n.cplbzs, o.cplbzs) as cplbzs -- 产品类别展示
    ,nvl(n.yqsylms, o.yqsylms) as yqsylms -- 预期收益率描述
    ,nvl(n.lcywlx, o.lcywlx) as lcywlx -- 理财业务类型
    ,nvl(n.nextkfqsrq, o.nextkfqsrq) as nextkfqsrq -- 下一个开放起始日期
    ,nvl(n.nextkfjsrq1, o.nextkfjsrq1) as nextkfjsrq1 -- 下一个开放结束日期
    ,nvl(n.fxjg, o.fxjg) as fxjg -- 发行机构
    ,nvl(n.cpxldm, o.cpxldm) as cpxldm -- 产品小类代码
    ,nvl(n.xsfl, o.xsfl) as xsfl -- 销售费率
    ,nvl(n.cjfl, o.cjfl) as cjfl -- 差价费率
    ,nvl(n.jz, o.jz) as jz -- 净值
    ,nvl(n.mbbh, o.mbbh) as mbbh -- 模板编号
    ,nvl(n.ztbz, o.ztbz) as ztbz -- 在途标志：0-否，1-是
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
from (select * from ${iol_schema}.pams_jxdx_lczh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_lczh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.zhdh <> n.zhdh
        or o.zhhm <> n.zhhm
        or o.bz <> n.bz
        or o.jgdh <> n.jgdh
        or o.kmh <> n.kmh
        or o.khrq <> n.khrq
        or o.xhrq <> n.xhrq
        or o.cpdm <> n.cpdm
        or o.cplb <> n.cplb
        or o.cpmc <> n.cpmc
        or o.mjksr <> n.mjksr
        or o.mjjsr <> n.mjjsr
        or o.nll <> n.nll
        or o.zhye <> n.zhye
        or o.zhbs <> n.zhbs
        or o.zhzt <> n.zhzt
        or o.gxhslx <> n.gxhslx
        or o.khdxdh <> n.khdxdh
        or o.khh <> n.khh
        or o.hydh <> n.hydh
        or o.tjrq <> n.tjrq
        or o.qxrq <> n.qxrq
        or o.zxrq <> n.zxrq
        or o.yqnhsyl <> n.yqnhsyl
        or o.cpyzsj <> n.cpyzsj
        or o.mrjehz <> n.mrjehz
        or o.cyfe <> n.cyfe
        or o.mjje <> n.mjje
        or o.zjjszh <> n.zjjszh
        or o.xssdm <> n.xssdm
        or o.yhbh <> n.yhbh
        or o.zhbh <> n.zhbh
        or o.cplbzs <> n.cplbzs
        or o.yqsylms <> n.yqsylms
        or o.lcywlx <> n.lcywlx
        or o.nextkfqsrq <> n.nextkfqsrq
        or o.nextkfjsrq1 <> n.nextkfjsrq1
        or o.fxjg <> n.fxjg
        or o.cpxldm <> n.cpxldm
        or o.xsfl <> n.xsfl
        or o.cjfl <> n.cjfl
        or o.jz <> n.jz
        or o.mbbh <> n.mbbh
        or o.ztbz <> n.ztbz
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_lczh_cl(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账号
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,xhrq -- 销户日期
            ,cpdm -- 产品代码
            ,cplb -- 产品类别
            ,cpmc -- 产品名称
            ,mjksr -- 募集开始日
            ,mjjsr -- 募集结束日
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,zhzt -- 账户状态
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,qxrq -- 起息日期
            ,zxrq -- 注销日期
            ,yqnhsyl -- 年化收益率
            ,cpyzsj -- 产品运作时间
            ,mrjehz -- 买入金额汇总
            ,cyfe -- 持有份额
            ,mjje -- 募集金额
            ,zjjszh -- 资金结算账户
            ,xssdm -- 销售商代码
            ,yhbh -- 银行编号
            ,zhbh -- 账户编号
            ,cplbzs -- 产品类别展示
            ,yqsylms -- 预期收益率描述
            ,lcywlx -- 理财业务类型
            ,nextkfqsrq -- 下一个开放起始日期
            ,nextkfjsrq1 -- 下一个开放结束日期
            ,fxjg -- 发行机构
            ,cpxldm -- 产品小类代码
            ,xsfl -- 销售费率
            ,cjfl -- 差价费率
            ,jz -- 净值
            ,mbbh -- 模板编号
            ,ztbz -- 在途标志：0-否，1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_lczh_op(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账号
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,jgdh -- 机构代号
            ,kmh -- 科目号
            ,khrq -- 开户日期
            ,xhrq -- 销户日期
            ,cpdm -- 产品代码
            ,cplb -- 产品类别
            ,cpmc -- 产品名称
            ,mjksr -- 募集开始日
            ,mjjsr -- 募集结束日
            ,nll -- 年利率
            ,zhye -- 账户余额
            ,zhbs -- 账户标识
            ,zhzt -- 账户状态
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,khh -- 客户号
            ,hydh -- 行员代号
            ,tjrq -- 统计日期
            ,qxrq -- 起息日期
            ,zxrq -- 注销日期
            ,yqnhsyl -- 年化收益率
            ,cpyzsj -- 产品运作时间
            ,mrjehz -- 买入金额汇总
            ,cyfe -- 持有份额
            ,mjje -- 募集金额
            ,zjjszh -- 资金结算账户
            ,xssdm -- 销售商代码
            ,yhbh -- 银行编号
            ,zhbh -- 账户编号
            ,cplbzs -- 产品类别展示
            ,yqsylms -- 预期收益率描述
            ,lcywlx -- 理财业务类型
            ,nextkfqsrq -- 下一个开放起始日期
            ,nextkfjsrq1 -- 下一个开放结束日期
            ,fxjg -- 发行机构
            ,cpxldm -- 产品小类代码
            ,xsfl -- 销售费率
            ,cjfl -- 差价费率
            ,jz -- 净值
            ,mbbh -- 模板编号
            ,ztbz -- 在途标志：0-否，1-是
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.zhdh -- 账号
    ,o.zhhm -- 账户户名
    ,o.bz -- 币种
    ,o.jgdh -- 机构代号
    ,o.kmh -- 科目号
    ,o.khrq -- 开户日期
    ,o.xhrq -- 销户日期
    ,o.cpdm -- 产品代码
    ,o.cplb -- 产品类别
    ,o.cpmc -- 产品名称
    ,o.mjksr -- 募集开始日
    ,o.mjjsr -- 募集结束日
    ,o.nll -- 年利率
    ,o.zhye -- 账户余额
    ,o.zhbs -- 账户标识
    ,o.zhzt -- 账户状态
    ,o.gxhslx -- 关系函数类型
    ,o.khdxdh -- 考核对象代号
    ,o.khh -- 客户号
    ,o.hydh -- 行员代号
    ,o.tjrq -- 统计日期
    ,o.qxrq -- 起息日期
    ,o.zxrq -- 注销日期
    ,o.yqnhsyl -- 年化收益率
    ,o.cpyzsj -- 产品运作时间
    ,o.mrjehz -- 买入金额汇总
    ,o.cyfe -- 持有份额
    ,o.mjje -- 募集金额
    ,o.zjjszh -- 资金结算账户
    ,o.xssdm -- 销售商代码
    ,o.yhbh -- 银行编号
    ,o.zhbh -- 账户编号
    ,o.cplbzs -- 产品类别展示
    ,o.yqsylms -- 预期收益率描述
    ,o.lcywlx -- 理财业务类型
    ,o.nextkfqsrq -- 下一个开放起始日期
    ,o.nextkfjsrq1 -- 下一个开放结束日期
    ,o.fxjg -- 发行机构
    ,o.cpxldm -- 产品小类代码
    ,o.xsfl -- 销售费率
    ,o.cjfl -- 差价费率
    ,o.jz -- 净值
    ,o.mbbh -- 模板编号
    ,o.ztbz -- 在途标志：0-否，1-是
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
from ${iol_schema}.pams_jxdx_lczh_bk o
    left join ${iol_schema}.pams_jxdx_lczh_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_lczh_cl d
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
--truncate table ${iol_schema}.pams_jxdx_lczh;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_lczh') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_lczh drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_lczh add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_lczh exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_lczh_cl;
alter table ${iol_schema}.pams_jxdx_lczh exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_lczh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_lczh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_lczh_op purge;
drop table ${iol_schema}.pams_jxdx_lczh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_lczh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_lczh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
