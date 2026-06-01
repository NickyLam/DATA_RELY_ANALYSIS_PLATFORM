/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_hszt_bz
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
create table ${iol_schema}.isbs_hszt_bz_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_hszt_bz
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_hszt_bz_op purge;
drop table ${iol_schema}.isbs_hszt_bz_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_hszt_bz_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_hszt_bz where 0=1;

create table ${iol_schema}.isbs_hszt_bz_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_hszt_bz where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_hszt_bz_cl(
            inr -- 主键
            ,trninr -- TRN表INR
            ,credattim -- 创建时间
            ,systid -- 修改域的列表
            ,trandt -- 核心日期
            ,bsnssq -- 利息说明
            ,transq -- 核心流水
            ,serino -- 头寸货物
            ,tranbr -- 交易机构
            ,acctbr -- 账户机构
            ,prcscd -- 自由文本信息
            ,evetdn -- 提示单据
            ,trprcd -- 代收细节
            ,crcycd -- 币种
            ,tranam -- 交易金额
            ,acctno -- 交易账号
            ,assis0 -- 收货说明
            ,assis1 -- 费用文本
            ,chrex0 -- 票据说明
            ,chrex1 -- 其他指示
            ,chrex2 -- 放货地址
            ,bzsta -- 船名
            ,times -- 次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_hszt_bz_op(
            inr -- 主键
            ,trninr -- TRN表INR
            ,credattim -- 创建时间
            ,systid -- 修改域的列表
            ,trandt -- 核心日期
            ,bsnssq -- 利息说明
            ,transq -- 核心流水
            ,serino -- 头寸货物
            ,tranbr -- 交易机构
            ,acctbr -- 账户机构
            ,prcscd -- 自由文本信息
            ,evetdn -- 提示单据
            ,trprcd -- 代收细节
            ,crcycd -- 币种
            ,tranam -- 交易金额
            ,acctno -- 交易账号
            ,assis0 -- 收货说明
            ,assis1 -- 费用文本
            ,chrex0 -- 票据说明
            ,chrex1 -- 其他指示
            ,chrex2 -- 放货地址
            ,bzsta -- 船名
            ,times -- 次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 主键
    ,nvl(n.trninr, o.trninr) as trninr -- TRN表INR
    ,nvl(n.credattim, o.credattim) as credattim -- 创建时间
    ,nvl(n.systid, o.systid) as systid -- 修改域的列表
    ,nvl(n.trandt, o.trandt) as trandt -- 核心日期
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 利息说明
    ,nvl(n.transq, o.transq) as transq -- 核心流水
    ,nvl(n.serino, o.serino) as serino -- 头寸货物
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 交易机构
    ,nvl(n.acctbr, o.acctbr) as acctbr -- 账户机构
    ,nvl(n.prcscd, o.prcscd) as prcscd -- 自由文本信息
    ,nvl(n.evetdn, o.evetdn) as evetdn -- 提示单据
    ,nvl(n.trprcd, o.trprcd) as trprcd -- 代收细节
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种
    ,nvl(n.tranam, o.tranam) as tranam -- 交易金额
    ,nvl(n.acctno, o.acctno) as acctno -- 交易账号
    ,nvl(n.assis0, o.assis0) as assis0 -- 收货说明
    ,nvl(n.assis1, o.assis1) as assis1 -- 费用文本
    ,nvl(n.chrex0, o.chrex0) as chrex0 -- 票据说明
    ,nvl(n.chrex1, o.chrex1) as chrex1 -- 其他指示
    ,nvl(n.chrex2, o.chrex2) as chrex2 -- 放货地址
    ,nvl(n.bzsta, o.bzsta) as bzsta -- 船名
    ,nvl(n.times, o.times) as times -- 次数
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_hszt_bz_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_hszt_bz where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.trninr <> n.trninr
        or o.credattim <> n.credattim
        or o.systid <> n.systid
        or o.trandt <> n.trandt
        or o.bsnssq <> n.bsnssq
        or o.transq <> n.transq
        or o.serino <> n.serino
        or o.tranbr <> n.tranbr
        or o.acctbr <> n.acctbr
        or o.prcscd <> n.prcscd
        or o.evetdn <> n.evetdn
        or o.trprcd <> n.trprcd
        or o.crcycd <> n.crcycd
        or o.tranam <> n.tranam
        or o.acctno <> n.acctno
        or o.assis0 <> n.assis0
        or o.assis1 <> n.assis1
        or o.chrex0 <> n.chrex0
        or o.chrex1 <> n.chrex1
        or o.chrex2 <> n.chrex2
        or o.bzsta <> n.bzsta
        or o.times <> n.times
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_hszt_bz_cl(
            inr -- 主键
            ,trninr -- TRN表INR
            ,credattim -- 创建时间
            ,systid -- 修改域的列表
            ,trandt -- 核心日期
            ,bsnssq -- 利息说明
            ,transq -- 核心流水
            ,serino -- 头寸货物
            ,tranbr -- 交易机构
            ,acctbr -- 账户机构
            ,prcscd -- 自由文本信息
            ,evetdn -- 提示单据
            ,trprcd -- 代收细节
            ,crcycd -- 币种
            ,tranam -- 交易金额
            ,acctno -- 交易账号
            ,assis0 -- 收货说明
            ,assis1 -- 费用文本
            ,chrex0 -- 票据说明
            ,chrex1 -- 其他指示
            ,chrex2 -- 放货地址
            ,bzsta -- 船名
            ,times -- 次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_hszt_bz_op(
            inr -- 主键
            ,trninr -- TRN表INR
            ,credattim -- 创建时间
            ,systid -- 修改域的列表
            ,trandt -- 核心日期
            ,bsnssq -- 利息说明
            ,transq -- 核心流水
            ,serino -- 头寸货物
            ,tranbr -- 交易机构
            ,acctbr -- 账户机构
            ,prcscd -- 自由文本信息
            ,evetdn -- 提示单据
            ,trprcd -- 代收细节
            ,crcycd -- 币种
            ,tranam -- 交易金额
            ,acctno -- 交易账号
            ,assis0 -- 收货说明
            ,assis1 -- 费用文本
            ,chrex0 -- 票据说明
            ,chrex1 -- 其他指示
            ,chrex2 -- 放货地址
            ,bzsta -- 船名
            ,times -- 次数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 主键
    ,o.trninr -- TRN表INR
    ,o.credattim -- 创建时间
    ,o.systid -- 修改域的列表
    ,o.trandt -- 核心日期
    ,o.bsnssq -- 利息说明
    ,o.transq -- 核心流水
    ,o.serino -- 头寸货物
    ,o.tranbr -- 交易机构
    ,o.acctbr -- 账户机构
    ,o.prcscd -- 自由文本信息
    ,o.evetdn -- 提示单据
    ,o.trprcd -- 代收细节
    ,o.crcycd -- 币种
    ,o.tranam -- 交易金额
    ,o.acctno -- 交易账号
    ,o.assis0 -- 收货说明
    ,o.assis1 -- 费用文本
    ,o.chrex0 -- 票据说明
    ,o.chrex1 -- 其他指示
    ,o.chrex2 -- 放货地址
    ,o.bzsta -- 船名
    ,o.times -- 次数
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
from ${iol_schema}.isbs_hszt_bz_bk o
    left join ${iol_schema}.isbs_hszt_bz_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_hszt_bz_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.isbs_hszt_bz;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_hszt_bz') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_hszt_bz drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_hszt_bz add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_hszt_bz exchange partition p_${batch_date} with table ${iol_schema}.isbs_hszt_bz_cl;
alter table ${iol_schema}.isbs_hszt_bz exchange partition p_20991231 with table ${iol_schema}.isbs_hszt_bz_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_hszt_bz to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_hszt_bz_op purge;
drop table ${iol_schema}.isbs_hszt_bz_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_hszt_bz_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_hszt_bz',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
