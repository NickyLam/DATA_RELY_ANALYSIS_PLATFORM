/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbtotdailyprofitloss
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbtotdailyprofitloss
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbtotdailyprofitloss purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbtotdailyprofitloss(
    in_client_no varchar2(30) -- 内部客户号
    ,bank_acc varchar2(64) -- 银行账号
    ,bank_no varchar2(32) -- 银行编号
    ,client_no varchar2(36) -- 客户号
    ,ta_code varchar2(18) -- ta代码
    ,prd_code varchar2(32) -- 产品代码
    ,nav number(18,8) -- 产品净值
    ,record_date number(22,0) -- 记录日期
    ,beg_date number(22,0) -- 期初日期
    ,beg_nav number(18,8) -- 期初净值
    ,end_date number(22,0) -- 期末日期
    ,end_nav number(18,8) -- 期末净值
    ,tot_vol number(22,3) -- 总份额
    ,allot_amt number(18,2) -- 认购金额
    ,allot_cfm_amt number(18,2) -- 认购确认金额
    ,sub_amt number(18,2) -- 申购金额
    ,auto_sub_amt number(18,2) -- 定投金额
    ,conv_in_amt number(18,2) -- 转换入金额
    ,trust_in_amt number(18,2) -- 转托管入金额
    ,assign_in_amt number(18,2) -- 非交易过户入金额
    ,force_add_amt number(18,2) -- 份额强增折算金额
    ,red_amt number(18,2) -- 赎回金额
    ,force_red_amt number(18,2) -- 强制赎回金额
    ,conv_out_amt number(18,2) -- 转换出金额
    ,trust_out_amt number(18,2) -- 转托管出金额
    ,assign_out_amt number(18,2) -- 非交易过户出金额
    ,div_vol_amt number(18,2) -- 分红份额金额
    ,div_vol number(22,3) -- 分红份额
    ,div_amt number(18,2) -- 分红金额
    ,fund_end_amt number(18,2) -- 基金清盘及终止金额
    ,force_sub_amt number(18,2) -- 份额强减折算金额
    ,income_rate number(9,8) -- 日涨幅率
    ,total_cost number(18,2) -- 总成本
    ,total_income number(18,2) -- 总收益
    ,avg_price number(22,8) -- 平均成本单价
    ,amt1 number(22,6) -- 备用金额1
    ,amt2 number(22,6) -- 备用金额2
    ,amt3 number(22,6) -- 备用金额3
    ,reserve1 varchar2(375) -- 备用字段1
    ,reserve2 varchar2(375) -- 备用字段2
    ,reserve3 varchar2(375) -- 备用字段3
    ,avg_hold_price number(20,8) -- 平均持有成本
    ,hold_profit_loss number(18,2) -- 持有收益金额
    ,old_hold_profit_loss number(18,2) -- 原持有浮动收益
    ,hold_tot_cost number(18,2) -- 持有总成本
    ,bag_total_income number(18,2) -- 原总收益
    ,day_rate number(18,8) -- 昨日涨幅
    ,income_new number(18,2) -- 日涨幅
    ,nav_date number(22,0) -- 净值日期
    ,profit_loss number(24,8) -- 浮动收益
    ,bag_cost number(18,2) -- 原投资成本
    ,bag_div_amt number(18,2) -- 原累计流出现金分红
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
grant select on ${iol_schema}.nfss_tbtotdailyprofitloss to ${iml_schema};
grant select on ${iol_schema}.nfss_tbtotdailyprofitloss to ${icl_schema};
grant select on ${iol_schema}.nfss_tbtotdailyprofitloss to ${idl_schema};
grant select on ${iol_schema}.nfss_tbtotdailyprofitloss to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbtotdailyprofitloss is '客户历史累计收益记录';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.in_client_no is '内部客户号';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.bank_acc is '银行账号';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.bank_no is '银行编号';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.client_no is '客户号';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.nav is '产品净值';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.record_date is '记录日期';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.beg_date is '期初日期';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.beg_nav is '期初净值';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.end_date is '期末日期';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.end_nav is '期末净值';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.tot_vol is '总份额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.allot_amt is '认购金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.allot_cfm_amt is '认购确认金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.sub_amt is '申购金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.auto_sub_amt is '定投金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.conv_in_amt is '转换入金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.trust_in_amt is '转托管入金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.assign_in_amt is '非交易过户入金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.force_add_amt is '份额强增折算金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.red_amt is '赎回金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.force_red_amt is '强制赎回金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.conv_out_amt is '转换出金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.trust_out_amt is '转托管出金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.assign_out_amt is '非交易过户出金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.div_vol_amt is '分红份额金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.div_vol is '分红份额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.div_amt is '分红金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.fund_end_amt is '基金清盘及终止金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.force_sub_amt is '份额强减折算金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.income_rate is '日涨幅率';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.total_cost is '总成本';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.total_income is '总收益';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.avg_price is '平均成本单价';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.amt3 is '备用金额3';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.reserve1 is '备用字段1';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.reserve2 is '备用字段2';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.reserve3 is '备用字段3';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.avg_hold_price is '平均持有成本';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.hold_profit_loss is '持有收益金额';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.old_hold_profit_loss is '原持有浮动收益';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.hold_tot_cost is '持有总成本';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.bag_total_income is '原总收益';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.day_rate is '昨日涨幅';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.income_new is '日涨幅';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.nav_date is '净值日期';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.profit_loss is '浮动收益';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.bag_cost is '原投资成本';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.bag_div_amt is '原累计流出现金分红';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_tbtotdailyprofitloss.etl_timestamp is 'ETL处理时间戳';
