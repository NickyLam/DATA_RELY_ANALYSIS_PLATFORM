/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_acct_exec
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
create table ${iol_schema}.ncbs_fm_acct_exec_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_acct_exec
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_acct_exec_op purge;
drop table ${iol_schema}.ncbs_fm_acct_exec_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_acct_exec_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_acct_exec where 0=1;

create table ${iol_schema}.ncbs_fm_acct_exec_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_acct_exec where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_acct_exec_cl(
            branch -- 机构编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,profit_center -- 利润中心
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,acct_exec_status -- 客户经理状态
            ,acct_exec_type -- 客户经理类型
            ,collat_mgr_ind -- 是否担保经理
            ,company -- 法人
            ,manager -- 主管经理
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,contact_id -- 联系类型id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_acct_exec_op(
            branch -- 机构编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,profit_center -- 利润中心
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,acct_exec_status -- 客户经理状态
            ,acct_exec_type -- 客户经理类型
            ,collat_mgr_ind -- 是否担保经理
            ,company -- 法人
            ,manager -- 主管经理
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,contact_id -- 联系类型id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.acct_exec_name, o.acct_exec_name) as acct_exec_name -- 客户经理姓名
    ,nvl(n.acct_exec_status, o.acct_exec_status) as acct_exec_status -- 客户经理状态
    ,nvl(n.acct_exec_type, o.acct_exec_type) as acct_exec_type -- 客户经理类型
    ,nvl(n.collat_mgr_ind, o.collat_mgr_ind) as collat_mgr_ind -- 是否担保经理
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.manager, o.manager) as manager -- 主管经理
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.iss_country, o.iss_country) as iss_country -- 发证国家
    ,nvl(n.contact_id, o.contact_id) as contact_id -- 联系类型id
    ,case when
            n.acct_exec is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acct_exec is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acct_exec is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_acct_exec_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_acct_exec where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acct_exec = n.acct_exec
where (
        o.acct_exec is null
    )
    or (
        n.acct_exec is null
    )
    or (
        o.branch <> n.branch
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.profit_center <> n.profit_center
        or o.acct_exec_name <> n.acct_exec_name
        or o.acct_exec_status <> n.acct_exec_status
        or o.acct_exec_type <> n.acct_exec_type
        or o.collat_mgr_ind <> n.collat_mgr_ind
        or o.company <> n.company
        or o.manager <> n.manager
        or o.tran_timestamp <> n.tran_timestamp
        or o.iss_country <> n.iss_country
        or o.contact_id <> n.contact_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_acct_exec_cl(
            branch -- 机构编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,profit_center -- 利润中心
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,acct_exec_status -- 客户经理状态
            ,acct_exec_type -- 客户经理类型
            ,collat_mgr_ind -- 是否担保经理
            ,company -- 法人
            ,manager -- 主管经理
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,contact_id -- 联系类型id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_acct_exec_op(
            branch -- 机构编号
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,profit_center -- 利润中心
            ,acct_exec -- 银行客户经理编号
            ,acct_exec_name -- 客户经理姓名
            ,acct_exec_status -- 客户经理状态
            ,acct_exec_type -- 客户经理类型
            ,collat_mgr_ind -- 是否担保经理
            ,company -- 法人
            ,manager -- 主管经理
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,contact_id -- 联系类型id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.profit_center -- 利润中心
    ,o.acct_exec -- 银行客户经理编号
    ,o.acct_exec_name -- 客户经理姓名
    ,o.acct_exec_status -- 客户经理状态
    ,o.acct_exec_type -- 客户经理类型
    ,o.collat_mgr_ind -- 是否担保经理
    ,o.company -- 法人
    ,o.manager -- 主管经理
    ,o.tran_timestamp -- 交易时间戳
    ,o.iss_country -- 发证国家
    ,o.contact_id -- 联系类型id
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
from ${iol_schema}.ncbs_fm_acct_exec_bk o
    left join ${iol_schema}.ncbs_fm_acct_exec_op n
        on
            o.acct_exec = n.acct_exec
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_acct_exec_cl d
        on
            o.acct_exec = d.acct_exec
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_acct_exec;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_acct_exec') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_acct_exec drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_acct_exec add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_acct_exec exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_acct_exec_cl;
alter table ${iol_schema}.ncbs_fm_acct_exec exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_acct_exec_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_acct_exec to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_acct_exec_op purge;
drop table ${iol_schema}.ncbs_fm_acct_exec_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_acct_exec_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_acct_exec',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
