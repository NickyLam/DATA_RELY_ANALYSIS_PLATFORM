/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_security
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
create table ${iol_schema}.ctms_tbs_v_security_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_security;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security where 0=1;

create table ${iol_schema}.ctms_tbs_v_security_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_cl(
            security_code -- 债券代码
            ,security_name -- 债券名称
            ,security_type -- 债券类别
            ,issuer -- 发行人
            ,guarantee -- 担保人
            ,ccy -- 本金币种
            ,int_ccy -- 利息币种
            ,issue_date -- 发行日
            ,start_coupon_date -- 起息日
            ,maturity_date -- 到期日
            ,lot_size -- 债券发行最小单位
            ,day_count -- 计息基准
            ,rate_type -- 利率方式
            ,fixed_rate -- 票面利率
            ,floating_rate -- 基准利率
            ,floating_rate_ind -- 浮动方向
            ,floating_spread -- 基本利差
            ,fixing_freq -- 重置频率
            ,ffixing_date -- 首次利率重置日
            ,coupon_freq -- 计息频率
            ,fcoupon_date -- 首次付息日
            ,payment_freq -- 付息频率
            ,compound_freq -- 复利频率
            ,option_type -- 选择权类别
            ,back_amt -- 每期还本金额
            ,number_issued -- 发行金额
            ,aution_rate -- 标售利率
            ,aution_price -- 发行价格
            ,first_trade_date -- 上市交易日
            ,market_type -- 市场类别
            ,repo_ratio -- 质押比
            ,security_short_name -- 债券简称
            ,convertable -- 是否是可转换债券
            ,convert_security_code -- 转换债券码
            ,discount_rate -- 是否贴现债
            ,cap -- 浮动利率上限
            ,floor -- 浮动利率下限
            ,fixing_rate_methoh -- 利率重置方法
            ,note -- 债券备注
            ,floating_rate_scale -- 利率小数位数
            ,stop_trade_date -- 停止流通日
            ,collateral_id -- 担保品
            ,floater_factor_op -- 浮动利率重算因子运算子
            ,floater_factor -- 浮动利率重算因子
            ,fixing_rules -- 是否有利率重置公式
            ,org_term -- 原始合约上的期限
            ,org_term_mult -- 原始合约上的期限单位
            ,isjx -- 是否计应收利息
            ,modify_date -- 修改日期
            ,compound -- 是否复利
            ,security_type_new -- 债券类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_op(
            security_code -- 债券代码
            ,security_name -- 债券名称
            ,security_type -- 债券类别
            ,issuer -- 发行人
            ,guarantee -- 担保人
            ,ccy -- 本金币种
            ,int_ccy -- 利息币种
            ,issue_date -- 发行日
            ,start_coupon_date -- 起息日
            ,maturity_date -- 到期日
            ,lot_size -- 债券发行最小单位
            ,day_count -- 计息基准
            ,rate_type -- 利率方式
            ,fixed_rate -- 票面利率
            ,floating_rate -- 基准利率
            ,floating_rate_ind -- 浮动方向
            ,floating_spread -- 基本利差
            ,fixing_freq -- 重置频率
            ,ffixing_date -- 首次利率重置日
            ,coupon_freq -- 计息频率
            ,fcoupon_date -- 首次付息日
            ,payment_freq -- 付息频率
            ,compound_freq -- 复利频率
            ,option_type -- 选择权类别
            ,back_amt -- 每期还本金额
            ,number_issued -- 发行金额
            ,aution_rate -- 标售利率
            ,aution_price -- 发行价格
            ,first_trade_date -- 上市交易日
            ,market_type -- 市场类别
            ,repo_ratio -- 质押比
            ,security_short_name -- 债券简称
            ,convertable -- 是否是可转换债券
            ,convert_security_code -- 转换债券码
            ,discount_rate -- 是否贴现债
            ,cap -- 浮动利率上限
            ,floor -- 浮动利率下限
            ,fixing_rate_methoh -- 利率重置方法
            ,note -- 债券备注
            ,floating_rate_scale -- 利率小数位数
            ,stop_trade_date -- 停止流通日
            ,collateral_id -- 担保品
            ,floater_factor_op -- 浮动利率重算因子运算子
            ,floater_factor -- 浮动利率重算因子
            ,fixing_rules -- 是否有利率重置公式
            ,org_term -- 原始合约上的期限
            ,org_term_mult -- 原始合约上的期限单位
            ,isjx -- 是否计应收利息
            ,modify_date -- 修改日期
            ,compound -- 是否复利
            ,security_type_new -- 债券类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.security_name, o.security_name) as security_name -- 债券名称
    ,nvl(n.security_type, o.security_type) as security_type -- 债券类别
    ,nvl(n.issuer, o.issuer) as issuer -- 发行人
    ,nvl(n.guarantee, o.guarantee) as guarantee -- 担保人
    ,nvl(n.ccy, o.ccy) as ccy -- 本金币种
    ,nvl(n.int_ccy, o.int_ccy) as int_ccy -- 利息币种
    ,nvl(n.issue_date, o.issue_date) as issue_date -- 发行日
    ,nvl(n.start_coupon_date, o.start_coupon_date) as start_coupon_date -- 起息日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.lot_size, o.lot_size) as lot_size -- 债券发行最小单位
    ,nvl(n.day_count, o.day_count) as day_count -- 计息基准
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 利率方式
    ,nvl(n.fixed_rate, o.fixed_rate) as fixed_rate -- 票面利率
    ,nvl(n.floating_rate, o.floating_rate) as floating_rate -- 基准利率
    ,nvl(n.floating_rate_ind, o.floating_rate_ind) as floating_rate_ind -- 浮动方向
    ,nvl(n.floating_spread, o.floating_spread) as floating_spread -- 基本利差
    ,nvl(n.fixing_freq, o.fixing_freq) as fixing_freq -- 重置频率
    ,nvl(n.ffixing_date, o.ffixing_date) as ffixing_date -- 首次利率重置日
    ,nvl(n.coupon_freq, o.coupon_freq) as coupon_freq -- 计息频率
    ,nvl(n.fcoupon_date, o.fcoupon_date) as fcoupon_date -- 首次付息日
    ,nvl(n.payment_freq, o.payment_freq) as payment_freq -- 付息频率
    ,nvl(n.compound_freq, o.compound_freq) as compound_freq -- 复利频率
    ,nvl(n.option_type, o.option_type) as option_type -- 选择权类别
    ,nvl(n.back_amt, o.back_amt) as back_amt -- 每期还本金额
    ,nvl(n.number_issued, o.number_issued) as number_issued -- 发行金额
    ,nvl(n.aution_rate, o.aution_rate) as aution_rate -- 标售利率
    ,nvl(n.aution_price, o.aution_price) as aution_price -- 发行价格
    ,nvl(n.first_trade_date, o.first_trade_date) as first_trade_date -- 上市交易日
    ,nvl(n.market_type, o.market_type) as market_type -- 市场类别
    ,nvl(n.repo_ratio, o.repo_ratio) as repo_ratio -- 质押比
    ,nvl(n.security_short_name, o.security_short_name) as security_short_name -- 债券简称
    ,nvl(n.convertable, o.convertable) as convertable -- 是否是可转换债券
    ,nvl(n.convert_security_code, o.convert_security_code) as convert_security_code -- 转换债券码
    ,nvl(n.discount_rate, o.discount_rate) as discount_rate -- 是否贴现债
    ,nvl(n.cap, o.cap) as cap -- 浮动利率上限
    ,nvl(n.floor, o.floor) as floor -- 浮动利率下限
    ,nvl(n.fixing_rate_methoh, o.fixing_rate_methoh) as fixing_rate_methoh -- 利率重置方法
    ,nvl(n.note, o.note) as note -- 债券备注
    ,nvl(n.floating_rate_scale, o.floating_rate_scale) as floating_rate_scale -- 利率小数位数
    ,nvl(n.stop_trade_date, o.stop_trade_date) as stop_trade_date -- 停止流通日
    ,nvl(n.collateral_id, o.collateral_id) as collateral_id -- 担保品
    ,nvl(n.floater_factor_op, o.floater_factor_op) as floater_factor_op -- 浮动利率重算因子运算子
    ,nvl(n.floater_factor, o.floater_factor) as floater_factor -- 浮动利率重算因子
    ,nvl(n.fixing_rules, o.fixing_rules) as fixing_rules -- 是否有利率重置公式
    ,nvl(n.org_term, o.org_term) as org_term -- 原始合约上的期限
    ,nvl(n.org_term_mult, o.org_term_mult) as org_term_mult -- 原始合约上的期限单位
    ,nvl(n.isjx, o.isjx) as isjx -- 是否计应收利息
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 修改日期
    ,nvl(n.compound, o.compound) as compound -- 是否复利
    ,nvl(n.security_type_new, o.security_type_new) as security_type_new -- 债券类别
    ,case when
            n.security_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.security_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.security_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_security_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_security where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.security_code = n.security_code
