/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_bal_table_data
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;
/*
-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.fams_bok_bal_table_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_bal_table_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');
*/
-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_bal_table_data_op purge;
drop table ${iol_schema}.fams_bok_bal_table_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_bal_table_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_bal_table_data where 0=1;

create table ${iol_schema}.fams_bok_bal_table_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_bal_table_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_bal_table_data_cl(
            seq_no -- 账套代码
            ,o_ccy -- 币种
            ,o_open_bal_flag -- 原币期初余额方向
            ,o_open_balance -- 原币期初余额
            ,o_happen_amt_d -- 原币本期借方发生额
            ,o_happen_amt_c -- 原币本期贷方发生额
            ,o_end_bal_flag -- 原币期末余额方向
            ,o_end_balance -- 原币期末余额
            ,b_open_bal_flag -- 本位币期初余额方向
            ,b_open_balance -- 本位币期初余额
            ,b_happen_amt_d -- 本位币本期借方发生额
            ,b_happen_amt_c -- 本位币本期贷方发生额
            ,b_end_bal_flag -- 本位币期末余额方向
            ,b_end_balance -- 本位币期末余额
            ,bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,bal_date -- 估值日期
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_bal_table_data_op(
            seq_no -- 账套代码
            ,o_ccy -- 币种
            ,o_open_bal_flag -- 原币期初余额方向
            ,o_open_balance -- 原币期初余额
            ,o_happen_amt_d -- 原币本期借方发生额
            ,o_happen_amt_c -- 原币本期贷方发生额
            ,o_end_bal_flag -- 原币期末余额方向
            ,o_end_balance -- 原币期末余额
            ,b_open_bal_flag -- 本位币期初余额方向
            ,b_open_balance -- 本位币期初余额
            ,b_happen_amt_d -- 本位币本期借方发生额
            ,b_happen_amt_c -- 本位币本期贷方发生额
            ,b_end_bal_flag -- 本位币期末余额方向
            ,b_end_balance -- 本位币期末余额
            ,bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,bal_date -- 估值日期
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq_no, o.seq_no) as seq_no -- 账套代码
    ,nvl(n.o_ccy, o.o_ccy) as o_ccy -- 币种
    ,nvl(n.o_open_bal_flag, o.o_open_bal_flag) as o_open_bal_flag -- 原币期初余额方向
    ,nvl(n.o_open_balance, o.o_open_balance) as o_open_balance -- 原币期初余额
    ,nvl(n.o_happen_amt_d, o.o_happen_amt_d) as o_happen_amt_d -- 原币本期借方发生额
    ,nvl(n.o_happen_amt_c, o.o_happen_amt_c) as o_happen_amt_c -- 原币本期贷方发生额
    ,nvl(n.o_end_bal_flag, o.o_end_bal_flag) as o_end_bal_flag -- 原币期末余额方向
    ,nvl(n.o_end_balance, o.o_end_balance) as o_end_balance -- 原币期末余额
    ,nvl(n.b_open_bal_flag, o.b_open_bal_flag) as b_open_bal_flag -- 本位币期初余额方向
    ,nvl(n.b_open_balance, o.b_open_balance) as b_open_balance -- 本位币期初余额
    ,nvl(n.b_happen_amt_d, o.b_happen_amt_d) as b_happen_amt_d -- 本位币本期借方发生额
    ,nvl(n.b_happen_amt_c, o.b_happen_amt_c) as b_happen_amt_c -- 本位币本期贷方发生额
    ,nvl(n.b_end_bal_flag, o.b_end_bal_flag) as b_end_bal_flag -- 本位币期末余额方向
    ,nvl(n.b_end_balance, o.b_end_balance) as b_end_balance -- 本位币期末余额
    ,nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.bookset_name, o.bookset_name) as bookset_name -- 账套名称
    ,nvl(n.bal_date, o.bal_date) as bal_date -- 估值日期
    ,nvl(n.subject_no, o.subject_no) as subject_no -- 科目号
    ,nvl(n.subject_name, o.subject_name) as subject_name -- 科目名称
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_bok_bal_table_data where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_bok_bal_table_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.o_ccy <> n.o_ccy
        or o.o_open_bal_flag <> n.o_open_bal_flag
        or o.o_open_balance <> n.o_open_balance
        or o.o_happen_amt_d <> n.o_happen_amt_d
        or o.o_happen_amt_c <> n.o_happen_amt_c
        or o.o_end_bal_flag <> n.o_end_bal_flag
        or o.o_end_balance <> n.o_end_balance
        or o.b_open_bal_flag <> n.b_open_bal_flag
        or o.b_open_balance <> n.b_open_balance
        or o.b_happen_amt_d <> n.b_happen_amt_d
        or o.b_happen_amt_c <> n.b_happen_amt_c
        or o.b_end_bal_flag <> n.b_end_bal_flag
        or o.b_end_balance <> n.b_end_balance
        or o.bookset_id <> n.bookset_id
        or o.bookset_name <> n.bookset_name
        or o.bal_date <> n.bal_date
        or o.subject_no <> n.subject_no
        or o.subject_name <> n.subject_name
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_bal_table_data_cl(
            seq_no -- 账套代码
            ,o_ccy -- 币种
            ,o_open_bal_flag -- 原币期初余额方向
            ,o_open_balance -- 原币期初余额
            ,o_happen_amt_d -- 原币本期借方发生额
            ,o_happen_amt_c -- 原币本期贷方发生额
            ,o_end_bal_flag -- 原币期末余额方向
            ,o_end_balance -- 原币期末余额
            ,b_open_bal_flag -- 本位币期初余额方向
            ,b_open_balance -- 本位币期初余额
            ,b_happen_amt_d -- 本位币本期借方发生额
            ,b_happen_amt_c -- 本位币本期贷方发生额
            ,b_end_bal_flag -- 本位币期末余额方向
            ,b_end_balance -- 本位币期末余额
            ,bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,bal_date -- 估值日期
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_bal_table_data_op(
            seq_no -- 账套代码
            ,o_ccy -- 币种
            ,o_open_bal_flag -- 原币期初余额方向
            ,o_open_balance -- 原币期初余额
            ,o_happen_amt_d -- 原币本期借方发生额
            ,o_happen_amt_c -- 原币本期贷方发生额
            ,o_end_bal_flag -- 原币期末余额方向
            ,o_end_balance -- 原币期末余额
            ,b_open_bal_flag -- 本位币期初余额方向
            ,b_open_balance -- 本位币期初余额
            ,b_happen_amt_d -- 本位币本期借方发生额
            ,b_happen_amt_c -- 本位币本期贷方发生额
            ,b_end_bal_flag -- 本位币期末余额方向
            ,b_end_balance -- 本位币期末余额
            ,bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,bal_date -- 估值日期
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq_no -- 账套代码
    ,o.o_ccy -- 币种
    ,o.o_open_bal_flag -- 原币期初余额方向
    ,o.o_open_balance -- 原币期初余额
    ,o.o_happen_amt_d -- 原币本期借方发生额
    ,o.o_happen_amt_c -- 原币本期贷方发生额
    ,o.o_end_bal_flag -- 原币期末余额方向
    ,o.o_end_balance -- 原币期末余额
    ,o.b_open_bal_flag -- 本位币期初余额方向
    ,o.b_open_balance -- 本位币期初余额
    ,o.b_happen_amt_d -- 本位币本期借方发生额
    ,o.b_happen_amt_c -- 本位币本期贷方发生额
    ,o.b_end_bal_flag -- 本位币期末余额方向
    ,o.b_end_balance -- 本位币期末余额
    ,o.bookset_id -- 账套代码
    ,o.bookset_name -- 账套名称
    ,o.bal_date -- 估值日期
    ,o.subject_no -- 科目号
    ,o.subject_name -- 科目名称
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
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
from (select * from ${iol_schema}.fams_bok_bal_table_data where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    left join ${iol_schema}.fams_bok_bal_table_data_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_bok_bal_table_data_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_bok_bal_table_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_bok_bal_table_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_bok_bal_table_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_bok_bal_table_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_bok_bal_table_data exchange partition p_${batch_date} with table ${iol_schema}.fams_bok_bal_table_data_cl;
alter table ${iol_schema}.fams_bok_bal_table_data exchange partition p_20991231 with table ${iol_schema}.fams_bok_bal_table_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_bal_table_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_bal_table_data_op purge;
drop table ${iol_schema}.fams_bok_bal_table_data_cl purge;
/*
whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_bal_table_data_bk purge;
*/
-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_bal_table_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
