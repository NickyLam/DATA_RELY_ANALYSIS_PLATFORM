/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_stage_rule_define
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
create table ${iol_schema}.ncbs_rb_dc_stage_rule_define_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_dc_stage_rule_define
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_rule_define_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_rule_define_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_rule_define_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_rule_define where 0=1;

create table ${iol_schema}.ncbs_rb_dc_stage_rule_define_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_rule_define where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_rule_define_cl(
            client_no -- 客户编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acr_rate_type -- 计提利率规则
            ,company -- 法人
            ,fee_type -- 费率类型
            ,observe_flag -- 是否设置观察日
            ,retry_flag -- 是否重算
            ,rule_desc -- 规则描述
            ,stage_code -- 期次代码
            ,stage_init_price -- 期初价格
            ,stage_risk_level -- 期次风险等级
            ,struct_class -- 结构性存款结构分类
            ,touch_flag -- 是否触碰
            ,touch_stop_flag -- 是否终止产品
            ,touch_type -- 触碰类型
            ,underlying_id -- 标的物代码
            ,effect_date -- 产品生效日期
            ,maturity_date -- 到期日期
            ,observe_end_date -- 观察终止日期
            ,observe_start_date -- 观察起始日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,accr_rate -- 计提利率
            ,actual_rate -- 行内利率
            ,amt_unit -- 金额单位
            ,auth_user_id -- 授权柜员
            ,float_rate -- 浮动利率
            ,high_grade_rate -- 高档利率
            ,high_threshold -- 最高价格
            ,in_section_days -- 区间内天数
            ,init_amt -- 认购起存金额
            ,low_end_rate -- 低档利率
            ,low_threshold -- 最低价格
            ,open_rate -- 开户利率
            ,out_section_days -- 区间外天数
            ,pre_rate -- 提前支取利率
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,stage_fixed_rate -- 期次级固定利率
            ,stage_low_limit -- 期次成立最低额度
            ,stage_percent_rate -- 期次级浮动百分比
            ,stage_spread_rate -- 期次级浮动百分点
            ,touch_percent -- 触碰百分比
            ,tran_branch -- 核心交易机构编号
            ,years_rate -- 年化利率
            ,settle_days -- 清算天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_rule_define_op(
            client_no -- 客户编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acr_rate_type -- 计提利率规则
            ,company -- 法人
            ,fee_type -- 费率类型
            ,observe_flag -- 是否设置观察日
            ,retry_flag -- 是否重算
            ,rule_desc -- 规则描述
            ,stage_code -- 期次代码
            ,stage_init_price -- 期初价格
            ,stage_risk_level -- 期次风险等级
            ,struct_class -- 结构性存款结构分类
            ,touch_flag -- 是否触碰
            ,touch_stop_flag -- 是否终止产品
            ,touch_type -- 触碰类型
            ,underlying_id -- 标的物代码
            ,effect_date -- 产品生效日期
            ,maturity_date -- 到期日期
            ,observe_end_date -- 观察终止日期
            ,observe_start_date -- 观察起始日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,accr_rate -- 计提利率
            ,actual_rate -- 行内利率
            ,amt_unit -- 金额单位
            ,auth_user_id -- 授权柜员
            ,float_rate -- 浮动利率
            ,high_grade_rate -- 高档利率
            ,high_threshold -- 最高价格
            ,in_section_days -- 区间内天数
            ,init_amt -- 认购起存金额
            ,low_end_rate -- 低档利率
            ,low_threshold -- 最低价格
            ,open_rate -- 开户利率
            ,out_section_days -- 区间外天数
            ,pre_rate -- 提前支取利率
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,stage_fixed_rate -- 期次级固定利率
            ,stage_low_limit -- 期次成立最低额度
            ,stage_percent_rate -- 期次级浮动百分比
            ,stage_spread_rate -- 期次级浮动百分点
            ,touch_percent -- 触碰百分比
            ,tran_branch -- 核心交易机构编号
            ,years_rate -- 年化利率
            ,settle_days -- 清算天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.acr_rate_type, o.acr_rate_type) as acr_rate_type -- 计提利率规则
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.observe_flag, o.observe_flag) as observe_flag -- 是否设置观察日
    ,nvl(n.retry_flag, o.retry_flag) as retry_flag -- 是否重算
    ,nvl(n.rule_desc, o.rule_desc) as rule_desc -- 规则描述
    ,nvl(n.stage_code, o.stage_code) as stage_code -- 期次代码
    ,nvl(n.stage_init_price, o.stage_init_price) as stage_init_price -- 期初价格
    ,nvl(n.stage_risk_level, o.stage_risk_level) as stage_risk_level -- 期次风险等级
    ,nvl(n.struct_class, o.struct_class) as struct_class -- 结构性存款结构分类
    ,nvl(n.touch_flag, o.touch_flag) as touch_flag -- 是否触碰
    ,nvl(n.touch_stop_flag, o.touch_stop_flag) as touch_stop_flag -- 是否终止产品
    ,nvl(n.touch_type, o.touch_type) as touch_type -- 触碰类型
    ,nvl(n.underlying_id, o.underlying_id) as underlying_id -- 标的物代码
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.observe_end_date, o.observe_end_date) as observe_end_date -- 观察终止日期
    ,nvl(n.observe_start_date, o.observe_start_date) as observe_start_date -- 观察起始日期
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.accr_rate, o.accr_rate) as accr_rate -- 计提利率
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.amt_unit, o.amt_unit) as amt_unit -- 金额单位
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.high_grade_rate, o.high_grade_rate) as high_grade_rate -- 高档利率
    ,nvl(n.high_threshold, o.high_threshold) as high_threshold -- 最高价格
    ,nvl(n.in_section_days, o.in_section_days) as in_section_days -- 区间内天数
    ,nvl(n.init_amt, o.init_amt) as init_amt -- 认购起存金额
    ,nvl(n.low_end_rate, o.low_end_rate) as low_end_rate -- 低档利率
    ,nvl(n.low_threshold, o.low_threshold) as low_threshold -- 最低价格
    ,nvl(n.open_rate, o.open_rate) as open_rate -- 开户利率
    ,nvl(n.out_section_days, o.out_section_days) as out_section_days -- 区间外天数
    ,nvl(n.pre_rate, o.pre_rate) as pre_rate -- 提前支取利率
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.sg_max_amt, o.sg_max_amt) as sg_max_amt -- 单笔认购最大金额
    ,nvl(n.stage_fixed_rate, o.stage_fixed_rate) as stage_fixed_rate -- 期次级固定利率
    ,nvl(n.stage_low_limit, o.stage_low_limit) as stage_low_limit -- 期次成立最低额度
    ,nvl(n.stage_percent_rate, o.stage_percent_rate) as stage_percent_rate -- 期次级浮动百分比
    ,nvl(n.stage_spread_rate, o.stage_spread_rate) as stage_spread_rate -- 期次级浮动百分点
    ,nvl(n.touch_percent, o.touch_percent) as touch_percent -- 触碰百分比
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.years_rate, o.years_rate) as years_rate -- 年化利率
    ,nvl(n.settle_days, o.settle_days) as settle_days -- 清算天数
    ,case when
            n.prod_type is null
            and n.stage_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_type is null
            and n.stage_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_type is null
            and n.stage_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_dc_stage_rule_define_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_dc_stage_rule_define where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prod_type = n.prod_type
            and o.stage_code = n.stage_code
