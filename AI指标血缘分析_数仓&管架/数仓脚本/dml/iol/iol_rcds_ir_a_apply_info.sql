/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_a_apply_info
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
create table ${iol_schema}.rcds_ir_a_apply_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_a_apply_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_a_apply_info_op purge;
drop table ${iol_schema}.rcds_ir_a_apply_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_a_apply_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_a_apply_info where 0=1;

create table ${iol_schema}.rcds_ir_a_apply_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_a_apply_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_a_apply_info_cl(
            grade_key_id -- 申请评分流水号
            ,application_num -- 申请编号
            ,data_time -- 数据记录时间
            ,apply_date -- 申请日期
            ,loan_amt_raw -- 申请金额
            ,loan_cur -- 申请币种
            ,loan_cur_std -- 申请币种(规则标准)
            ,repay_mode -- 还款方式
            ,repay_mode_std -- 还款方式(规则标准)
            ,loan_purpose -- 贷款用途
            ,loan_purpose_desc -- 贷款用途描述
            ,original_loan_term_raw -- 贷款期限
            ,prod_type_raw -- 贷款种类
            ,prod_type_raw_std -- 贷款种类(规则标准)
            ,cus_manager -- 客户经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_a_apply_info_op(
            grade_key_id -- 申请评分流水号
            ,application_num -- 申请编号
            ,data_time -- 数据记录时间
            ,apply_date -- 申请日期
            ,loan_amt_raw -- 申请金额
            ,loan_cur -- 申请币种
            ,loan_cur_std -- 申请币种(规则标准)
            ,repay_mode -- 还款方式
            ,repay_mode_std -- 还款方式(规则标准)
            ,loan_purpose -- 贷款用途
            ,loan_purpose_desc -- 贷款用途描述
            ,original_loan_term_raw -- 贷款期限
            ,prod_type_raw -- 贷款种类
            ,prod_type_raw_std -- 贷款种类(规则标准)
            ,cus_manager -- 客户经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.application_num, o.application_num) as application_num -- 申请编号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 申请日期
    ,nvl(n.loan_amt_raw, o.loan_amt_raw) as loan_amt_raw -- 申请金额
    ,nvl(n.loan_cur, o.loan_cur) as loan_cur -- 申请币种
    ,nvl(n.loan_cur_std, o.loan_cur_std) as loan_cur_std -- 申请币种(规则标准)
    ,nvl(n.repay_mode, o.repay_mode) as repay_mode -- 还款方式
    ,nvl(n.repay_mode_std, o.repay_mode_std) as repay_mode_std -- 还款方式(规则标准)
    ,nvl(n.loan_purpose, o.loan_purpose) as loan_purpose -- 贷款用途
    ,nvl(n.loan_purpose_desc, o.loan_purpose_desc) as loan_purpose_desc -- 贷款用途描述
    ,nvl(n.original_loan_term_raw, o.original_loan_term_raw) as original_loan_term_raw -- 贷款期限
    ,nvl(n.prod_type_raw, o.prod_type_raw) as prod_type_raw -- 贷款种类
    ,nvl(n.prod_type_raw_std, o.prod_type_raw_std) as prod_type_raw_std -- 贷款种类(规则标准)
    ,nvl(n.cus_manager, o.cus_manager) as cus_manager -- 客户经理
    ,case when
            n.grade_key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.grade_key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.grade_key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_ir_a_apply_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_a_apply_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.grade_key_id = n.grade_key_id
where (
        o.grade_key_id is null
    )
    or (
        n.grade_key_id is null
    )
    or (
        o.application_num <> n.application_num
        or o.data_time <> n.data_time
        or o.apply_date <> n.apply_date
        or o.loan_amt_raw <> n.loan_amt_raw
        or o.loan_cur <> n.loan_cur
        or o.loan_cur_std <> n.loan_cur_std
        or o.repay_mode <> n.repay_mode
        or o.repay_mode_std <> n.repay_mode_std
        or o.loan_purpose <> n.loan_purpose
        or o.loan_purpose_desc <> n.loan_purpose_desc
        or o.original_loan_term_raw <> n.original_loan_term_raw
        or o.prod_type_raw <> n.prod_type_raw
        or o.prod_type_raw_std <> n.prod_type_raw_std
        or o.cus_manager <> n.cus_manager
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_a_apply_info_cl(
            grade_key_id -- 申请评分流水号
            ,application_num -- 申请编号
            ,data_time -- 数据记录时间
            ,apply_date -- 申请日期
            ,loan_amt_raw -- 申请金额
            ,loan_cur -- 申请币种
            ,loan_cur_std -- 申请币种(规则标准)
            ,repay_mode -- 还款方式
            ,repay_mode_std -- 还款方式(规则标准)
            ,loan_purpose -- 贷款用途
            ,loan_purpose_desc -- 贷款用途描述
            ,original_loan_term_raw -- 贷款期限
            ,prod_type_raw -- 贷款种类
            ,prod_type_raw_std -- 贷款种类(规则标准)
            ,cus_manager -- 客户经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_a_apply_info_op(
            grade_key_id -- 申请评分流水号
            ,application_num -- 申请编号
            ,data_time -- 数据记录时间
            ,apply_date -- 申请日期
            ,loan_amt_raw -- 申请金额
            ,loan_cur -- 申请币种
            ,loan_cur_std -- 申请币种(规则标准)
            ,repay_mode -- 还款方式
            ,repay_mode_std -- 还款方式(规则标准)
            ,loan_purpose -- 贷款用途
            ,loan_purpose_desc -- 贷款用途描述
            ,original_loan_term_raw -- 贷款期限
            ,prod_type_raw -- 贷款种类
            ,prod_type_raw_std -- 贷款种类(规则标准)
            ,cus_manager -- 客户经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.application_num -- 申请编号
    ,o.data_time -- 数据记录时间
    ,o.apply_date -- 申请日期
    ,o.loan_amt_raw -- 申请金额
    ,o.loan_cur -- 申请币种
    ,o.loan_cur_std -- 申请币种(规则标准)
    ,o.repay_mode -- 还款方式
    ,o.repay_mode_std -- 还款方式(规则标准)
    ,o.loan_purpose -- 贷款用途
    ,o.loan_purpose_desc -- 贷款用途描述
    ,o.original_loan_term_raw -- 贷款期限
    ,o.prod_type_raw -- 贷款种类
    ,o.prod_type_raw_std -- 贷款种类(规则标准)
    ,o.cus_manager -- 客户经理
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_a_apply_info_bk o
    left join ${iol_schema}.rcds_ir_a_apply_info_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_a_apply_info_cl d
        on
            o.grade_key_id = d.grade_key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_ir_a_apply_info;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_a_apply_info exchange partition p_19000101 with table ${iol_schema}.rcds_ir_a_apply_info_cl;
alter table ${iol_schema}.rcds_ir_a_apply_info exchange partition p_20991231 with table ${iol_schema}.rcds_ir_a_apply_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_a_apply_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_a_apply_info_op purge;
drop table ${iol_schema}.rcds_ir_a_apply_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_a_apply_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_a_apply_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
