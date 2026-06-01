/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbgrpproduct
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
create table ${iol_schema}.nfss_tbgrpproduct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbgrpproduct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbgrpproduct_op purge;
drop table ${iol_schema}.nfss_tbgrpproduct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbgrpproduct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbgrpproduct where 0=1;

create table ${iol_schema}.nfss_tbgrpproduct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbgrpproduct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbgrpproduct_cl(
            group_code -- 分组代码
            ,group_name -- 分组名称
            ,group_max_buy_amt -- 累计最大购买金额
            ,group_max_redeem_amt -- 累计最大赎回金额
            ,status -- 状态
            ,close_time -- 闭市时间
            ,open_time -- 开市时间
            ,yield -- 七日年化收益率
            ,income_unit -- 万份收益
            ,remark -- 备注
            ,first_limit_amount -- 策略转入基准金额
            ,append_amount -- 追加投资金额
            ,pmin_invest_amt -- 个人最低定投金额
            ,product_risk -- 产品风险等级
            ,strategy_mode -- 策略模式:0：黑盒策略 1：白盒CPPI策略 2：白盒金字塔策略 3：白盒二八轮动策略 4：自定义组合策略 5：公募投顾策略
            ,create_date -- 创建日期
            ,create_time -- 创建时间戳
            ,modi_date -- 最后修改日期
            ,modi_time -- 最后修改时间
            ,channels -- 开放渠道:允许渠道组
            ,template_code -- 模板编码:产品模板
            ,model_type -- 模块类型（参数设置用）
            ,liqu_mode -- 账务模式:[K_ZWMS] 0-转账 1-冻结
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbgrpproduct_op(
            group_code -- 分组代码
            ,group_name -- 分组名称
            ,group_max_buy_amt -- 累计最大购买金额
            ,group_max_redeem_amt -- 累计最大赎回金额
            ,status -- 状态
            ,close_time -- 闭市时间
            ,open_time -- 开市时间
            ,yield -- 七日年化收益率
            ,income_unit -- 万份收益
            ,remark -- 备注
            ,first_limit_amount -- 策略转入基准金额
            ,append_amount -- 追加投资金额
            ,pmin_invest_amt -- 个人最低定投金额
            ,product_risk -- 产品风险等级
            ,strategy_mode -- 策略模式:0：黑盒策略 1：白盒CPPI策略 2：白盒金字塔策略 3：白盒二八轮动策略 4：自定义组合策略 5：公募投顾策略
            ,create_date -- 创建日期
            ,create_time -- 创建时间戳
            ,modi_date -- 最后修改日期
            ,modi_time -- 最后修改时间
            ,channels -- 开放渠道:允许渠道组
            ,template_code -- 模板编码:产品模板
            ,model_type -- 模块类型（参数设置用）
            ,liqu_mode -- 账务模式:[K_ZWMS] 0-转账 1-冻结
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.group_code, o.group_code) as group_code -- 分组代码
    ,nvl(n.group_name, o.group_name) as group_name -- 分组名称
    ,nvl(n.group_max_buy_amt, o.group_max_buy_amt) as group_max_buy_amt -- 累计最大购买金额
    ,nvl(n.group_max_redeem_amt, o.group_max_redeem_amt) as group_max_redeem_amt -- 累计最大赎回金额
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.close_time, o.close_time) as close_time -- 闭市时间
    ,nvl(n.open_time, o.open_time) as open_time -- 开市时间
    ,nvl(n.yield, o.yield) as yield -- 七日年化收益率
    ,nvl(n.income_unit, o.income_unit) as income_unit -- 万份收益
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.first_limit_amount, o.first_limit_amount) as first_limit_amount -- 策略转入基准金额
    ,nvl(n.append_amount, o.append_amount) as append_amount -- 追加投资金额
    ,nvl(n.pmin_invest_amt, o.pmin_invest_amt) as pmin_invest_amt -- 个人最低定投金额
    ,nvl(n.product_risk, o.product_risk) as product_risk -- 产品风险等级
    ,nvl(n.strategy_mode, o.strategy_mode) as strategy_mode -- 策略模式:0：黑盒策略 1：白盒CPPI策略 2：白盒金字塔策略 3：白盒二八轮动策略 4：自定义组合策略 5：公募投顾策略
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间戳
    ,nvl(n.modi_date, o.modi_date) as modi_date -- 最后修改日期
    ,nvl(n.modi_time, o.modi_time) as modi_time -- 最后修改时间
    ,nvl(n.channels, o.channels) as channels -- 开放渠道:允许渠道组
    ,nvl(n.template_code, o.template_code) as template_code -- 模板编码:产品模板
    ,nvl(n.model_type, o.model_type) as model_type -- 模块类型（参数设置用）
    ,nvl(n.liqu_mode, o.liqu_mode) as liqu_mode -- 账务模式:[K_ZWMS] 0-转账 1-冻结
    ,case when
            n.group_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.group_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.group_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbgrpproduct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbgrpproduct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.group_code = n.group_code
