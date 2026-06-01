/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_client_relation
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
create table ${iol_schema}.ncbs_rb_acct_client_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_client_relation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_client_relation_op purge;
drop table ${iol_schema}.ncbs_rb_acct_client_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_client_relation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_client_relation where 0=1;

create table ${iol_schema}.ncbs_rb_acct_client_relation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_client_relation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_client_relation_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,acct_class -- 账户等级
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,app_flag -- 附属卡标志
            ,company -- 法人
            ,default_settle_acct -- 是否默认结算账户
            ,individual_flag -- 对公对私标志
            ,is_card -- 是否卡
            ,is_corp_settle_card -- 单位结算卡标志
            ,lead_acct_flag -- 主账户标志
            ,reason_code_desc -- 原因代码描述
            ,shard_id -- 分库标志
            ,source_type -- 渠道编号
            ,tran_timestamp -- 交易时间戳
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,actual_acct_no -- 实际账号
            ,parent_internal_key -- 上级账户标识符
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_client_relation_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,acct_class -- 账户等级
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,app_flag -- 附属卡标志
            ,company -- 法人
            ,default_settle_acct -- 是否默认结算账户
            ,individual_flag -- 对公对私标志
            ,is_card -- 是否卡
            ,is_corp_settle_card -- 单位结算卡标志
            ,lead_acct_flag -- 主账户标志
            ,reason_code_desc -- 原因代码描述
            ,shard_id -- 分库标志
            ,source_type -- 渠道编号
            ,tran_timestamp -- 交易时间戳
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,actual_acct_no -- 实际账号
            ,parent_internal_key -- 上级账户标识符
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reason_code, o.reason_code) as reason_code -- 账户用途
    ,nvl(n.acct_class, o.acct_class) as acct_class -- 账户等级
    ,nvl(n.acct_nature, o.acct_nature) as acct_nature -- 存款账户类型
    ,nvl(n.acct_real_flag, o.acct_real_flag) as acct_real_flag -- 账户虚实标志
    ,nvl(n.app_flag, o.app_flag) as app_flag -- 附属卡标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.default_settle_acct, o.default_settle_acct) as default_settle_acct -- 是否默认结算账户
    ,nvl(n.individual_flag, o.individual_flag) as individual_flag -- 对公对私标志
    ,nvl(n.is_card, o.is_card) as is_card -- 是否卡
    ,nvl(n.is_corp_settle_card, o.is_corp_settle_card) as is_corp_settle_card -- 单位结算卡标志
    ,nvl(n.lead_acct_flag, o.lead_acct_flag) as lead_acct_flag -- 主账户标志
    ,nvl(n.reason_code_desc, o.reason_code_desc) as reason_code_desc -- 原因代码描述
    ,nvl(n.shard_id, o.shard_id) as shard_id -- 分库标志
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_branch, o.acct_branch) as acct_branch -- 开户机构编号
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.actual_acct_no, o.actual_acct_no) as actual_acct_no -- 实际账号
    ,nvl(n.parent_internal_key, o.parent_internal_key) as parent_internal_key -- 上级账户标识符
    ,case when
            n.acct_seq_no is null
            and n.base_acct_no is null
            and n.client_no is null
            and n.internal_key is null
            and n.prod_type is null
            and n.acct_ccy is null
            and n.actual_acct_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acct_seq_no is null
            and n.base_acct_no is null
            and n.client_no is null
            and n.internal_key is null
            and n.prod_type is null
            and n.acct_ccy is null
            and n.actual_acct_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acct_seq_no is null
            and n.base_acct_no is null
            and n.client_no is null
            and n.internal_key is null
            and n.prod_type is null
            and n.acct_ccy is null
            and n.actual_acct_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_client_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_client_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acct_seq_no = n.acct_seq_no
            and o.base_acct_no = n.base_acct_no
            and o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.prod_type = n.prod_type
            and o.acct_ccy = n.acct_ccy
            and o.actual_acct_no = n.actual_acct_no
