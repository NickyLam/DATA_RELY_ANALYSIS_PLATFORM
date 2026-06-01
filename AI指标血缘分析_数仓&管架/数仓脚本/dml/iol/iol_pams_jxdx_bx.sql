/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_bx
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
create table ${iol_schema}.pams_jxdx_bx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_bx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_bx_op purge;
drop table ${iol_schema}.pams_jxdx_bx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_bx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_bx where 0=1;

create table ${iol_schema}.pams_jxdx_bx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_bx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_bx_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,jyzhdh -- 账号代号
            ,cph -- 产品号
            ,cpmc -- 产品名称
            ,bxdbh -- 保险单编号
            ,xybh -- 协议编号
            ,frbh -- 法人编号
            ,tadm -- TA代码
            ,khh -- 客户号
            ,jgdh -- 机构代号
            ,hydh -- 行员代号
            ,gydh -- 柜员工号
            ,jyrq -- 交易日期
            ,bdrq -- 保单日期
            ,bdsxrq -- 保单生效日期
            ,bxdqrq -- 保险到期日期
            ,tbrmc -- 投保人名称
            ,tbrzjhm -- 投保人证件号码
            ,bxgsmc -- 保险公司名称
            ,xzlx -- 险种类型
            ,zxmc -- 产品全称
            ,tbxz -- 投保险种
            ,bbxrmc -- 被保险人名称
            ,bbxrzjhm -- 被保险人证件号码
            ,jffs -- 缴费方式
            ,jfnqdw -- 缴费年期单位
            ,bxqxdw -- 保险期限单位
            ,jfnq -- 缴费年期
            ,bxqx -- 保险期限
            ,jyqd -- 交易渠道
            ,bdzt -- 保单状态
            ,tbrq -- 投保日期
            ,zhye -- 账户余额
            ,dlsxfl -- 代理手续费率
            ,dlsxf -- 代理手续费
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,qs -- 取数
            ,xzmc -- 险种名称
            ,bf -- 保费
            ,nlj -- 年累计
            ,jlj -- 季累计
            ,ylj -- 月累计余额
            ,nrj -- 年日均
            ,jrj -- 季日均
            ,yrj -- 月日均
            ,ncye -- 年初余额
            ,jcye -- 季初余额
            ,ycye -- 月初余额
            ,dqye -- 当期余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_bx_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,jyzhdh -- 账号代号
            ,cph -- 产品号
            ,cpmc -- 产品名称
            ,bxdbh -- 保险单编号
            ,xybh -- 协议编号
            ,frbh -- 法人编号
            ,tadm -- TA代码
            ,khh -- 客户号
            ,jgdh -- 机构代号
            ,hydh -- 行员代号
            ,gydh -- 柜员工号
            ,jyrq -- 交易日期
            ,bdrq -- 保单日期
            ,bdsxrq -- 保单生效日期
            ,bxdqrq -- 保险到期日期
            ,tbrmc -- 投保人名称
            ,tbrzjhm -- 投保人证件号码
            ,bxgsmc -- 保险公司名称
            ,xzlx -- 险种类型
            ,zxmc -- 产品全称
            ,tbxz -- 投保险种
            ,bbxrmc -- 被保险人名称
            ,bbxrzjhm -- 被保险人证件号码
            ,jffs -- 缴费方式
            ,jfnqdw -- 缴费年期单位
            ,bxqxdw -- 保险期限单位
            ,jfnq -- 缴费年期
            ,bxqx -- 保险期限
            ,jyqd -- 交易渠道
            ,bdzt -- 保单状态
            ,tbrq -- 投保日期
            ,zhye -- 账户余额
            ,dlsxfl -- 代理手续费率
            ,dlsxf -- 代理手续费
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,qs -- 取数
            ,xzmc -- 险种名称
            ,bf -- 保费
            ,nlj -- 年累计
            ,jlj -- 季累计
            ,ylj -- 月累计余额
            ,nrj -- 年日均
            ,jrj -- 季日均
            ,yrj -- 月日均
            ,ncye -- 年初余额
            ,jcye -- 季初余额
            ,ycye -- 月初余额
            ,dqye -- 当期余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.jyzhdh, o.jyzhdh) as jyzhdh -- 账号代号
    ,nvl(n.cph, o.cph) as cph -- 产品号
    ,nvl(n.cpmc, o.cpmc) as cpmc -- 产品名称
    ,nvl(n.bxdbh, o.bxdbh) as bxdbh -- 保险单编号
    ,nvl(n.xybh, o.xybh) as xybh -- 协议编号
    ,nvl(n.frbh, o.frbh) as frbh -- 法人编号
    ,nvl(n.tadm, o.tadm) as tadm -- TA代码
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.jgdh, o.jgdh) as jgdh -- 机构代号
    ,nvl(n.hydh, o.hydh) as hydh -- 行员代号
    ,nvl(n.gydh, o.gydh) as gydh -- 柜员工号
    ,nvl(n.jyrq, o.jyrq) as jyrq -- 交易日期
    ,nvl(n.bdrq, o.bdrq) as bdrq -- 保单日期
    ,nvl(n.bdsxrq, o.bdsxrq) as bdsxrq -- 保单生效日期
    ,nvl(n.bxdqrq, o.bxdqrq) as bxdqrq -- 保险到期日期
    ,nvl(n.tbrmc, o.tbrmc) as tbrmc -- 投保人名称
    ,nvl(n.tbrzjhm, o.tbrzjhm) as tbrzjhm -- 投保人证件号码
    ,nvl(n.bxgsmc, o.bxgsmc) as bxgsmc -- 保险公司名称
    ,nvl(n.xzlx, o.xzlx) as xzlx -- 险种类型
    ,nvl(n.zxmc, o.zxmc) as zxmc -- 产品全称
    ,nvl(n.tbxz, o.tbxz) as tbxz -- 投保险种
    ,nvl(n.bbxrmc, o.bbxrmc) as bbxrmc -- 被保险人名称
    ,nvl(n.bbxrzjhm, o.bbxrzjhm) as bbxrzjhm -- 被保险人证件号码
    ,nvl(n.jffs, o.jffs) as jffs -- 缴费方式
    ,nvl(n.jfnqdw, o.jfnqdw) as jfnqdw -- 缴费年期单位
    ,nvl(n.bxqxdw, o.bxqxdw) as bxqxdw -- 保险期限单位
    ,nvl(n.jfnq, o.jfnq) as jfnq -- 缴费年期
    ,nvl(n.bxqx, o.bxqx) as bxqx -- 保险期限
    ,nvl(n.jyqd, o.jyqd) as jyqd -- 交易渠道
    ,nvl(n.bdzt, o.bdzt) as bdzt -- 保单状态
    ,nvl(n.tbrq, o.tbrq) as tbrq -- 投保日期
    ,nvl(n.zhye, o.zhye) as zhye -- 账户余额
    ,nvl(n.dlsxfl, o.dlsxfl) as dlsxfl -- 代理手续费率
    ,nvl(n.dlsxf, o.dlsxf) as dlsxf -- 代理手续费
    ,nvl(n.khdxdh, o.khdxdh) as khdxdh -- 考核对象代号
    ,nvl(n.gxhslx, o.gxhslx) as gxhslx -- 关系函数类型
    ,nvl(n.qs, o.qs) as qs -- 取数
    ,nvl(n.xzmc, o.xzmc) as xzmc -- 险种名称
    ,nvl(n.bf, o.bf) as bf -- 保费
    ,nvl(n.nlj, o.nlj) as nlj -- 年累计
    ,nvl(n.jlj, o.jlj) as jlj -- 季累计
    ,nvl(n.ylj, o.ylj) as ylj -- 月累计余额
    ,nvl(n.nrj, o.nrj) as nrj -- 年日均
    ,nvl(n.jrj, o.jrj) as jrj -- 季日均
    ,nvl(n.yrj, o.yrj) as yrj -- 月日均
    ,nvl(n.ncye, o.ncye) as ncye -- 年初余额
    ,nvl(n.jcye, o.jcye) as jcye -- 季初余额
    ,nvl(n.ycye, o.ycye) as ycye -- 月初余额
    ,nvl(n.dqye, o.dqye) as dqye -- 当期余额
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
from (select * from ${iol_schema}.pams_jxdx_bx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_bx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.jxdxdh = n.jxdxdh
where (
        o.jxdxdh is null
    )
    or (
        n.jxdxdh is null
    )
    or (
        o.tjrq <> n.tjrq
        or o.jyzhdh <> n.jyzhdh
        or o.cph <> n.cph
        or o.cpmc <> n.cpmc
        or o.bxdbh <> n.bxdbh
        or o.xybh <> n.xybh
        or o.frbh <> n.frbh
        or o.tadm <> n.tadm
        or o.khh <> n.khh
        or o.jgdh <> n.jgdh
        or o.hydh <> n.hydh
        or o.gydh <> n.gydh
        or o.jyrq <> n.jyrq
        or o.bdrq <> n.bdrq
        or o.bdsxrq <> n.bdsxrq
        or o.bxdqrq <> n.bxdqrq
        or o.tbrmc <> n.tbrmc
        or o.tbrzjhm <> n.tbrzjhm
        or o.bxgsmc <> n.bxgsmc
        or o.xzlx <> n.xzlx
        or o.zxmc <> n.zxmc
        or o.tbxz <> n.tbxz
        or o.bbxrmc <> n.bbxrmc
        or o.bbxrzjhm <> n.bbxrzjhm
        or o.jffs <> n.jffs
        or o.jfnqdw <> n.jfnqdw
        or o.bxqxdw <> n.bxqxdw
        or o.jfnq <> n.jfnq
        or o.bxqx <> n.bxqx
        or o.jyqd <> n.jyqd
        or o.bdzt <> n.bdzt
        or o.tbrq <> n.tbrq
        or o.zhye <> n.zhye
        or o.dlsxfl <> n.dlsxfl
        or o.dlsxf <> n.dlsxf
        or o.khdxdh <> n.khdxdh
        or o.gxhslx <> n.gxhslx
        or o.qs <> n.qs
        or o.xzmc <> n.xzmc
        or o.bf <> n.bf
        or o.nlj <> n.nlj
        or o.jlj <> n.jlj
        or o.ylj <> n.ylj
        or o.nrj <> n.nrj
        or o.jrj <> n.jrj
        or o.yrj <> n.yrj
        or o.ncye <> n.ncye
        or o.jcye <> n.jcye
        or o.ycye <> n.ycye
        or o.dqye <> n.dqye
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_bx_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,jyzhdh -- 账号代号
            ,cph -- 产品号
            ,cpmc -- 产品名称
            ,bxdbh -- 保险单编号
            ,xybh -- 协议编号
            ,frbh -- 法人编号
            ,tadm -- TA代码
            ,khh -- 客户号
            ,jgdh -- 机构代号
            ,hydh -- 行员代号
            ,gydh -- 柜员工号
            ,jyrq -- 交易日期
            ,bdrq -- 保单日期
            ,bdsxrq -- 保单生效日期
            ,bxdqrq -- 保险到期日期
            ,tbrmc -- 投保人名称
            ,tbrzjhm -- 投保人证件号码
            ,bxgsmc -- 保险公司名称
            ,xzlx -- 险种类型
            ,zxmc -- 产品全称
            ,tbxz -- 投保险种
            ,bbxrmc -- 被保险人名称
            ,bbxrzjhm -- 被保险人证件号码
            ,jffs -- 缴费方式
            ,jfnqdw -- 缴费年期单位
            ,bxqxdw -- 保险期限单位
            ,jfnq -- 缴费年期
            ,bxqx -- 保险期限
            ,jyqd -- 交易渠道
            ,bdzt -- 保单状态
            ,tbrq -- 投保日期
            ,zhye -- 账户余额
            ,dlsxfl -- 代理手续费率
            ,dlsxf -- 代理手续费
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,qs -- 取数
            ,xzmc -- 险种名称
            ,bf -- 保费
            ,nlj -- 年累计
            ,jlj -- 季累计
            ,ylj -- 月累计余额
            ,nrj -- 年日均
            ,jrj -- 季日均
            ,yrj -- 月日均
            ,ncye -- 年初余额
            ,jcye -- 季初余额
            ,ycye -- 月初余额
            ,dqye -- 当期余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_bx_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,jyzhdh -- 账号代号
            ,cph -- 产品号
            ,cpmc -- 产品名称
            ,bxdbh -- 保险单编号
            ,xybh -- 协议编号
            ,frbh -- 法人编号
            ,tadm -- TA代码
            ,khh -- 客户号
            ,jgdh -- 机构代号
            ,hydh -- 行员代号
            ,gydh -- 柜员工号
            ,jyrq -- 交易日期
            ,bdrq -- 保单日期
            ,bdsxrq -- 保单生效日期
            ,bxdqrq -- 保险到期日期
            ,tbrmc -- 投保人名称
            ,tbrzjhm -- 投保人证件号码
            ,bxgsmc -- 保险公司名称
            ,xzlx -- 险种类型
            ,zxmc -- 产品全称
            ,tbxz -- 投保险种
            ,bbxrmc -- 被保险人名称
            ,bbxrzjhm -- 被保险人证件号码
            ,jffs -- 缴费方式
            ,jfnqdw -- 缴费年期单位
            ,bxqxdw -- 保险期限单位
            ,jfnq -- 缴费年期
            ,bxqx -- 保险期限
            ,jyqd -- 交易渠道
            ,bdzt -- 保单状态
            ,tbrq -- 投保日期
            ,zhye -- 账户余额
            ,dlsxfl -- 代理手续费率
            ,dlsxf -- 代理手续费
            ,khdxdh -- 考核对象代号
            ,gxhslx -- 关系函数类型
            ,qs -- 取数
            ,xzmc -- 险种名称
            ,bf -- 保费
            ,nlj -- 年累计
            ,jlj -- 季累计
            ,ylj -- 月累计余额
            ,nrj -- 年日均
            ,jrj -- 季日均
            ,yrj -- 月日均
            ,ncye -- 年初余额
            ,jcye -- 季初余额
            ,ycye -- 月初余额
            ,dqye -- 当期余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.tjrq -- 统计日期
    ,o.jyzhdh -- 账号代号
    ,o.cph -- 产品号
    ,o.cpmc -- 产品名称
    ,o.bxdbh -- 保险单编号
    ,o.xybh -- 协议编号
    ,o.frbh -- 法人编号
    ,o.tadm -- TA代码
    ,o.khh -- 客户号
    ,o.jgdh -- 机构代号
    ,o.hydh -- 行员代号
    ,o.gydh -- 柜员工号
    ,o.jyrq -- 交易日期
    ,o.bdrq -- 保单日期
    ,o.bdsxrq -- 保单生效日期
    ,o.bxdqrq -- 保险到期日期
    ,o.tbrmc -- 投保人名称
    ,o.tbrzjhm -- 投保人证件号码
    ,o.bxgsmc -- 保险公司名称
    ,o.xzlx -- 险种类型
    ,o.zxmc -- 产品全称
    ,o.tbxz -- 投保险种
    ,o.bbxrmc -- 被保险人名称
    ,o.bbxrzjhm -- 被保险人证件号码
    ,o.jffs -- 缴费方式
    ,o.jfnqdw -- 缴费年期单位
    ,o.bxqxdw -- 保险期限单位
    ,o.jfnq -- 缴费年期
    ,o.bxqx -- 保险期限
    ,o.jyqd -- 交易渠道
    ,o.bdzt -- 保单状态
    ,o.tbrq -- 投保日期
    ,o.zhye -- 账户余额
    ,o.dlsxfl -- 代理手续费率
    ,o.dlsxf -- 代理手续费
    ,o.khdxdh -- 考核对象代号
    ,o.gxhslx -- 关系函数类型
    ,o.qs -- 取数
    ,o.xzmc -- 险种名称
    ,o.bf -- 保费
    ,o.nlj -- 年累计
    ,o.jlj -- 季累计
    ,o.ylj -- 月累计余额
    ,o.nrj -- 年日均
    ,o.jrj -- 季日均
    ,o.yrj -- 月日均
    ,o.ncye -- 年初余额
    ,o.jcye -- 季初余额
    ,o.ycye -- 月初余额
    ,o.dqye -- 当期余额
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
from ${iol_schema}.pams_jxdx_bx_bk o
    left join ${iol_schema}.pams_jxdx_bx_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_bx_cl d
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
--truncate table ${iol_schema}.pams_jxdx_bx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_bx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_bx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_bx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_bx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_bx_cl;
alter table ${iol_schema}.pams_jxdx_bx exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_bx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_bx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_bx_op purge;
drop table ${iol_schema}.pams_jxdx_bx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_bx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_bx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
