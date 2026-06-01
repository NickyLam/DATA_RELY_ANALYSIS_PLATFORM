/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ibank_curr_cap_acct_bal_h_ibmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_curr_cap_acct_bal_h partition for ('ibmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_op purge;
drop table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_cap_acct_id -- 外部资金账户编号
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,curr_cd -- 币种代码
    ,acct_bal -- 账户余额
    ,futures_margin -- 期货保证金
    ,open_tm -- 开仓时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_curr_cap_acct_bal_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_curr_cap_acct_bal_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_curr_cap_acct_bal_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_accounting_cash_obj_his-1
insert into ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_cap_acct_id -- 外部资金账户编号
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,curr_cd -- 币种代码
    ,acct_bal -- 账户余额
    ,futures_margin -- 期货保证金
    ,open_tm -- 开仓时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '100042'||P1.CASH_ACCT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.OBJ_ID -- 对象编号
    ,P1.TSK_ID -- 任务编号
    ,P1.EXT_CASH_ACCT_ID -- 外部资金账户编号
    ,P1.CASH_ACCT_ID -- 内部资金账户编号
    ,NVL(TRIM(P1.CURRENCY),'-') -- 币种代码
    ,P1.REAL_AMOUNT -- 账户余额
    ,P1.REAL_MARGIN -- 期货保证金
    ,${iml_schema}.TIMEFORMAT_MIN(P1.OPEN_TIME) -- 开仓时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_accounting_cash_obj_his' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_accounting_cash_obj_his p1
where  1 = 1 
    AND TO_DATE(P1.BEG_DATE,'YYYY-MM-DD') = TO_DATE('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,obj_id
  	                                        ,task_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_cap_acct_id -- 外部资金账户编号
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,curr_cd -- 币种代码
    ,acct_bal -- 账户余额
    ,futures_margin -- 期货保证金
    ,open_tm -- 开仓时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_cap_acct_id -- 外部资金账户编号
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,curr_cd -- 币种代码
    ,acct_bal -- 账户余额
    ,futures_margin -- 期货保证金
    ,open_tm -- 开仓时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.obj_id, o.obj_id) as obj_id -- 对象编号
    ,nvl(n.task_id, o.task_id) as task_id -- 任务编号
    ,nvl(n.ext_cap_acct_id, o.ext_cap_acct_id) as ext_cap_acct_id -- 外部资金账户编号
    ,nvl(n.intnal_cap_acct_id, o.intnal_cap_acct_id) as intnal_cap_acct_id -- 内部资金账户编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.acct_bal, o.acct_bal) as acct_bal -- 账户余额
    ,nvl(n.futures_margin, o.futures_margin) as futures_margin -- 期货保证金
    ,nvl(n.open_tm, o.open_tm) as open_tm -- 开仓时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.obj_id is null
            and n.task_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.obj_id is null
            and n.task_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.obj_id is null
            and n.task_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.obj_id = n.obj_id
            and o.task_id = n.task_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.obj_id is null
        and o.task_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.obj_id is null
        and n.task_id is null
    )
    or (
        o.ext_cap_acct_id <> n.ext_cap_acct_id
        or o.intnal_cap_acct_id <> n.intnal_cap_acct_id
        or o.curr_cd <> n.curr_cd
        or o.acct_bal <> n.acct_bal
        or o.futures_margin <> n.futures_margin
        or o.open_tm <> n.open_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_cap_acct_id -- 外部资金账户编号
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,curr_cd -- 币种代码
    ,acct_bal -- 账户余额
    ,futures_margin -- 期货保证金
    ,open_tm -- 开仓时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,obj_id -- 对象编号
    ,task_id -- 任务编号
    ,ext_cap_acct_id -- 外部资金账户编号
    ,intnal_cap_acct_id -- 内部资金账户编号
    ,curr_cd -- 币种代码
    ,acct_bal -- 账户余额
    ,futures_margin -- 期货保证金
    ,open_tm -- 开仓时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.obj_id -- 对象编号
    ,o.task_id -- 任务编号
    ,o.ext_cap_acct_id -- 外部资金账户编号
    ,o.intnal_cap_acct_id -- 内部资金账户编号
    ,o.curr_cd -- 币种代码
    ,o.acct_bal -- 账户余额
    ,o.futures_margin -- 期货保证金
    ,o.open_tm -- 开仓时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_bk o
    left join ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.obj_id = n.obj_id
            and o.task_id = n.task_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.obj_id = d.obj_id
            and o.task_id = d.task_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h;
alter table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h exchange subpartition p_ibmsf1_19000101 with table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_cl;
alter table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ibank_curr_cap_acct_bal_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_tm purge;
drop table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_op purge;
drop table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ibank_curr_cap_acct_bal_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ibank_curr_cap_acct_bal_h', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
