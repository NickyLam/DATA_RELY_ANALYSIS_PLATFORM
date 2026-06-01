/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_amend_branch
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
create table ${iol_schema}.ncbs_rb_amend_branch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_amend_branch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_amend_branch_op purge;
drop table ${iol_schema}.ncbs_rb_amend_branch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_amend_branch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_amend_branch where 0=1;

create table ${iol_schema}.ncbs_rb_amend_branch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_amend_branch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_amend_branch_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,amend_seq_no -- 变更序号
            ,company -- 法人
            ,error_msg -- 错误代码
            ,seq_no -- 序号
            ,amend_date -- 变更日期
            ,auth_date -- 授权日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,tran_branch -- 核心交易机构编号
            ,branch_change_type -- 机构撤并交易类型
            ,ob_amend_seq_no -- 记录机构变更时，公共产生的序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_amend_branch_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,amend_seq_no -- 变更序号
            ,company -- 法人
            ,error_msg -- 错误代码
            ,seq_no -- 序号
            ,amend_date -- 变更日期
            ,auth_date -- 授权日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,tran_branch -- 核心交易机构编号
            ,branch_change_type -- 机构撤并交易类型
            ,ob_amend_seq_no -- 记录机构变更时，公共产生的序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.amend_seq_no, o.amend_seq_no) as amend_seq_no -- 变更序号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.error_msg, o.error_msg) as error_msg -- 错误代码
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.amend_date, o.amend_date) as amend_date -- 变更日期
    ,nvl(n.auth_date, o.auth_date) as auth_date -- 授权日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.new_branch, o.new_branch) as new_branch -- 变更后机构
    ,nvl(n.old_branch, o.old_branch) as old_branch -- 变更前机构
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.branch_change_type, o.branch_change_type) as branch_change_type -- 机构撤并交易类型
    ,nvl(n.ob_amend_seq_no, o.ob_amend_seq_no) as ob_amend_seq_no -- 记录机构变更时，公共产生的序号
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
from (select * from ${iol_schema}.ncbs_rb_amend_branch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_amend_branch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.amend_seq_no <> n.amend_seq_no
        or o.company <> n.company
        or o.error_msg <> n.error_msg
        or o.amend_date <> n.amend_date
        or o.auth_date <> n.auth_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.auth_user_id <> n.auth_user_id
        or o.new_branch <> n.new_branch
        or o.old_branch <> n.old_branch
        or o.tran_branch <> n.tran_branch
        or o.branch_change_type <> n.branch_change_type
        or o.ob_amend_seq_no <> n.ob_amend_seq_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_amend_branch_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,amend_seq_no -- 变更序号
            ,company -- 法人
            ,error_msg -- 错误代码
            ,seq_no -- 序号
            ,amend_date -- 变更日期
            ,auth_date -- 授权日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,tran_branch -- 核心交易机构编号
            ,branch_change_type -- 机构撤并交易类型
            ,ob_amend_seq_no -- 记录机构变更时，公共产生的序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_amend_branch_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,amend_seq_no -- 变更序号
            ,company -- 法人
            ,error_msg -- 错误代码
            ,seq_no -- 序号
            ,amend_date -- 变更日期
            ,auth_date -- 授权日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,new_branch -- 变更后机构
            ,old_branch -- 变更前机构
            ,tran_branch -- 核心交易机构编号
            ,branch_change_type -- 机构撤并交易类型
            ,ob_amend_seq_no -- 记录机构变更时，公共产生的序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.amend_seq_no -- 变更序号
    ,o.company -- 法人
    ,o.error_msg -- 错误代码
    ,o.seq_no -- 序号
    ,o.amend_date -- 变更日期
    ,o.auth_date -- 授权日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.auth_user_id -- 授权柜员
    ,o.new_branch -- 变更后机构
    ,o.old_branch -- 变更前机构
    ,o.tran_branch -- 核心交易机构编号
    ,o.branch_change_type -- 机构撤并交易类型
    ,o.ob_amend_seq_no -- 记录机构变更时，公共产生的序号
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
from ${iol_schema}.ncbs_rb_amend_branch_bk o
    left join ${iol_schema}.ncbs_rb_amend_branch_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_amend_branch_cl d
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
--truncate table ${iol_schema}.ncbs_rb_amend_branch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_amend_branch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_amend_branch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_amend_branch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_amend_branch exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_amend_branch_cl;
alter table ${iol_schema}.ncbs_rb_amend_branch exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_amend_branch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_amend_branch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_amend_branch_op purge;
drop table ${iol_schema}.ncbs_rb_amend_branch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_amend_branch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_amend_branch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
