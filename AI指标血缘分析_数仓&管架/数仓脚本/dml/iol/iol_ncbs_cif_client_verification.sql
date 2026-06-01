/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cif_client_verification
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
create table ${iol_schema}.ncbs_cif_client_verification_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cif_client_verification
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cif_client_verification_op purge;
drop table ${iol_schema}.ncbs_cif_client_verification_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cif_client_verification_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cif_client_verification where 0=1;

create table ${iol_schema}.ncbs_cif_client_verification_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cif_client_verification where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cif_client_verification_cl(
            client_no -- 客户编号
            ,remark -- 备注
            ,batch_no -- 批次号
            ,company -- 法人
            ,is_save -- 留存标志
            ,job_run_id -- 批处理任务id
            ,ret_code -- 状态码
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,treatment -- 处理种类
            ,verification_result -- 核查结果
            ,verification_source_type -- 核查渠道
            ,verify_status -- 核查状态
            ,tran_timestamp -- 交易时间戳
            ,verification_date -- 核实日期
            ,unverification_reason -- 无法核实原因
            ,verification_branch -- 核查机构
            ,verification_user_id -- 核实柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cif_client_verification_op(
            client_no -- 客户编号
            ,remark -- 备注
            ,batch_no -- 批次号
            ,company -- 法人
            ,is_save -- 留存标志
            ,job_run_id -- 批处理任务id
            ,ret_code -- 状态码
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,treatment -- 处理种类
            ,verification_result -- 核查结果
            ,verification_source_type -- 核查渠道
            ,verify_status -- 核查状态
            ,tran_timestamp -- 交易时间戳
            ,verification_date -- 核实日期
            ,unverification_reason -- 无法核实原因
            ,verification_branch -- 核查机构
            ,verification_user_id -- 核实柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.is_save, o.is_save) as is_save -- 留存标志
    ,nvl(n.job_run_id, o.job_run_id) as job_run_id -- 批处理任务id
    ,nvl(n.ret_code, o.ret_code) as ret_code -- 状态码
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 服务状态描述
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.treatment, o.treatment) as treatment -- 处理种类
    ,nvl(n.verification_result, o.verification_result) as verification_result -- 核查结果
    ,nvl(n.verification_source_type, o.verification_source_type) as verification_source_type -- 核查渠道
    ,nvl(n.verify_status, o.verify_status) as verify_status -- 核查状态
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.verification_date, o.verification_date) as verification_date -- 核实日期
    ,nvl(n.unverification_reason, o.unverification_reason) as unverification_reason -- 无法核实原因
    ,nvl(n.verification_branch, o.verification_branch) as verification_branch -- 核查机构
    ,nvl(n.verification_user_id, o.verification_user_id) as verification_user_id -- 核实柜员
    ,case when
            n.client_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.client_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.client_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cif_client_verification_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cif_client_verification where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.client_no = n.client_no
where (
        o.client_no is null
    )
    or (
        n.client_no is null
    )
    or (
        o.remark <> n.remark
        or o.batch_no <> n.batch_no
        or o.company <> n.company
        or o.is_save <> n.is_save
        or o.job_run_id <> n.job_run_id
        or o.ret_code <> n.ret_code
        or o.ret_msg <> n.ret_msg
        or o.seq_no <> n.seq_no
        or o.treatment <> n.treatment
        or o.verification_result <> n.verification_result
        or o.verification_source_type <> n.verification_source_type
        or o.verify_status <> n.verify_status
        or o.tran_timestamp <> n.tran_timestamp
        or o.verification_date <> n.verification_date
        or o.unverification_reason <> n.unverification_reason
        or o.verification_branch <> n.verification_branch
        or o.verification_user_id <> n.verification_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cif_client_verification_cl(
            client_no -- 客户编号
            ,remark -- 备注
            ,batch_no -- 批次号
            ,company -- 法人
            ,is_save -- 留存标志
            ,job_run_id -- 批处理任务id
            ,ret_code -- 状态码
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,treatment -- 处理种类
            ,verification_result -- 核查结果
            ,verification_source_type -- 核查渠道
            ,verify_status -- 核查状态
            ,tran_timestamp -- 交易时间戳
            ,verification_date -- 核实日期
            ,unverification_reason -- 无法核实原因
            ,verification_branch -- 核查机构
            ,verification_user_id -- 核实柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cif_client_verification_op(
            client_no -- 客户编号
            ,remark -- 备注
            ,batch_no -- 批次号
            ,company -- 法人
            ,is_save -- 留存标志
            ,job_run_id -- 批处理任务id
            ,ret_code -- 状态码
            ,ret_msg -- 服务状态描述
            ,seq_no -- 序号
            ,treatment -- 处理种类
            ,verification_result -- 核查结果
            ,verification_source_type -- 核查渠道
            ,verify_status -- 核查状态
            ,tran_timestamp -- 交易时间戳
            ,verification_date -- 核实日期
            ,unverification_reason -- 无法核实原因
            ,verification_branch -- 核查机构
            ,verification_user_id -- 核实柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.remark -- 备注
    ,o.batch_no -- 批次号
    ,o.company -- 法人
    ,o.is_save -- 留存标志
    ,o.job_run_id -- 批处理任务id
    ,o.ret_code -- 状态码
    ,o.ret_msg -- 服务状态描述
    ,o.seq_no -- 序号
    ,o.treatment -- 处理种类
    ,o.verification_result -- 核查结果
    ,o.verification_source_type -- 核查渠道
    ,o.verify_status -- 核查状态
    ,o.tran_timestamp -- 交易时间戳
    ,o.verification_date -- 核实日期
    ,o.unverification_reason -- 无法核实原因
    ,o.verification_branch -- 核查机构
    ,o.verification_user_id -- 核实柜员
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
from ${iol_schema}.ncbs_cif_client_verification_bk o
    left join ${iol_schema}.ncbs_cif_client_verification_op n
        on
            o.client_no = n.client_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cif_client_verification_cl d
        on
            o.client_no = d.client_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cif_client_verification;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cif_client_verification') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cif_client_verification drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cif_client_verification add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cif_client_verification exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cif_client_verification_cl;
alter table ${iol_schema}.ncbs_cif_client_verification exchange partition p_20991231 with table ${iol_schema}.ncbs_cif_client_verification_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cif_client_verification to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cif_client_verification_op purge;
drop table ${iol_schema}.ncbs_cif_client_verification_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cif_client_verification_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cif_client_verification',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
