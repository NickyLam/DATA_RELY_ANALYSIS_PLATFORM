/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0nds_loan_writeoff_list_suc
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
create table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_op purge;
drop table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc where 0=1;

create table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_op(
        writeoff_date -- 核销日期
        ,name -- 姓名
        ,cust_id -- 客户号
        ,bank_no -- 银行号
        ,bank_group_id -- 银团号
        ,product_cd -- 产品号
        ,logical_card_no -- 卡号
        ,ref_nbr -- 参考号
        ,writeoff_proc_status -- 核销状态
        ,loan_init_prin -- 本金
        ,loan_intr_penalty -- 利息罚息
        ,bank_proportion -- 银团比例
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.writeoff_date -- 核销日期
    ,n.name -- 姓名
    ,n.cust_id -- 客户号
    ,n.bank_no -- 银行号
    ,n.bank_group_id -- 银团号
    ,n.product_cd -- 产品号
    ,n.logical_card_no -- 卡号
    ,n.ref_nbr -- 参考号
    ,n.writeoff_proc_status -- 核销状态
    ,n.loan_init_prin -- 本金
    ,n.loan_intr_penalty -- 利息罚息
    ,n.bank_proportion -- 银团比例
    ,n.batchfilename -- 批量文件名
    ,n.seqno -- 序列号
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.mpcs_a0nds_loan_writeoff_list_suc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batchfilename = n.batchfilename
            and o.seqno = n.seqno
where (
        o.batchfilename is null
        and o.seqno is null
    )
    or (
        o.writeoff_date <> n.writeoff_date
        or o.name <> n.name
        or o.cust_id <> n.cust_id
        or o.bank_no <> n.bank_no
        or o.bank_group_id <> n.bank_group_id
        or o.product_cd <> n.product_cd
        or o.logical_card_no <> n.logical_card_no
        or o.ref_nbr <> n.ref_nbr
        or o.writeoff_proc_status <> n.writeoff_proc_status
        or o.loan_init_prin <> n.loan_init_prin
        or o.loan_intr_penalty <> n.loan_intr_penalty
        or o.bank_proportion <> n.bank_proportion
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_cl(
            writeoff_date -- 核销日期
        ,name -- 姓名
        ,cust_id -- 客户号
        ,bank_no -- 银行号
        ,bank_group_id -- 银团号
        ,product_cd -- 产品号
        ,logical_card_no -- 卡号
        ,ref_nbr -- 参考号
        ,writeoff_proc_status -- 核销状态
        ,loan_init_prin -- 本金
        ,loan_intr_penalty -- 利息罚息
        ,bank_proportion -- 银团比例
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_op(
            writeoff_date -- 核销日期
        ,name -- 姓名
        ,cust_id -- 客户号
        ,bank_no -- 银行号
        ,bank_group_id -- 银团号
        ,product_cd -- 产品号
        ,logical_card_no -- 卡号
        ,ref_nbr -- 参考号
        ,writeoff_proc_status -- 核销状态
        ,loan_init_prin -- 本金
        ,loan_intr_penalty -- 利息罚息
        ,bank_proportion -- 银团比例
        ,batchfilename -- 批量文件名
        ,seqno -- 序列号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.writeoff_date -- 核销日期
    ,o.name -- 姓名
    ,o.cust_id -- 客户号
    ,o.bank_no -- 银行号
    ,o.bank_group_id -- 银团号
    ,o.product_cd -- 产品号
    ,o.logical_card_no -- 卡号
    ,o.ref_nbr -- 参考号
    ,o.writeoff_proc_status -- 核销状态
    ,o.loan_init_prin -- 本金
    ,o.loan_intr_penalty -- 利息罚息
    ,o.bank_proportion -- 银团比例
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
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
from ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_bk o
    left join ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_op n
        on
            o.batchfilename = n.batchfilename
            and o.seqno = n.seqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc exchange partition p_19000101 with table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_cl;
alter table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc exchange partition p_20991231 with table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_op purge;
drop table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0nds_loan_writeoff_list_suc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0nds_loan_writeoff_list_suc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
