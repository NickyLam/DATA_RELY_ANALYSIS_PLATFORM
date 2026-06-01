/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_a_ent_info
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
create table ${iol_schema}.rcds_ir_a_ent_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rcds_ir_a_ent_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_a_ent_info_op purge;
drop table ${iol_schema}.rcds_ir_a_ent_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_a_ent_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_a_ent_info where 0=1;

create table ${iol_schema}.rcds_ir_a_ent_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_a_ent_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_a_ent_info_cl(
            grade_key_id -- 申请评分流水号
            ,application_num -- 申请编号
            ,data_time -- 数据记录时间
            ,ent_name -- 经营体名称
            ,ent_id -- 经营体注册号
            ,ent_est_date -- 设立日期
            ,ent_legal_name -- 法定代表人名称
            ,ent_tel -- 经营体电话
            ,end_reg_ad -- 注册地址
            ,ent_office_ad -- 经营地址
            ,ent_reg_capital -- 注册资本
            ,ent_real_capital -- 实收资本
            ,ent_emp_num -- 员工人数
            ,ent_cus_relation -- 申请人与经营体之关系
            ,ent_cus_relation_std -- 申请人与经营体之关系(规则标准)
            ,ent_cus_share -- 申请人对经营体持股比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_a_ent_info_op(
            grade_key_id -- 申请评分流水号
            ,application_num -- 申请编号
            ,data_time -- 数据记录时间
            ,ent_name -- 经营体名称
            ,ent_id -- 经营体注册号
            ,ent_est_date -- 设立日期
            ,ent_legal_name -- 法定代表人名称
            ,ent_tel -- 经营体电话
            ,end_reg_ad -- 注册地址
            ,ent_office_ad -- 经营地址
            ,ent_reg_capital -- 注册资本
            ,ent_real_capital -- 实收资本
            ,ent_emp_num -- 员工人数
            ,ent_cus_relation -- 申请人与经营体之关系
            ,ent_cus_relation_std -- 申请人与经营体之关系(规则标准)
            ,ent_cus_share -- 申请人对经营体持股比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grade_key_id, o.grade_key_id) as grade_key_id -- 申请评分流水号
    ,nvl(n.application_num, o.application_num) as application_num -- 申请编号
    ,nvl(n.data_time, o.data_time) as data_time -- 数据记录时间
    ,nvl(n.ent_name, o.ent_name) as ent_name -- 经营体名称
    ,nvl(n.ent_id, o.ent_id) as ent_id -- 经营体注册号
    ,nvl(n.ent_est_date, o.ent_est_date) as ent_est_date -- 设立日期
    ,nvl(n.ent_legal_name, o.ent_legal_name) as ent_legal_name -- 法定代表人名称
    ,nvl(n.ent_tel, o.ent_tel) as ent_tel -- 经营体电话
    ,nvl(n.end_reg_ad, o.end_reg_ad) as end_reg_ad -- 注册地址
    ,nvl(n.ent_office_ad, o.ent_office_ad) as ent_office_ad -- 经营地址
    ,nvl(n.ent_reg_capital, o.ent_reg_capital) as ent_reg_capital -- 注册资本
    ,nvl(n.ent_real_capital, o.ent_real_capital) as ent_real_capital -- 实收资本
    ,nvl(n.ent_emp_num, o.ent_emp_num) as ent_emp_num -- 员工人数
    ,nvl(n.ent_cus_relation, o.ent_cus_relation) as ent_cus_relation -- 申请人与经营体之关系
    ,nvl(n.ent_cus_relation_std, o.ent_cus_relation_std) as ent_cus_relation_std -- 申请人与经营体之关系(规则标准)
    ,nvl(n.ent_cus_share, o.ent_cus_share) as ent_cus_share -- 申请人对经营体持股比例
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
from (select * from ${iol_schema}.rcds_ir_a_ent_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rcds_ir_a_ent_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.ent_name <> n.ent_name
        or o.ent_id <> n.ent_id
        or o.ent_est_date <> n.ent_est_date
        or o.ent_legal_name <> n.ent_legal_name
        or o.ent_tel <> n.ent_tel
        or o.end_reg_ad <> n.end_reg_ad
        or o.ent_office_ad <> n.ent_office_ad
        or o.ent_reg_capital <> n.ent_reg_capital
        or o.ent_real_capital <> n.ent_real_capital
        or o.ent_emp_num <> n.ent_emp_num
        or o.ent_cus_relation <> n.ent_cus_relation
        or o.ent_cus_relation_std <> n.ent_cus_relation_std
        or o.ent_cus_share <> n.ent_cus_share
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rcds_ir_a_ent_info_cl(
            grade_key_id -- 申请评分流水号
            ,application_num -- 申请编号
            ,data_time -- 数据记录时间
            ,ent_name -- 经营体名称
            ,ent_id -- 经营体注册号
            ,ent_est_date -- 设立日期
            ,ent_legal_name -- 法定代表人名称
            ,ent_tel -- 经营体电话
            ,end_reg_ad -- 注册地址
            ,ent_office_ad -- 经营地址
            ,ent_reg_capital -- 注册资本
            ,ent_real_capital -- 实收资本
            ,ent_emp_num -- 员工人数
            ,ent_cus_relation -- 申请人与经营体之关系
            ,ent_cus_relation_std -- 申请人与经营体之关系(规则标准)
            ,ent_cus_share -- 申请人对经营体持股比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rcds_ir_a_ent_info_op(
            grade_key_id -- 申请评分流水号
            ,application_num -- 申请编号
            ,data_time -- 数据记录时间
            ,ent_name -- 经营体名称
            ,ent_id -- 经营体注册号
            ,ent_est_date -- 设立日期
            ,ent_legal_name -- 法定代表人名称
            ,ent_tel -- 经营体电话
            ,end_reg_ad -- 注册地址
            ,ent_office_ad -- 经营地址
            ,ent_reg_capital -- 注册资本
            ,ent_real_capital -- 实收资本
            ,ent_emp_num -- 员工人数
            ,ent_cus_relation -- 申请人与经营体之关系
            ,ent_cus_relation_std -- 申请人与经营体之关系(规则标准)
            ,ent_cus_share -- 申请人对经营体持股比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grade_key_id -- 申请评分流水号
    ,o.application_num -- 申请编号
    ,o.data_time -- 数据记录时间
    ,o.ent_name -- 经营体名称
    ,o.ent_id -- 经营体注册号
    ,o.ent_est_date -- 设立日期
    ,o.ent_legal_name -- 法定代表人名称
    ,o.ent_tel -- 经营体电话
    ,o.end_reg_ad -- 注册地址
    ,o.ent_office_ad -- 经营地址
    ,o.ent_reg_capital -- 注册资本
    ,o.ent_real_capital -- 实收资本
    ,o.ent_emp_num -- 员工人数
    ,o.ent_cus_relation -- 申请人与经营体之关系
    ,o.ent_cus_relation_std -- 申请人与经营体之关系(规则标准)
    ,o.ent_cus_share -- 申请人对经营体持股比例
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rcds_ir_a_ent_info_bk o
    left join ${iol_schema}.rcds_ir_a_ent_info_op n
        on
            o.grade_key_id = n.grade_key_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rcds_ir_a_ent_info_cl d
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
-- truncate table ${iol_schema}.rcds_ir_a_ent_info;

-- 4.2 exchange partition
alter table ${iol_schema}.rcds_ir_a_ent_info exchange partition p_19000101 with table ${iol_schema}.rcds_ir_a_ent_info_cl;
alter table ${iol_schema}.rcds_ir_a_ent_info exchange partition p_20991231 with table ${iol_schema}.rcds_ir_a_ent_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_a_ent_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rcds_ir_a_ent_info_op purge;
drop table ${iol_schema}.rcds_ir_a_ent_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rcds_ir_a_ent_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_a_ent_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
