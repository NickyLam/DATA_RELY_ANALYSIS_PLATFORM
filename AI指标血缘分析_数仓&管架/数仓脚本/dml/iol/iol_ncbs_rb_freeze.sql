/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_freeze
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
create table ${iol_schema}.ncbs_rb_freeze_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_freeze
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_freeze_op purge;
drop table ${iol_schema}.ncbs_rb_freeze_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_freeze_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_freeze where 0=1;

create table ${iol_schema}.ncbs_rb_freeze_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_freeze where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_freeze_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,freeze_status -- 冻结状态
            ,full_freeze_ind -- 全额冻结标志
            ,narrative -- 摘要
            ,program_id -- 交易代码
            ,res_priority -- 冻结级别
            ,res_seq_no -- 限制编号
            ,source_module -- 源模块
            ,tran_timestamp -- 交易时间戳
            ,pledged_amt -- 限制金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_freeze_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,freeze_status -- 冻结状态
            ,full_freeze_ind -- 全额冻结标志
            ,narrative -- 摘要
            ,program_id -- 交易代码
            ,res_priority -- 冻结级别
            ,res_seq_no -- 限制编号
            ,source_module -- 源模块
            ,tran_timestamp -- 交易时间戳
            ,pledged_amt -- 限制金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.freeze_status, o.freeze_status) as freeze_status -- 冻结状态
    ,nvl(n.full_freeze_ind, o.full_freeze_ind) as full_freeze_ind -- 全额冻结标志
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.program_id, o.program_id) as program_id -- 交易代码
    ,nvl(n.res_priority, o.res_priority) as res_priority -- 冻结级别
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.pledged_amt, o.pledged_amt) as pledged_amt -- 限制金额
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.internal_key is null
            and n.res_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.res_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.res_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_freeze_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_freeze where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.res_seq_no = n.res_seq_no
where (
        o.internal_key is null
        and o.res_seq_no is null
    )
    or (
        n.internal_key is null
        and n.res_seq_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.reference <> n.reference
        or o.restraint_type <> n.restraint_type
        or o.tran_type <> n.tran_type
        or o.user_id <> n.user_id
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.freeze_status <> n.freeze_status
        or o.full_freeze_ind <> n.full_freeze_ind
        or o.narrative <> n.narrative
        or o.program_id <> n.program_id
        or o.res_priority <> n.res_priority
        or o.source_module <> n.source_module
        or o.tran_timestamp <> n.tran_timestamp
        or o.pledged_amt <> n.pledged_amt
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_freeze_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,freeze_status -- 冻结状态
            ,full_freeze_ind -- 全额冻结标志
            ,narrative -- 摘要
            ,program_id -- 交易代码
            ,res_priority -- 冻结级别
            ,res_seq_no -- 限制编号
            ,source_module -- 源模块
            ,tran_timestamp -- 交易时间戳
            ,pledged_amt -- 限制金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_freeze_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,restraint_type -- 限制类型
            ,tran_type -- 交易类型
            ,user_id -- 交易柜员编号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,freeze_status -- 冻结状态
            ,full_freeze_ind -- 全额冻结标志
            ,narrative -- 摘要
            ,program_id -- 交易代码
            ,res_priority -- 冻结级别
            ,res_seq_no -- 限制编号
            ,source_module -- 源模块
            ,tran_timestamp -- 交易时间戳
            ,pledged_amt -- 限制金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.restraint_type -- 限制类型
    ,o.tran_type -- 交易类型
    ,o.user_id -- 交易柜员编号
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.freeze_status -- 冻结状态
    ,o.full_freeze_ind -- 全额冻结标志
    ,o.narrative -- 摘要
    ,o.program_id -- 交易代码
    ,o.res_priority -- 冻结级别
    ,o.res_seq_no -- 限制编号
    ,o.source_module -- 源模块
    ,o.tran_timestamp -- 交易时间戳
    ,o.pledged_amt -- 限制金额
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_rb_freeze_bk o
    left join ${iol_schema}.ncbs_rb_freeze_op n
        on
            o.internal_key = n.internal_key
            and o.res_seq_no = n.res_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_freeze_cl d
        on
            o.internal_key = d.internal_key
            and o.res_seq_no = d.res_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_freeze;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_freeze') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_freeze drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_freeze add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_freeze exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_freeze_cl;
alter table ${iol_schema}.ncbs_rb_freeze exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_freeze_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_freeze to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_freeze_op purge;
drop table ${iol_schema}.ncbs_rb_freeze_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_freeze_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_freeze',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
