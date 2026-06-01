/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_agent_consmt_lot_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_agent_consmt_lot_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_agent_consmt_lot_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_agent_consmt_lot_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(10) -- TA代码
    ,prod_id varchar2(60) -- 产品编号
    ,std_prod_id varchar2(500) -- 标准产品编号
    ,tran_acct_id varchar2(60) -- 交易账户编号
    ,consmt_bus_type_cd varchar2(10) -- 代销业务类型代码
    ,cap_stl_acct_num varchar2(60) -- 资金结算账号
    ,cust_id varchar2(60) -- 客户编号
    ,cont_id varchar2(60) -- 合约编号
    ,belong_org_id varchar2(60) -- 归属机构编号
    ,bank_id varchar2(60) -- 银行编号
    ,seller_id varchar2(60) -- 销售商编号
    ,ec_flg_cd varchar2(10) -- 钞汇标志代码
    ,divd_way_cd varchar2(10) -- 分红方式代码
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,lot_type_cd varchar2(10) -- 份额类型代码
    ,comb_sell_flag varchar2(10) -- 组合销售标志
    ,comb_prod_id varchar2(100) -- 组合产品编号
    ,fir_subscr_dt date -- 首次认购日期
    ,final_activ_acct_dt date -- 最后动户日期
    ,actl_value_dt date -- 实际起息日期
    ,actl_exp_dt date -- 实际到期日期
    ,divd_ratio number(18,8) -- 分红比例
    ,yld_rat number(18,8) -- 收益率
    ,acm_prft number(30,2) -- 累计收益
    ,unpaid_prft number(30,2) -- 未付收益
    ,froz_unpaid_prft number(30,2) -- 冻结未付收益
    ,curr_issue_prft number(30,2) -- 本期收益
    ,td_prft number(30,2) -- 本日收益
    ,tran_froz_lot number(30,2) -- 交易冻结份额
    ,lonterm_froz_lot number(30,2) -- 长期冻结份额
    ,loc_froz_lot number(30,2) -- 本地冻结份额
    ,ld_tot_lot number(30,2) -- 上日总份额
    ,uncfm_prod_amt number(30,2) -- 未确认产品金额
    ,redem_amt number(30,2) -- 赎回金额
    ,buy_cost number(30,2) -- 买入成本
    ,tot_lot number(30,2) -- 总份额
    ,nv number(18,8) -- 净值
    ,curr_bal number(30,8) -- 当前余额
    ,ear_d_bal number(30,8) -- 日初余额
    ,ear_m_bal number(30,8) -- 月初余额
    ,ear_s_bal number(30,8) -- 季初余额
    ,ear_y_bal number(30,8) -- 年初余额
    ,y_acm_bal number(30,8) -- 年累计余额
    ,s_acm_bal number(30,8) -- 季累计余额
    ,m_acm_bal number(30,8) -- 月累计余额
    ,y_avg_bal number(30,8) -- 年日均余额
    ,q_avg_bal number(30,8) -- 季日均余额
    ,m_avg_bal number(30,8) -- 月日均余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_agent_consmt_lot_info to ${idl_schema};
grant select on ${icl_schema}.cmm_agent_consmt_lot_info to ${iel_schema};
grant select on ${icl_schema}.cmm_agent_consmt_lot_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_agent_consmt_lot_info is '代理代销份额信息';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.ta_cd is 'TA代码';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.tran_acct_id is '交易账户编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.consmt_bus_type_cd is '代销业务类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.cap_stl_acct_num is '资金结算账号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.cont_id is '合约编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.belong_org_id is '归属机构编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.bank_id is '银行编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.seller_id is '销售商编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.ec_flg_cd is '钞汇标志代码';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.divd_way_cd is '分红方式代码';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.lot_type_cd is '份额类型代码';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.comb_sell_flag is '组合销售标志';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.comb_prod_id is '组合产品编号';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.fir_subscr_dt is '首次认购日期';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.final_activ_acct_dt is '最后动户日期';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.actl_value_dt is '实际起息日期';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.actl_exp_dt is '实际到期日期';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.divd_ratio is '分红比例';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.yld_rat is '收益率';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.acm_prft is '累计收益';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.unpaid_prft is '未付收益';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.froz_unpaid_prft is '冻结未付收益';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.curr_issue_prft is '本期收益';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.td_prft is '本日收益';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.tran_froz_lot is '交易冻结份额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.lonterm_froz_lot is '长期冻结份额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.loc_froz_lot is '本地冻结份额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.ld_tot_lot is '上日总份额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.uncfm_prod_amt is '未确认产品金额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.redem_amt is '赎回金额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.buy_cost is '买入成本';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.tot_lot is '总份额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.nv is '净值';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.curr_bal is '当前余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_agent_consmt_lot_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_agent_consmt_lot_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_agent_consmt_lot_info.etl_timestamp is 'ETL处理时间戳';
