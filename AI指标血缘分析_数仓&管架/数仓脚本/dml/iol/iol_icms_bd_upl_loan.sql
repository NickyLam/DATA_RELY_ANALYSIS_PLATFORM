/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bd_upl_loan
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
create table ${iol_schema}.icms_bd_upl_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bd_upl_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bd_upl_loan_op purge;
drop table ${iol_schema}.icms_bd_upl_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bd_upl_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bd_upl_loan where 0=1;

create table ${iol_schema}.icms_bd_upl_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bd_upl_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bd_upl_loan_cl(
            serialno -- 借据号
            ,surplusphases -- 剩余期数
            ,eacmprincipal -- 每期扣款额本金利息
            ,yqtotalsum -- 逾期管理累计应还
            ,yqfuli -- 逾期管理复利
            ,duebalance -- 暂存借据余额
            ,yqinterest -- 逾期管理利息
            ,acceptinttype -- 计息方式
            ,logoutdate -- 销账日期
            ,hxinrate -- 核销表内利息
            ,migtflag -- migtflag
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,changepayaccountname -- 变更后的还款账号名称
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,legal -- 诉讼费
            ,raccrint -- 未结正常利息
            ,preinttype -- 预收息标志
            ,yqfaxi -- 逾期管理罚息
            ,changepayaccountno -- 变更后的还款账号
            ,yqnormalbalance -- 逾期管理正常本金
            ,yqbadbalance -- 逾期管理逾期本金
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,bdflag -- 买断清收标志
            ,fixterm -- 周期
            ,hxoutrate -- 核销表外利息
            ,loanspecies -- 贷款种类
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,hxtype -- 核销类别
            ,loantype -- 贷款类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bd_upl_loan_op(
            serialno -- 借据号
            ,surplusphases -- 剩余期数
            ,eacmprincipal -- 每期扣款额本金利息
            ,yqtotalsum -- 逾期管理累计应还
            ,yqfuli -- 逾期管理复利
            ,duebalance -- 暂存借据余额
            ,yqinterest -- 逾期管理利息
            ,acceptinttype -- 计息方式
            ,logoutdate -- 销账日期
            ,hxinrate -- 核销表内利息
            ,migtflag -- migtflag
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,changepayaccountname -- 变更后的还款账号名称
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,legal -- 诉讼费
            ,raccrint -- 未结正常利息
            ,preinttype -- 预收息标志
            ,yqfaxi -- 逾期管理罚息
            ,changepayaccountno -- 变更后的还款账号
            ,yqnormalbalance -- 逾期管理正常本金
            ,yqbadbalance -- 逾期管理逾期本金
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,bdflag -- 买断清收标志
            ,fixterm -- 周期
            ,hxoutrate -- 核销表外利息
            ,loanspecies -- 贷款种类
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,hxtype -- 核销类别
            ,loantype -- 贷款类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 借据号
    ,nvl(n.surplusphases, o.surplusphases) as surplusphases -- 剩余期数
    ,nvl(n.eacmprincipal, o.eacmprincipal) as eacmprincipal -- 每期扣款额本金利息
    ,nvl(n.yqtotalsum, o.yqtotalsum) as yqtotalsum -- 逾期管理累计应还
    ,nvl(n.yqfuli, o.yqfuli) as yqfuli -- 逾期管理复利
    ,nvl(n.duebalance, o.duebalance) as duebalance -- 暂存借据余额
    ,nvl(n.yqinterest, o.yqinterest) as yqinterest -- 逾期管理利息
    ,nvl(n.acceptinttype, o.acceptinttype) as acceptinttype -- 计息方式
    ,nvl(n.logoutdate, o.logoutdate) as logoutdate -- 销账日期
    ,nvl(n.hxinrate, o.hxinrate) as hxinrate -- 核销表内利息
    ,nvl(n.migtflag, o.migtflag) as migtflag -- migtflag
    ,nvl(n.nextperiodreturninterestsum, o.nextperiodreturninterestsum) as nextperiodreturninterestsum -- 下一期还息金额
    ,nvl(n.changepayaccountname, o.changepayaccountname) as changepayaccountname -- 变更后的还款账号名称
    ,nvl(n.nextperiodreturninterestdate, o.nextperiodreturninterestdate) as nextperiodreturninterestdate -- 下一期还息日期
    ,nvl(n.legal, o.legal) as legal -- 诉讼费
    ,nvl(n.raccrint, o.raccrint) as raccrint -- 未结正常利息
    ,nvl(n.preinttype, o.preinttype) as preinttype -- 预收息标志
    ,nvl(n.yqfaxi, o.yqfaxi) as yqfaxi -- 逾期管理罚息
    ,nvl(n.changepayaccountno, o.changepayaccountno) as changepayaccountno -- 变更后的还款账号
    ,nvl(n.yqnormalbalance, o.yqnormalbalance) as yqnormalbalance -- 逾期管理正常本金
    ,nvl(n.yqbadbalance, o.yqbadbalance) as yqbadbalance -- 逾期管理逾期本金
    ,nvl(n.nextperiodreturnprincipalsum, o.nextperiodreturnprincipalsum) as nextperiodreturnprincipalsum -- 下一期还本金额
    ,nvl(n.bdflag, o.bdflag) as bdflag -- 买断清收标志
    ,nvl(n.fixterm, o.fixterm) as fixterm -- 周期
    ,nvl(n.hxoutrate, o.hxoutrate) as hxoutrate -- 核销表外利息
    ,nvl(n.loanspecies, o.loanspecies) as loanspecies -- 贷款种类
    ,nvl(n.nextperiodreturnprincipaldate, o.nextperiodreturnprincipaldate) as nextperiodreturnprincipaldate -- 下一期还本日期
    ,nvl(n.hxtype, o.hxtype) as hxtype -- 核销类别
    ,nvl(n.loantype, o.loantype) as loantype -- 贷款类型
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_bd_upl_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bd_upl_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.surplusphases <> n.surplusphases
        or o.eacmprincipal <> n.eacmprincipal
        or o.yqtotalsum <> n.yqtotalsum
        or o.yqfuli <> n.yqfuli
        or o.duebalance <> n.duebalance
        or o.yqinterest <> n.yqinterest
        or o.acceptinttype <> n.acceptinttype
        or o.logoutdate <> n.logoutdate
        or o.hxinrate <> n.hxinrate
        or o.migtflag <> n.migtflag
        or o.nextperiodreturninterestsum <> n.nextperiodreturninterestsum
        or o.changepayaccountname <> n.changepayaccountname
        or o.nextperiodreturninterestdate <> n.nextperiodreturninterestdate
        or o.legal <> n.legal
        or o.raccrint <> n.raccrint
        or o.preinttype <> n.preinttype
        or o.yqfaxi <> n.yqfaxi
        or o.changepayaccountno <> n.changepayaccountno
        or o.yqnormalbalance <> n.yqnormalbalance
        or o.yqbadbalance <> n.yqbadbalance
        or o.nextperiodreturnprincipalsum <> n.nextperiodreturnprincipalsum
        or o.bdflag <> n.bdflag
        or o.fixterm <> n.fixterm
        or o.hxoutrate <> n.hxoutrate
        or o.loanspecies <> n.loanspecies
        or o.nextperiodreturnprincipaldate <> n.nextperiodreturnprincipaldate
        or o.hxtype <> n.hxtype
        or o.loantype <> n.loantype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bd_upl_loan_cl(
            serialno -- 借据号
            ,surplusphases -- 剩余期数
            ,eacmprincipal -- 每期扣款额本金利息
            ,yqtotalsum -- 逾期管理累计应还
            ,yqfuli -- 逾期管理复利
            ,duebalance -- 暂存借据余额
            ,yqinterest -- 逾期管理利息
            ,acceptinttype -- 计息方式
            ,logoutdate -- 销账日期
            ,hxinrate -- 核销表内利息
            ,migtflag -- migtflag
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,changepayaccountname -- 变更后的还款账号名称
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,legal -- 诉讼费
            ,raccrint -- 未结正常利息
            ,preinttype -- 预收息标志
            ,yqfaxi -- 逾期管理罚息
            ,changepayaccountno -- 变更后的还款账号
            ,yqnormalbalance -- 逾期管理正常本金
            ,yqbadbalance -- 逾期管理逾期本金
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,bdflag -- 买断清收标志
            ,fixterm -- 周期
            ,hxoutrate -- 核销表外利息
            ,loanspecies -- 贷款种类
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,hxtype -- 核销类别
            ,loantype -- 贷款类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bd_upl_loan_op(
            serialno -- 借据号
            ,surplusphases -- 剩余期数
            ,eacmprincipal -- 每期扣款额本金利息
            ,yqtotalsum -- 逾期管理累计应还
            ,yqfuli -- 逾期管理复利
            ,duebalance -- 暂存借据余额
            ,yqinterest -- 逾期管理利息
            ,acceptinttype -- 计息方式
            ,logoutdate -- 销账日期
            ,hxinrate -- 核销表内利息
            ,migtflag -- migtflag
            ,nextperiodreturninterestsum -- 下一期还息金额
            ,changepayaccountname -- 变更后的还款账号名称
            ,nextperiodreturninterestdate -- 下一期还息日期
            ,legal -- 诉讼费
            ,raccrint -- 未结正常利息
            ,preinttype -- 预收息标志
            ,yqfaxi -- 逾期管理罚息
            ,changepayaccountno -- 变更后的还款账号
            ,yqnormalbalance -- 逾期管理正常本金
            ,yqbadbalance -- 逾期管理逾期本金
            ,nextperiodreturnprincipalsum -- 下一期还本金额
            ,bdflag -- 买断清收标志
            ,fixterm -- 周期
            ,hxoutrate -- 核销表外利息
            ,loanspecies -- 贷款种类
            ,nextperiodreturnprincipaldate -- 下一期还本日期
            ,hxtype -- 核销类别
            ,loantype -- 贷款类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 借据号
    ,o.surplusphases -- 剩余期数
    ,o.eacmprincipal -- 每期扣款额本金利息
    ,o.yqtotalsum -- 逾期管理累计应还
    ,o.yqfuli -- 逾期管理复利
    ,o.duebalance -- 暂存借据余额
    ,o.yqinterest -- 逾期管理利息
    ,o.acceptinttype -- 计息方式
    ,o.logoutdate -- 销账日期
    ,o.hxinrate -- 核销表内利息
    ,o.migtflag -- migtflag
    ,o.nextperiodreturninterestsum -- 下一期还息金额
    ,o.changepayaccountname -- 变更后的还款账号名称
    ,o.nextperiodreturninterestdate -- 下一期还息日期
    ,o.legal -- 诉讼费
    ,o.raccrint -- 未结正常利息
    ,o.preinttype -- 预收息标志
    ,o.yqfaxi -- 逾期管理罚息
    ,o.changepayaccountno -- 变更后的还款账号
    ,o.yqnormalbalance -- 逾期管理正常本金
    ,o.yqbadbalance -- 逾期管理逾期本金
    ,o.nextperiodreturnprincipalsum -- 下一期还本金额
    ,o.bdflag -- 买断清收标志
    ,o.fixterm -- 周期
    ,o.hxoutrate -- 核销表外利息
    ,o.loanspecies -- 贷款种类
    ,o.nextperiodreturnprincipaldate -- 下一期还本日期
    ,o.hxtype -- 核销类别
    ,o.loantype -- 贷款类型
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
from ${iol_schema}.icms_bd_upl_loan_bk o
    left join ${iol_schema}.icms_bd_upl_loan_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bd_upl_loan_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_bd_upl_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bd_upl_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bd_upl_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bd_upl_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bd_upl_loan exchange partition p_${batch_date} with table ${iol_schema}.icms_bd_upl_loan_cl;
alter table ${iol_schema}.icms_bd_upl_loan exchange partition p_20991231 with table ${iol_schema}.icms_bd_upl_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bd_upl_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bd_upl_loan_op purge;
drop table ${iol_schema}.icms_bd_upl_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bd_upl_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bd_upl_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
