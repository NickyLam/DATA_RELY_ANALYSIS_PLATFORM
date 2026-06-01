/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_clawback_info_detail
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
create table ${iol_schema}.fams_bok_clawback_info_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_clawback_info_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_clawback_info_detail_op purge;
drop table ${iol_schema}.fams_bok_clawback_info_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_clawback_info_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_clawback_info_detail where 0=1;

create table ${iol_schema}.fams_bok_clawback_info_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_clawback_info_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_clawback_info_detail_cl(
            bookset_id -- 账套代码
            ,layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型
            ,branch -- 分支序号
            ,happen_date -- 会计日期
            ,book_date -- 入账日期
            ,bookset_date -- 账套日期
            ,fee_type -- 费用类型
            ,clawback_amt -- 回补金额
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
        into ${iol_schema}.fams_bok_clawback_info_detail_op(
            bookset_id -- 账套代码
            ,layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型
            ,branch -- 分支序号
            ,happen_date -- 会计日期
            ,book_date -- 入账日期
            ,bookset_date -- 账套日期
            ,fee_type -- 费用类型
            ,clawback_amt -- 回补金额
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
    nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.layering_id, o.layering_id) as layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.finprod_type, o.finprod_type) as finprod_type -- 金融产品类型
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.happen_date, o.happen_date) as happen_date -- 会计日期
    ,nvl(n.book_date, o.book_date) as book_date -- 入账日期
    ,nvl(n.bookset_date, o.bookset_date) as bookset_date -- 账套日期
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费用类型
    ,nvl(n.clawback_amt, o.clawback_amt) as clawback_amt -- 回补金额
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.bookset_id is null
            and n.layering_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.fee_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bookset_id is null
            and n.layering_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.fee_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bookset_id is null
            and n.layering_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.fee_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_bok_clawback_info_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_bok_clawback_info_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bookset_id = n.bookset_id
            and o.layering_id = n.layering_id
            and o.happen_date = n.happen_date
            and o.book_date = n.book_date
            and o.fee_type = n.fee_type
where (
        o.bookset_id is null
        and o.layering_id is null
        and o.happen_date is null
        and o.book_date is null
        and o.fee_type is null
    )
    or (
        n.bookset_id is null
        and n.layering_id is null
        and n.happen_date is null
        and n.book_date is null
        and n.fee_type is null
    )
    or (
        o.finprod_id <> n.finprod_id
        or o.finprod_type <> n.finprod_type
        or o.branch <> n.branch
        or o.bookset_date <> n.bookset_date
        or o.clawback_amt <> n.clawback_amt
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
        into ${iol_schema}.fams_bok_clawback_info_detail_cl(
            bookset_id -- 账套代码
            ,layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型
            ,branch -- 分支序号
            ,happen_date -- 会计日期
            ,book_date -- 入账日期
            ,bookset_date -- 账套日期
            ,fee_type -- 费用类型
            ,clawback_amt -- 回补金额
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
        into ${iol_schema}.fams_bok_clawback_info_detail_op(
            bookset_id -- 账套代码
            ,layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型
            ,branch -- 分支序号
            ,happen_date -- 会计日期
            ,book_date -- 入账日期
            ,bookset_date -- 账套日期
            ,fee_type -- 费用类型
            ,clawback_amt -- 回补金额
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
    o.bookset_id -- 账套代码
    ,o.layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
    ,o.finprod_id -- 金融产品代码
    ,o.finprod_type -- 金融产品类型
    ,o.branch -- 分支序号
    ,o.happen_date -- 会计日期
    ,o.book_date -- 入账日期
    ,o.bookset_date -- 账套日期
    ,o.fee_type -- 费用类型
    ,o.clawback_amt -- 回补金额
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
from ${iol_schema}.fams_bok_clawback_info_detail_bk o
    left join ${iol_schema}.fams_bok_clawback_info_detail_op n
        on
            o.bookset_id = n.bookset_id
            and o.layering_id = n.layering_id
            and o.happen_date = n.happen_date
            and o.book_date = n.book_date
            and o.fee_type = n.fee_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_bok_clawback_info_detail_cl d
        on
            o.bookset_id = d.bookset_id
            and o.layering_id = d.layering_id
            and o.happen_date = d.happen_date
            and o.book_date = d.book_date
            and o.fee_type = d.fee_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_bok_clawback_info_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_bok_clawback_info_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_bok_clawback_info_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_bok_clawback_info_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_bok_clawback_info_detail exchange partition p_${batch_date} with table ${iol_schema}.fams_bok_clawback_info_detail_cl;
alter table ${iol_schema}.fams_bok_clawback_info_detail exchange partition p_20991231 with table ${iol_schema}.fams_bok_clawback_info_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_clawback_info_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_clawback_info_detail_op purge;
drop table ${iol_schema}.fams_bok_clawback_info_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_clawback_info_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_clawback_info_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
