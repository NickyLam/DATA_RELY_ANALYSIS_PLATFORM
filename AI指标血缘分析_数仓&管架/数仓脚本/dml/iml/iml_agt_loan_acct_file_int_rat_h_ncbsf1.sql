/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_acct_file_int_rat_h_ncbsf1
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
alter table ${iml_schema}.agt_loan_acct_file_int_rat_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_file_int_rat_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    cust_id -- 客户编号
    ,agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,seq_num -- 序号
    ,tenor_type_cd -- 期限类型代码
    ,lp_id -- 法人编号
    ,and_begin_day_diff_between_days -- 与起始日相差天数
    ,invalid_dt -- 失效天数
    ,acrs_mon_int_rat -- 跨月利率
    ,not_acrs_mon_int_rat -- 不跨月利率
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_file_int_rat_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_file_int_rat_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_file_int_rat_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_acct_gear_detail-1
insert into ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_tm(
    cust_id -- 客户编号
    ,agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,seq_num -- 序号
    ,tenor_type_cd -- 期限类型代码
    ,lp_id -- 法人编号
    ,and_begin_day_diff_between_days -- 与起始日相差天数
    ,invalid_dt -- 失效天数
    ,acrs_mon_int_rat -- 跨月利率
    ,not_acrs_mon_int_rat -- 不跨月利率
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLIENT_NO -- 客户编号
    ,'300001'||INTERNAL_KEY -- 协议编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.SEQ_NO -- 序号
    ,nvl(trim(P1.TERM_TYPE),'-') -- 期限类型代码
    ,'9999' -- 法人编号
    ,P1.START_DAYS -- 与起始日相差天数
    ,P1.END_DAYS -- 失效天数
    ,P1.CROSS_PERIOD_RATE -- 跨月利率
    ,P1.PERIOD_RATE -- 不跨月利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_acct_gear_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_gear_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_tm 
  	                                group by 
  	                                        cust_id
  	                                        ,agt_id
  	                                        ,acct_id
  	                                        ,seq_num
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
        into ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_cl(
            cust_id -- 客户编号
    ,agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,seq_num -- 序号
    ,tenor_type_cd -- 期限类型代码
    ,lp_id -- 法人编号
    ,and_begin_day_diff_between_days -- 与起始日相差天数
    ,invalid_dt -- 失效天数
    ,acrs_mon_int_rat -- 跨月利率
    ,not_acrs_mon_int_rat -- 不跨月利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_op(
            cust_id -- 客户编号
    ,agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,seq_num -- 序号
    ,tenor_type_cd -- 期限类型代码
    ,lp_id -- 法人编号
    ,and_begin_day_diff_between_days -- 与起始日相差天数
    ,invalid_dt -- 失效天数
    ,acrs_mon_int_rat -- 跨月利率
    ,not_acrs_mon_int_rat -- 不跨月利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.and_begin_day_diff_between_days, o.and_begin_day_diff_between_days) as and_begin_day_diff_between_days -- 与起始日相差天数
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效天数
    ,nvl(n.acrs_mon_int_rat, o.acrs_mon_int_rat) as acrs_mon_int_rat -- 跨月利率
    ,nvl(n.not_acrs_mon_int_rat, o.not_acrs_mon_int_rat) as not_acrs_mon_int_rat -- 不跨月利率
    ,case when
            n.cust_id is null
            and n.agt_id is null
            and n.acct_id is null
            and n.seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_id is null
            and n.agt_id is null
            and n.acct_id is null
            and n.seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_id is null
            and n.agt_id is null
            and n.acct_id is null
            and n.seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.cust_id = n.cust_id
            and o.agt_id = n.agt_id
            and o.acct_id = n.acct_id
            and o.seq_num = n.seq_num
where (
        o.cust_id is null
        and o.agt_id is null
        and o.acct_id is null
        and o.seq_num is null
    )
    or (
        n.cust_id is null
        and n.agt_id is null
        and n.acct_id is null
        and n.seq_num is null
    )
    or (
        o.tenor_type_cd <> n.tenor_type_cd
        or o.lp_id <> n.lp_id
        or o.and_begin_day_diff_between_days <> n.and_begin_day_diff_between_days
        or o.invalid_dt <> n.invalid_dt
        or o.acrs_mon_int_rat <> n.acrs_mon_int_rat
        or o.not_acrs_mon_int_rat <> n.not_acrs_mon_int_rat
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_cl(
            cust_id -- 客户编号
    ,agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,seq_num -- 序号
    ,tenor_type_cd -- 期限类型代码
    ,lp_id -- 法人编号
    ,and_begin_day_diff_between_days -- 与起始日相差天数
    ,invalid_dt -- 失效天数
    ,acrs_mon_int_rat -- 跨月利率
    ,not_acrs_mon_int_rat -- 不跨月利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_op(
            cust_id -- 客户编号
    ,agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,seq_num -- 序号
    ,tenor_type_cd -- 期限类型代码
    ,lp_id -- 法人编号
    ,and_begin_day_diff_between_days -- 与起始日相差天数
    ,invalid_dt -- 失效天数
    ,acrs_mon_int_rat -- 跨月利率
    ,not_acrs_mon_int_rat -- 不跨月利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cust_id -- 客户编号
    ,o.agt_id -- 协议编号
    ,o.acct_id -- 账户编号
    ,o.seq_num -- 序号
    ,o.tenor_type_cd -- 期限类型代码
    ,o.lp_id -- 法人编号
    ,o.and_begin_day_diff_between_days -- 与起始日相差天数
    ,o.invalid_dt -- 失效天数
    ,o.acrs_mon_int_rat -- 跨月利率
    ,o.not_acrs_mon_int_rat -- 不跨月利率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_op n
        on
            o.cust_id = n.cust_id
            and o.agt_id = n.agt_id
            and o.acct_id = n.acct_id
            and o.seq_num = n.seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_cl d
        on
            o.cust_id = d.cust_id
            and o.agt_id = d.agt_id
            and o.acct_id = d.acct_id
            and o.seq_num = d.seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_acct_file_int_rat_h;
--alter table ${iml_schema}.agt_loan_acct_file_int_rat_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_acct_file_int_rat_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_acct_file_int_rat_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_loan_acct_file_int_rat_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_acct_file_int_rat_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_acct_file_int_rat_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_acct_file_int_rat_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_acct_file_int_rat_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_acct_file_int_rat_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
