/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_consmt_fund_lot_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_consmt_fund_lot_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_consmt_fund_lot_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_consmt_fund_lot_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,std_prod_id varchar2(500) -- 标准产品编号
    ,intnal_cust_id varchar2(100) -- 内部客户编号
    ,seller_id varchar2(100) -- 销售商编号
    ,bank_id varchar2(100) -- 银行编号
    ,cust_id varchar2(100) -- 客户编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,ta_tran_acct_id varchar2(100) -- TA交易账户编号
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,tran_med_type_cd varchar2(30) -- 交易介质类型代码
    ,tran_acct_id varchar2(100) -- 交易账户编号
    ,ta_cd varchar2(30) -- TA代码
    ,finc_acct_id varchar2(100) -- 理财账户编号
    ,prod_id varchar2(100) -- 产品编号
    ,cont_id varchar2(100) -- 合约编号
    ,final_chg_dt date -- 最后变动日期
    ,lot_tot number(30,2) -- 份额总数
    ,tran_froz_lot number(30,2) -- 交易冻结份额
    ,lonterm_froz_lot number(30,2) -- 长期冻结份额
    ,comb_invest_lot number(30,2) -- 组合投资份额
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,init_divd_way_cd varchar2(30) -- 原分红方式代码
    ,bonus_ratio number(30,8) -- 红利比例
    ,yd_lot_tot number(30,2) -- 昨日份额总数
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,supp_invest_flg varchar2(10) -- 追加投资标志
    ,loc_froz_lot number(30,2) -- 本地冻结份额
    ,curr_issue_prft number(30,8) -- 本期收益
    ,prft_cust_ratio number(18,6) -- 收益客户比例
    ,buy_cost number(30,2) -- 买入成本
    ,acm_inco number(30,2) -- 累计收入
    ,unpaid_prft number(30,2) -- 未付收益
    ,froz_unpaid_prft number(30,2) -- 冻结未付收益
    ,new_assign_prft number(30,2) -- 新分配收益
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_consmt_fund_lot_h to ${icl_schema};
grant select on ${iml_schema}.agt_consmt_fund_lot_h to ${idl_schema};
grant select on ${iml_schema}.agt_consmt_fund_lot_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_consmt_fund_lot_h is '代销基金份额历史';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.seller_id is '销售商编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.bank_id is '银行编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.tran_acct_id is '交易账户编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.cont_id is '合约编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.final_chg_dt is '最后变动日期';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.lot_tot is '份额总数';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.tran_froz_lot is '交易冻结份额';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.lonterm_froz_lot is '长期冻结份额';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.comb_invest_lot is '组合投资份额';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.init_divd_way_cd is '原分红方式代码';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.bonus_ratio is '红利比例';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.yd_lot_tot is '昨日份额总数';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.supp_invest_flg is '追加投资标志';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.loc_froz_lot is '本地冻结份额';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.curr_issue_prft is '本期收益';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.prft_cust_ratio is '收益客户比例';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.buy_cost is '买入成本';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.acm_inco is '累计收入';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.unpaid_prft is '未付收益';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.froz_unpaid_prft is '冻结未付收益';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.new_assign_prft is '新分配收益';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_consmt_fund_lot_h.etl_timestamp is 'ETL处理时间戳';
