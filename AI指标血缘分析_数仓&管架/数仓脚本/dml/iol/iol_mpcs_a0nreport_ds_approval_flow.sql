/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0nreport_ds_approval_flow
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
whenever sqlerror continue none ;
create table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0nreport_ds_approval_flow;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_op purge;
drop table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0nreport_ds_approval_flow where 0=1;

create table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0nreport_ds_approval_flow where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mpcs_a0nreport_ds_approval_flow_op(
        partition_date -- 分区日期
        ,biz_no -- 流水号
        ,bank_no -- 银行号
        ,final_ret -- 最终审批结果
        ,ours_approval_ret -- 合作行审批结果
        ,code_block -- 拒绝码
        ,is_first -- 是否首借
        ,outer_ret -- 合作行机房审批结果
        ,psz_ret -- Psz区审批结果
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,cust_score -- 客户评分
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.partition_date -- 分区日期
    ,n.biz_no -- 流水号
    ,n.bank_no -- 银行号
    ,n.final_ret -- 最终审批结果
    ,n.ours_approval_ret -- 合作行审批结果
    ,n.code_block -- 拒绝码
    ,n.is_first -- 是否首借
    ,n.outer_ret -- 合作行机房审批结果
    ,n.psz_ret -- Psz区审批结果
    ,n.batchfilename -- 批量文件名
    ,n.seqno -- 序列号
    ,n.cust_score -- 客户评分
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0nreport_ds_approval_flow_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.mpcs_a0nreport_ds_approval_flow where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batchfilename = n.batchfilename
            and o.seqno = n.seqno
where (
        o.batchfilename is null
        and o.seqno is null
    )
    or (
        o.partition_date <> n.partition_date
        or o.biz_no <> n.biz_no
        or o.bank_no <> n.bank_no
        or o.final_ret <> n.final_ret
        or o.ours_approval_ret <> n.ours_approval_ret
        or o.code_block <> n.code_block
        or o.is_first <> n.is_first
        or o.outer_ret <> n.outer_ret
        or o.psz_ret <> n.psz_ret
        or o.cust_score <> n.cust_score
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0nreport_ds_approval_flow_cl(
            partition_date -- 分区日期
        ,biz_no -- 流水号
        ,bank_no -- 银行号
        ,final_ret -- 最终审批结果
        ,ours_approval_ret -- 合作行审批结果
        ,code_block -- 拒绝码
        ,is_first -- 是否首借
        ,outer_ret -- 合作行机房审批结果
        ,psz_ret -- Psz区审批结果
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,cust_score -- 客户评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0nreport_ds_approval_flow_op(
            partition_date -- 分区日期
        ,biz_no -- 流水号
        ,bank_no -- 银行号
        ,final_ret -- 最终审批结果
        ,ours_approval_ret -- 合作行审批结果
        ,code_block -- 拒绝码
        ,is_first -- 是否首借
        ,outer_ret -- 合作行机房审批结果
        ,psz_ret -- Psz区审批结果
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,cust_score -- 客户评分
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.partition_date -- 分区日期
    ,o.biz_no -- 流水号
    ,o.bank_no -- 银行号
    ,o.final_ret -- 最终审批结果
    ,o.ours_approval_ret -- 合作行审批结果
    ,o.code_block -- 拒绝码
    ,o.is_first -- 是否首借
    ,o.outer_ret -- 合作行机房审批结果
    ,o.psz_ret -- Psz区审批结果
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
    ,o.cust_score -- 客户评分
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0nreport_ds_approval_flow_bk o
    left join ${iol_schema}.mpcs_a0nreport_ds_approval_flow_op n
        on
            o.batchfilename = n.batchfilename
            and o.seqno = n.seqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0nreport_ds_approval_flow;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0nreport_ds_approval_flow exchange partition p_19000101 with table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_cl;
alter table ${iol_schema}.mpcs_a0nreport_ds_approval_flow exchange partition p_20991231 with table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0nreport_ds_approval_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_op purge;
drop table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0nreport_ds_approval_flow_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0nreport_ds_approval_flow',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
