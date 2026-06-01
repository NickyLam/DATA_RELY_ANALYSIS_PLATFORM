/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkgsdincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkgsdincome
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkgsdincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkgsdincome(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司id
    ,ann_dt varchar2(12) -- 公告日期
    ,begin_dt varchar2(12) -- 起始日期
    ,end_dt varchar2(12) -- 截止日期
    ,report_type number(9,0) -- 报告类型代码
    ,statement_type number(9,0) -- 报表类型代码
    ,is_calc number(1,0) -- 是否计算值
    ,crncy_code varchar2(30) -- 货币代码
    ,tot_oper_rev number(20,4) -- 总营业收入
    ,bus_inc number(20,4) -- 主营收入
    ,oth_bus_inc number(20,4) -- 其他营业收入
    ,rev_comm_inc number(20,4) -- 扣除贷款损失准备前收入
    ,prov_loan_loss number(20,4) -- 贷款损失准备
    ,premiums_earned number(20,4) -- 净已赚保费
    ,trade_inc_net number(20,4) -- 交易账户净收入
    ,int_inverst_inc number(20,4) -- 利息及股息收入
    ,rev_rent number(20,4) -- 租金收入
    ,tenant_reim_exp number(20,4) -- 租户认缴物业维护综合费
    ,gain_sale_real_estate number(20,4) -- 房地产销售收入
    ,mtg_inc number(20,4) -- 抵押贷款相关收入
    ,net_int_inc number(20,4) -- 利息净收入
    ,broker_comm_inc number(20,4) -- 经纪佣金收入
    ,uw_ib_inc number(20,4) -- 承销与投资银行费收入
    ,aum_inc number(20,4) -- 资产管理费收入
    ,trade_inc number(20,4) -- 自营业务收入
    ,net_fee_inc number(20,4) -- 手续费及佣金净收入
    ,fee_inc number(20,4) -- 手续费及佣金收入
    ,fee_exp number(20,4) -- 减：手续费及佣金开支
    ,premiums_inc number(20,4) -- 毛承保保费及保单费收入
    ,reserve_chg number(20,4) -- 减:未到期责任准备金变动
    ,premium_ceded number(20,4) -- 减:分出保费
    ,tot_oper_cost number(20,4) -- 总营业支出
    ,bus_cost number(20,4) -- 营业成本
    ,oper_exp number(20,4) -- 营业开支
    ,policy_int number(20,4) -- 保单持有人利益
    ,sga_exp number(20,4) -- 销售、行政及一般费用
    ,dist_exp number(20,4) -- 营销费用
    ,admin_exp number(20,4) -- 行政(管理)费用
    ,rd_exp number(20,4) -- 研发费用
    ,oth_bus_exp number(20,4) -- 其他营业费用合计
    ,opprofit number(20,4) -- 营业利润
    ,grossmargin number(20,4) -- 毛利
    ,int_inc number(20,4) -- 利息收入
    ,int_exp number(20,4) -- 利息支出
    ,invest_gain number(20,4) -- 权益性投资损益
    ,oth_nonpo_inc number(20,4) -- 其他非经营性损益
    ,nonrecuritem_bef_profits number(20,4) -- 非经常项目前利润
    ,unusual_items number(20,4) -- 非经常项目损益
    ,inc_pretax number(20,4) -- 除税前利润(除税前盈利)
    ,tax number(20,4) -- 所得税
    ,minority_int_inc number(20,4) -- 少数股东损益
    ,noncontinuous_net_op number(20,4) -- 持续经营净利润
    ,disc_oper number(20,4) -- 非持续经营净利润
    ,oth_spec_item number(20,4) -- 其他特殊项
    ,net_profit_cs number(20,4) -- 净利润
    ,dvd_pfd_adj number(20,4) -- 优先股利及其他调整项
    ,np_belongto_commonsh number(20,4) -- 归属普通股东净利润
    ,ci_belongto_commonsh number(20,4) -- 归属普通股东综合收益
    ,tot_ci number(20,4) -- 综合收益总值
    ,inc_afttax number(20,4) -- 除税后利润(除税后但未计少数股东权益之盈利)
    ,fairvalue_chg number(20,4) -- 公平值变动损益
    ,s_info_comptype varchar2(2) -- 报告期公司类型代码
    ,s_memo varchar2(1500) -- 备注
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
grant select on ${iol_schema}.wind_hkgsdincome to ${iml_schema};
grant select on ${iol_schema}.wind_hkgsdincome to ${icl_schema};
grant select on ${iol_schema}.wind_hkgsdincome to ${idl_schema};
grant select on ${iol_schema}.wind_hkgsdincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkgsdincome is '香港股票损益表(GSD)';
comment on column ${iol_schema}.wind_hkgsdincome.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkgsdincome.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hkgsdincome.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hkgsdincome.begin_dt is '起始日期';
comment on column ${iol_schema}.wind_hkgsdincome.end_dt is '截止日期';
comment on column ${iol_schema}.wind_hkgsdincome.report_type is '报告类型代码';
comment on column ${iol_schema}.wind_hkgsdincome.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_hkgsdincome.is_calc is '是否计算值';
comment on column ${iol_schema}.wind_hkgsdincome.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hkgsdincome.tot_oper_rev is '总营业收入';
comment on column ${iol_schema}.wind_hkgsdincome.bus_inc is '主营收入';
comment on column ${iol_schema}.wind_hkgsdincome.oth_bus_inc is '其他营业收入';
comment on column ${iol_schema}.wind_hkgsdincome.rev_comm_inc is '扣除贷款损失准备前收入';
comment on column ${iol_schema}.wind_hkgsdincome.prov_loan_loss is '贷款损失准备';
comment on column ${iol_schema}.wind_hkgsdincome.premiums_earned is '净已赚保费';
comment on column ${iol_schema}.wind_hkgsdincome.trade_inc_net is '交易账户净收入';
comment on column ${iol_schema}.wind_hkgsdincome.int_inverst_inc is '利息及股息收入';
comment on column ${iol_schema}.wind_hkgsdincome.rev_rent is '租金收入';
comment on column ${iol_schema}.wind_hkgsdincome.tenant_reim_exp is '租户认缴物业维护综合费';
comment on column ${iol_schema}.wind_hkgsdincome.gain_sale_real_estate is '房地产销售收入';
comment on column ${iol_schema}.wind_hkgsdincome.mtg_inc is '抵押贷款相关收入';
comment on column ${iol_schema}.wind_hkgsdincome.net_int_inc is '利息净收入';
comment on column ${iol_schema}.wind_hkgsdincome.broker_comm_inc is '经纪佣金收入';
comment on column ${iol_schema}.wind_hkgsdincome.uw_ib_inc is '承销与投资银行费收入';
comment on column ${iol_schema}.wind_hkgsdincome.aum_inc is '资产管理费收入';
comment on column ${iol_schema}.wind_hkgsdincome.trade_inc is '自营业务收入';
comment on column ${iol_schema}.wind_hkgsdincome.net_fee_inc is '手续费及佣金净收入';
comment on column ${iol_schema}.wind_hkgsdincome.fee_inc is '手续费及佣金收入';
comment on column ${iol_schema}.wind_hkgsdincome.fee_exp is '减：手续费及佣金开支';
comment on column ${iol_schema}.wind_hkgsdincome.premiums_inc is '毛承保保费及保单费收入';
comment on column ${iol_schema}.wind_hkgsdincome.reserve_chg is '减:未到期责任准备金变动';
comment on column ${iol_schema}.wind_hkgsdincome.premium_ceded is '减:分出保费';
comment on column ${iol_schema}.wind_hkgsdincome.tot_oper_cost is '总营业支出';
comment on column ${iol_schema}.wind_hkgsdincome.bus_cost is '营业成本';
comment on column ${iol_schema}.wind_hkgsdincome.oper_exp is '营业开支';
comment on column ${iol_schema}.wind_hkgsdincome.policy_int is '保单持有人利益';
comment on column ${iol_schema}.wind_hkgsdincome.sga_exp is '销售、行政及一般费用';
comment on column ${iol_schema}.wind_hkgsdincome.dist_exp is '营销费用';
comment on column ${iol_schema}.wind_hkgsdincome.admin_exp is '行政(管理)费用';
comment on column ${iol_schema}.wind_hkgsdincome.rd_exp is '研发费用';
comment on column ${iol_schema}.wind_hkgsdincome.oth_bus_exp is '其他营业费用合计';
comment on column ${iol_schema}.wind_hkgsdincome.opprofit is '营业利润';
comment on column ${iol_schema}.wind_hkgsdincome.grossmargin is '毛利';
comment on column ${iol_schema}.wind_hkgsdincome.int_inc is '利息收入';
comment on column ${iol_schema}.wind_hkgsdincome.int_exp is '利息支出';
comment on column ${iol_schema}.wind_hkgsdincome.invest_gain is '权益性投资损益';
comment on column ${iol_schema}.wind_hkgsdincome.oth_nonpo_inc is '其他非经营性损益';
comment on column ${iol_schema}.wind_hkgsdincome.nonrecuritem_bef_profits is '非经常项目前利润';
comment on column ${iol_schema}.wind_hkgsdincome.unusual_items is '非经常项目损益';
comment on column ${iol_schema}.wind_hkgsdincome.inc_pretax is '除税前利润(除税前盈利)';
comment on column ${iol_schema}.wind_hkgsdincome.tax is '所得税';
comment on column ${iol_schema}.wind_hkgsdincome.minority_int_inc is '少数股东损益';
comment on column ${iol_schema}.wind_hkgsdincome.noncontinuous_net_op is '持续经营净利润';
comment on column ${iol_schema}.wind_hkgsdincome.disc_oper is '非持续经营净利润';
comment on column ${iol_schema}.wind_hkgsdincome.oth_spec_item is '其他特殊项';
comment on column ${iol_schema}.wind_hkgsdincome.net_profit_cs is '净利润';
comment on column ${iol_schema}.wind_hkgsdincome.dvd_pfd_adj is '优先股利及其他调整项';
comment on column ${iol_schema}.wind_hkgsdincome.np_belongto_commonsh is '归属普通股东净利润';
comment on column ${iol_schema}.wind_hkgsdincome.ci_belongto_commonsh is '归属普通股东综合收益';
comment on column ${iol_schema}.wind_hkgsdincome.tot_ci is '综合收益总值';
comment on column ${iol_schema}.wind_hkgsdincome.inc_afttax is '除税后利润(除税后但未计少数股东权益之盈利)';
comment on column ${iol_schema}.wind_hkgsdincome.fairvalue_chg is '公平值变动损益';
comment on column ${iol_schema}.wind_hkgsdincome.s_info_comptype is '报告期公司类型代码';
comment on column ${iol_schema}.wind_hkgsdincome.s_memo is '备注';
comment on column ${iol_schema}.wind_hkgsdincome.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hkgsdincome.etl_timestamp is 'ETL处理时间戳';
