/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_rcd_ir_grade_collection_sum
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
create table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_rcd_ir_grade_collection_sum;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_op purge;
drop table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_rcd_ir_grade_collection_sum where 0=1;

create table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_rcd_ir_grade_collection_sum where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_rcd_ir_grade_collection_sum_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,loan_total_bal -- 贷款余额
            ,rist_level -- 风险等级
            ,grade -- 评分结果
            ,warning_level -- 预警优化级
            ,collection_level -- 催收优先级
            ,past_overdue -- 过去发生逾期情况
            ,overdue -- 逾期期数
            ,remark -- 备注
            ,mode_type -- 
            ,serno -- 业务流水号
            ,blng_org_id -- 所属机构
            ,iden_num -- 客户证件号码
            ,cus_name -- 客户名称
            ,grade_key_id -- 申请评分流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_rcd_ir_grade_collection_sum_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,loan_total_bal -- 贷款余额
            ,rist_level -- 风险等级
            ,grade -- 评分结果
            ,warning_level -- 预警优化级
            ,collection_level -- 催收优先级
            ,past_overdue -- 过去发生逾期情况
            ,overdue -- 逾期期数
            ,remark -- 备注
            ,mode_type -- 
            ,serno -- 业务流水号
            ,blng_org_id -- 所属机构
            ,iden_num -- 客户证件号码
            ,cus_name -- 客户名称
            ,grade_key_id -- 申请评分流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_id, o.key_id) as key_id -- 主键
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 借据号
    ,nvl(n.data_dt, o.data_dt) as data_dt -- 数据日期
    ,nvl(n.loan_biz_type_cd, o.loan_biz_type_cd) as loan_biz_type_cd -- 业务品种代码
    ,nvl(n.loan_total_bal, o.loan_total_bal) as loan_total_bal -- 贷款余额
    ,nvl(n.rist_level, o.rist_level) as rist_level -- 风险等级
    ,nvl(n.grade, o.grade) as grade -- 评分结果
    ,nvl(n.warning_level, o.warning_level) as warning_level -- 预警优化级
    ,nvl(n.collection_level, o.collection_level) as collection_level -- 催收优先级
    ,nvl(n.past_overdue, o.past_overdue) as past_overdue -- 过去发生逾期情况
    ,nvl(n.overdue, o.overdue) as overdue -- 逾期期数
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.mode_type, o.mode_type) as mode_type -- 
    ,nvl(n.serno, o.serno) as serno -- 业务流水号
    ,nvl(n.blng_org_id, o.blng_org_id) as blng_org_id -- 所属机构
    ,nvl(n.iden_num, o.iden_num) as iden_num -- 客户证件号码
    ,nvl(n.cus_name, o.cus_name) as cus_name -- 客户名称
    ,nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,case when
            n.key_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rcds_rcd_ir_grade_collection_sum_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_rcd_ir_grade_collection_sum where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_id = n.key_id
where (
        o.key_id is null
    )
    or (
        n.key_id is null
    )
    or (
        o.loan_no <> n.loan_no
        or o.data_dt <> n.data_dt
        or o.loan_biz_type_cd <> n.loan_biz_type_cd
        or o.loan_total_bal <> n.loan_total_bal
        or o.rist_level <> n.rist_level
        or o.grade <> n.grade
        or o.warning_level <> n.warning_level
        or o.collection_level <> n.collection_level
        or o.past_overdue <> n.past_overdue
        or o.overdue <> n.overdue
        or o.remark <> n.remark
        or o.mode_type <> n.mode_type
        or o.serno <> n.serno
        or o.blng_org_id <> n.blng_org_id
        or o.iden_num <> n.iden_num
        or o.cus_name <> n.cus_name
        or o.grade_key_id <> n.grade_key_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_rcd_ir_grade_collection_sum_cl(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,loan_total_bal -- 贷款余额
            ,rist_level -- 风险等级
            ,grade -- 评分结果
            ,warning_level -- 预警优化级
            ,collection_level -- 催收优先级
            ,past_overdue -- 过去发生逾期情况
            ,overdue -- 逾期期数
            ,remark -- 备注
            ,mode_type -- 
            ,serno -- 业务流水号
            ,blng_org_id -- 所属机构
            ,iden_num -- 客户证件号码
            ,cus_name -- 客户名称
            ,grade_key_id -- 申请评分流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_rcd_ir_grade_collection_sum_op(
            key_id -- 主键
            ,loan_no -- 借据号
            ,data_dt -- 数据日期
            ,loan_biz_type_cd -- 业务品种代码
            ,loan_total_bal -- 贷款余额
            ,rist_level -- 风险等级
            ,grade -- 评分结果
            ,warning_level -- 预警优化级
            ,collection_level -- 催收优先级
            ,past_overdue -- 过去发生逾期情况
            ,overdue -- 逾期期数
            ,remark -- 备注
            ,mode_type -- 
            ,serno -- 业务流水号
            ,blng_org_id -- 所属机构
            ,iden_num -- 客户证件号码
            ,cus_name -- 客户名称
            ,grade_key_id -- 申请评分流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_id -- 主键
    ,o.loan_no -- 借据号
    ,o.data_dt -- 数据日期
    ,o.loan_biz_type_cd -- 业务品种代码
    ,o.loan_total_bal -- 贷款余额
    ,o.rist_level -- 风险等级
    ,o.grade -- 评分结果
    ,o.warning_level -- 预警优化级
    ,o.collection_level -- 催收优先级
    ,o.past_overdue -- 过去发生逾期情况
    ,o.overdue -- 逾期期数
    ,o.remark -- 备注
    ,o.mode_type -- 
    ,o.serno -- 业务流水号
    ,o.blng_org_id -- 所属机构
    ,o.iden_num -- 客户证件号码
    ,o.cus_name -- 客户名称
    ,o.grade_key_id -- 申请评分流水号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_rcd_ir_grade_collection_sum_bk o
    left join ${iol_schema}.rcds_rcd_ir_grade_collection_sum_op n
        on
            o.key_id = n.key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_rcd_ir_grade_collection_sum_cl d
        on
            o.key_id = d.key_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rcds_rcd_ir_grade_collection_sum;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_rcd_ir_grade_collection_sum exchange partition p_19000101 with table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_cl;
alter table ${iol_schema}.rcds_rcd_ir_grade_collection_sum exchange partition p_20991231 with table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_rcd_ir_grade_collection_sum to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_op purge;
drop table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_rcd_ir_grade_collection_sum_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_rcd_ir_grade_collection_sum',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