where (
        o.prod_type is null
        and o.stage_code is null
    )
    or (
        n.prod_type is null
        and n.stage_code is null
    )
    or (
        o.client_no <> n.client_no
        or o.user_id <> n.user_id
        or o.acr_rate_type <> n.acr_rate_type
        or o.company <> n.company
        or o.fee_type <> n.fee_type
        or o.observe_flag <> n.observe_flag
        or o.retry_flag <> n.retry_flag
        or o.rule_desc <> n.rule_desc
        or o.stage_init_price <> n.stage_init_price
        or o.stage_risk_level <> n.stage_risk_level
        or o.struct_class <> n.struct_class
        or o.touch_flag <> n.touch_flag
        or o.touch_stop_flag <> n.touch_stop_flag
        or o.touch_type <> n.touch_type
        or o.underlying_id <> n.underlying_id
        or o.effect_date <> n.effect_date
        or o.maturity_date <> n.maturity_date
        or o.observe_end_date <> n.observe_end_date
        or o.observe_start_date <> n.observe_start_date
        or o.settle_date <> n.settle_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.accr_rate <> n.accr_rate
        or o.actual_rate <> n.actual_rate
        or o.amt_unit <> n.amt_unit
        or o.auth_user_id <> n.auth_user_id
        or o.float_rate <> n.float_rate
        or o.high_grade_rate <> n.high_grade_rate
        or o.high_threshold <> n.high_threshold
        or o.in_section_days <> n.in_section_days
        or o.init_amt <> n.init_amt
        or o.low_end_rate <> n.low_end_rate
        or o.low_threshold <> n.low_threshold
        or o.open_rate <> n.open_rate
        or o.out_section_days <> n.out_section_days
        or o.pre_rate <> n.pre_rate
        or o.real_rate <> n.real_rate
        or o.sg_max_amt <> n.sg_max_amt
        or o.stage_fixed_rate <> n.stage_fixed_rate
        or o.stage_low_limit <> n.stage_low_limit
        or o.stage_percent_rate <> n.stage_percent_rate
        or o.stage_spread_rate <> n.stage_spread_rate
        or o.touch_percent <> n.touch_percent
        or o.tran_branch <> n.tran_branch
        or o.years_rate <> n.years_rate
        or o.settle_days <> n.settle_days
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_rule_define_cl(
            client_no -- 客户编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acr_rate_type -- 计提利率规则
            ,company -- 法人
            ,fee_type -- 费率类型
            ,observe_flag -- 是否设置观察日
            ,retry_flag -- 是否重算
            ,rule_desc -- 规则描述
            ,stage_code -- 期次代码
            ,stage_init_price -- 期初价格
            ,stage_risk_level -- 期次风险等级
            ,struct_class -- 结构性存款结构分类
            ,touch_flag -- 是否触碰
            ,touch_stop_flag -- 是否终止产品
            ,touch_type -- 触碰类型
            ,underlying_id -- 标的物代码
            ,effect_date -- 产品生效日期
            ,maturity_date -- 到期日期
            ,observe_end_date -- 观察终止日期
            ,observe_start_date -- 观察起始日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,accr_rate -- 计提利率
            ,actual_rate -- 行内利率
            ,amt_unit -- 金额单位
            ,auth_user_id -- 授权柜员
            ,float_rate -- 浮动利率
            ,high_grade_rate -- 高档利率
            ,high_threshold -- 最高价格
            ,in_section_days -- 区间内天数
            ,init_amt -- 认购起存金额
            ,low_end_rate -- 低档利率
            ,low_threshold -- 最低价格
            ,open_rate -- 开户利率
            ,out_section_days -- 区间外天数
            ,pre_rate -- 提前支取利率
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,stage_fixed_rate -- 期次级固定利率
            ,stage_low_limit -- 期次成立最低额度
            ,stage_percent_rate -- 期次级浮动百分比
            ,stage_spread_rate -- 期次级浮动百分点
            ,touch_percent -- 触碰百分比
            ,tran_branch -- 核心交易机构编号
            ,years_rate -- 年化利率
            ,settle_days -- 清算天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_rule_define_op(
            client_no -- 客户编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acr_rate_type -- 计提利率规则
            ,company -- 法人
            ,fee_type -- 费率类型
            ,observe_flag -- 是否设置观察日
            ,retry_flag -- 是否重算
            ,rule_desc -- 规则描述
            ,stage_code -- 期次代码
            ,stage_init_price -- 期初价格
            ,stage_risk_level -- 期次风险等级
            ,struct_class -- 结构性存款结构分类
            ,touch_flag -- 是否触碰
            ,touch_stop_flag -- 是否终止产品
            ,touch_type -- 触碰类型
            ,underlying_id -- 标的物代码
            ,effect_date -- 产品生效日期
            ,maturity_date -- 到期日期
            ,observe_end_date -- 观察终止日期
            ,observe_start_date -- 观察起始日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,accr_rate -- 计提利率
            ,actual_rate -- 行内利率
            ,amt_unit -- 金额单位
            ,auth_user_id -- 授权柜员
            ,float_rate -- 浮动利率
            ,high_grade_rate -- 高档利率
            ,high_threshold -- 最高价格
            ,in_section_days -- 区间内天数
            ,init_amt -- 认购起存金额
            ,low_end_rate -- 低档利率
            ,low_threshold -- 最低价格
            ,open_rate -- 开户利率
            ,out_section_days -- 区间外天数
            ,pre_rate -- 提前支取利率
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,stage_fixed_rate -- 期次级固定利率
            ,stage_low_limit -- 期次成立最低额度
            ,stage_percent_rate -- 期次级浮动百分比
            ,stage_spread_rate -- 期次级浮动百分点
            ,touch_percent -- 触碰百分比
            ,tran_branch -- 核心交易机构编号
            ,years_rate -- 年化利率
            ,settle_days -- 清算天数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.acr_rate_type -- 计提利率规则
    ,o.company -- 法人
    ,o.fee_type -- 费率类型
    ,o.observe_flag -- 是否设置观察日
    ,o.retry_flag -- 是否重算
    ,o.rule_desc -- 规则描述
    ,o.stage_code -- 期次代码
    ,o.stage_init_price -- 期初价格
    ,o.stage_risk_level -- 期次风险等级
    ,o.struct_class -- 结构性存款结构分类
    ,o.touch_flag -- 是否触碰
    ,o.touch_stop_flag -- 是否终止产品
    ,o.touch_type -- 触碰类型
    ,o.underlying_id -- 标的物代码
    ,o.effect_date -- 产品生效日期
    ,o.maturity_date -- 到期日期
    ,o.observe_end_date -- 观察终止日期
    ,o.observe_start_date -- 观察起始日期
    ,o.settle_date -- 结算日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.accr_rate -- 计提利率
    ,o.actual_rate -- 行内利率
    ,o.amt_unit -- 金额单位
    ,o.auth_user_id -- 授权柜员
    ,o.float_rate -- 浮动利率
    ,o.high_grade_rate -- 高档利率
    ,o.high_threshold -- 最高价格
    ,o.in_section_days -- 区间内天数
    ,o.init_amt -- 认购起存金额
    ,o.low_end_rate -- 低档利率
    ,o.low_threshold -- 最低价格
    ,o.open_rate -- 开户利率
    ,o.out_section_days -- 区间外天数
    ,o.pre_rate -- 提前支取利率
    ,o.real_rate -- 执行利率
    ,o.sg_max_amt -- 单笔认购最大金额
    ,o.stage_fixed_rate -- 期次级固定利率
    ,o.stage_low_limit -- 期次成立最低额度
    ,o.stage_percent_rate -- 期次级浮动百分比
    ,o.stage_spread_rate -- 期次级浮动百分点
    ,o.touch_percent -- 触碰百分比
    ,o.tran_branch -- 核心交易机构编号
    ,o.years_rate -- 年化利率
    ,o.settle_days -- 清算天数
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
from ${iol_schema}.ncbs_rb_dc_stage_rule_define_bk o
    left join ${iol_schema}.ncbs_rb_dc_stage_rule_define_op n
        on
            o.prod_type = n.prod_type
            and o.stage_code = n.stage_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_dc_stage_rule_define_cl d
        on
            o.prod_type = d.prod_type
            and o.stage_code = d.stage_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_dc_stage_rule_define;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_dc_stage_rule_define') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_dc_stage_rule_define drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_dc_stage_rule_define add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_dc_stage_rule_define exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_stage_rule_define_cl;
alter table ${iol_schema}.ncbs_rb_dc_stage_rule_define exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_dc_stage_rule_define_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_stage_rule_define to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_rule_define_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_rule_define_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_dc_stage_rule_define_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_stage_rule_define',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