where (
        o.security_code is null
    )
    or (
        n.security_code is null
    )
    or (
        o.security_name <> n.security_name
        or o.security_type <> n.security_type
        or o.issuer <> n.issuer
        or o.guarantee <> n.guarantee
        or o.ccy <> n.ccy
        or o.int_ccy <> n.int_ccy
        or o.issue_date <> n.issue_date
        or o.start_coupon_date <> n.start_coupon_date
        or o.maturity_date <> n.maturity_date
        or o.lot_size <> n.lot_size
        or o.day_count <> n.day_count
        or o.rate_type <> n.rate_type
        or o.fixed_rate <> n.fixed_rate
        or o.floating_rate <> n.floating_rate
        or o.floating_rate_ind <> n.floating_rate_ind
        or o.floating_spread <> n.floating_spread
        or o.fixing_freq <> n.fixing_freq
        or o.ffixing_date <> n.ffixing_date
        or o.coupon_freq <> n.coupon_freq
        or o.fcoupon_date <> n.fcoupon_date
        or o.payment_freq <> n.payment_freq
        or o.compound_freq <> n.compound_freq
        or o.option_type <> n.option_type
        or o.back_amt <> n.back_amt
        or o.number_issued <> n.number_issued
        or o.aution_rate <> n.aution_rate
        or o.aution_price <> n.aution_price
        or o.first_trade_date <> n.first_trade_date
        or o.market_type <> n.market_type
        or o.repo_ratio <> n.repo_ratio
        or o.security_short_name <> n.security_short_name
        or o.convertable <> n.convertable
        or o.convert_security_code <> n.convert_security_code
        or o.discount_rate <> n.discount_rate
        or o.cap <> n.cap
        or o.floor <> n.floor
        or o.fixing_rate_methoh <> n.fixing_rate_methoh
        or o.note <> n.note
        or o.floating_rate_scale <> n.floating_rate_scale
        or o.stop_trade_date <> n.stop_trade_date
        or o.collateral_id <> n.collateral_id
        or o.floater_factor_op <> n.floater_factor_op
        or o.floater_factor <> n.floater_factor
        or o.fixing_rules <> n.fixing_rules
        or o.org_term <> n.org_term
        or o.org_term_mult <> n.org_term_mult
        or o.isjx <> n.isjx
        or o.modify_date <> n.modify_date
        or o.compound <> n.compound
        or o.security_type_new <> n.security_type_new
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_cl(
            security_code -- 债券代码
            ,security_name -- 债券名称
            ,security_type -- 债券类别
            ,issuer -- 发行人
            ,guarantee -- 担保人
            ,ccy -- 本金币种
            ,int_ccy -- 利息币种
            ,issue_date -- 发行日
            ,start_coupon_date -- 起息日
            ,maturity_date -- 到期日
            ,lot_size -- 债券发行最小单位
            ,day_count -- 计息基准
            ,rate_type -- 利率方式
            ,fixed_rate -- 票面利率
            ,floating_rate -- 基准利率
            ,floating_rate_ind -- 浮动方向
            ,floating_spread -- 基本利差
            ,fixing_freq -- 重置频率
            ,ffixing_date -- 首次利率重置日
            ,coupon_freq -- 计息频率
            ,fcoupon_date -- 首次付息日
            ,payment_freq -- 付息频率
            ,compound_freq -- 复利频率
            ,option_type -- 选择权类别
            ,back_amt -- 每期还本金额
            ,number_issued -- 发行金额
            ,aution_rate -- 标售利率
            ,aution_price -- 发行价格
            ,first_trade_date -- 上市交易日
            ,market_type -- 市场类别
            ,repo_ratio -- 质押比
            ,security_short_name -- 债券简称
            ,convertable -- 是否是可转换债券
            ,convert_security_code -- 转换债券码
            ,discount_rate -- 是否贴现债
            ,cap -- 浮动利率上限
            ,floor -- 浮动利率下限
            ,fixing_rate_methoh -- 利率重置方法
            ,note -- 债券备注
            ,floating_rate_scale -- 利率小数位数
            ,stop_trade_date -- 停止流通日
            ,collateral_id -- 担保品
            ,floater_factor_op -- 浮动利率重算因子运算子
            ,floater_factor -- 浮动利率重算因子
            ,fixing_rules -- 是否有利率重置公式
            ,org_term -- 原始合约上的期限
            ,org_term_mult -- 原始合约上的期限单位
            ,isjx -- 是否计应收利息
            ,modify_date -- 修改日期
            ,compound -- 是否复利
            ,security_type_new -- 债券类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_op(
            security_code -- 债券代码
            ,security_name -- 债券名称
            ,security_type -- 债券类别
            ,issuer -- 发行人
            ,guarantee -- 担保人
            ,ccy -- 本金币种
            ,int_ccy -- 利息币种
            ,issue_date -- 发行日
            ,start_coupon_date -- 起息日
            ,maturity_date -- 到期日
            ,lot_size -- 债券发行最小单位
            ,day_count -- 计息基准
            ,rate_type -- 利率方式
            ,fixed_rate -- 票面利率
            ,floating_rate -- 基准利率
            ,floating_rate_ind -- 浮动方向
            ,floating_spread -- 基本利差
            ,fixing_freq -- 重置频率
            ,ffixing_date -- 首次利率重置日
            ,coupon_freq -- 计息频率
            ,fcoupon_date -- 首次付息日
            ,payment_freq -- 付息频率
            ,compound_freq -- 复利频率
            ,option_type -- 选择权类别
            ,back_amt -- 每期还本金额
            ,number_issued -- 发行金额
            ,aution_rate -- 标售利率
            ,aution_price -- 发行价格
            ,first_trade_date -- 上市交易日
            ,market_type -- 市场类别
            ,repo_ratio -- 质押比
            ,security_short_name -- 债券简称
            ,convertable -- 是否是可转换债券
            ,convert_security_code -- 转换债券码
            ,discount_rate -- 是否贴现债
            ,cap -- 浮动利率上限
            ,floor -- 浮动利率下限
            ,fixing_rate_methoh -- 利率重置方法
            ,note -- 债券备注
            ,floating_rate_scale -- 利率小数位数
            ,stop_trade_date -- 停止流通日
            ,collateral_id -- 担保品
            ,floater_factor_op -- 浮动利率重算因子运算子
            ,floater_factor -- 浮动利率重算因子
            ,fixing_rules -- 是否有利率重置公式
            ,org_term -- 原始合约上的期限
            ,org_term_mult -- 原始合约上的期限单位
            ,isjx -- 是否计应收利息
            ,modify_date -- 修改日期
            ,compound -- 是否复利
            ,security_type_new -- 债券类别
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.security_code -- 债券代码
    ,o.security_name -- 债券名称
    ,o.security_type -- 债券类别
    ,o.issuer -- 发行人
    ,o.guarantee -- 担保人
    ,o.ccy -- 本金币种
    ,o.int_ccy -- 利息币种
    ,o.issue_date -- 发行日
    ,o.start_coupon_date -- 起息日
    ,o.maturity_date -- 到期日
    ,o.lot_size -- 债券发行最小单位
    ,o.day_count -- 计息基准
    ,o.rate_type -- 利率方式
    ,o.fixed_rate -- 票面利率
    ,o.floating_rate -- 基准利率
    ,o.floating_rate_ind -- 浮动方向
    ,o.floating_spread -- 基本利差
    ,o.fixing_freq -- 重置频率
    ,o.ffixing_date -- 首次利率重置日
    ,o.coupon_freq -- 计息频率
    ,o.fcoupon_date -- 首次付息日
    ,o.payment_freq -- 付息频率
    ,o.compound_freq -- 复利频率
    ,o.option_type -- 选择权类别
    ,o.back_amt -- 每期还本金额
    ,o.number_issued -- 发行金额
    ,o.aution_rate -- 标售利率
    ,o.aution_price -- 发行价格
    ,o.first_trade_date -- 上市交易日
    ,o.market_type -- 市场类别
    ,o.repo_ratio -- 质押比
    ,o.security_short_name -- 债券简称
    ,o.convertable -- 是否是可转换债券
    ,o.convert_security_code -- 转换债券码
    ,o.discount_rate -- 是否贴现债
    ,o.cap -- 浮动利率上限
    ,o.floor -- 浮动利率下限
    ,o.fixing_rate_methoh -- 利率重置方法
    ,o.note -- 债券备注
    ,o.floating_rate_scale -- 利率小数位数
    ,o.stop_trade_date -- 停止流通日
    ,o.collateral_id -- 担保品
    ,o.floater_factor_op -- 浮动利率重算因子运算子
    ,o.floater_factor -- 浮动利率重算因子
    ,o.fixing_rules -- 是否有利率重置公式
    ,o.org_term -- 原始合约上的期限
    ,o.org_term_mult -- 原始合约上的期限单位
    ,o.isjx -- 是否计应收利息
    ,o.modify_date -- 修改日期
    ,o.compound -- 是否复利
    ,o.security_type_new -- 债券类别
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_security_bk o
    left join ${iol_schema}.ctms_tbs_v_security_op n
        on
            o.security_code = n.security_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_security_cl d
        on
            o.security_code = d.security_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_security;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_security exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_security_cl;
alter table ${iol_schema}.ctms_tbs_v_security exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_security_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_security to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_security_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_security',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
