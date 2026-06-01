/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cmfincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cmfincome
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cmfincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cmfincome(
    object_id varchar2(57) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,sec_id varchar2(15) -- 证券ID
    ,report_period varchar2(12) -- 报告期
    ,ann_dt varchar2(12) -- 公告日期
    ,is_list number(5,0) -- 是否上市后数据
    ,tot_inc number(20,4) -- 收入合计
    ,int_inc number(20,4) -- 利息收入合计
    ,cash_int_inc number(20,4) -- 存款利息收入
    ,bond_int_inc number(20,4) -- 债券利息收入
    ,abs_int_inc number(20,4) -- 资产支持证券利息收入
    ,repo_int_inc number(20,4) -- 买入返售证券收入
    ,other_int_inc number(20,4) -- 其他利息收入
    ,inv_inc number(20,4) -- 投资收益合计
    ,stock_inv_inc number(20,4) -- 股票差价收入
    ,bond_inv_inc number(20,4) -- 债券差价收入
    ,fund_inv_inc number(20,4) -- 证券买卖差价-基金
    ,abs_inv_inc number(20,4) -- 资产支持证券投资收益
    ,derivative_inv_inc number(20,4) -- 权证差价收入
    ,dvd_inc number(20,4) -- 股息收入
    ,change_fair_value number(22,4) -- 未实现利得
    ,exch_inc number(20,4) -- 汇兑收入
    ,other_inc number(20,4) -- 其它收入
    ,tot_exp number(20,4) -- 费用合计
    ,mgmt_exp number(20,4) -- 管理费
    ,cust_maint_exp number(20,4) -- 客户维护费
    ,custodian_exp number(20,4) -- 托管费
    ,selling_dist_exp number(20,4) -- 基金销售服务费
    ,trade_exp number(20,4) -- 交易费用
    ,int_exp number(20,4) -- 利息支出
    ,repo_exp number(20,4) -- 卖出回购证券支出
    ,other_exp number(20,4) -- 其他费用合计
    ,acct_exp number(20,4) -- 会计师费
    ,audit_exp number(20,4) -- 审计费用
    ,tot_profit number(22,4) -- 基金经营业绩
    ,inc_tax number(20,4) -- 所得税费用
    ,net_profit number(20,4) -- 净利润
    ,memo varchar2(1500) -- 备注
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_cmfincome to ${iml_schema};
grant select on ${iol_schema}.wind_cmfincome to ${icl_schema};
grant select on ${iol_schema}.wind_cmfincome to ${idl_schema};
grant select on ${iol_schema}.wind_cmfincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cmfincome is '中国共同基金利润表';
comment on column ${iol_schema}.wind_cmfincome.object_id is '对象ID';
comment on column ${iol_schema}.wind_cmfincome.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cmfincome.sec_id is '证券ID';
comment on column ${iol_schema}.wind_cmfincome.report_period is '报告期';
comment on column ${iol_schema}.wind_cmfincome.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_cmfincome.is_list is '是否上市后数据';
comment on column ${iol_schema}.wind_cmfincome.tot_inc is '收入合计';
comment on column ${iol_schema}.wind_cmfincome.int_inc is '利息收入合计';
comment on column ${iol_schema}.wind_cmfincome.cash_int_inc is '存款利息收入';
comment on column ${iol_schema}.wind_cmfincome.bond_int_inc is '债券利息收入';
comment on column ${iol_schema}.wind_cmfincome.abs_int_inc is '资产支持证券利息收入';
comment on column ${iol_schema}.wind_cmfincome.repo_int_inc is '买入返售证券收入';
comment on column ${iol_schema}.wind_cmfincome.other_int_inc is '其他利息收入';
comment on column ${iol_schema}.wind_cmfincome.inv_inc is '投资收益合计';
comment on column ${iol_schema}.wind_cmfincome.stock_inv_inc is '股票差价收入';
comment on column ${iol_schema}.wind_cmfincome.bond_inv_inc is '债券差价收入';
comment on column ${iol_schema}.wind_cmfincome.fund_inv_inc is '证券买卖差价-基金';
comment on column ${iol_schema}.wind_cmfincome.abs_inv_inc is '资产支持证券投资收益';
comment on column ${iol_schema}.wind_cmfincome.derivative_inv_inc is '权证差价收入';
comment on column ${iol_schema}.wind_cmfincome.dvd_inc is '股息收入';
comment on column ${iol_schema}.wind_cmfincome.change_fair_value is '未实现利得';
comment on column ${iol_schema}.wind_cmfincome.exch_inc is '汇兑收入';
comment on column ${iol_schema}.wind_cmfincome.other_inc is '其它收入';
comment on column ${iol_schema}.wind_cmfincome.tot_exp is '费用合计';
comment on column ${iol_schema}.wind_cmfincome.mgmt_exp is '管理费';
comment on column ${iol_schema}.wind_cmfincome.cust_maint_exp is '客户维护费';
comment on column ${iol_schema}.wind_cmfincome.custodian_exp is '托管费';
comment on column ${iol_schema}.wind_cmfincome.selling_dist_exp is '基金销售服务费';
comment on column ${iol_schema}.wind_cmfincome.trade_exp is '交易费用';
comment on column ${iol_schema}.wind_cmfincome.int_exp is '利息支出';
comment on column ${iol_schema}.wind_cmfincome.repo_exp is '卖出回购证券支出';
comment on column ${iol_schema}.wind_cmfincome.other_exp is '其他费用合计';
comment on column ${iol_schema}.wind_cmfincome.acct_exp is '会计师费';
comment on column ${iol_schema}.wind_cmfincome.audit_exp is '审计费用';
comment on column ${iol_schema}.wind_cmfincome.tot_profit is '基金经营业绩';
comment on column ${iol_schema}.wind_cmfincome.inc_tax is '所得税费用';
comment on column ${iol_schema}.wind_cmfincome.net_profit is '净利润';
comment on column ${iol_schema}.wind_cmfincome.memo is '备注';
comment on column ${iol_schema}.wind_cmfincome.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cmfincome.etl_timestamp is 'ETL处理时间戳';
