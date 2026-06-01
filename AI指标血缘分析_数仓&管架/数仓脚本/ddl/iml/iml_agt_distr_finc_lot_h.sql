/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_distr_finc_lot_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_distr_finc_lot_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_distr_finc_lot_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_distr_finc_lot_h(
    finc_cust_id varchar2(60) -- 理财客户编号
    ,lp_id varchar2(60) -- 法人编号
    ,seller_id varchar2(60) -- 销售商编号
    ,bank_id varchar2(60) -- 银行编号
    ,ta_tran_acct_id varchar2(60) -- TA交易账户编号
    ,src_prod_id varchar2(60) -- 源产品编号
    ,agt_id varchar2(60) -- 协议编号
    ,bank_acct_id varchar2(60) -- 银行账户编号
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,ta_cd varchar2(30) -- TA代码
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,cust_grouping_cd varchar2(30) -- 客户分组代码
    ,supp_invest_flg varchar2(30) -- 追加投资标志
    ,lot_tot number(30,8) -- 份额总数
    ,curr_issue_prft number(30,8) -- 本期收益
    ,yld_rat number(18,8) -- 收益率
    ,buy_cost_amt number(18,8) -- 买入成本金额
    ,unpaid_prft number(18,8) -- 未付收益
    ,divd_ratio number(18,8) -- 分红比例
    ,finc_prod_id varchar2(60) -- 理财产品编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_distr_finc_lot_h to ${icl_schema};
grant select on ${iml_schema}.agt_distr_finc_lot_h to ${idl_schema};
grant select on ${iml_schema}.agt_distr_finc_lot_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_distr_finc_lot_h is '分销理财份额历史';
comment on column ${iml_schema}.agt_distr_finc_lot_h.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.seller_id is '销售商编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.bank_id is '银行编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.src_prod_id is '源产品编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_distr_finc_lot_h.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.agt_distr_finc_lot_h.cust_grouping_cd is '客户分组代码';
comment on column ${iml_schema}.agt_distr_finc_lot_h.supp_invest_flg is '追加投资标志';
comment on column ${iml_schema}.agt_distr_finc_lot_h.lot_tot is '份额总数';
comment on column ${iml_schema}.agt_distr_finc_lot_h.curr_issue_prft is '本期收益';
comment on column ${iml_schema}.agt_distr_finc_lot_h.yld_rat is '收益率';
comment on column ${iml_schema}.agt_distr_finc_lot_h.buy_cost_amt is '买入成本金额';
comment on column ${iml_schema}.agt_distr_finc_lot_h.unpaid_prft is '未付收益';
comment on column ${iml_schema}.agt_distr_finc_lot_h.divd_ratio is '分红比例';
comment on column ${iml_schema}.agt_distr_finc_lot_h.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.agt_distr_finc_lot_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_distr_finc_lot_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_distr_finc_lot_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_distr_finc_lot_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_distr_finc_lot_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_distr_finc_lot_h.etl_timestamp is 'ETL处理时间戳';
