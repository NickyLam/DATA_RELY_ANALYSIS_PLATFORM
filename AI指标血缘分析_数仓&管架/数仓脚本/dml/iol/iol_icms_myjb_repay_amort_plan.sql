/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myjb_repay_amort_plan
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
create table ${iol_schema}.icms_myjb_repay_amort_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_myjb_repay_amort_plan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_repay_amort_plan_op purge;
drop table ${iol_schema}.icms_myjb_repay_amort_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_repay_amort_plan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myjb_repay_amort_plan where 0=1;

create table ${iol_schema}.icms_myjb_repay_amort_plan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_myjb_repay_amort_plan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myjb_repay_amort_plan_cl(
            contractno -- 融资平台贷款合约号
            ,termno -- 期次号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,intamt -- 初始利息匡算金额
            ,prinamt -- 本金金额
            ,prinbal -- 本金余额
            ,intovddays -- 利息逾期天数
            ,enddate -- 分期结束日期
            ,startdate -- 分期开始日期
            ,intbal -- 利息余额
            ,ovdintpnltbal -- 逾期利息罚息余额
            ,prinovddate -- 本金转逾期日期
            ,settledate -- 会计日期
            ,status -- 分期状态
            ,prinovddays -- 本金逾期天数
            ,intovddate -- 利息转逾期日期
            ,inputdate -- 登记时间
            ,cleardate -- 结清日期
            ,ovdprinpnltbal -- 逾期本金罚息余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myjb_repay_amort_plan_op(
            contractno -- 融资平台贷款合约号
            ,termno -- 期次号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,intamt -- 初始利息匡算金额
            ,prinamt -- 本金金额
            ,prinbal -- 本金余额
            ,intovddays -- 利息逾期天数
            ,enddate -- 分期结束日期
            ,startdate -- 分期开始日期
            ,intbal -- 利息余额
            ,ovdintpnltbal -- 逾期利息罚息余额
            ,prinovddate -- 本金转逾期日期
            ,settledate -- 会计日期
            ,status -- 分期状态
            ,prinovddays -- 本金逾期天数
            ,intovddate -- 利息转逾期日期
            ,inputdate -- 登记时间
            ,cleardate -- 结清日期
            ,ovdprinpnltbal -- 逾期本金罚息余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.contractno, o.contractno) as contractno -- 融资平台贷款合约号
    ,nvl(n.termno, o.termno) as termno -- 期次号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.intamt, o.intamt) as intamt -- 初始利息匡算金额
    ,nvl(n.prinamt, o.prinamt) as prinamt -- 本金金额
    ,nvl(n.prinbal, o.prinbal) as prinbal -- 本金余额
    ,nvl(n.intovddays, o.intovddays) as intovddays -- 利息逾期天数
    ,nvl(n.enddate, o.enddate) as enddate -- 分期结束日期
    ,nvl(n.startdate, o.startdate) as startdate -- 分期开始日期
    ,nvl(n.intbal, o.intbal) as intbal -- 利息余额
    ,nvl(n.ovdintpnltbal, o.ovdintpnltbal) as ovdintpnltbal -- 逾期利息罚息余额
    ,nvl(n.prinovddate, o.prinovddate) as prinovddate -- 本金转逾期日期
    ,nvl(n.settledate, o.settledate) as settledate -- 会计日期
    ,nvl(n.status, o.status) as status -- 分期状态
    ,nvl(n.prinovddays, o.prinovddays) as prinovddays -- 本金逾期天数
    ,nvl(n.intovddate, o.intovddate) as intovddate -- 利息转逾期日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.cleardate, o.cleardate) as cleardate -- 结清日期
    ,nvl(n.ovdprinpnltbal, o.ovdprinpnltbal) as ovdprinpnltbal -- 逾期本金罚息余额
    ,case when
            n.contractno is null
            and n.termno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.contractno is null
            and n.termno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.contractno is null
            and n.termno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_myjb_repay_amort_plan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_myjb_repay_amort_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.contractno = n.contractno
            and o.termno = n.termno
