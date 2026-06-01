/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ban_bank_bok_balance
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
create table ${iol_schema}.fams_ban_bank_bok_balance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ban_bank_bok_balance
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_bank_bok_balance_op purge;
drop table ${iol_schema}.fams_ban_bank_bok_balance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_bank_bok_balance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_bank_bok_balance where 0=1;

create table ${iol_schema}.fams_ban_bank_bok_balance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_bank_bok_balance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_bank_bok_balance_cl(
            finprod_id -- 金融产品代码
            ,balance_date -- 余额日期
            ,subject_no -- 科目号
            ,fsubject_no -- 父科目号
            ,subject_level -- 科目级别
            ,bal_flag -- 余额方向
            ,o_ccy -- 原币
            ,o_amt -- 原币余额
            ,b_ccy -- 本位币
            ,b_amt -- 本位币余额
            ,is_leaf -- 是否叶子节点
            ,num_amt -- 数量余额
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,bookset_id -- 账套代码
            ,detail_subject_no -- 产品编号
            ,detail_subject_level -- 可售产品级别
            ,tdy_o_c_amt -- 原币本期贷方发生额
            ,tdy_o_d_amt -- 原币本期借方发生额
            ,o_c_amt -- 原币本期贷方余额
            ,o_d_amt -- 原币本期借方余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_bank_bok_balance_op(
            finprod_id -- 金融产品代码
            ,balance_date -- 余额日期
            ,subject_no -- 科目号
            ,fsubject_no -- 父科目号
            ,subject_level -- 科目级别
            ,bal_flag -- 余额方向
            ,o_ccy -- 原币
            ,o_amt -- 原币余额
            ,b_ccy -- 本位币
            ,b_amt -- 本位币余额
            ,is_leaf -- 是否叶子节点
            ,num_amt -- 数量余额
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,bookset_id -- 账套代码
            ,detail_subject_no -- 产品编号
            ,detail_subject_level -- 可售产品级别
            ,tdy_o_c_amt -- 原币本期贷方发生额
            ,tdy_o_d_amt -- 原币本期借方发生额
            ,o_c_amt -- 原币本期贷方余额
            ,o_d_amt -- 原币本期借方余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.balance_date, o.balance_date) as balance_date -- 余额日期
    ,nvl(n.subject_no, o.subject_no) as subject_no -- 科目号
    ,nvl(n.fsubject_no, o.fsubject_no) as fsubject_no -- 父科目号
    ,nvl(n.subject_level, o.subject_level) as subject_level -- 科目级别
    ,nvl(n.bal_flag, o.bal_flag) as bal_flag -- 余额方向
    ,nvl(n.o_ccy, o.o_ccy) as o_ccy -- 原币
    ,nvl(n.o_amt, o.o_amt) as o_amt -- 原币余额
    ,nvl(n.b_ccy, o.b_ccy) as b_ccy -- 本位币
    ,nvl(n.b_amt, o.b_amt) as b_amt -- 本位币余额
    ,nvl(n.is_leaf, o.is_leaf) as is_leaf -- 是否叶子节点
    ,nvl(n.num_amt, o.num_amt) as num_amt -- 数量余额
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.detail_subject_no, o.detail_subject_no) as detail_subject_no -- 产品编号
    ,nvl(n.detail_subject_level, o.detail_subject_level) as detail_subject_level -- 可售产品级别
    ,nvl(n.tdy_o_c_amt, o.tdy_o_c_amt) as tdy_o_c_amt -- 原币本期贷方发生额
    ,nvl(n.tdy_o_d_amt, o.tdy_o_d_amt) as tdy_o_d_amt -- 原币本期借方发生额
    ,nvl(n.o_c_amt, o.o_c_amt) as o_c_amt -- 原币本期贷方余额
    ,nvl(n.o_d_amt, o.o_d_amt) as o_d_amt -- 原币本期借方余额
    ,case when
            n.balance_date is null
            and n.subject_no is null
            and n.bookset_id is null
            and n.detail_subject_no is null
            and n.detail_subject_level is null
            and n.tdy_o_c_amt is null
            and n.tdy_o_d_amt is null
            and n.o_c_amt is null
            and n.o_d_amt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.balance_date is null
            and n.subject_no is null
            and n.bookset_id is null
            and n.detail_subject_no is null
            and n.detail_subject_level is null
            and n.tdy_o_c_amt is null
            and n.tdy_o_d_amt is null
            and n.o_c_amt is null
            and n.o_d_amt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.balance_date is null
            and n.subject_no is null
            and n.bookset_id is null
            and n.detail_subject_no is null
            and n.detail_subject_level is null
            and n.tdy_o_c_amt is null
            and n.tdy_o_d_amt is null
            and n.o_c_amt is null
            and n.o_d_amt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ban_bank_bok_balance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ban_bank_bok_balance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.balance_date = n.balance_date
            and o.subject_no = n.subject_no
            and o.bookset_id = n.bookset_id
            and o.detail_subject_no = n.detail_subject_no
            and o.detail_subject_level = n.detail_subject_level
            and o.tdy_o_c_amt = n.tdy_o_c_amt
            and o.tdy_o_d_amt = n.tdy_o_d_amt
            and o.o_c_amt = n.o_c_amt
            and o.o_d_amt = n.o_d_amt
