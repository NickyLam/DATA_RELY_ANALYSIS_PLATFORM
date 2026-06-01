/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_cash_calc_rule
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
create table ${iol_schema}.fams_fin_cash_calc_rule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_cash_calc_rule;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_cash_calc_rule_op purge;
drop table ${iol_schema}.fams_fin_cash_calc_rule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_cash_calc_rule_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_cash_calc_rule where 0=1;

create table ${iol_schema}.fams_fin_cash_calc_rule_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_cash_calc_rule where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_cash_calc_rule_cl(
            cash_id -- 现金流代码
            ,eff_date -- 生效日期
            ,calc_type -- 计算类型，固定利率、浮动利率
            ,base_type -- 基数类型，本金、资产净值、实收资本等
            ,base_date_type -- 基数日期类型，上一工作日、上一自然日、当日、上一开放日等
            ,basis -- 计息基础，a/360，a/365等
            ,yield -- 生效利率
            ,is_initial -- 是否初始利率
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_cash_calc_rule_op(
            cash_id -- 现金流代码
            ,eff_date -- 生效日期
            ,calc_type -- 计算类型，固定利率、浮动利率
            ,base_type -- 基数类型，本金、资产净值、实收资本等
            ,base_date_type -- 基数日期类型，上一工作日、上一自然日、当日、上一开放日等
            ,basis -- 计息基础，a/360，a/365等
            ,yield -- 生效利率
            ,is_initial -- 是否初始利率
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cash_id, o.cash_id) as cash_id -- 现金流代码
    ,nvl(n.eff_date, o.eff_date) as eff_date -- 生效日期
    ,nvl(n.calc_type, o.calc_type) as calc_type -- 计算类型，固定利率、浮动利率
    ,nvl(n.base_type, o.base_type) as base_type -- 基数类型，本金、资产净值、实收资本等
    ,nvl(n.base_date_type, o.base_date_type) as base_date_type -- 基数日期类型，上一工作日、上一自然日、当日、上一开放日等
    ,nvl(n.basis, o.basis) as basis -- 计息基础，a/360，a/365等
    ,nvl(n.yield, o.yield) as yield -- 生效利率
    ,nvl(n.is_initial, o.is_initial) as is_initial -- 是否初始利率
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.finprod_type, o.finprod_type) as finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,nvl(n.finprod_type2, o.finprod_type2) as finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.cash_id is null
            and n.eff_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cash_id is null
            and n.eff_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cash_id is null
            and n.eff_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_fin_cash_calc_rule_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_cash_calc_rule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cash_id = n.cash_id
            and o.eff_date = n.eff_date
where (
        o.cash_id is null
        and o.eff_date is null
    )
    or (
        n.cash_id is null
        and n.eff_date is null
    )
    or (
        o.calc_type <> n.calc_type
        or o.base_type <> n.base_type
        or o.base_date_type <> n.base_date_type
        or o.basis <> n.basis
        or o.yield <> n.yield
        or o.is_initial <> n.is_initial
        or o.finprod_id <> n.finprod_id
        or o.finprod_type <> n.finprod_type
        or o.finprod_type2 <> n.finprod_type2
        or o.branch <> n.branch
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_cash_calc_rule_cl(
            cash_id -- 现金流代码
            ,eff_date -- 生效日期
            ,calc_type -- 计算类型，固定利率、浮动利率
            ,base_type -- 基数类型，本金、资产净值、实收资本等
            ,base_date_type -- 基数日期类型，上一工作日、上一自然日、当日、上一开放日等
            ,basis -- 计息基础，a/360，a/365等
            ,yield -- 生效利率
            ,is_initial -- 是否初始利率
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_cash_calc_rule_op(
            cash_id -- 现金流代码
            ,eff_date -- 生效日期
            ,calc_type -- 计算类型，固定利率、浮动利率
            ,base_type -- 基数类型，本金、资产净值、实收资本等
            ,base_date_type -- 基数日期类型，上一工作日、上一自然日、当日、上一开放日等
            ,basis -- 计息基础，a/360，a/365等
            ,yield -- 生效利率
            ,is_initial -- 是否初始利率
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cash_id -- 现金流代码
    ,o.eff_date -- 生效日期
    ,o.calc_type -- 计算类型，固定利率、浮动利率
    ,o.base_type -- 基数类型，本金、资产净值、实收资本等
    ,o.base_date_type -- 基数日期类型，上一工作日、上一自然日、当日、上一开放日等
    ,o.basis -- 计息基础，a/360，a/365等
    ,o.yield -- 生效利率
    ,o.is_initial -- 是否初始利率
    ,o.finprod_id -- 金融产品代码
    ,o.finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,o.finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,o.branch -- 分支序号
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_fin_cash_calc_rule_bk o
    left join ${iol_schema}.fams_fin_cash_calc_rule_op n
        on
            o.cash_id = n.cash_id
            and o.eff_date = n.eff_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_cash_calc_rule_cl d
        on
            o.cash_id = d.cash_id
            and o.eff_date = d.eff_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_fin_cash_calc_rule;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_fin_cash_calc_rule exchange partition p_19000101 with table ${iol_schema}.fams_fin_cash_calc_rule_cl;
alter table ${iol_schema}.fams_fin_cash_calc_rule exchange partition p_20991231 with table ${iol_schema}.fams_fin_cash_calc_rule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_cash_calc_rule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_cash_calc_rule_op purge;
drop table ${iol_schema}.fams_fin_cash_calc_rule_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_cash_calc_rule_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_cash_calc_rule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
