/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_transfer_canpunk
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
create table ${iol_schema}.ncbs_cl_transfer_canpunk_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_transfer_canpunk
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_transfer_canpunk_op purge;
drop table ${iol_schema}.ncbs_cl_transfer_canpunk_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_canpunk_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_transfer_canpunk where 0=1;

create table ${iol_schema}.ncbs_cl_transfer_canpunk_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_transfer_canpunk where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_transfer_canpunk_cl(
            contract_no -- 合同编号
            ,reference -- 交易参考号
            ,batch_no -- 批次号
            ,company -- 法人
            ,tran_status -- 冲补抹标志
            ,transfer_seq_no -- 资产证券化合同明细主键
            ,unpack_error_desc -- 撤包错误信息描述
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_transfer_canpunk_op(
            contract_no -- 合同编号
            ,reference -- 交易参考号
            ,batch_no -- 批次号
            ,company -- 法人
            ,tran_status -- 冲补抹标志
            ,transfer_seq_no -- 资产证券化合同明细主键
            ,unpack_error_desc -- 撤包错误信息描述
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_status, o.tran_status) as tran_status -- 冲补抹标志
    ,nvl(n.transfer_seq_no, o.transfer_seq_no) as transfer_seq_no -- 资产证券化合同明细主键
    ,nvl(n.unpack_error_desc, o.unpack_error_desc) as unpack_error_desc -- 撤包错误信息描述
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,case when
            n.transfer_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.transfer_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.transfer_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_transfer_canpunk_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_transfer_canpunk where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.transfer_seq_no = n.transfer_seq_no
where (
        o.transfer_seq_no is null
    )
    or (
        n.transfer_seq_no is null
    )
    or (
        o.contract_no <> n.contract_no
        or o.reference <> n.reference
        or o.batch_no <> n.batch_no
        or o.company <> n.company
        or o.tran_status <> n.tran_status
        or o.unpack_error_desc <> n.unpack_error_desc
        or o.tran_timestamp <> n.tran_timestamp
        or o.loan_no <> n.loan_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_transfer_canpunk_cl(
            contract_no -- 合同编号
            ,reference -- 交易参考号
            ,batch_no -- 批次号
            ,company -- 法人
            ,tran_status -- 冲补抹标志
            ,transfer_seq_no -- 资产证券化合同明细主键
            ,unpack_error_desc -- 撤包错误信息描述
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_transfer_canpunk_op(
            contract_no -- 合同编号
            ,reference -- 交易参考号
            ,batch_no -- 批次号
            ,company -- 法人
            ,tran_status -- 冲补抹标志
            ,transfer_seq_no -- 资产证券化合同明细主键
            ,unpack_error_desc -- 撤包错误信息描述
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.contract_no -- 合同编号
    ,o.reference -- 交易参考号
    ,o.batch_no -- 批次号
    ,o.company -- 法人
    ,o.tran_status -- 冲补抹标志
    ,o.transfer_seq_no -- 资产证券化合同明细主键
    ,o.unpack_error_desc -- 撤包错误信息描述
    ,o.tran_timestamp -- 交易时间戳
    ,o.loan_no -- 贷款号
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
from ${iol_schema}.ncbs_cl_transfer_canpunk_bk o
    left join ${iol_schema}.ncbs_cl_transfer_canpunk_op n
        on
            o.transfer_seq_no = n.transfer_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_transfer_canpunk_cl d
        on
            o.transfer_seq_no = d.transfer_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_transfer_canpunk;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_transfer_canpunk') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_transfer_canpunk drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_transfer_canpunk add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_transfer_canpunk exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_transfer_canpunk_cl;
alter table ${iol_schema}.ncbs_cl_transfer_canpunk exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_transfer_canpunk_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_transfer_canpunk to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_transfer_canpunk_op purge;
drop table ${iol_schema}.ncbs_cl_transfer_canpunk_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_transfer_canpunk_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_transfer_canpunk',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
