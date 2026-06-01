/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_branch_rev_meg_register
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
create table ${iol_schema}.ncbs_rb_branch_rev_meg_register_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_branch_rev_meg_register
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_branch_rev_meg_register_op purge;
drop table ${iol_schema}.ncbs_rb_branch_rev_meg_register_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_branch_rev_meg_register_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_branch_rev_meg_register where 0=1;

create table ${iol_schema}.ncbs_rb_branch_rev_meg_register_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_branch_rev_meg_register where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_branch_rev_meg_register_cl(
            file_name -- 文件名称
            ,file_path -- 文件路径
            ,apply_no -- 申请编号
            ,company -- 法人
            ,merge_apply_status -- 机构撤并申请状态
            ,rev_meg_type -- 机构拆并类型
            ,apply_date -- 申请日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,in_branch -- 拆入机构
            ,out_branch -- 出库机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_branch_rev_meg_register_op(
            file_name -- 文件名称
            ,file_path -- 文件路径
            ,apply_no -- 申请编号
            ,company -- 法人
            ,merge_apply_status -- 机构撤并申请状态
            ,rev_meg_type -- 机构拆并类型
            ,apply_date -- 申请日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,in_branch -- 拆入机构
            ,out_branch -- 出库机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.file_name, o.file_name) as file_name -- 文件名称
    ,nvl(n.file_path, o.file_path) as file_path -- 文件路径
    ,nvl(n.apply_no, o.apply_no) as apply_no -- 申请编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.merge_apply_status, o.merge_apply_status) as merge_apply_status -- 机构撤并申请状态
    ,nvl(n.rev_meg_type, o.rev_meg_type) as rev_meg_type -- 机构拆并类型
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,nvl(n.in_branch, o.in_branch) as in_branch -- 拆入机构
    ,nvl(n.out_branch, o.out_branch) as out_branch -- 出库机构
    ,case when
            n.apply_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.apply_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.apply_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_branch_rev_meg_register_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_branch_rev_meg_register where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.apply_no = n.apply_no
where (
        o.apply_no is null
    )
    or (
        n.apply_no is null
    )
    or (
        o.file_name <> n.file_name
        or o.file_path <> n.file_path
        or o.company <> n.company
        or o.merge_apply_status <> n.merge_apply_status
        or o.rev_meg_type <> n.rev_meg_type
        or o.apply_date <> n.apply_date
        or o.effect_date <> n.effect_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.update_date <> n.update_date
        or o.in_branch <> n.in_branch
        or o.out_branch <> n.out_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_branch_rev_meg_register_cl(
            file_name -- 文件名称
            ,file_path -- 文件路径
            ,apply_no -- 申请编号
            ,company -- 法人
            ,merge_apply_status -- 机构撤并申请状态
            ,rev_meg_type -- 机构拆并类型
            ,apply_date -- 申请日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,in_branch -- 拆入机构
            ,out_branch -- 出库机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_branch_rev_meg_register_op(
            file_name -- 文件名称
            ,file_path -- 文件路径
            ,apply_no -- 申请编号
            ,company -- 法人
            ,merge_apply_status -- 机构撤并申请状态
            ,rev_meg_type -- 机构拆并类型
            ,apply_date -- 申请日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,in_branch -- 拆入机构
            ,out_branch -- 出库机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.file_name -- 文件名称
    ,o.file_path -- 文件路径
    ,o.apply_no -- 申请编号
    ,o.company -- 法人
    ,o.merge_apply_status -- 机构撤并申请状态
    ,o.rev_meg_type -- 机构拆并类型
    ,o.apply_date -- 申请日期
    ,o.effect_date -- 产品生效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.update_date -- 更新日期
    ,o.in_branch -- 拆入机构
    ,o.out_branch -- 出库机构
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
from ${iol_schema}.ncbs_rb_branch_rev_meg_register_bk o
    left join ${iol_schema}.ncbs_rb_branch_rev_meg_register_op n
        on
            o.apply_no = n.apply_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_branch_rev_meg_register_cl d
        on
            o.apply_no = d.apply_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_branch_rev_meg_register;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_branch_rev_meg_register') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_branch_rev_meg_register drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_branch_rev_meg_register add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_branch_rev_meg_register exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_branch_rev_meg_register_cl;
alter table ${iol_schema}.ncbs_rb_branch_rev_meg_register exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_branch_rev_meg_register_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_branch_rev_meg_register to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_branch_rev_meg_register_op purge;
drop table ${iol_schema}.ncbs_rb_branch_rev_meg_register_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_branch_rev_meg_register_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_branch_rev_meg_register',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
