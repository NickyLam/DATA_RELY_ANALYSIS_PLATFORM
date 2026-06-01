/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_restraint_allow_busi
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
create table ${iol_schema}.ncbs_rb_restraint_allow_busi_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_restraint_allow_busi
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_restraint_allow_busi_op purge;
drop table ${iol_schema}.ncbs_rb_restraint_allow_busi_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_restraint_allow_busi_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_restraint_allow_busi where 0=1;

create table ${iol_schema}.ncbs_rb_restraint_allow_busi_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_restraint_allow_busi where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_restraint_allow_busi_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,restraint_type -- 限制类型
            ,user_id -- 交易柜员编号
            ,busi_type -- 业务种类
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,restraints_status -- 限制状态
            ,last_tran_date -- 最后交易日期
            ,tran_date -- 交易日期
            ,acct_ccy -- 账户币种
            ,tran_branch -- 核心交易机构编号
            ,allow_channel -- 允许的渠道集合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_restraint_allow_busi_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,restraint_type -- 限制类型
            ,user_id -- 交易柜员编号
            ,busi_type -- 业务种类
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,restraints_status -- 限制状态
            ,last_tran_date -- 最后交易日期
            ,tran_date -- 交易日期
            ,acct_ccy -- 账户币种
            ,tran_branch -- 核心交易机构编号
            ,allow_channel -- 允许的渠道集合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务种类
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.restraints_status, o.restraints_status) as restraints_status -- 限制状态
    ,nvl(n.last_tran_date, o.last_tran_date) as last_tran_date -- 最后交易日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.allow_channel, o.allow_channel) as allow_channel -- 允许的渠道集合
    ,case when
            n.res_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.res_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.res_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_restraint_allow_busi_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_restraint_allow_busi where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.res_seq_no = n.res_seq_no
where (
        o.res_seq_no is null
    )
    or (
        n.res_seq_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.restraint_type <> n.restraint_type
        or o.user_id <> n.user_id
        or o.busi_type <> n.busi_type
        or o.company <> n.company
        or o.restraints_status <> n.restraints_status
        or o.last_tran_date <> n.last_tran_date
        or o.tran_date <> n.tran_date
        or o.acct_ccy <> n.acct_ccy
        or o.tran_branch <> n.tran_branch
        or o.allow_channel <> n.allow_channel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_restraint_allow_busi_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,restraint_type -- 限制类型
            ,user_id -- 交易柜员编号
            ,busi_type -- 业务种类
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,restraints_status -- 限制状态
            ,last_tran_date -- 最后交易日期
            ,tran_date -- 交易日期
            ,acct_ccy -- 账户币种
            ,tran_branch -- 核心交易机构编号
            ,allow_channel -- 允许的渠道集合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_restraint_allow_busi_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,restraint_type -- 限制类型
            ,user_id -- 交易柜员编号
            ,busi_type -- 业务种类
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,restraints_status -- 限制状态
            ,last_tran_date -- 最后交易日期
            ,tran_date -- 交易日期
            ,acct_ccy -- 账户币种
            ,tran_branch -- 核心交易机构编号
            ,allow_channel -- 允许的渠道集合
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.restraint_type -- 限制类型
    ,o.user_id -- 交易柜员编号
    ,o.busi_type -- 业务种类
    ,o.company -- 法人
    ,o.res_seq_no -- 限制编号
    ,o.restraints_status -- 限制状态
    ,o.last_tran_date -- 最后交易日期
    ,o.tran_date -- 交易日期
    ,o.acct_ccy -- 账户币种
    ,o.tran_branch -- 核心交易机构编号
    ,o.allow_channel -- 允许的渠道集合
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
from ${iol_schema}.ncbs_rb_restraint_allow_busi_bk o
    left join ${iol_schema}.ncbs_rb_restraint_allow_busi_op n
        on
            o.res_seq_no = n.res_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_restraint_allow_busi_cl d
        on
            o.res_seq_no = d.res_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_restraint_allow_busi;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_restraint_allow_busi') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_restraint_allow_busi drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_restraint_allow_busi add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_restraint_allow_busi exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_restraint_allow_busi_cl;
alter table ${iol_schema}.ncbs_rb_restraint_allow_busi exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_restraint_allow_busi_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_restraint_allow_busi to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_restraint_allow_busi_op purge;
drop table ${iol_schema}.ncbs_rb_restraint_allow_busi_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_restraint_allow_busi_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_restraint_allow_busi',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
