/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_black_name
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
create table ${iol_schema}.ncbs_rb_black_name_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_black_name
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_black_name_op purge;
drop table ${iol_schema}.ncbs_rb_black_name_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_black_name_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_black_name where 0=1;

create table ${iol_schema}.ncbs_rb_black_name_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_black_name where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_black_name_cl(
            acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,black_no -- 黑名单编号
            ,black_seq -- 黑名单序号
            ,company -- 法人
            ,list_source -- 名单来源
            ,our_bank_flag -- 黑名单客户标志
            ,uncounter_desc -- 入表原因
            ,create_date -- 创建日期
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_black_name_op(
            acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,black_no -- 黑名单编号
            ,black_seq -- 黑名单序号
            ,company -- 法人
            ,list_source -- 名单来源
            ,our_bank_flag -- 黑名单客户标志
            ,uncounter_desc -- 入表原因
            ,create_date -- 创建日期
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.black_no, o.black_no) as black_no -- 黑名单编号
    ,nvl(n.black_seq, o.black_seq) as black_seq -- 黑名单序号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.list_source, o.list_source) as list_source -- 名单来源
    ,nvl(n.our_bank_flag, o.our_bank_flag) as our_bank_flag -- 黑名单客户标志
    ,nvl(n.uncounter_desc, o.uncounter_desc) as uncounter_desc -- 入表原因
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.remark1, o.remark1) as remark1 -- 备注1
    ,nvl(n.remark2, o.remark2) as remark2 -- 备注2
    ,nvl(n.remark3, o.remark3) as remark3 -- 备注3
    ,case when
            n.black_seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.black_seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.black_seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_black_name_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_black_name where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.black_seq = n.black_seq
where (
        o.black_seq is null
    )
    or (
        n.black_seq is null
    )
    or (
        o.acct_status <> n.acct_status
        or o.base_acct_no <> n.base_acct_no
        or o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.black_no <> n.black_no
        or o.company <> n.company
        or o.list_source <> n.list_source
        or o.our_bank_flag <> n.our_bank_flag
        or o.uncounter_desc <> n.uncounter_desc
        or o.create_date <> n.create_date
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_black_name_cl(
            acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,black_no -- 黑名单编号
            ,black_seq -- 黑名单序号
            ,company -- 法人
            ,list_source -- 名单来源
            ,our_bank_flag -- 黑名单客户标志
            ,uncounter_desc -- 入表原因
            ,create_date -- 创建日期
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_black_name_op(
            acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,black_no -- 黑名单编号
            ,black_seq -- 黑名单序号
            ,company -- 法人
            ,list_source -- 名单来源
            ,our_bank_flag -- 黑名单客户标志
            ,uncounter_desc -- 入表原因
            ,create_date -- 创建日期
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_status -- 账户状态
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.black_no -- 黑名单编号
    ,o.black_seq -- 黑名单序号
    ,o.company -- 法人
    ,o.list_source -- 名单来源
    ,o.our_bank_flag -- 黑名单客户标志
    ,o.uncounter_desc -- 入表原因
    ,o.create_date -- 创建日期
    ,o.effect_date -- 产品生效日期
    ,o.expire_date -- 失效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.remark1 -- 备注1
    ,o.remark2 -- 备注2
    ,o.remark3 -- 备注3
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
from ${iol_schema}.ncbs_rb_black_name_bk o
    left join ${iol_schema}.ncbs_rb_black_name_op n
        on
            o.black_seq = n.black_seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_black_name_cl d
        on
            o.black_seq = d.black_seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_black_name;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_black_name') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_black_name drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_black_name add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_black_name exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_black_name_cl;
alter table ${iol_schema}.ncbs_rb_black_name exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_black_name_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_black_name to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_black_name_op purge;
drop table ${iol_schema}.ncbs_rb_black_name_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_black_name_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_black_name',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
