/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_cash_plan
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
create table ${iol_schema}.fams_fin_cash_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_fin_cash_plan;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_cash_plan_op purge;
drop table ${iol_schema}.fams_fin_cash_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_cash_plan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_cash_plan where 0=1;

create table ${iol_schema}.fams_fin_cash_plan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_fin_cash_plan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_cash_plan_cl(
            cash_id -- 现金流代码
            ,cash_num -- 现金流序号，从1开始
            ,cash_type -- 现金流类型，中间还本、中间收息、到期还本、到期收息、费用支付等
            ,vdate_unadjust -- 未调整的计算开始日
            ,mdate_unadjust -- 未调整的计算结束日
            ,pay_date_unadjust -- 未调整的计划支付日
            ,vdate -- 调整后的计算开始日
            ,mdate -- 调整后的计算结束日
            ,pay_date -- 调整后的计划支付日
            ,termdays -- 计算周期天数
            ,vdate_y -- 理论计息年度开始日，a/a_bond适用
            ,vdate_term -- 完整周期开始日
            ,mdate_term -- 完整周期结束日
            ,termdays_term -- 完整周期天数
            ,prin_amt -- 计划支付本金，针对现金流类型为本金的
            ,int_prin_amt -- 计息本金，存计划支付利息对应的本金
            ,int_amt -- 计划支付利息，还本计息区间对应的利息
            ,is_pay_int -- 是否支付利息，针对现金流类型为本金的
            ,cash_amt -- 计划支付现金流，如果支付利息：计划支付本金+计划支付利息。如果不支付利息：计划支付本金
            ,cash_baseamt -- 现金流基数，存100或者总金额的具体数值
            ,cash_unit_type -- 现金流单位，单位、百元、 总金额
            ,calc_function -- 计息算法，分摊法、累计法，目前无
            ,frequency -- 年付息次数
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,pay_type -- 支付方式，现金、红利再投等
            ,range_yield -- 区间净收益率
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,repay_without_int -- 区间还本未付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_cash_plan_op(
            cash_id -- 现金流代码
            ,cash_num -- 现金流序号，从1开始
            ,cash_type -- 现金流类型，中间还本、中间收息、到期还本、到期收息、费用支付等
            ,vdate_unadjust -- 未调整的计算开始日
            ,mdate_unadjust -- 未调整的计算结束日
            ,pay_date_unadjust -- 未调整的计划支付日
            ,vdate -- 调整后的计算开始日
            ,mdate -- 调整后的计算结束日
            ,pay_date -- 调整后的计划支付日
            ,termdays -- 计算周期天数
            ,vdate_y -- 理论计息年度开始日，a/a_bond适用
            ,vdate_term -- 完整周期开始日
            ,mdate_term -- 完整周期结束日
            ,termdays_term -- 完整周期天数
            ,prin_amt -- 计划支付本金，针对现金流类型为本金的
            ,int_prin_amt -- 计息本金，存计划支付利息对应的本金
            ,int_amt -- 计划支付利息，还本计息区间对应的利息
            ,is_pay_int -- 是否支付利息，针对现金流类型为本金的
            ,cash_amt -- 计划支付现金流，如果支付利息：计划支付本金+计划支付利息。如果不支付利息：计划支付本金
            ,cash_baseamt -- 现金流基数，存100或者总金额的具体数值
            ,cash_unit_type -- 现金流单位，单位、百元、 总金额
            ,calc_function -- 计息算法，分摊法、累计法，目前无
            ,frequency -- 年付息次数
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,pay_type -- 支付方式，现金、红利再投等
            ,range_yield -- 区间净收益率
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,repay_without_int -- 区间还本未付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cash_id, o.cash_id) as cash_id -- 现金流代码
    ,nvl(n.cash_num, o.cash_num) as cash_num -- 现金流序号，从1开始
    ,nvl(n.cash_type, o.cash_type) as cash_type -- 现金流类型，中间还本、中间收息、到期还本、到期收息、费用支付等
    ,nvl(n.vdate_unadjust, o.vdate_unadjust) as vdate_unadjust -- 未调整的计算开始日
    ,nvl(n.mdate_unadjust, o.mdate_unadjust) as mdate_unadjust -- 未调整的计算结束日
    ,nvl(n.pay_date_unadjust, o.pay_date_unadjust) as pay_date_unadjust -- 未调整的计划支付日
    ,nvl(n.vdate, o.vdate) as vdate -- 调整后的计算开始日
    ,nvl(n.mdate, o.mdate) as mdate -- 调整后的计算结束日
    ,nvl(n.pay_date, o.pay_date) as pay_date -- 调整后的计划支付日
    ,nvl(n.termdays, o.termdays) as termdays -- 计算周期天数
    ,nvl(n.vdate_y, o.vdate_y) as vdate_y -- 理论计息年度开始日，a/a_bond适用
    ,nvl(n.vdate_term, o.vdate_term) as vdate_term -- 完整周期开始日
    ,nvl(n.mdate_term, o.mdate_term) as mdate_term -- 完整周期结束日
    ,nvl(n.termdays_term, o.termdays_term) as termdays_term -- 完整周期天数
    ,nvl(n.prin_amt, o.prin_amt) as prin_amt -- 计划支付本金，针对现金流类型为本金的
    ,nvl(n.int_prin_amt, o.int_prin_amt) as int_prin_amt -- 计息本金，存计划支付利息对应的本金
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 计划支付利息，还本计息区间对应的利息
    ,nvl(n.is_pay_int, o.is_pay_int) as is_pay_int -- 是否支付利息，针对现金流类型为本金的
    ,nvl(n.cash_amt, o.cash_amt) as cash_amt -- 计划支付现金流，如果支付利息：计划支付本金+计划支付利息。如果不支付利息：计划支付本金
    ,nvl(n.cash_baseamt, o.cash_baseamt) as cash_baseamt -- 现金流基数，存100或者总金额的具体数值
    ,nvl(n.cash_unit_type, o.cash_unit_type) as cash_unit_type -- 现金流单位，单位、百元、 总金额
    ,nvl(n.calc_function, o.calc_function) as calc_function -- 计息算法，分摊法、累计法，目前无
    ,nvl(n.frequency, o.frequency) as frequency -- 年付息次数
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.finprod_type, o.finprod_type) as finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,nvl(n.finprod_type2, o.finprod_type2) as finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 支付方式，现金、红利再投等
    ,nvl(n.range_yield, o.range_yield) as range_yield -- 区间净收益率
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.repay_without_int, o.repay_without_int) as repay_without_int -- 区间还本未付利息
    ,case when
            n.cash_id is null
            and n.mdate is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cash_id is null
            and n.mdate is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cash_id is null
            and n.mdate is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_fin_cash_plan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_fin_cash_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cash_id = n.cash_id
            and o.mdate = n.mdate