where (
        o.acct_seq_no is null
        and o.base_acct_no is null
        and o.client_no is null
        and o.internal_key is null
        and o.prod_type is null
        and o.acct_ccy is null
        and o.actual_acct_no is null
    )
    or (
        n.acct_seq_no is null
        and n.base_acct_no is null
        and n.client_no is null
        and n.internal_key is null
        and n.prod_type is null
        and n.acct_ccy is null
        and n.actual_acct_no is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_status <> n.acct_status
        or o.card_no <> n.card_no
        or o.client_type <> n.client_type
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.reason_code <> n.reason_code
        or o.acct_class <> n.acct_class
        or o.acct_nature <> n.acct_nature
        or o.acct_real_flag <> n.acct_real_flag
        or o.app_flag <> n.app_flag
        or o.company <> n.company
        or o.default_settle_acct <> n.default_settle_acct
        or o.individual_flag <> n.individual_flag
        or o.is_card <> n.is_card
        or o.is_corp_settle_card <> n.is_corp_settle_card
        or o.lead_acct_flag <> n.lead_acct_flag
        or o.reason_code_desc <> n.reason_code_desc
        or o.shard_id <> n.shard_id
        or o.source_type <> n.source_type
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_branch <> n.acct_branch
        or o.parent_internal_key <> n.parent_internal_key
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_client_relation_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,acct_class -- 账户等级
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,app_flag -- 附属卡标志
            ,company -- 法人
            ,default_settle_acct -- 是否默认结算账户
            ,individual_flag -- 对公对私标志
            ,is_card -- 是否卡
            ,is_corp_settle_card -- 单位结算卡标志
            ,lead_acct_flag -- 主账户标志
            ,reason_code_desc -- 原因代码描述
            ,shard_id -- 分库标志
            ,source_type -- 渠道编号
            ,tran_timestamp -- 交易时间戳
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,actual_acct_no -- 实际账号
            ,parent_internal_key -- 上级账户标识符
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_client_relation_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reason_code -- 账户用途
            ,acct_class -- 账户等级
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,app_flag -- 附属卡标志
            ,company -- 法人
            ,default_settle_acct -- 是否默认结算账户
            ,individual_flag -- 对公对私标志
            ,is_card -- 是否卡
            ,is_corp_settle_card -- 单位结算卡标志
            ,lead_acct_flag -- 主账户标志
            ,reason_code_desc -- 原因代码描述
            ,shard_id -- 分库标志
            ,source_type -- 渠道编号
            ,tran_timestamp -- 交易时间戳
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,actual_acct_no -- 实际账号
            ,parent_internal_key -- 上级账户标识符
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.acct_status -- 账户状态
    ,o.base_acct_no -- 交易账号/卡号
    ,o.card_no -- 卡号
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.reason_code -- 账户用途
    ,o.acct_class -- 账户等级
    ,o.acct_nature -- 存款账户类型
    ,o.acct_real_flag -- 账户虚实标志
    ,o.app_flag -- 附属卡标志
    ,o.company -- 法人
    ,o.default_settle_acct -- 是否默认结算账户
    ,o.individual_flag -- 对公对私标志
    ,o.is_card -- 是否卡
    ,o.is_corp_settle_card -- 单位结算卡标志
    ,o.lead_acct_flag -- 主账户标志
    ,o.reason_code_desc -- 原因代码描述
    ,o.shard_id -- 分库标志
    ,o.source_type -- 渠道编号
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_branch -- 开户机构编号
    ,o.acct_ccy -- 账户币种
    ,o.actual_acct_no -- 实际账号
    ,o.parent_internal_key -- 上级账户标识符
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
from ${iol_schema}.ncbs_rb_acct_client_relation_bk o
    left join ${iol_schema}.ncbs_rb_acct_client_relation_op n
        on
            o.acct_seq_no = n.acct_seq_no
            and o.base_acct_no = n.base_acct_no
            and o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.prod_type = n.prod_type
            and o.acct_ccy = n.acct_ccy
            and o.actual_acct_no = n.actual_acct_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_client_relation_cl d
        on
            o.acct_seq_no = d.acct_seq_no
            and o.base_acct_no = d.base_acct_no
            and o.client_no = d.client_no
            and o.internal_key = d.internal_key
            and o.prod_type = d.prod_type
            and o.acct_ccy = d.acct_ccy
            and o.actual_acct_no = d.actual_acct_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_client_relation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_client_relation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_client_relation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_client_relation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_client_relation exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_client_relation_cl;
alter table ${iol_schema}.ncbs_rb_acct_client_relation exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_client_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_client_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_client_relation_op purge;
drop table ${iol_schema}.ncbs_rb_acct_client_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_client_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_client_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
