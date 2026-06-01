/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_yht
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
create table ${iol_schema}.ncbs_rb_agreement_yht_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_yht
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_yht_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_yht_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_yht_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_yht where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_yht_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_yht where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_yht_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,acct_real_flag -- 账户虚实标志
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,int_flag -- 是否扣划利息标志
            ,iss_od_flag -- 是否透支
            ,main_agreement_id -- 主协议协议号
            ,next_max_seq_no -- 下级账户最大序号
            ,non_transplant_flag -- 是否未移植数据
            ,self_flag -- 自有资金子账户标识
            ,settle_ind -- 账户结算模式
            ,source_type -- 渠道编号
            ,yht_acct_flag -- 一户通账户标志
            ,yht_acct_level -- 一户通账户层级
            ,yht_acct_main_flag -- 一户通主账户标志
            ,yht_acct_org_schema -- 一户通账户结构模式
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,alt_acct_name -- 备用账户名称
            ,parent_internal_key -- 上级账户标识符
            ,yht_prod_type -- 一户通产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_yht_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,acct_real_flag -- 账户虚实标志
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,int_flag -- 是否扣划利息标志
            ,iss_od_flag -- 是否透支
            ,main_agreement_id -- 主协议协议号
            ,next_max_seq_no -- 下级账户最大序号
            ,non_transplant_flag -- 是否未移植数据
            ,self_flag -- 自有资金子账户标识
            ,settle_ind -- 账户结算模式
            ,source_type -- 渠道编号
            ,yht_acct_flag -- 一户通账户标志
            ,yht_acct_level -- 一户通账户层级
            ,yht_acct_main_flag -- 一户通主账户标志
            ,yht_acct_org_schema -- 一户通账户结构模式
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,alt_acct_name -- 备用账户名称
            ,parent_internal_key -- 上级账户标识符
            ,yht_prod_type -- 一户通产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.acct_real_flag, o.acct_real_flag) as acct_real_flag -- 账户虚实标志
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.int_flag, o.int_flag) as int_flag -- 是否扣划利息标志
    ,nvl(n.iss_od_flag, o.iss_od_flag) as iss_od_flag -- 是否透支
    ,nvl(n.main_agreement_id, o.main_agreement_id) as main_agreement_id -- 主协议协议号
    ,nvl(n.next_max_seq_no, o.next_max_seq_no) as next_max_seq_no -- 下级账户最大序号
    ,nvl(n.non_transplant_flag, o.non_transplant_flag) as non_transplant_flag -- 是否未移植数据
    ,nvl(n.self_flag, o.self_flag) as self_flag -- 自有资金子账户标识
    ,nvl(n.settle_ind, o.settle_ind) as settle_ind -- 账户结算模式
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.yht_acct_flag, o.yht_acct_flag) as yht_acct_flag -- 一户通账户标志
    ,nvl(n.yht_acct_level, o.yht_acct_level) as yht_acct_level -- 一户通账户层级
    ,nvl(n.yht_acct_main_flag, o.yht_acct_main_flag) as yht_acct_main_flag -- 一户通主账户标志
    ,nvl(n.yht_acct_org_schema, o.yht_acct_org_schema) as yht_acct_org_schema -- 一户通账户结构模式
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.alt_acct_name, o.alt_acct_name) as alt_acct_name -- 备用账户名称
    ,nvl(n.parent_internal_key, o.parent_internal_key) as parent_internal_key -- 上级账户标识符
    ,nvl(n.yht_prod_type, o.yht_prod_type) as yht_prod_type -- 一户通产品类型
    ,case when
            n.agreement_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_agreement_yht_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_yht where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