where (
        o.contractno is null
        and o.termno is null
    )
    or (
        n.contractno is null
        and n.termno is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.intamt <> n.intamt
        or o.prinamt <> n.prinamt
        or o.prinbal <> n.prinbal
        or o.intovddays <> n.intovddays
        or o.enddate <> n.enddate
        or o.startdate <> n.startdate
        or o.intbal <> n.intbal
        or o.ovdintpnltbal <> n.ovdintpnltbal
        or o.prinovddate <> n.prinovddate
        or o.settledate <> n.settledate
        or o.status <> n.status
        or o.prinovddays <> n.prinovddays
        or o.intovddate <> n.intovddate
        or o.inputdate <> n.inputdate
        or o.cleardate <> n.cleardate
        or o.ovdprinpnltbal <> n.ovdprinpnltbal
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myjb_repay_amort_plan_cl(
            contractno -- 融资平台贷款合约号
            ,termno -- 期次号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,intamt -- 初始利息匡算金额
            ,prinamt -- 本金金额
            ,prinbal -- 本金余额
            ,intovddays -- 利息逾期天数
            ,enddate -- 分期结束日期
            ,startdate -- 分期开始日期
            ,intbal -- 利息余额
            ,ovdintpnltbal -- 逾期利息罚息余额
            ,prinovddate -- 本金转逾期日期
            ,settledate -- 会计日期
            ,status -- 分期状态
            ,prinovddays -- 本金逾期天数
            ,intovddate -- 利息转逾期日期
            ,inputdate -- 登记时间
            ,cleardate -- 结清日期
            ,ovdprinpnltbal -- 逾期本金罚息余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myjb_repay_amort_plan_op(
            contractno -- 融资平台贷款合约号
            ,termno -- 期次号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,intamt -- 初始利息匡算金额
            ,prinamt -- 本金金额
            ,prinbal -- 本金余额
            ,intovddays -- 利息逾期天数
            ,enddate -- 分期结束日期
            ,startdate -- 分期开始日期
            ,intbal -- 利息余额
            ,ovdintpnltbal -- 逾期利息罚息余额
            ,prinovddate -- 本金转逾期日期
            ,settledate -- 会计日期
            ,status -- 分期状态
            ,prinovddays -- 本金逾期天数
            ,intovddate -- 利息转逾期日期
            ,inputdate -- 登记时间
            ,cleardate -- 结清日期
            ,ovdprinpnltbal -- 逾期本金罚息余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.contractno -- 融资平台贷款合约号
    ,o.termno -- 期次号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.intamt -- 初始利息匡算金额
    ,o.prinamt -- 本金金额
    ,o.prinbal -- 本金余额
    ,o.intovddays -- 利息逾期天数
    ,o.enddate -- 分期结束日期
    ,o.startdate -- 分期开始日期
    ,o.intbal -- 利息余额
    ,o.ovdintpnltbal -- 逾期利息罚息余额
    ,o.prinovddate -- 本金转逾期日期
    ,o.settledate -- 会计日期
    ,o.status -- 分期状态
    ,o.prinovddays -- 本金逾期天数
    ,o.intovddate -- 利息转逾期日期
    ,o.inputdate -- 登记时间
    ,o.cleardate -- 结清日期
    ,o.ovdprinpnltbal -- 逾期本金罚息余额
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
from ${iol_schema}.icms_myjb_repay_amort_plan_bk o
    left join ${iol_schema}.icms_myjb_repay_amort_plan_op n
        on
            o.contractno = n.contractno
            and o.termno = n.termno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_myjb_repay_amort_plan_cl d
        on
            o.contractno = d.contractno
            and o.termno = d.termno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_myjb_repay_amort_plan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_myjb_repay_amort_plan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_myjb_repay_amort_plan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_myjb_repay_amort_plan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_myjb_repay_amort_plan exchange partition p_${batch_date} with table ${iol_schema}.icms_myjb_repay_amort_plan_cl;
alter table ${iol_schema}.icms_myjb_repay_amort_plan exchange partition p_20991231 with table ${iol_schema}.icms_myjb_repay_amort_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myjb_repay_amort_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_repay_amort_plan_op purge;
drop table ${iol_schema}.icms_myjb_repay_amort_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_myjb_repay_amort_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myjb_repay_amort_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
