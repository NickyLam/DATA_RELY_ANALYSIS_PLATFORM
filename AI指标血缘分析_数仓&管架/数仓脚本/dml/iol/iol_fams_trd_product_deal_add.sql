/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_trd_product_deal_add
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
create table ${iol_schema}.fams_trd_product_deal_add_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_trd_product_deal_add;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_trd_product_deal_add_op purge;
drop table ${iol_schema}.fams_trd_product_deal_add_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_trd_product_deal_add_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_trd_product_deal_add where 0=1;

create table ${iol_schema}.fams_trd_product_deal_add_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_trd_product_deal_add where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_trd_product_deal_add_cl(
            trade_id -- 交易编号
            ,portfolio_id -- 投资组合代码
            ,custom_cash_type -- 自定义现金流类型
            ,gen_type -- 生成方式：接口接入、画面录入、批处理生成
            ,pur_cfm_date -- 预计申购确认日
            ,red_cfm_date -- 预计赎回到账日
            ,reg_date -- 权益登记日
            ,bonus_cfm_date -- 预计分红日
            ,entrust_id -- 委托代码
            ,pay_type -- 支付类型，交易方向为分红除权时填写，红利再投、现金分红
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,red_profit -- 赎回收益
            ,red_cost -- 赎回成本
            ,reg_date_amt -- 
            ,mp_finprod_id -- 主协议金融产品代码
            ,mp_branch -- 主协议分支序号
            ,deal_mode -- 处理模式
            ,exc_deal_type -- 外汇交易类型
            ,cur_pair -- 货币对
            ,term_type -- 期限品种
            ,usd_amt -- 折美元金额
            ,our_role -- 我方角色
            ,quot_pre -- 报价精度
            ,priced_date -- 定价日
            ,priced_date_rate -- 定价日即期汇率
            ,dif_pay_amt -- 差额收付金额
            ,dif_pay_ccy -- 差额收付币种
            ,dif_ps -- 差额收付方向
            ,lock_mdate -- 锁定期截止日
            ,with_lock_period -- 是否有锁定期
            ,ref_rate -- 差额交割参考汇率
            ,deviation -- 偏离度
            ,asset_recommand_org -- 资产推荐方
            ,exp_con_value -- 预计转股价值
            ,deposit_amt -- 保证金金额
            ,r_finprod_id -- 转换资产代码
            ,terminate_rate -- 提前终止利率
            ,penalty_intamt -- 罚息金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_trd_product_deal_add_op(
            trade_id -- 交易编号
            ,portfolio_id -- 投资组合代码
            ,custom_cash_type -- 自定义现金流类型
            ,gen_type -- 生成方式：接口接入、画面录入、批处理生成
            ,pur_cfm_date -- 预计申购确认日
            ,red_cfm_date -- 预计赎回到账日
            ,reg_date -- 权益登记日
            ,bonus_cfm_date -- 预计分红日
            ,entrust_id -- 委托代码
            ,pay_type -- 支付类型，交易方向为分红除权时填写，红利再投、现金分红
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,red_profit -- 赎回收益
            ,red_cost -- 赎回成本
            ,reg_date_amt -- 
            ,mp_finprod_id -- 主协议金融产品代码
            ,mp_branch -- 主协议分支序号
            ,deal_mode -- 处理模式
            ,exc_deal_type -- 外汇交易类型
            ,cur_pair -- 货币对
            ,term_type -- 期限品种
            ,usd_amt -- 折美元金额
            ,our_role -- 我方角色
            ,quot_pre -- 报价精度
            ,priced_date -- 定价日
            ,priced_date_rate -- 定价日即期汇率
            ,dif_pay_amt -- 差额收付金额
            ,dif_pay_ccy -- 差额收付币种
            ,dif_ps -- 差额收付方向
            ,lock_mdate -- 锁定期截止日
            ,with_lock_period -- 是否有锁定期
            ,ref_rate -- 差额交割参考汇率
            ,deviation -- 偏离度
            ,asset_recommand_org -- 资产推荐方
            ,exp_con_value -- 预计转股价值
            ,deposit_amt -- 保证金金额
            ,r_finprod_id -- 转换资产代码
            ,terminate_rate -- 提前终止利率
            ,penalty_intamt -- 罚息金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trade_id, o.trade_id) as trade_id -- 交易编号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投资组合代码
    ,nvl(n.custom_cash_type, o.custom_cash_type) as custom_cash_type -- 自定义现金流类型
    ,nvl(n.gen_type, o.gen_type) as gen_type -- 生成方式：接口接入、画面录入、批处理生成
    ,nvl(n.pur_cfm_date, o.pur_cfm_date) as pur_cfm_date -- 预计申购确认日
    ,nvl(n.red_cfm_date, o.red_cfm_date) as red_cfm_date -- 预计赎回到账日
    ,nvl(n.reg_date, o.reg_date) as reg_date -- 权益登记日
    ,nvl(n.bonus_cfm_date, o.bonus_cfm_date) as bonus_cfm_date -- 预计分红日
    ,nvl(n.entrust_id, o.entrust_id) as entrust_id -- 委托代码
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 支付类型，交易方向为分红除权时填写，红利再投、现金分红
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.red_profit, o.red_profit) as red_profit -- 赎回收益
    ,nvl(n.red_cost, o.red_cost) as red_cost -- 赎回成本
    ,nvl(n.reg_date_amt, o.reg_date_amt) as reg_date_amt -- 
    ,nvl(n.mp_finprod_id, o.mp_finprod_id) as mp_finprod_id -- 主协议金融产品代码
    ,nvl(n.mp_branch, o.mp_branch) as mp_branch -- 主协议分支序号
    ,nvl(n.deal_mode, o.deal_mode) as deal_mode -- 处理模式
    ,nvl(n.exc_deal_type, o.exc_deal_type) as exc_deal_type -- 外汇交易类型
    ,nvl(n.cur_pair, o.cur_pair) as cur_pair -- 货币对
    ,nvl(n.term_type, o.term_type) as term_type -- 期限品种
    ,nvl(n.usd_amt, o.usd_amt) as usd_amt -- 折美元金额
    ,nvl(n.our_role, o.our_role) as our_role -- 我方角色
    ,nvl(n.quot_pre, o.quot_pre) as quot_pre -- 报价精度
    ,nvl(n.priced_date, o.priced_date) as priced_date -- 定价日
    ,nvl(n.priced_date_rate, o.priced_date_rate) as priced_date_rate -- 定价日即期汇率
    ,nvl(n.dif_pay_amt, o.dif_pay_amt) as dif_pay_amt -- 差额收付金额
    ,nvl(n.dif_pay_ccy, o.dif_pay_ccy) as dif_pay_ccy -- 差额收付币种
    ,nvl(n.dif_ps, o.dif_ps) as dif_ps -- 差额收付方向
    ,nvl(n.lock_mdate, o.lock_mdate) as lock_mdate -- 锁定期截止日
    ,nvl(n.with_lock_period, o.with_lock_period) as with_lock_period -- 是否有锁定期
    ,nvl(n.ref_rate, o.ref_rate) as ref_rate -- 差额交割参考汇率
    ,nvl(n.deviation, o.deviation) as deviation -- 偏离度
    ,nvl(n.asset_recommand_org, o.asset_recommand_org) as asset_recommand_org -- 资产推荐方
    ,nvl(n.exp_con_value, o.exp_con_value) as exp_con_value -- 预计转股价值
    ,nvl(n.deposit_amt, o.deposit_amt) as deposit_amt -- 保证金金额
    ,nvl(n.r_finprod_id, o.r_finprod_id) as r_finprod_id -- 转换资产代码
    ,nvl(n.terminate_rate, o.terminate_rate) as terminate_rate -- 提前终止利率
    ,nvl(n.penalty_intamt, o.penalty_intamt) as penalty_intamt -- 罚息金额
    ,case when
            n.trade_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trade_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trade_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_trd_product_deal_add_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_trd_product_deal_add where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trade_id = n.trade_id