where (
        o.agreement_id is null
    )
    or (
        n.agreement_id is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.prod_type <> n.prod_type
        or o.acct_real_flag <> n.acct_real_flag
        or o.agreement_status <> n.agreement_status
        or o.company <> n.company
        or o.int_flag <> n.int_flag
        or o.iss_od_flag <> n.iss_od_flag
        or o.main_agreement_id <> n.main_agreement_id
        or o.next_max_seq_no <> n.next_max_seq_no
        or o.non_transplant_flag <> n.non_transplant_flag
        or o.self_flag <> n.self_flag
        or o.settle_ind <> n.settle_ind
        or o.source_type <> n.source_type
        or o.yht_acct_flag <> n.yht_acct_flag
        or o.yht_acct_level <> n.yht_acct_level
        or o.yht_acct_main_flag <> n.yht_acct_main_flag
        or o.yht_acct_org_schema <> n.yht_acct_org_schema
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.alt_acct_name <> n.alt_acct_name
        or o.parent_internal_key <> n.parent_internal_key
        or o.yht_prod_type <> n.yht_prod_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_yht_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,acct_real_flag -- 账户虚实标志
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,int_flag -- 是否扣划利息标志
            ,iss_od_flag -- 是否透支
            ,main_agreement_id -- 主协议协议号
            ,next_max_seq_no -- 下级账户最大序号
            ,non_transplant_flag -- 是否未移植数据
            ,self_flag -- 自有资金子账户标识
            ,settle_ind -- 账户结算模式
            ,source_type -- 渠道编号
            ,yht_acct_flag -- 一户通账户标志
            ,yht_acct_level -- 一户通账户层级
            ,yht_acct_main_flag -- 一户通主账户标志
            ,yht_acct_org_schema -- 一户通账户结构模式
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,alt_acct_name -- 备用账户名称
            ,parent_internal_key -- 上级账户标识符
            ,yht_prod_type -- 一户通产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_yht_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,acct_real_flag -- 账户虚实标志
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,company -- 法人
            ,int_flag -- 是否扣划利息标志
            ,iss_od_flag -- 是否透支
            ,main_agreement_id -- 主协议协议号
            ,next_max_seq_no -- 下级账户最大序号
            ,non_transplant_flag -- 是否未移植数据
            ,self_flag -- 自有资金子账户标识
            ,settle_ind -- 账户结算模式
            ,source_type -- 渠道编号
            ,yht_acct_flag -- 一户通账户标志
            ,yht_acct_level -- 一户通账户层级
            ,yht_acct_main_flag -- 一户通主账户标志
            ,yht_acct_org_schema -- 一户通账户结构模式
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,alt_acct_name -- 备用账户名称
            ,parent_internal_key -- 上级账户标识符
            ,yht_prod_type -- 一户通产品类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.acct_real_flag -- 账户虚实标志
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.company -- 法人
    ,o.int_flag -- 是否扣划利息标志
    ,o.iss_od_flag -- 是否透支
    ,o.main_agreement_id -- 主协议协议号
    ,o.next_max_seq_no -- 下级账户最大序号
    ,o.non_transplant_flag -- 是否未移植数据
    ,o.self_flag -- 自有资金子账户标识
    ,o.settle_ind -- 账户结算模式
    ,o.source_type -- 渠道编号
    ,o.yht_acct_flag -- 一户通账户标志
    ,o.yht_acct_level -- 一户通账户层级
    ,o.yht_acct_main_flag -- 一户通主账户标志
    ,o.yht_acct_org_schema -- 一户通账户结构模式
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.alt_acct_name -- 备用账户名称
    ,o.parent_internal_key -- 上级账户标识符
    ,o.yht_prod_type -- 一户通产品类型
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
from ${iol_schema}.ncbs_rb_agreement_yht_bk o
    left join ${iol_schema}.ncbs_rb_agreement_yht_op n
        on
            o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_yht_cl d
        on
            o.agreement_id = d.agreement_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_yht;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_yht') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_yht drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_yht add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_yht exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_yht_cl;
alter table ${iol_schema}.ncbs_rb_agreement_yht exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_yht_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_yht to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_yht_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_yht_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_yht_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_yht',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
