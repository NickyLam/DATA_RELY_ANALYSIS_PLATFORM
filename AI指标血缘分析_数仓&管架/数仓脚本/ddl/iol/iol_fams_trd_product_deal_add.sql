/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_trd_product_deal_add
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_trd_product_deal_add
whenever sqlerror continue none;
drop table ${iol_schema}.fams_trd_product_deal_add purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_trd_product_deal_add(
    trade_id varchar2(36) -- 交易编号
    ,portfolio_id varchar2(50) -- 投资组合代码
    ,custom_cash_type varchar2(50) -- 自定义现金流类型
    ,gen_type varchar2(50) -- 生成方式：接口接入、画面录入、批处理生成
    ,pur_cfm_date date -- 预计申购确认日
    ,red_cfm_date date -- 预计赎回到账日
    ,reg_date date -- 权益登记日
    ,bonus_cfm_date date -- 预计分红日
    ,entrust_id varchar2(32) -- 委托代码
    ,pay_type varchar2(50) -- 支付类型，交易方向为分红除权时填写，红利再投、现金分红
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,red_profit number(30,2) -- 赎回收益
    ,red_cost number(30,2) -- 赎回成本
    ,reg_date_amt number(30,4) -- 
    ,mp_finprod_id varchar2(32) -- 主协议金融产品代码
    ,mp_branch number(10) -- 主协议分支序号
    ,deal_mode varchar2(50) -- 处理模式
    ,exc_deal_type varchar2(50) -- 外汇交易类型
    ,cur_pair varchar2(50) -- 货币对
    ,term_type varchar2(50) -- 期限品种
    ,usd_amt number(30,2) -- 折美元金额
    ,our_role varchar2(50) -- 我方角色
    ,quot_pre number(30,2) -- 报价精度
    ,priced_date date -- 定价日
    ,priced_date_rate number(30,14) -- 定价日即期汇率
    ,dif_pay_amt number(30,2) -- 差额收付金额
    ,dif_pay_ccy varchar2(50) -- 差额收付币种
    ,dif_ps varchar2(50) -- 差额收付方向
    ,lock_mdate date -- 锁定期截止日
    ,with_lock_period varchar2(50) -- 是否有锁定期
    ,ref_rate varchar2(50) -- 差额交割参考汇率
    ,deviation number(30,14) -- 偏离度
    ,asset_recommand_org varchar2(32) -- 资产推荐方
    ,exp_con_value number(30,2) -- 预计转股价值
    ,deposit_amt number(30,2) -- 保证金金额
    ,r_finprod_id varchar2(50) -- 转换资产代码
    ,terminate_rate number(30,4) -- 提前终止利率
    ,penalty_intamt number(30,4) -- 罚息金额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_trd_product_deal_add to ${iml_schema};
grant select on ${iol_schema}.fams_trd_product_deal_add to ${icl_schema};
grant select on ${iol_schema}.fams_trd_product_deal_add to ${idl_schema};
grant select on ${iol_schema}.fams_trd_product_deal_add to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_trd_product_deal_add is '金融产品交易附属表';
comment on column ${iol_schema}.fams_trd_product_deal_add.trade_id is '交易编号';
comment on column ${iol_schema}.fams_trd_product_deal_add.portfolio_id is '投资组合代码';
comment on column ${iol_schema}.fams_trd_product_deal_add.custom_cash_type is '自定义现金流类型';
comment on column ${iol_schema}.fams_trd_product_deal_add.gen_type is '生成方式：接口接入、画面录入、批处理生成';
comment on column ${iol_schema}.fams_trd_product_deal_add.pur_cfm_date is '预计申购确认日';
comment on column ${iol_schema}.fams_trd_product_deal_add.red_cfm_date is '预计赎回到账日';
comment on column ${iol_schema}.fams_trd_product_deal_add.reg_date is '权益登记日';
comment on column ${iol_schema}.fams_trd_product_deal_add.bonus_cfm_date is '预计分红日';
comment on column ${iol_schema}.fams_trd_product_deal_add.entrust_id is '委托代码';
comment on column ${iol_schema}.fams_trd_product_deal_add.pay_type is '支付类型，交易方向为分红除权时填写，红利再投、现金分红';
comment on column ${iol_schema}.fams_trd_product_deal_add.create_user is '创建人';
comment on column ${iol_schema}.fams_trd_product_deal_add.create_dept is '创建部门';
comment on column ${iol_schema}.fams_trd_product_deal_add.create_time is '创建时间';
comment on column ${iol_schema}.fams_trd_product_deal_add.update_user is '更新人';
comment on column ${iol_schema}.fams_trd_product_deal_add.update_time is '更新时间';
comment on column ${iol_schema}.fams_trd_product_deal_add.red_profit is '赎回收益';
comment on column ${iol_schema}.fams_trd_product_deal_add.red_cost is '赎回成本';
comment on column ${iol_schema}.fams_trd_product_deal_add.reg_date_amt is '';
comment on column ${iol_schema}.fams_trd_product_deal_add.mp_finprod_id is '主协议金融产品代码';
comment on column ${iol_schema}.fams_trd_product_deal_add.mp_branch is '主协议分支序号';
comment on column ${iol_schema}.fams_trd_product_deal_add.deal_mode is '处理模式';
comment on column ${iol_schema}.fams_trd_product_deal_add.exc_deal_type is '外汇交易类型';
comment on column ${iol_schema}.fams_trd_product_deal_add.cur_pair is '货币对';
comment on column ${iol_schema}.fams_trd_product_deal_add.term_type is '期限品种';
comment on column ${iol_schema}.fams_trd_product_deal_add.usd_amt is '折美元金额';
comment on column ${iol_schema}.fams_trd_product_deal_add.our_role is '我方角色';
comment on column ${iol_schema}.fams_trd_product_deal_add.quot_pre is '报价精度';
comment on column ${iol_schema}.fams_trd_product_deal_add.priced_date is '定价日';
comment on column ${iol_schema}.fams_trd_product_deal_add.priced_date_rate is '定价日即期汇率';
comment on column ${iol_schema}.fams_trd_product_deal_add.dif_pay_amt is '差额收付金额';
comment on column ${iol_schema}.fams_trd_product_deal_add.dif_pay_ccy is '差额收付币种';
comment on column ${iol_schema}.fams_trd_product_deal_add.dif_ps is '差额收付方向';
comment on column ${iol_schema}.fams_trd_product_deal_add.lock_mdate is '锁定期截止日';
comment on column ${iol_schema}.fams_trd_product_deal_add.with_lock_period is '是否有锁定期';
comment on column ${iol_schema}.fams_trd_product_deal_add.ref_rate is '差额交割参考汇率';
comment on column ${iol_schema}.fams_trd_product_deal_add.deviation is '偏离度';
comment on column ${iol_schema}.fams_trd_product_deal_add.asset_recommand_org is '资产推荐方';
comment on column ${iol_schema}.fams_trd_product_deal_add.exp_con_value is '预计转股价值';
comment on column ${iol_schema}.fams_trd_product_deal_add.deposit_amt is '保证金金额';
comment on column ${iol_schema}.fams_trd_product_deal_add.r_finprod_id is '转换资产代码';
comment on column ${iol_schema}.fams_trd_product_deal_add.terminate_rate is '提前终止利率';
comment on column ${iol_schema}.fams_trd_product_deal_add.penalty_intamt is '罚息金额';
comment on column ${iol_schema}.fams_trd_product_deal_add.start_dt is '开始时间';
comment on column ${iol_schema}.fams_trd_product_deal_add.end_dt is '结束时间';
comment on column ${iol_schema}.fams_trd_product_deal_add.id_mark is '增删标志';
comment on column ${iol_schema}.fams_trd_product_deal_add.etl_timestamp is 'ETL处理时间戳';