where (
        o.trade_id is null
    )
    or (
        n.trade_id is null
    )
    or (
        o.portfolio_id <> n.portfolio_id
        or o.custom_cash_type <> n.custom_cash_type
        or o.gen_type <> n.gen_type
        or o.pur_cfm_date <> n.pur_cfm_date
        or o.red_cfm_date <> n.red_cfm_date
        or o.reg_date <> n.reg_date
        or o.bonus_cfm_date <> n.bonus_cfm_date
        or o.entrust_id <> n.entrust_id
        or o.pay_type <> n.pay_type
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.red_profit <> n.red_profit
        or o.red_cost <> n.red_cost
        or o.reg_date_amt <> n.reg_date_amt
        or o.mp_finprod_id <> n.mp_finprod_id
        or o.mp_branch <> n.mp_branch
        or o.deal_mode <> n.deal_mode
        or o.exc_deal_type <> n.exc_deal_type
        or o.cur_pair <> n.cur_pair
        or o.term_type <> n.term_type
        or o.usd_amt <> n.usd_amt
        or o.our_role <> n.our_role
        or o.quot_pre <> n.quot_pre
        or o.priced_date <> n.priced_date
        or o.priced_date_rate <> n.priced_date_rate
        or o.dif_pay_amt <> n.dif_pay_amt
        or o.dif_pay_ccy <> n.dif_pay_ccy
        or o.dif_ps <> n.dif_ps
        or o.lock_mdate <> n.lock_mdate
        or o.with_lock_period <> n.with_lock_period
        or o.ref_rate <> n.ref_rate
        or o.deviation <> n.deviation
        or o.asset_recommand_org <> n.asset_recommand_org
        or o.exp_con_value <> n.exp_con_value
        or o.deposit_amt <> n.deposit_amt
        or o.r_finprod_id <> n.r_finprod_id
        or o.terminate_rate <> n.terminate_rate
        or o.penalty_intamt <> n.penalty_intamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_trd_product_deal_add_cl(
            trade_id -- 交易编号
            ,portfolio_id -- 投资组合代码
            ,custom_cash_type -- 自定义现金流类型
            ,gen_type -- 生成方式：接口接入、画面录入、批处理生成
            ,pur_cfm_date -- 预计申购确认日
            ,red_cfm_date -- 预计赎回到账日
            ,reg_date -- 权益登记日
            ,bonus_cfm_date -- 预计分红日
            ,entrust_id -- 委托代码
            ,pay_type -- 支付类型，交易方向为分红除权时填写，红利再投、现金分红
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,red_profit -- 赎回收益
            ,red_cost -- 赎回成本
            ,reg_date_amt -- 
            ,mp_finprod_id -- 主协议金融产品代码
            ,mp_branch -- 主协议分支序号
            ,deal_mode -- 处理模式
            ,exc_deal_type -- 外汇交易类型
            ,cur_pair -- 货币对
            ,term_type -- 期限品种
            ,usd_amt -- 折美元金额
            ,our_role -- 我方角色
            ,quot_pre -- 报价精度
            ,priced_date -- 定价日
            ,priced_date_rate -- 定价日即期汇率
            ,dif_pay_amt -- 差额收付金额
            ,dif_pay_ccy -- 差额收付币种
            ,dif_ps -- 差额收付方向
            ,lock_mdate -- 锁定期截止日
            ,with_lock_period -- 是否有锁定期
            ,ref_rate -- 差额交割参考汇率
            ,deviation -- 偏离度
            ,asset_recommand_org -- 资产推荐方
            ,exp_con_value -- 预计转股价值
            ,deposit_amt -- 保证金金额
            ,r_finprod_id -- 转换资产代码
            ,terminate_rate -- 提前终止利率
            ,penalty_intamt -- 罚息金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_trd_product_deal_add_op(
            trade_id -- 交易编号
            ,portfolio_id -- 投资组合代码
            ,custom_cash_type -- 自定义现金流类型
            ,gen_type -- 生成方式：接口接入、画面录入、批处理生成
            ,pur_cfm_date -- 预计申购确认日
            ,red_cfm_date -- 预计赎回到账日
            ,reg_date -- 权益登记日
            ,bonus_cfm_date -- 预计分红日
            ,entrust_id -- 委托代码
            ,pay_type -- 支付类型，交易方向为分红除权时填写，红利再投、现金分红
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,red_profit -- 赎回收益
            ,red_cost -- 赎回成本
            ,reg_date_amt -- 
            ,mp_finprod_id -- 主协议金融产品代码
            ,mp_branch -- 主协议分支序号
            ,deal_mode -- 处理模式
            ,exc_deal_type -- 外汇交易类型
            ,cur_pair -- 货币对
            ,term_type -- 期限品种
            ,usd_amt -- 折美元金额
            ,our_role -- 我方角色
            ,quot_pre -- 报价精度
            ,priced_date -- 定价日
            ,priced_date_rate -- 定价日即期汇率
            ,dif_pay_amt -- 差额收付金额
            ,dif_pay_ccy -- 差额收付币种
            ,dif_ps -- 差额收付方向
            ,lock_mdate -- 锁定期截止日
            ,with_lock_period -- 是否有锁定期
            ,ref_rate -- 差额交割参考汇率
            ,deviation -- 偏离度
            ,asset_recommand_org -- 资产推荐方
            ,exp_con_value -- 预计转股价值
            ,deposit_amt -- 保证金金额
            ,r_finprod_id -- 转换资产代码
            ,terminate_rate -- 提前终止利率
            ,penalty_intamt -- 罚息金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trade_id -- 交易编号
    ,o.portfolio_id -- 投资组合代码
    ,o.custom_cash_type -- 自定义现金流类型
    ,o.gen_type -- 生成方式：接口接入、画面录入、批处理生成
    ,o.pur_cfm_date -- 预计申购确认日
    ,o.red_cfm_date -- 预计赎回到账日
    ,o.reg_date -- 权益登记日
    ,o.bonus_cfm_date -- 预计分红日
    ,o.entrust_id -- 委托代码
    ,o.pay_type -- 支付类型，交易方向为分红除权时填写，红利再投、现金分红
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.red_profit -- 赎回收益
    ,o.red_cost -- 赎回成本
    ,o.reg_date_amt -- 
    ,o.mp_finprod_id -- 主协议金融产品代码
    ,o.mp_branch -- 主协议分支序号
    ,o.deal_mode -- 处理模式
    ,o.exc_deal_type -- 外汇交易类型
    ,o.cur_pair -- 货币对
    ,o.term_type -- 期限品种
    ,o.usd_amt -- 折美元金额
    ,o.our_role -- 我方角色
    ,o.quot_pre -- 报价精度
    ,o.priced_date -- 定价日
    ,o.priced_date_rate -- 定价日即期汇率
    ,o.dif_pay_amt -- 差额收付金额
    ,o.dif_pay_ccy -- 差额收付币种
    ,o.dif_ps -- 差额收付方向
    ,o.lock_mdate -- 锁定期截止日
    ,o.with_lock_period -- 是否有锁定期
    ,o.ref_rate -- 差额交割参考汇率
    ,o.deviation -- 偏离度
    ,o.asset_recommand_org -- 资产推荐方
    ,o.exp_con_value -- 预计转股价值
    ,o.deposit_amt -- 保证金金额
    ,o.r_finprod_id -- 转换资产代码
    ,o.terminate_rate -- 提前终止利率
    ,o.penalty_intamt -- 罚息金额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_trd_product_deal_add_bk o
    left join ${iol_schema}.fams_trd_product_deal_add_op n
        on
            o.trade_id = n.trade_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_trd_product_deal_add_cl d
        on
            o.trade_id = d.trade_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_trd_product_deal_add;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_trd_product_deal_add exchange partition p_19000101 with table ${iol_schema}.fams_trd_product_deal_add_cl;
alter table ${iol_schema}.fams_trd_product_deal_add exchange partition p_20991231 with table ${iol_schema}.fams_trd_product_deal_add_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_trd_product_deal_add to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_trd_product_deal_add_op purge;
drop table ${iol_schema}.fams_trd_product_deal_add_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_trd_product_deal_add_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_trd_product_deal_add',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