where (
        o.cash_id is null
        and o.mdate is null
    )
    or (
        n.cash_id is null
        and n.mdate is null
    )
    or (
        o.cash_num <> n.cash_num
        or o.cash_type <> n.cash_type
        or o.vdate_unadjust <> n.vdate_unadjust
        or o.mdate_unadjust <> n.mdate_unadjust
        or o.pay_date_unadjust <> n.pay_date_unadjust
        or o.vdate <> n.vdate
        or o.pay_date <> n.pay_date
        or o.termdays <> n.termdays
        or o.vdate_y <> n.vdate_y
        or o.vdate_term <> n.vdate_term
        or o.mdate_term <> n.mdate_term
        or o.termdays_term <> n.termdays_term
        or o.prin_amt <> n.prin_amt
        or o.int_prin_amt <> n.int_prin_amt
        or o.int_amt <> n.int_amt
        or o.is_pay_int <> n.is_pay_int
        or o.cash_amt <> n.cash_amt
        or o.cash_baseamt <> n.cash_baseamt
        or o.cash_unit_type <> n.cash_unit_type
        or o.calc_function <> n.calc_function
        or o.frequency <> n.frequency
        or o.finprod_id <> n.finprod_id
        or o.finprod_type <> n.finprod_type
        or o.finprod_type2 <> n.finprod_type2
        or o.branch <> n.branch
        or o.pay_type <> n.pay_type
        or o.range_yield <> n.range_yield
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.repay_without_int <> n.repay_without_int
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_fin_cash_plan_cl(
            cash_id -- 现金流代码
            ,cash_num -- 现金流序号，从1开始
            ,cash_type -- 现金流类型，中间还本、中间收息、到期还本、到期收息、费用支付等
            ,vdate_unadjust -- 未调整的计算开始日
            ,mdate_unadjust -- 未调整的计算结束日
            ,pay_date_unadjust -- 未调整的计划支付日
            ,vdate -- 调整后的计算开始日
            ,mdate -- 调整后的计算结束日
            ,pay_date -- 调整后的计划支付日
            ,termdays -- 计算周期天数
            ,vdate_y -- 理论计息年度开始日，a/a_bond适用
            ,vdate_term -- 完整周期开始日
            ,mdate_term -- 完整周期结束日
            ,termdays_term -- 完整周期天数
            ,prin_amt -- 计划支付本金，针对现金流类型为本金的
            ,int_prin_amt -- 计息本金，存计划支付利息对应的本金
            ,int_amt -- 计划支付利息，还本计息区间对应的利息
            ,is_pay_int -- 是否支付利息，针对现金流类型为本金的
            ,cash_amt -- 计划支付现金流，如果支付利息：计划支付本金+计划支付利息。如果不支付利息：计划支付本金
            ,cash_baseamt -- 现金流基数，存100或者总金额的具体数值
            ,cash_unit_type -- 现金流单位，单位、百元、 总金额
            ,calc_function -- 计息算法，分摊法、累计法，目前无
            ,frequency -- 年付息次数
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,pay_type -- 支付方式，现金、红利再投等
            ,range_yield -- 区间净收益率
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,repay_without_int -- 区间还本未付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_fin_cash_plan_op(
            cash_id -- 现金流代码
            ,cash_num -- 现金流序号，从1开始
            ,cash_type -- 现金流类型，中间还本、中间收息、到期还本、到期收息、费用支付等
            ,vdate_unadjust -- 未调整的计算开始日
            ,mdate_unadjust -- 未调整的计算结束日
            ,pay_date_unadjust -- 未调整的计划支付日
            ,vdate -- 调整后的计算开始日
            ,mdate -- 调整后的计算结束日
            ,pay_date -- 调整后的计划支付日
            ,termdays -- 计算周期天数
            ,vdate_y -- 理论计息年度开始日，a/a_bond适用
            ,vdate_term -- 完整周期开始日
            ,mdate_term -- 完整周期结束日
            ,termdays_term -- 完整周期天数
            ,prin_amt -- 计划支付本金，针对现金流类型为本金的
            ,int_prin_amt -- 计息本金，存计划支付利息对应的本金
            ,int_amt -- 计划支付利息，还本计息区间对应的利息
            ,is_pay_int -- 是否支付利息，针对现金流类型为本金的
            ,cash_amt -- 计划支付现金流，如果支付利息：计划支付本金+计划支付利息。如果不支付利息：计划支付本金
            ,cash_baseamt -- 现金流基数，存100或者总金额的具体数值
            ,cash_unit_type -- 现金流单位，单位、百元、 总金额
            ,calc_function -- 计息算法，分摊法、累计法，目前无
            ,frequency -- 年付息次数
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,pay_type -- 支付方式，现金、红利再投等
            ,range_yield -- 区间净收益率
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,repay_without_int -- 区间还本未付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cash_id -- 现金流代码
    ,o.cash_num -- 现金流序号，从1开始
    ,o.cash_type -- 现金流类型，中间还本、中间收息、到期还本、到期收息、费用支付等
    ,o.vdate_unadjust -- 未调整的计算开始日
    ,o.mdate_unadjust -- 未调整的计算结束日
    ,o.pay_date_unadjust -- 未调整的计划支付日
    ,o.vdate -- 调整后的计算开始日
    ,o.mdate -- 调整后的计算结束日
    ,o.pay_date -- 调整后的计划支付日
    ,o.termdays -- 计算周期天数
    ,o.vdate_y -- 理论计息年度开始日，a/a_bond适用
    ,o.vdate_term -- 完整周期开始日
    ,o.mdate_term -- 完整周期结束日
    ,o.termdays_term -- 完整周期天数
    ,o.prin_amt -- 计划支付本金，针对现金流类型为本金的
    ,o.int_prin_amt -- 计息本金，存计划支付利息对应的本金
    ,o.int_amt -- 计划支付利息，还本计息区间对应的利息
    ,o.is_pay_int -- 是否支付利息，针对现金流类型为本金的
    ,o.cash_amt -- 计划支付现金流，如果支付利息：计划支付本金+计划支付利息。如果不支付利息：计划支付本金
    ,o.cash_baseamt -- 现金流基数，存100或者总金额的具体数值
    ,o.cash_unit_type -- 现金流单位，单位、百元、 总金额
    ,o.calc_function -- 计息算法，分摊法、累计法，目前无
    ,o.frequency -- 年付息次数
    ,o.finprod_id -- 金融产品代码
    ,o.finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,o.finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,o.branch -- 分支序号
    ,o.pay_type -- 支付方式，现金、红利再投等
    ,o.range_yield -- 区间净收益率
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.repay_without_int -- 区间还本未付利息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_fin_cash_plan_bk o
    left join ${iol_schema}.fams_fin_cash_plan_op n
        on
            o.cash_id = n.cash_id
            and o.mdate = n.mdate
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_fin_cash_plan_cl d
        on
            o.cash_id = d.cash_id
            and o.mdate = d.mdate
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_fin_cash_plan;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_fin_cash_plan exchange partition p_19000101 with table ${iol_schema}.fams_fin_cash_plan_cl;
alter table ${iol_schema}.fams_fin_cash_plan exchange partition p_20991231 with table ${iol_schema}.fams_fin_cash_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_fin_cash_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_fin_cash_plan_op purge;
drop table ${iol_schema}.fams_fin_cash_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_fin_cash_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_fin_cash_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