where (
        o.balance_date is null
        and o.subject_no is null
        and o.bookset_id is null
        and o.detail_subject_no is null
        and o.detail_subject_level is null
        and o.tdy_o_c_amt is null
        and o.tdy_o_d_amt is null
        and o.o_c_amt is null
        and o.o_d_amt is null
    )
    or (
        n.balance_date is null
        and n.subject_no is null
        and n.bookset_id is null
        and n.detail_subject_no is null
        and n.detail_subject_level is null
        and n.tdy_o_c_amt is null
        and n.tdy_o_d_amt is null
        and n.o_c_amt is null
        and n.o_d_amt is null
    )
    or (
        o.finprod_id <> n.finprod_id
        or o.fsubject_no <> n.fsubject_no
        or o.subject_level <> n.subject_level
        or o.bal_flag <> n.bal_flag
        or o.o_ccy <> n.o_ccy
        or o.o_amt <> n.o_amt
        or o.b_ccy <> n.b_ccy
        or o.b_amt <> n.b_amt
        or o.is_leaf <> n.is_leaf
        or o.num_amt <> n.num_amt
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
        into ${iol_schema}.fams_ban_bank_bok_balance_cl(
            finprod_id -- 金融产品代码
            ,balance_date -- 余额日期
            ,subject_no -- 科目号
            ,fsubject_no -- 父科目号
            ,subject_level -- 科目级别
            ,bal_flag -- 余额方向
            ,o_ccy -- 原币
            ,o_amt -- 原币余额
            ,b_ccy -- 本位币
            ,b_amt -- 本位币余额
            ,is_leaf -- 是否叶子节点
            ,num_amt -- 数量余额
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,bookset_id -- 账套代码
            ,detail_subject_no -- 产品编号
            ,detail_subject_level -- 可售产品级别
            ,tdy_o_c_amt -- 原币本期贷方发生额
            ,tdy_o_d_amt -- 原币本期借方发生额
            ,o_c_amt -- 原币本期贷方余额
            ,o_d_amt -- 原币本期借方余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_bank_bok_balance_op(
            finprod_id -- 金融产品代码
            ,balance_date -- 余额日期
            ,subject_no -- 科目号
            ,fsubject_no -- 父科目号
            ,subject_level -- 科目级别
            ,bal_flag -- 余额方向
            ,o_ccy -- 原币
            ,o_amt -- 原币余额
            ,b_ccy -- 本位币
            ,b_amt -- 本位币余额
            ,is_leaf -- 是否叶子节点
            ,num_amt -- 数量余额
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,bookset_id -- 账套代码
            ,detail_subject_no -- 产品编号
            ,detail_subject_level -- 可售产品级别
            ,tdy_o_c_amt -- 原币本期贷方发生额
            ,tdy_o_d_amt -- 原币本期借方发生额
            ,o_c_amt -- 原币本期贷方余额
            ,o_d_amt -- 原币本期借方余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.finprod_id -- 金融产品代码
    ,o.balance_date -- 余额日期
    ,o.subject_no -- 科目号
    ,o.fsubject_no -- 父科目号
    ,o.subject_level -- 科目级别
    ,o.bal_flag -- 余额方向
    ,o.o_ccy -- 原币
    ,o.o_amt -- 原币余额
    ,o.b_ccy -- 本位币
    ,o.b_amt -- 本位币余额
    ,o.is_leaf -- 是否叶子节点
    ,o.num_amt -- 数量余额
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.bookset_id -- 账套代码
    ,o.detail_subject_no -- 产品编号
    ,o.detail_subject_level -- 可售产品级别
    ,o.tdy_o_c_amt -- 原币本期贷方发生额
    ,o.tdy_o_d_amt -- 原币本期借方发生额
    ,o.o_c_amt -- 原币本期贷方余额
    ,o.o_d_amt -- 原币本期借方余额
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
from ${iol_schema}.fams_ban_bank_bok_balance_bk o
    left join ${iol_schema}.fams_ban_bank_bok_balance_op n
        on
            o.balance_date = n.balance_date
            and o.subject_no = n.subject_no
            and o.bookset_id = n.bookset_id
            and o.detail_subject_no = n.detail_subject_no
            and o.detail_subject_level = n.detail_subject_level
            and o.tdy_o_c_amt = n.tdy_o_c_amt
            and o.tdy_o_d_amt = n.tdy_o_d_amt
            and o.o_c_amt = n.o_c_amt
            and o.o_d_amt = n.o_d_amt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ban_bank_bok_balance_cl d
        on
            o.balance_date = d.balance_date
            and o.subject_no = d.subject_no
            and o.bookset_id = d.bookset_id
            and o.detail_subject_no = d.detail_subject_no
            and o.detail_subject_level = d.detail_subject_level
            and o.tdy_o_c_amt = d.tdy_o_c_amt
            and o.tdy_o_d_amt = d.tdy_o_d_amt
            and o.o_c_amt = d.o_c_amt
            and o.o_d_amt = d.o_d_amt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_ban_bank_bok_balance;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_ban_bank_bok_balance') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_ban_bank_bok_balance drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_ban_bank_bok_balance add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_ban_bank_bok_balance exchange partition p_${batch_date} with table ${iol_schema}.fams_ban_bank_bok_balance_cl;
alter table ${iol_schema}.fams_ban_bank_bok_balance exchange partition p_20991231 with table ${iol_schema}.fams_ban_bank_bok_balance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ban_bank_bok_balance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_bank_bok_balance_op purge;
drop table ${iol_schema}.fams_ban_bank_bok_balance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ban_bank_bok_balance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ban_bank_bok_balance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
