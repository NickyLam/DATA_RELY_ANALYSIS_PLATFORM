/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_repayment_plan_info
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
create table ${iol_schema}.icms_zjbk_repayment_plan_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zjbk_repayment_plan_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_repayment_plan_info_op purge;
drop table ${iol_schema}.icms_zjbk_repayment_plan_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_repayment_plan_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_repayment_plan_info where 0=1;

create table ${iol_schema}.icms_zjbk_repayment_plan_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_repayment_plan_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_repayment_plan_info_cl(
            curdate -- 账务日期
            ,loanid -- 借据号
            ,termno -- 期序
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,cleardate -- 结清日期
            ,termstatus -- 本期状态
            ,printotal -- 应还本金
            ,prinrepay -- 已还本金
            ,intplan -- 计划利息
            ,inttotal -- 应还利息
            ,intrepay -- 已还利息
            ,intdiscount -- 减免利息
            ,intbal -- 利息余额
            ,pnltinttotal -- 应还罚息
            ,pnltintrepay -- 已还罚息
            ,pnltintdiscount -- 减免罚息
            ,pnltintbal -- 罚息余额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,productno -- 产品编号
            ,outloanchannelno -- 平台订单号
            ,daysovd -- 逾期天数
            ,currency -- 币种
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_repayment_plan_info_op(
            curdate -- 账务日期
            ,loanid -- 借据号
            ,termno -- 期序
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,cleardate -- 结清日期
            ,termstatus -- 本期状态
            ,printotal -- 应还本金
            ,prinrepay -- 已还本金
            ,intplan -- 计划利息
            ,inttotal -- 应还利息
            ,intrepay -- 已还利息
            ,intdiscount -- 减免利息
            ,intbal -- 利息余额
            ,pnltinttotal -- 应还罚息
            ,pnltintrepay -- 已还罚息
            ,pnltintdiscount -- 减免罚息
            ,pnltintbal -- 罚息余额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,productno -- 产品编号
            ,outloanchannelno -- 平台订单号
            ,daysovd -- 逾期天数
            ,currency -- 币种
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.curdate, o.curdate) as curdate -- 账务日期
    ,nvl(n.loanid, o.loanid) as loanid -- 借据号
    ,nvl(n.termno, o.termno) as termno -- 期序
    ,nvl(n.startdate, o.startdate) as startdate -- 开始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日期
    ,nvl(n.cleardate, o.cleardate) as cleardate -- 结清日期
    ,nvl(n.termstatus, o.termstatus) as termstatus -- 本期状态
    ,nvl(n.printotal, o.printotal) as printotal -- 应还本金
    ,nvl(n.prinrepay, o.prinrepay) as prinrepay -- 已还本金
    ,nvl(n.intplan, o.intplan) as intplan -- 计划利息
    ,nvl(n.inttotal, o.inttotal) as inttotal -- 应还利息
    ,nvl(n.intrepay, o.intrepay) as intrepay -- 已还利息
    ,nvl(n.intdiscount, o.intdiscount) as intdiscount -- 减免利息
    ,nvl(n.intbal, o.intbal) as intbal -- 利息余额
    ,nvl(n.pnltinttotal, o.pnltinttotal) as pnltinttotal -- 应还罚息
    ,nvl(n.pnltintrepay, o.pnltintrepay) as pnltintrepay -- 已还罚息
    ,nvl(n.pnltintdiscount, o.pnltintdiscount) as pnltintdiscount -- 减免罚息
    ,nvl(n.pnltintbal, o.pnltintbal) as pnltintbal -- 罚息余额
    ,nvl(n.prepmtfeerepay, o.prepmtfeerepay) as prepmtfeerepay -- 已还提前还款手续费
    ,nvl(n.productno, o.productno) as productno -- 产品编号
    ,nvl(n.outloanchannelno, o.outloanchannelno) as outloanchannelno -- 平台订单号
    ,nvl(n.daysovd, o.daysovd) as daysovd -- 逾期天数
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.dailyint, o.dailyint) as dailyint -- 当日计提利息
    ,nvl(n.dailypnltint, o.dailypnltint) as dailypnltint -- 当日计提罚息
    ,case when
            n.loanid is null
            and n.termno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.loanid is null
            and n.termno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.loanid is null
            and n.termno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_zjbk_repayment_plan_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zjbk_repayment_plan_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.loanid = n.loanid
            and o.termno = n.termno
