/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a51ubrelationreg
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
create table ${iol_schema}.mpcs_a51ubrelationreg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a51ubrelationreg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a51ubrelationreg_op purge;
drop table ${iol_schema}.mpcs_a51ubrelationreg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubrelationreg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubrelationreg where 0=1;

create table ${iol_schema}.mpcs_a51ubrelationreg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a51ubrelationreg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a51ubrelationreg_cl(
            priacct -- 账号
            ,usernotype -- 用户号码类型
            ,userno -- 用户号码(支付项目)
            ,usernoareacd -- 用户号码地区编码
            ,usernoareacdadd -- 用户号码附加地区编码
            ,acptermnlid -- 商户代码
            ,paymode -- 支付方式标志
            ,paymodetype -- 支付方式类型
            ,paymodeno -- 支付方式号码
            ,comsiontime -- 委托关系期限
            ,maxlimitamt -- 最高限制金额
            ,minlimitamt -- 最低限制金额
            ,payextent -- 支付区间
            ,reserve -- 代收频率
            ,opendt -- 签约日期
            ,closdt -- 解约日期
            ,status -- 状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
            ,relbusitype -- 关联业务类型 01 : 有卡自助消费 02 : 无卡自助消费 03 : 互联网消费 04 : 订购 05 : 柜面无卡存款 06 : 自助存款 07 : 自助转账 08 : 互联网转账 09 : 代收 10 : 代付 11 : 预付费卡充值 14 : 无卡自助消费开通或关闭
            ,channels -- 签约渠道 CNT-柜面 CUP-银联 WEB-网银
            ,daymaxamt -- 当日最大交易限额
            ,snglmaxamt -- 单笔最大交易限额
            ,mtbrnnbr -- 维护网点
            ,mttlrnbr -- 维护柜员
            ,lastdt -- 最后维护日期
            ,lasttm -- 最后维护时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a51ubrelationreg_op(
            priacct -- 账号
            ,usernotype -- 用户号码类型
            ,userno -- 用户号码(支付项目)
            ,usernoareacd -- 用户号码地区编码
            ,usernoareacdadd -- 用户号码附加地区编码
            ,acptermnlid -- 商户代码
            ,paymode -- 支付方式标志
            ,paymodetype -- 支付方式类型
            ,paymodeno -- 支付方式号码
            ,comsiontime -- 委托关系期限
            ,maxlimitamt -- 最高限制金额
            ,minlimitamt -- 最低限制金额
            ,payextent -- 支付区间
            ,reserve -- 代收频率
            ,opendt -- 签约日期
            ,closdt -- 解约日期
            ,status -- 状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
            ,relbusitype -- 关联业务类型 01 : 有卡自助消费 02 : 无卡自助消费 03 : 互联网消费 04 : 订购 05 : 柜面无卡存款 06 : 自助存款 07 : 自助转账 08 : 互联网转账 09 : 代收 10 : 代付 11 : 预付费卡充值 14 : 无卡自助消费开通或关闭
            ,channels -- 签约渠道 CNT-柜面 CUP-银联 WEB-网银
            ,daymaxamt -- 当日最大交易限额
            ,snglmaxamt -- 单笔最大交易限额
            ,mtbrnnbr -- 维护网点
            ,mttlrnbr -- 维护柜员
            ,lastdt -- 最后维护日期
            ,lasttm -- 最后维护时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.priacct, o.priacct) as priacct -- 账号
    ,nvl(n.usernotype, o.usernotype) as usernotype -- 用户号码类型
    ,nvl(n.userno, o.userno) as userno -- 用户号码(支付项目)
    ,nvl(n.usernoareacd, o.usernoareacd) as usernoareacd -- 用户号码地区编码
    ,nvl(n.usernoareacdadd, o.usernoareacdadd) as usernoareacdadd -- 用户号码附加地区编码
    ,nvl(n.acptermnlid, o.acptermnlid) as acptermnlid -- 商户代码
    ,nvl(n.paymode, o.paymode) as paymode -- 支付方式标志
    ,nvl(n.paymodetype, o.paymodetype) as paymodetype -- 支付方式类型
    ,nvl(n.paymodeno, o.paymodeno) as paymodeno -- 支付方式号码
    ,nvl(n.comsiontime, o.comsiontime) as comsiontime -- 委托关系期限
    ,nvl(n.maxlimitamt, o.maxlimitamt) as maxlimitamt -- 最高限制金额
    ,nvl(n.minlimitamt, o.minlimitamt) as minlimitamt -- 最低限制金额
    ,nvl(n.payextent, o.payextent) as payextent -- 支付区间
    ,nvl(n.reserve, o.reserve) as reserve -- 代收频率
    ,nvl(n.opendt, o.opendt) as opendt -- 签约日期
    ,nvl(n.closdt, o.closdt) as closdt -- 解约日期
    ,nvl(n.status, o.status) as status -- 状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
    ,nvl(n.relbusitype, o.relbusitype) as relbusitype -- 关联业务类型 01 : 有卡自助消费 02 : 无卡自助消费 03 : 互联网消费 04 : 订购 05 : 柜面无卡存款 06 : 自助存款 07 : 自助转账 08 : 互联网转账 09 : 代收 10 : 代付 11 : 预付费卡充值 14 : 无卡自助消费开通或关闭
    ,nvl(n.channels, o.channels) as channels -- 签约渠道 CNT-柜面 CUP-银联 WEB-网银
    ,nvl(n.daymaxamt, o.daymaxamt) as daymaxamt -- 当日最大交易限额
    ,nvl(n.snglmaxamt, o.snglmaxamt) as snglmaxamt -- 单笔最大交易限额
    ,nvl(n.mtbrnnbr, o.mtbrnnbr) as mtbrnnbr -- 维护网点
    ,nvl(n.mttlrnbr, o.mttlrnbr) as mttlrnbr -- 维护柜员
    ,nvl(n.lastdt, o.lastdt) as lastdt -- 最后维护日期
    ,nvl(n.lasttm, o.lasttm) as lasttm -- 最后维护时间
    ,case when
            n.priacct is null
            and n.usernotype is null
            and n.userno is null
            and n.acptermnlid is null
            and n.relbusitype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.priacct is null
            and n.usernotype is null
            and n.userno is null
            and n.acptermnlid is null
            and n.relbusitype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.priacct is null
            and n.usernotype is null
            and n.userno is null
            and n.acptermnlid is null
            and n.relbusitype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a51ubrelationreg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a51ubrelationreg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.priacct = n.priacct
            and o.usernotype = n.usernotype
            and o.userno = n.userno
            and o.acptermnlid = n.acptermnlid
            and o.relbusitype = n.relbusitype
where (
        o.priacct is null
        and o.usernotype is null
        and o.userno is null
        and o.acptermnlid is null
        and o.relbusitype is null
    )
    or (
        n.priacct is null
        and n.usernotype is null
        and n.userno is null
        and n.acptermnlid is null
        and n.relbusitype is null
    )
    or (
        o.usernoareacd <> n.usernoareacd
        or o.usernoareacdadd <> n.usernoareacdadd
        or o.paymode <> n.paymode
        or o.paymodetype <> n.paymodetype
        or o.paymodeno <> n.paymodeno
        or o.comsiontime <> n.comsiontime
        or o.maxlimitamt <> n.maxlimitamt
        or o.minlimitamt <> n.minlimitamt
        or o.payextent <> n.payextent
        or o.reserve <> n.reserve
        or o.opendt <> n.opendt
        or o.closdt <> n.closdt
        or o.status <> n.status
        or o.channels <> n.channels
        or o.daymaxamt <> n.daymaxamt
        or o.snglmaxamt <> n.snglmaxamt
        or o.mtbrnnbr <> n.mtbrnnbr
        or o.mttlrnbr <> n.mttlrnbr
        or o.lastdt <> n.lastdt
        or o.lasttm <> n.lasttm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a51ubrelationreg_cl(
            priacct -- 账号
            ,usernotype -- 用户号码类型
            ,userno -- 用户号码(支付项目)
            ,usernoareacd -- 用户号码地区编码
            ,usernoareacdadd -- 用户号码附加地区编码
            ,acptermnlid -- 商户代码
            ,paymode -- 支付方式标志
            ,paymodetype -- 支付方式类型
            ,paymodeno -- 支付方式号码
            ,comsiontime -- 委托关系期限
            ,maxlimitamt -- 最高限制金额
            ,minlimitamt -- 最低限制金额
            ,payextent -- 支付区间
            ,reserve -- 代收频率
            ,opendt -- 签约日期
            ,closdt -- 解约日期
            ,status -- 状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
            ,relbusitype -- 关联业务类型 01 : 有卡自助消费 02 : 无卡自助消费 03 : 互联网消费 04 : 订购 05 : 柜面无卡存款 06 : 自助存款 07 : 自助转账 08 : 互联网转账 09 : 代收 10 : 代付 11 : 预付费卡充值 14 : 无卡自助消费开通或关闭
            ,channels -- 签约渠道 CNT-柜面 CUP-银联 WEB-网银
            ,daymaxamt -- 当日最大交易限额
            ,snglmaxamt -- 单笔最大交易限额
            ,mtbrnnbr -- 维护网点
            ,mttlrnbr -- 维护柜员
            ,lastdt -- 最后维护日期
            ,lasttm -- 最后维护时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a51ubrelationreg_op(
            priacct -- 账号
            ,usernotype -- 用户号码类型
            ,userno -- 用户号码(支付项目)
            ,usernoareacd -- 用户号码地区编码
            ,usernoareacdadd -- 用户号码附加地区编码
            ,acptermnlid -- 商户代码
            ,paymode -- 支付方式标志
            ,paymodetype -- 支付方式类型
            ,paymodeno -- 支付方式号码
            ,comsiontime -- 委托关系期限
            ,maxlimitamt -- 最高限制金额
            ,minlimitamt -- 最低限制金额
            ,payextent -- 支付区间
            ,reserve -- 代收频率
            ,opendt -- 签约日期
            ,closdt -- 解约日期
            ,status -- 状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
            ,relbusitype -- 关联业务类型 01 : 有卡自助消费 02 : 无卡自助消费 03 : 互联网消费 04 : 订购 05 : 柜面无卡存款 06 : 自助存款 07 : 自助转账 08 : 互联网转账 09 : 代收 10 : 代付 11 : 预付费卡充值 14 : 无卡自助消费开通或关闭
            ,channels -- 签约渠道 CNT-柜面 CUP-银联 WEB-网银
            ,daymaxamt -- 当日最大交易限额
            ,snglmaxamt -- 单笔最大交易限额
            ,mtbrnnbr -- 维护网点
            ,mttlrnbr -- 维护柜员
            ,lastdt -- 最后维护日期
            ,lasttm -- 最后维护时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.priacct -- 账号
    ,o.usernotype -- 用户号码类型
    ,o.userno -- 用户号码(支付项目)
    ,o.usernoareacd -- 用户号码地区编码
    ,o.usernoareacdadd -- 用户号码附加地区编码
    ,o.acptermnlid -- 商户代码
    ,o.paymode -- 支付方式标志
    ,o.paymodetype -- 支付方式类型
    ,o.paymodeno -- 支付方式号码
    ,o.comsiontime -- 委托关系期限
    ,o.maxlimitamt -- 最高限制金额
    ,o.minlimitamt -- 最低限制金额
    ,o.payextent -- 支付区间
    ,o.reserve -- 代收频率
    ,o.opendt -- 签约日期
    ,o.closdt -- 解约日期
    ,o.status -- 状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
    ,o.relbusitype -- 关联业务类型 01 : 有卡自助消费 02 : 无卡自助消费 03 : 互联网消费 04 : 订购 05 : 柜面无卡存款 06 : 自助存款 07 : 自助转账 08 : 互联网转账 09 : 代收 10 : 代付 11 : 预付费卡充值 14 : 无卡自助消费开通或关闭
    ,o.channels -- 签约渠道 CNT-柜面 CUP-银联 WEB-网银
    ,o.daymaxamt -- 当日最大交易限额
    ,o.snglmaxamt -- 单笔最大交易限额
    ,o.mtbrnnbr -- 维护网点
    ,o.mttlrnbr -- 维护柜员
    ,o.lastdt -- 最后维护日期
    ,o.lasttm -- 最后维护时间
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
from ${iol_schema}.mpcs_a51ubrelationreg_bk o
    left join ${iol_schema}.mpcs_a51ubrelationreg_op n
        on
            o.priacct = n.priacct
            and o.usernotype = n.usernotype
            and o.userno = n.userno
            and o.acptermnlid = n.acptermnlid
            and o.relbusitype = n.relbusitype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a51ubrelationreg_cl d
        on
            o.priacct = d.priacct
            and o.usernotype = d.usernotype
            and o.userno = d.userno
            and o.acptermnlid = d.acptermnlid
            and o.relbusitype = d.relbusitype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a51ubrelationreg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a51ubrelationreg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a51ubrelationreg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a51ubrelationreg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a51ubrelationreg exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a51ubrelationreg_cl;
alter table ${iol_schema}.mpcs_a51ubrelationreg exchange partition p_20991231 with table ${iol_schema}.mpcs_a51ubrelationreg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a51ubrelationreg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a51ubrelationreg_op purge;
drop table ${iol_schema}.mpcs_a51ubrelationreg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a51ubrelationreg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a51ubrelationreg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
