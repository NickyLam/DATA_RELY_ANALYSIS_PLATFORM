/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharenonprofitloss
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharenonprofitloss
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharenonprofitloss purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharenonprofitloss(
    object_id varchar2(57) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司id
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(120) -- 报表类型
    ,crncy_code varchar2(15) -- 货币代码
    ,non_current_gains_losses number(20,4) -- 非流动资产处置损益
    ,tax_return number(20,4) -- 税收返还减免
    ,government_subsidy number(20,4) -- 政府补助
    ,capital_occupation_fee number(20,4) -- 资金占用费
    ,consolidated_gains_losses number(20,4) -- 企业合并产生的损益
    ,non_assets_gains_losses number(20,4) -- 非货币性资产交换损益
    ,investment_gains_losses number(20,4) -- 委托投资损益
    ,impairment_assets number(20,4) -- 资产减值准备
    ,debt_restructuring number(20,4) -- 债务重组损益
    ,enterprise_restructuring number(20,4) -- 企业重组费用
    ,trading_price_unfair number(20,4) -- 交易价格显失公允产生的损益
    ,net_profit_loss_subsidiaries number(20,4) -- 同一控制下企业合并产生的子公司净损益
    ,expected_liabilities number(20,4) -- 预计负债产生的损益
    ,onoiae number(20,4) -- 其他营业外收支净额
    ,other_projects number(20,4) -- 其他项目
    ,non_recurring_gains_losses number(20,4) -- 非经常性损益项目小计
    ,income_tax_impact number(20,4) -- 所得税影响数
    ,profit_loss_shareholders number(20,4) -- 少数股东损益影响数
    ,non_recurring_gains_losses1 number(20,4) -- 非经常性损益项目合计
    ,s_fa_deductedprofittoprofit number(20,4) -- 扣除非经常损益后的净利润
    ,s_fa_deductedprofittoprofit1 number(20,4) -- 扣除非经常损益后的归属公司股东的净利润
    ,fairvalue_change_gains_losses number(20,4) -- 持有(或处置)交易性金融资产和负债产生的公允价值变动损益
    ,provision_impairment_reversed number(20,4) -- 单独进行监制测试的应收款项减值准备转回
    ,proceeds_loan number(20,4) -- 对外委托贷款取得的收益
    ,changes_real_estate_value number(20,4) -- 公允价值法计量的投资性房地产价值变动损益
    ,profit_loss_adjustment number(20,4) -- 法规要求一次性损益调整影响
    ,custody_fee_income number(20,4) -- 受托经营取得的托管费收入
    ,is_published number(1,0) -- 是否公布
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
grant select on ${iol_schema}.wind_asharenonprofitloss to ${iml_schema};
grant select on ${iol_schema}.wind_asharenonprofitloss to ${icl_schema};
grant select on ${iol_schema}.wind_asharenonprofitloss to ${idl_schema};
grant select on ${iol_schema}.wind_asharenonprofitloss to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharenonprofitloss is '中国A股非经常性损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharenonprofitloss.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_asharenonprofitloss.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_asharenonprofitloss.report_period is '报告期';
comment on column ${iol_schema}.wind_asharenonprofitloss.statement_type is '报表类型';
comment on column ${iol_schema}.wind_asharenonprofitloss.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_asharenonprofitloss.non_current_gains_losses is '非流动资产处置损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.tax_return is '税收返还减免';
comment on column ${iol_schema}.wind_asharenonprofitloss.government_subsidy is '政府补助';
comment on column ${iol_schema}.wind_asharenonprofitloss.capital_occupation_fee is '资金占用费';
comment on column ${iol_schema}.wind_asharenonprofitloss.consolidated_gains_losses is '企业合并产生的损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.non_assets_gains_losses is '非货币性资产交换损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.investment_gains_losses is '委托投资损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.impairment_assets is '资产减值准备';
comment on column ${iol_schema}.wind_asharenonprofitloss.debt_restructuring is '债务重组损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.enterprise_restructuring is '企业重组费用';
comment on column ${iol_schema}.wind_asharenonprofitloss.trading_price_unfair is '交易价格显失公允产生的损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.net_profit_loss_subsidiaries is '同一控制下企业合并产生的子公司净损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.expected_liabilities is '预计负债产生的损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.onoiae is '其他营业外收支净额';
comment on column ${iol_schema}.wind_asharenonprofitloss.other_projects is '其他项目';
comment on column ${iol_schema}.wind_asharenonprofitloss.non_recurring_gains_losses is '非经常性损益项目小计';
comment on column ${iol_schema}.wind_asharenonprofitloss.income_tax_impact is '所得税影响数';
comment on column ${iol_schema}.wind_asharenonprofitloss.profit_loss_shareholders is '少数股东损益影响数';
comment on column ${iol_schema}.wind_asharenonprofitloss.non_recurring_gains_losses1 is '非经常性损益项目合计';
comment on column ${iol_schema}.wind_asharenonprofitloss.s_fa_deductedprofittoprofit is '扣除非经常损益后的净利润';
comment on column ${iol_schema}.wind_asharenonprofitloss.s_fa_deductedprofittoprofit1 is '扣除非经常损益后的归属公司股东的净利润';
comment on column ${iol_schema}.wind_asharenonprofitloss.fairvalue_change_gains_losses is '持有(或处置)交易性金融资产和负债产生的公允价值变动损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.provision_impairment_reversed is '单独进行监制测试的应收款项减值准备转回';
comment on column ${iol_schema}.wind_asharenonprofitloss.proceeds_loan is '对外委托贷款取得的收益';
comment on column ${iol_schema}.wind_asharenonprofitloss.changes_real_estate_value is '公允价值法计量的投资性房地产价值变动损益';
comment on column ${iol_schema}.wind_asharenonprofitloss.profit_loss_adjustment is '法规要求一次性损益调整影响';
comment on column ${iol_schema}.wind_asharenonprofitloss.custody_fee_income is '受托经营取得的托管费收入';
comment on column ${iol_schema}.wind_asharenonprofitloss.is_published is '是否公布';
comment on column ${iol_schema}.wind_asharenonprofitloss.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharenonprofitloss.etl_timestamp is 'ETL处理时间戳';