where (
        o.group_code is null
    )
    or (
        n.group_code is null
    )
    or (
        o.group_name <> n.group_name
        or o.group_max_buy_amt <> n.group_max_buy_amt
        or o.group_max_redeem_amt <> n.group_max_redeem_amt
        or o.status <> n.status
        or o.close_time <> n.close_time
        or o.open_time <> n.open_time
        or o.yield <> n.yield
        or o.income_unit <> n.income_unit
        or o.remark <> n.remark
        or o.first_limit_amount <> n.first_limit_amount
        or o.append_amount <> n.append_amount
        or o.pmin_invest_amt <> n.pmin_invest_amt
        or o.product_risk <> n.product_risk
        or o.strategy_mode <> n.strategy_mode
        or o.create_date <> n.create_date
        or o.create_time <> n.create_time
        or o.modi_date <> n.modi_date
        or o.modi_time <> n.modi_time
        or o.channels <> n.channels
        or o.template_code <> n.template_code
        or o.model_type <> n.model_type
        or o.liqu_mode <> n.liqu_mode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbgrpproduct_cl(
            group_code -- 分组代码
            ,group_name -- 分组名称
            ,group_max_buy_amt -- 累计最大购买金额
            ,group_max_redeem_amt -- 累计最大赎回金额
            ,status -- 状态
            ,close_time -- 闭市时间
            ,open_time -- 开市时间
            ,yield -- 七日年化收益率
            ,income_unit -- 万份收益
            ,remark -- 备注
            ,first_limit_amount -- 策略转入基准金额
            ,append_amount -- 追加投资金额
            ,pmin_invest_amt -- 个人最低定投金额
            ,product_risk -- 产品风险等级
            ,strategy_mode -- 策略模式:0：黑盒策略 1：白盒CPPI策略 2：白盒金字塔策略 3：白盒二八轮动策略 4：自定义组合策略 5：公募投顾策略
            ,create_date -- 创建日期
            ,create_time -- 创建时间戳
            ,modi_date -- 最后修改日期
            ,modi_time -- 最后修改时间
            ,channels -- 开放渠道:允许渠道组
            ,template_code -- 模板编码:产品模板
            ,model_type -- 模块类型（参数设置用）
            ,liqu_mode -- 账务模式:[K_ZWMS] 0-转账 1-冻结
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbgrpproduct_op(
            group_code -- 分组代码
            ,group_name -- 分组名称
            ,group_max_buy_amt -- 累计最大购买金额
            ,group_max_redeem_amt -- 累计最大赎回金额
            ,status -- 状态
            ,close_time -- 闭市时间
            ,open_time -- 开市时间
            ,yield -- 七日年化收益率
            ,income_unit -- 万份收益
            ,remark -- 备注
            ,first_limit_amount -- 策略转入基准金额
            ,append_amount -- 追加投资金额
            ,pmin_invest_amt -- 个人最低定投金额
            ,product_risk -- 产品风险等级
            ,strategy_mode -- 策略模式:0：黑盒策略 1：白盒CPPI策略 2：白盒金字塔策略 3：白盒二八轮动策略 4：自定义组合策略 5：公募投顾策略
            ,create_date -- 创建日期
            ,create_time -- 创建时间戳
            ,modi_date -- 最后修改日期
            ,modi_time -- 最后修改时间
            ,channels -- 开放渠道:允许渠道组
            ,template_code -- 模板编码:产品模板
            ,model_type -- 模块类型（参数设置用）
            ,liqu_mode -- 账务模式:[K_ZWMS] 0-转账 1-冻结
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.group_code -- 分组代码
    ,o.group_name -- 分组名称
    ,o.group_max_buy_amt -- 累计最大购买金额
    ,o.group_max_redeem_amt -- 累计最大赎回金额
    ,o.status -- 状态
    ,o.close_time -- 闭市时间
    ,o.open_time -- 开市时间
    ,o.yield -- 七日年化收益率
    ,o.income_unit -- 万份收益
    ,o.remark -- 备注
    ,o.first_limit_amount -- 策略转入基准金额
    ,o.append_amount -- 追加投资金额
    ,o.pmin_invest_amt -- 个人最低定投金额
    ,o.product_risk -- 产品风险等级
    ,o.strategy_mode -- 策略模式:0：黑盒策略 1：白盒CPPI策略 2：白盒金字塔策略 3：白盒二八轮动策略 4：自定义组合策略 5：公募投顾策略
    ,o.create_date -- 创建日期
    ,o.create_time -- 创建时间戳
    ,o.modi_date -- 最后修改日期
    ,o.modi_time -- 最后修改时间
    ,o.channels -- 开放渠道:允许渠道组
    ,o.template_code -- 模板编码:产品模板
    ,o.model_type -- 模块类型（参数设置用）
    ,o.liqu_mode -- 账务模式:[K_ZWMS] 0-转账 1-冻结
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
from ${iol_schema}.nfss_tbgrpproduct_bk o
    left join ${iol_schema}.nfss_tbgrpproduct_op n
        on
            o.group_code = n.group_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbgrpproduct_cl d
        on
            o.group_code = d.group_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_tbgrpproduct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_tbgrpproduct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_tbgrpproduct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_tbgrpproduct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_tbgrpproduct exchange partition p_${batch_date} with table ${iol_schema}.nfss_tbgrpproduct_cl;
alter table ${iol_schema}.nfss_tbgrpproduct exchange partition p_20991231 with table ${iol_schema}.nfss_tbgrpproduct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbgrpproduct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbgrpproduct_op purge;
drop table ${iol_schema}.nfss_tbgrpproduct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbgrpproduct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbgrpproduct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