where (
        o.loanid is null
        and o.termno is null
    )
    or (
        n.loanid is null
        and n.termno is null
    )
    or (
        o.curdate <> n.curdate
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.cleardate <> n.cleardate
        or o.termstatus <> n.termstatus
        or o.printotal <> n.printotal
        or o.prinrepay <> n.prinrepay
        or o.intplan <> n.intplan
        or o.inttotal <> n.inttotal
        or o.intrepay <> n.intrepay
        or o.intdiscount <> n.intdiscount
        or o.intbal <> n.intbal
        or o.pnltinttotal <> n.pnltinttotal
        or o.pnltintrepay <> n.pnltintrepay
        or o.pnltintdiscount <> n.pnltintdiscount
        or o.pnltintbal <> n.pnltintbal
        or o.prepmtfeerepay <> n.prepmtfeerepay
        or o.productno <> n.productno
        or o.outloanchannelno <> n.outloanchannelno
        or o.daysovd <> n.daysovd
        or o.currency <> n.currency
        or o.dailyint <> n.dailyint
        or o.dailypnltint <> n.dailypnltint
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_repayment_plan_info_cl(
            curdate -- 账务日期
            ,loanid -- 借据号
            ,termno -- 期序
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,cleardate -- 结清日期
            ,termstatus -- 本期状态
            ,printotal -- 应还本金
            ,prinrepay -- 已还本金
            ,intplan -- 计划利息
            ,inttotal -- 应还利息
            ,intrepay -- 已还利息
            ,intdiscount -- 减免利息
            ,intbal -- 利息余额
            ,pnltinttotal -- 应还罚息
            ,pnltintrepay -- 已还罚息
            ,pnltintdiscount -- 减免罚息
            ,pnltintbal -- 罚息余额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,productno -- 产品编号
            ,outloanchannelno -- 平台订单号
            ,daysovd -- 逾期天数
            ,currency -- 币种
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_repayment_plan_info_op(
            curdate -- 账务日期
            ,loanid -- 借据号
            ,termno -- 期序
            ,startdate -- 开始日期
            ,enddate -- 到期日期
            ,cleardate -- 结清日期
            ,termstatus -- 本期状态
            ,printotal -- 应还本金
            ,prinrepay -- 已还本金
            ,intplan -- 计划利息
            ,inttotal -- 应还利息
            ,intrepay -- 已还利息
            ,intdiscount -- 减免利息
            ,intbal -- 利息余额
            ,pnltinttotal -- 应还罚息
            ,pnltintrepay -- 已还罚息
            ,pnltintdiscount -- 减免罚息
            ,pnltintbal -- 罚息余额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,productno -- 产品编号
            ,outloanchannelno -- 平台订单号
            ,daysovd -- 逾期天数
            ,currency -- 币种
            ,dailyint -- 当日计提利息
            ,dailypnltint -- 当日计提罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.curdate -- 账务日期
    ,o.loanid -- 借据号
    ,o.termno -- 期序
    ,o.startdate -- 开始日期
    ,o.enddate -- 到期日期
    ,o.cleardate -- 结清日期
    ,o.termstatus -- 本期状态
    ,o.printotal -- 应还本金
    ,o.prinrepay -- 已还本金
    ,o.intplan -- 计划利息
    ,o.inttotal -- 应还利息
    ,o.intrepay -- 已还利息
    ,o.intdiscount -- 减免利息
    ,o.intbal -- 利息余额
    ,o.pnltinttotal -- 应还罚息
    ,o.pnltintrepay -- 已还罚息
    ,o.pnltintdiscount -- 减免罚息
    ,o.pnltintbal -- 罚息余额
    ,o.prepmtfeerepay -- 已还提前还款手续费
    ,o.productno -- 产品编号
    ,o.outloanchannelno -- 平台订单号
    ,o.daysovd -- 逾期天数
    ,o.currency -- 币种
    ,o.dailyint -- 当日计提利息
    ,o.dailypnltint -- 当日计提罚息
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
from ${iol_schema}.icms_zjbk_repayment_plan_info_bk o
    left join ${iol_schema}.icms_zjbk_repayment_plan_info_op n
        on
            o.loanid = n.loanid
            and o.termno = n.termno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zjbk_repayment_plan_info_cl d
        on
            o.loanid = d.loanid
            and o.termno = d.termno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_zjbk_repayment_plan_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zjbk_repayment_plan_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zjbk_repayment_plan_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zjbk_repayment_plan_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zjbk_repayment_plan_info exchange partition p_${batch_date} with table ${iol_schema}.icms_zjbk_repayment_plan_info_cl;
alter table ${iol_schema}.icms_zjbk_repayment_plan_info exchange partition p_20991231 with table ${iol_schema}.icms_zjbk_repayment_plan_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zjbk_repayment_plan_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_repayment_plan_info_op purge;
drop table ${iol_schema}.icms_zjbk_repayment_plan_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zjbk_repayment_plan_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zjbk_repayment_plan_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
