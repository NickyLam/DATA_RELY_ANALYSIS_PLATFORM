/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_dr_rateinfo
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
whenever sqlerror continue none ;
create table ${iol_schema}.nrrs_dr_rateinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_dr_rateinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_dr_rateinfo_op purge;
drop table ${iol_schema}.nrrs_dr_rateinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_dr_rateinfo_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.nrrs_dr_rateinfo where 0=1;

create table ${iol_schema}.nrrs_dr_rateinfo_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.nrrs_dr_rateinfo where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.nrrs_dr_rateinfo_op(
        lsh -- 评级流水号，每次调用债项评级引擎都会生出一个新的评级流水号
        ,caldate -- 债项评级计算日期，格式yyyy-mm-dd
        ,custid -- 授信客户编号
        ,calobj -- 计算层面：0-额度层面、1-合同层面、2-借据层面
        ,calalg -- 债项评级算法：0-初级法、1-过渡期
        ,disalg -- 缓释分配算法：0-比例法、1-消耗法
        ,allcover -- 抵质押品与保证是否同时覆盖：0-是、1-否
        ,ctype -- C%作用方式：0-直接作用、1-折扣系数方式作用
        ,source -- 调用债项评级计算引擎的方式：0-单一计算、1-夜间批量、2-押品压力测试
        ,pdchoose -- PD对象使用开关，0-使用债项的PD对象，1-不使用债项的PD对象
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.lsh -- 评级流水号，每次调用债项评级引擎都会生出一个新的评级流水号
    ,n.caldate -- 债项评级计算日期，格式yyyy-mm-dd
    ,n.custid -- 授信客户编号
    ,n.calobj -- 计算层面：0-额度层面、1-合同层面、2-借据层面
    ,n.calalg -- 债项评级算法：0-初级法、1-过渡期
    ,n.disalg -- 缓释分配算法：0-比例法、1-消耗法
    ,n.allcover -- 抵质押品与保证是否同时覆盖：0-是、1-否
    ,n.ctype -- C%作用方式：0-直接作用、1-折扣系数方式作用
    ,n.source -- 调用债项评级计算引擎的方式：0-单一计算、1-夜间批量、2-押品压力测试
    ,n.pdchoose -- PD对象使用开关，0-使用债项的PD对象，1-不使用债项的PD对象
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_dr_rateinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.nrrs_dr_rateinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.lsh = n.lsh
where (
        o.lsh is null
    )
    or (
        o.caldate <> n.caldate
        or o.custid <> n.custid
        or o.calobj <> n.calobj
        or o.calalg <> n.calalg
        or o.disalg <> n.disalg
        or o.allcover <> n.allcover
        or o.ctype <> n.ctype
        or o.source <> n.source
        or o.pdchoose <> n.pdchoose
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_dr_rateinfo_cl(
            lsh -- 评级流水号，每次调用债项评级引擎都会生出一个新的评级流水号
        ,caldate -- 债项评级计算日期，格式yyyy-mm-dd
        ,custid -- 授信客户编号
        ,calobj -- 计算层面：0-额度层面、1-合同层面、2-借据层面
        ,calalg -- 债项评级算法：0-初级法、1-过渡期
        ,disalg -- 缓释分配算法：0-比例法、1-消耗法
        ,allcover -- 抵质押品与保证是否同时覆盖：0-是、1-否
        ,ctype -- C%作用方式：0-直接作用、1-折扣系数方式作用
        ,source -- 调用债项评级计算引擎的方式：0-单一计算、1-夜间批量、2-押品压力测试
        ,pdchoose -- PD对象使用开关，0-使用债项的PD对象，1-不使用债项的PD对象
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_dr_rateinfo_op(
            lsh -- 评级流水号，每次调用债项评级引擎都会生出一个新的评级流水号
        ,caldate -- 债项评级计算日期，格式yyyy-mm-dd
        ,custid -- 授信客户编号
        ,calobj -- 计算层面：0-额度层面、1-合同层面、2-借据层面
        ,calalg -- 债项评级算法：0-初级法、1-过渡期
        ,disalg -- 缓释分配算法：0-比例法、1-消耗法
        ,allcover -- 抵质押品与保证是否同时覆盖：0-是、1-否
        ,ctype -- C%作用方式：0-直接作用、1-折扣系数方式作用
        ,source -- 调用债项评级计算引擎的方式：0-单一计算、1-夜间批量、2-押品压力测试
        ,pdchoose -- PD对象使用开关，0-使用债项的PD对象，1-不使用债项的PD对象
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lsh -- 评级流水号，每次调用债项评级引擎都会生出一个新的评级流水号
    ,o.caldate -- 债项评级计算日期，格式yyyy-mm-dd
    ,o.custid -- 授信客户编号
    ,o.calobj -- 计算层面：0-额度层面、1-合同层面、2-借据层面
    ,o.calalg -- 债项评级算法：0-初级法、1-过渡期
    ,o.disalg -- 缓释分配算法：0-比例法、1-消耗法
    ,o.allcover -- 抵质押品与保证是否同时覆盖：0-是、1-否
    ,o.ctype -- C%作用方式：0-直接作用、1-折扣系数方式作用
    ,o.source -- 调用债项评级计算引擎的方式：0-单一计算、1-夜间批量、2-押品压力测试
    ,o.pdchoose -- PD对象使用开关，0-使用债项的PD对象，1-不使用债项的PD对象
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nrrs_dr_rateinfo_bk o
    left join ${iol_schema}.nrrs_dr_rateinfo_op n
        on
            o.lsh = n.lsh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nrrs_dr_rateinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.nrrs_dr_rateinfo exchange partition p_19000101 with table ${iol_schema}.nrrs_dr_rateinfo_cl;
alter table ${iol_schema}.nrrs_dr_rateinfo exchange partition p_20991231 with table ${iol_schema}.nrrs_dr_rateinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_dr_rateinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_dr_rateinfo_op purge;
drop table ${iol_schema}.nrrs_dr_rateinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_dr_rateinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_dr_rateinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
