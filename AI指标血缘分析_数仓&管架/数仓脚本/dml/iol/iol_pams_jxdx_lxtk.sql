/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_lxtk
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
create table ${iol_schema}.pams_jxdx_lxtk_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxdx_lxtk
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_lxtk_op purge;
drop table ${iol_schema}.pams_jxdx_lxtk_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_lxtk_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_lxtk where 0=1;

create table ${iol_schema}.pams_jxdx_lxtk_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxdx_lxtk where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_lxtk_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,qdrq -- 渠道日期
            ,sjh -- 手机号
            ,xnkhh -- 客户ID（虚拟客户号）
            ,zhdh -- 账号（卡号）
            ,khh -- 客户号（内部户）
            ,khjgdh -- 开户行机构代码
            ,ylkhjylsh -- 银联开户交易流水号
            ,khrq -- 开户日期
            ,ywlb -- 业务类别：1-旅行通卡业务；2-福旅通业务
            ,khysms -- 开户要素模式
            ,zjlx -- 证件类型
            ,zjh1 -- 证件号1
            ,zjh2 -- 证件号2
            ,xing -- 姓
            ,ming -- 名
            ,xm -- 姓名
            ,xb -- 性别
            ,csrq -- 出生日期
            ,gj -- 国籍
            ,zy -- 职业
            ,zyms -- 职业描述
            ,ssjmsf -- 税收居民身份
            ,lxdz -- 联系地址
            ,sfzjfzrq -- 身份证件发证日期
            ,sfzjyxq -- 身份证件有效期
            ,yyjcjlsh -- 影印件采集交易的查询流水号
            ,pdm -- 省代码
            ,cdm -- 市代码
            ,ddm -- 区代码
            ,ssn -- 税收居民国/地区
            ,ssid -- 居民国/地区纳税人识别号
            ,jjtgyy -- 不能提供居民国/地区纳税人识别号的原因
            ,jtyy -- 具体原因
            ,rjqd -- 入境渠道
            ,xyhyjg -- 信源核验结果
            ,skqdid -- 申卡渠道id
            ,skqdmc -- 申卡渠道名称
            ,khqjlsh -- 开户全局流水号
            ,zt -- 状态
            ,zhdj -- 账户等级
            ,yxq -- 旅行通卡有效期
            ,xe -- 旅行通卡限额
            ,ljczje -- 累计充值金额
            ,tkzhye -- 退卡账户余额，即退卡账户转清算户交易金额
            ,zxwhrq -- 最新维护时间
            ,jyrq -- 解约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_lxtk_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,qdrq -- 渠道日期
            ,sjh -- 手机号
            ,xnkhh -- 客户ID（虚拟客户号）
            ,zhdh -- 账号（卡号）
            ,khh -- 客户号（内部户）
            ,khjgdh -- 开户行机构代码
            ,ylkhjylsh -- 银联开户交易流水号
            ,khrq -- 开户日期
            ,ywlb -- 业务类别：1-旅行通卡业务；2-福旅通业务
            ,khysms -- 开户要素模式
            ,zjlx -- 证件类型
            ,zjh1 -- 证件号1
            ,zjh2 -- 证件号2
            ,xing -- 姓
            ,ming -- 名
            ,xm -- 姓名
            ,xb -- 性别
            ,csrq -- 出生日期
            ,gj -- 国籍
            ,zy -- 职业
            ,zyms -- 职业描述
            ,ssjmsf -- 税收居民身份
            ,lxdz -- 联系地址
            ,sfzjfzrq -- 身份证件发证日期
            ,sfzjyxq -- 身份证件有效期
            ,yyjcjlsh -- 影印件采集交易的查询流水号
            ,pdm -- 省代码
            ,cdm -- 市代码
            ,ddm -- 区代码
            ,ssn -- 税收居民国/地区
            ,ssid -- 居民国/地区纳税人识别号
            ,jjtgyy -- 不能提供居民国/地区纳税人识别号的原因
            ,jtyy -- 具体原因
            ,rjqd -- 入境渠道
            ,xyhyjg -- 信源核验结果
            ,skqdid -- 申卡渠道id
            ,skqdmc -- 申卡渠道名称
            ,khqjlsh -- 开户全局流水号
            ,zt -- 状态
            ,zhdj -- 账户等级
            ,yxq -- 旅行通卡有效期
            ,xe -- 旅行通卡限额
            ,ljczje -- 累计充值金额
            ,tkzhye -- 退卡账户余额，即退卡账户转清算户交易金额
            ,zxwhrq -- 最新维护时间
            ,jyrq -- 解约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.jxdxdh, o.jxdxdh) as jxdxdh -- 绩效对象代号
    ,nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.qdrq, o.qdrq) as qdrq -- 渠道日期
    ,nvl(n.sjh, o.sjh) as sjh -- 手机号
    ,nvl(n.xnkhh, o.xnkhh) as xnkhh -- 客户ID（虚拟客户号）
    ,nvl(n.zhdh, o.zhdh) as zhdh -- 账号（卡号）
    ,nvl(n.khh, o.khh) as khh -- 客户号（内部户）
    ,nvl(n.khjgdh, o.khjgdh) as khjgdh -- 开户行机构代码
    ,nvl(n.ylkhjylsh, o.ylkhjylsh) as ylkhjylsh -- 银联开户交易流水号
    ,nvl(n.khrq, o.khrq) as khrq -- 开户日期
    ,nvl(n.ywlb, o.ywlb) as ywlb -- 业务类别：1-旅行通卡业务；2-福旅通业务
    ,nvl(n.khysms, o.khysms) as khysms -- 开户要素模式
    ,nvl(n.zjlx, o.zjlx) as zjlx -- 证件类型
    ,nvl(n.zjh1, o.zjh1) as zjh1 -- 证件号1
    ,nvl(n.zjh2, o.zjh2) as zjh2 -- 证件号2
    ,nvl(n.xing, o.xing) as xing -- 姓
    ,nvl(n.ming, o.ming) as ming -- 名
    ,nvl(n.xm, o.xm) as xm -- 姓名
    ,nvl(n.xb, o.xb) as xb -- 性别
    ,nvl(n.csrq, o.csrq) as csrq -- 出生日期
    ,nvl(n.gj, o.gj) as gj -- 国籍
    ,nvl(n.zy, o.zy) as zy -- 职业
    ,nvl(n.zyms, o.zyms) as zyms -- 职业描述
    ,nvl(n.ssjmsf, o.ssjmsf) as ssjmsf -- 税收居民身份
    ,nvl(n.lxdz, o.lxdz) as lxdz -- 联系地址
    ,nvl(n.sfzjfzrq, o.sfzjfzrq) as sfzjfzrq -- 身份证件发证日期
    ,nvl(n.sfzjyxq, o.sfzjyxq) as sfzjyxq -- 身份证件有效期
    ,nvl(n.yyjcjlsh, o.yyjcjlsh) as yyjcjlsh -- 影印件采集交易的查询流水号
    ,nvl(n.pdm, o.pdm) as pdm -- 省代码
    ,nvl(n.cdm, o.cdm) as cdm -- 市代码
    ,nvl(n.ddm, o.ddm) as ddm -- 区代码
    ,nvl(n.ssn, o.ssn) as ssn -- 税收居民国/地区
    ,nvl(n.ssid, o.ssid) as ssid -- 居民国/地区纳税人识别号
    ,nvl(n.jjtgyy, o.jjtgyy) as jjtgyy -- 不能提供居民国/地区纳税人识别号的原因
    ,nvl(n.jtyy, o.jtyy) as jtyy -- 具体原因
    ,nvl(n.rjqd, o.rjqd) as rjqd -- 入境渠道
    ,nvl(n.xyhyjg, o.xyhyjg) as xyhyjg -- 信源核验结果
    ,nvl(n.skqdid, o.skqdid) as skqdid -- 申卡渠道id
    ,nvl(n.skqdmc, o.skqdmc) as skqdmc -- 申卡渠道名称
    ,nvl(n.khqjlsh, o.khqjlsh) as khqjlsh -- 开户全局流水号
    ,nvl(n.zt, o.zt) as zt -- 状态
    ,nvl(n.zhdj, o.zhdj) as zhdj -- 账户等级
    ,nvl(n.yxq, o.yxq) as yxq -- 旅行通卡有效期
    ,nvl(n.xe, o.xe) as xe -- 旅行通卡限额
    ,nvl(n.ljczje, o.ljczje) as ljczje -- 累计充值金额
    ,nvl(n.tkzhye, o.tkzhye) as tkzhye -- 退卡账户余额，即退卡账户转清算户交易金额
    ,nvl(n.zxwhrq, o.zxwhrq) as zxwhrq -- 最新维护时间
    ,nvl(n.jyrq, o.jyrq) as jyrq -- 解约日期
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
from (select * from ${iol_schema}.pams_jxdx_lxtk_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxdx_lxtk where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.qdrq <> n.qdrq
        or o.sjh <> n.sjh
        or o.xnkhh <> n.xnkhh
        or o.zhdh <> n.zhdh
        or o.khh <> n.khh
        or o.khjgdh <> n.khjgdh
        or o.ylkhjylsh <> n.ylkhjylsh
        or o.khrq <> n.khrq
        or o.ywlb <> n.ywlb
        or o.khysms <> n.khysms
        or o.zjlx <> n.zjlx
        or o.zjh1 <> n.zjh1
        or o.zjh2 <> n.zjh2
        or o.xing <> n.xing
        or o.ming <> n.ming
        or o.xm <> n.xm
        or o.xb <> n.xb
        or o.csrq <> n.csrq
        or o.gj <> n.gj
        or o.zy <> n.zy
        or o.zyms <> n.zyms
        or o.ssjmsf <> n.ssjmsf
        or o.lxdz <> n.lxdz
        or o.sfzjfzrq <> n.sfzjfzrq
        or o.sfzjyxq <> n.sfzjyxq
        or o.yyjcjlsh <> n.yyjcjlsh
        or o.pdm <> n.pdm
        or o.cdm <> n.cdm
        or o.ddm <> n.ddm
        or o.ssn <> n.ssn
        or o.ssid <> n.ssid
        or o.jjtgyy <> n.jjtgyy
        or o.jtyy <> n.jtyy
        or o.rjqd <> n.rjqd
        or o.xyhyjg <> n.xyhyjg
        or o.skqdid <> n.skqdid
        or o.skqdmc <> n.skqdmc
        or o.khqjlsh <> n.khqjlsh
        or o.zt <> n.zt
        or o.zhdj <> n.zhdj
        or o.yxq <> n.yxq
        or o.xe <> n.xe
        or o.ljczje <> n.ljczje
        or o.tkzhye <> n.tkzhye
        or o.zxwhrq <> n.zxwhrq
        or o.jyrq <> n.jyrq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxdx_lxtk_cl(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,qdrq -- 渠道日期
            ,sjh -- 手机号
            ,xnkhh -- 客户ID（虚拟客户号）
            ,zhdh -- 账号（卡号）
            ,khh -- 客户号（内部户）
            ,khjgdh -- 开户行机构代码
            ,ylkhjylsh -- 银联开户交易流水号
            ,khrq -- 开户日期
            ,ywlb -- 业务类别：1-旅行通卡业务；2-福旅通业务
            ,khysms -- 开户要素模式
            ,zjlx -- 证件类型
            ,zjh1 -- 证件号1
            ,zjh2 -- 证件号2
            ,xing -- 姓
            ,ming -- 名
            ,xm -- 姓名
            ,xb -- 性别
            ,csrq -- 出生日期
            ,gj -- 国籍
            ,zy -- 职业
            ,zyms -- 职业描述
            ,ssjmsf -- 税收居民身份
            ,lxdz -- 联系地址
            ,sfzjfzrq -- 身份证件发证日期
            ,sfzjyxq -- 身份证件有效期
            ,yyjcjlsh -- 影印件采集交易的查询流水号
            ,pdm -- 省代码
            ,cdm -- 市代码
            ,ddm -- 区代码
            ,ssn -- 税收居民国/地区
            ,ssid -- 居民国/地区纳税人识别号
            ,jjtgyy -- 不能提供居民国/地区纳税人识别号的原因
            ,jtyy -- 具体原因
            ,rjqd -- 入境渠道
            ,xyhyjg -- 信源核验结果
            ,skqdid -- 申卡渠道id
            ,skqdmc -- 申卡渠道名称
            ,khqjlsh -- 开户全局流水号
            ,zt -- 状态
            ,zhdj -- 账户等级
            ,yxq -- 旅行通卡有效期
            ,xe -- 旅行通卡限额
            ,ljczje -- 累计充值金额
            ,tkzhye -- 退卡账户余额，即退卡账户转清算户交易金额
            ,zxwhrq -- 最新维护时间
            ,jyrq -- 解约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxdx_lxtk_op(
            jxdxdh -- 绩效对象代号
            ,tjrq -- 统计日期
            ,qdrq -- 渠道日期
            ,sjh -- 手机号
            ,xnkhh -- 客户ID（虚拟客户号）
            ,zhdh -- 账号（卡号）
            ,khh -- 客户号（内部户）
            ,khjgdh -- 开户行机构代码
            ,ylkhjylsh -- 银联开户交易流水号
            ,khrq -- 开户日期
            ,ywlb -- 业务类别：1-旅行通卡业务；2-福旅通业务
            ,khysms -- 开户要素模式
            ,zjlx -- 证件类型
            ,zjh1 -- 证件号1
            ,zjh2 -- 证件号2
            ,xing -- 姓
            ,ming -- 名
            ,xm -- 姓名
            ,xb -- 性别
            ,csrq -- 出生日期
            ,gj -- 国籍
            ,zy -- 职业
            ,zyms -- 职业描述
            ,ssjmsf -- 税收居民身份
            ,lxdz -- 联系地址
            ,sfzjfzrq -- 身份证件发证日期
            ,sfzjyxq -- 身份证件有效期
            ,yyjcjlsh -- 影印件采集交易的查询流水号
            ,pdm -- 省代码
            ,cdm -- 市代码
            ,ddm -- 区代码
            ,ssn -- 税收居民国/地区
            ,ssid -- 居民国/地区纳税人识别号
            ,jjtgyy -- 不能提供居民国/地区纳税人识别号的原因
            ,jtyy -- 具体原因
            ,rjqd -- 入境渠道
            ,xyhyjg -- 信源核验结果
            ,skqdid -- 申卡渠道id
            ,skqdmc -- 申卡渠道名称
            ,khqjlsh -- 开户全局流水号
            ,zt -- 状态
            ,zhdj -- 账户等级
            ,yxq -- 旅行通卡有效期
            ,xe -- 旅行通卡限额
            ,ljczje -- 累计充值金额
            ,tkzhye -- 退卡账户余额，即退卡账户转清算户交易金额
            ,zxwhrq -- 最新维护时间
            ,jyrq -- 解约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.jxdxdh -- 绩效对象代号
    ,o.tjrq -- 统计日期
    ,o.qdrq -- 渠道日期
    ,o.sjh -- 手机号
    ,o.xnkhh -- 客户ID（虚拟客户号）
    ,o.zhdh -- 账号（卡号）
    ,o.khh -- 客户号（内部户）
    ,o.khjgdh -- 开户行机构代码
    ,o.ylkhjylsh -- 银联开户交易流水号
    ,o.khrq -- 开户日期
    ,o.ywlb -- 业务类别：1-旅行通卡业务；2-福旅通业务
    ,o.khysms -- 开户要素模式
    ,o.zjlx -- 证件类型
    ,o.zjh1 -- 证件号1
    ,o.zjh2 -- 证件号2
    ,o.xing -- 姓
    ,o.ming -- 名
    ,o.xm -- 姓名
    ,o.xb -- 性别
    ,o.csrq -- 出生日期
    ,o.gj -- 国籍
    ,o.zy -- 职业
    ,o.zyms -- 职业描述
    ,o.ssjmsf -- 税收居民身份
    ,o.lxdz -- 联系地址
    ,o.sfzjfzrq -- 身份证件发证日期
    ,o.sfzjyxq -- 身份证件有效期
    ,o.yyjcjlsh -- 影印件采集交易的查询流水号
    ,o.pdm -- 省代码
    ,o.cdm -- 市代码
    ,o.ddm -- 区代码
    ,o.ssn -- 税收居民国/地区
    ,o.ssid -- 居民国/地区纳税人识别号
    ,o.jjtgyy -- 不能提供居民国/地区纳税人识别号的原因
    ,o.jtyy -- 具体原因
    ,o.rjqd -- 入境渠道
    ,o.xyhyjg -- 信源核验结果
    ,o.skqdid -- 申卡渠道id
    ,o.skqdmc -- 申卡渠道名称
    ,o.khqjlsh -- 开户全局流水号
    ,o.zt -- 状态
    ,o.zhdj -- 账户等级
    ,o.yxq -- 旅行通卡有效期
    ,o.xe -- 旅行通卡限额
    ,o.ljczje -- 累计充值金额
    ,o.tkzhye -- 退卡账户余额，即退卡账户转清算户交易金额
    ,o.zxwhrq -- 最新维护时间
    ,o.jyrq -- 解约日期
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
from ${iol_schema}.pams_jxdx_lxtk_bk o
    left join ${iol_schema}.pams_jxdx_lxtk_op n
        on
            o.jxdxdh = n.jxdxdh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxdx_lxtk_cl d
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
--truncate table ${iol_schema}.pams_jxdx_lxtk;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxdx_lxtk') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxdx_lxtk drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxdx_lxtk add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxdx_lxtk exchange partition p_${batch_date} with table ${iol_schema}.pams_jxdx_lxtk_cl;
alter table ${iol_schema}.pams_jxdx_lxtk exchange partition p_20991231 with table ${iol_schema}.pams_jxdx_lxtk_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxdx_lxtk to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxdx_lxtk_op purge;
drop table ${iol_schema}.pams_jxdx_lxtk_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxdx_lxtk_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxdx_lxtk',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
