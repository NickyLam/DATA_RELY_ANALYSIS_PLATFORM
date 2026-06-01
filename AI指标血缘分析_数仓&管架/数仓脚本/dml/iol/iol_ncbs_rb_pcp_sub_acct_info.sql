/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_pcp_sub_acct_info
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
create table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_pcp_sub_acct_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_op purge;
drop table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pcp_sub_acct_info where 0=1;

create table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_pcp_sub_acct_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pcp_sub_acct_info_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,inc_exp_ind -- 收支标志
            ,min_sub_status -- 主子状态
            ,pcp_group_id -- 资金池账户组id
            ,priority -- 优先级
            ,sub_seq_no -- 系统流水号
            ,create_date -- 创建日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,tran_branch -- 核心交易机构编号
            ,upper_base_acct_no -- 上级账户（组主账户）
            ,upper_internal_key -- 组主账户内部键
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pcp_sub_acct_info_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,inc_exp_ind -- 收支标志
            ,min_sub_status -- 主子状态
            ,pcp_group_id -- 资金池账户组id
            ,priority -- 优先级
            ,sub_seq_no -- 系统流水号
            ,create_date -- 创建日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,tran_branch -- 核心交易机构编号
            ,upper_base_acct_no -- 上级账户（组主账户）
            ,upper_internal_key -- 组主账户内部键
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
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.inc_exp_ind, o.inc_exp_ind) as inc_exp_ind -- 收支标志
    ,nvl(n.min_sub_status, o.min_sub_status) as min_sub_status -- 主子状态
    ,nvl(n.pcp_group_id, o.pcp_group_id) as pcp_group_id -- 资金池账户组id
    ,nvl(n.priority, o.priority) as priority -- 优先级
    ,nvl(n.sub_seq_no, o.sub_seq_no) as sub_seq_no -- 系统流水号
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.upper_base_acct_no, o.upper_base_acct_no) as upper_base_acct_no -- 上级账户（组主账户）
    ,nvl(n.upper_internal_key, o.upper_internal_key) as upper_internal_key -- 组主账户内部键
    ,case when
            n.internal_key is null
            and n.pcp_group_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.pcp_group_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.pcp_group_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_pcp_sub_acct_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_pcp_sub_acct_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.pcp_group_id = n.pcp_group_id
where (
        o.internal_key is null
        and o.pcp_group_id is null
    )
    or (
        n.internal_key is null
        and n.pcp_group_id is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.inc_exp_ind <> n.inc_exp_ind
        or o.min_sub_status <> n.min_sub_status
        or o.priority <> n.priority
        or o.sub_seq_no <> n.sub_seq_no
        or o.create_date <> n.create_date
        or o.effect_date <> n.effect_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.auth_user_id <> n.auth_user_id
        or o.tran_branch <> n.tran_branch
        or o.upper_base_acct_no <> n.upper_base_acct_no
        or o.upper_internal_key <> n.upper_internal_key
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_pcp_sub_acct_info_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,inc_exp_ind -- 收支标志
            ,min_sub_status -- 主子状态
            ,pcp_group_id -- 资金池账户组id
            ,priority -- 优先级
            ,sub_seq_no -- 系统流水号
            ,create_date -- 创建日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,tran_branch -- 核心交易机构编号
            ,upper_base_acct_no -- 上级账户（组主账户）
            ,upper_internal_key -- 组主账户内部键
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_pcp_sub_acct_info_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,inc_exp_ind -- 收支标志
            ,min_sub_status -- 主子状态
            ,pcp_group_id -- 资金池账户组id
            ,priority -- 优先级
            ,sub_seq_no -- 系统流水号
            ,create_date -- 创建日期
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,auth_user_id -- 授权柜员
            ,tran_branch -- 核心交易机构编号
            ,upper_base_acct_no -- 上级账户（组主账户）
            ,upper_internal_key -- 组主账户内部键
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
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.inc_exp_ind -- 收支标志
    ,o.min_sub_status -- 主子状态
    ,o.pcp_group_id -- 资金池账户组id
    ,o.priority -- 优先级
    ,o.sub_seq_no -- 系统流水号
    ,o.create_date -- 创建日期
    ,o.effect_date -- 产品生效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.auth_user_id -- 授权柜员
    ,o.tran_branch -- 核心交易机构编号
    ,o.upper_base_acct_no -- 上级账户（组主账户）
    ,o.upper_internal_key -- 组主账户内部键
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
from ${iol_schema}.ncbs_rb_pcp_sub_acct_info_bk o
    left join ${iol_schema}.ncbs_rb_pcp_sub_acct_info_op n
        on
            o.internal_key = n.internal_key
            and o.pcp_group_id = n.pcp_group_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_pcp_sub_acct_info_cl d
        on
            o.internal_key = d.internal_key
            and o.pcp_group_id = d.pcp_group_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_pcp_sub_acct_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_pcp_sub_acct_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_pcp_sub_acct_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_pcp_sub_acct_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_pcp_sub_acct_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_cl;
alter table ${iol_schema}.ncbs_rb_pcp_sub_acct_info exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_pcp_sub_acct_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_op purge;
drop table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_pcp_sub_acct_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_pcp_sub_acct_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
