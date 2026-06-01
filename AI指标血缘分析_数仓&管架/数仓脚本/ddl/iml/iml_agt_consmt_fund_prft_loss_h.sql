/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_consmt_fund_prft_loss_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_consmt_fund_prft_loss_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_consmt_fund_prft_loss_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_consmt_fund_prft_loss_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_cust_id varchar2(100) -- 内部客户编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,bank_id varchar2(100) -- 银行编号
    ,cust_id varchar2(100) -- 客户编号
    ,ta_cd varchar2(30) -- TA代码
    ,fund_prod_id varchar2(100) -- 基金产品编号
    ,tm_bg_dt date -- 期初日期
    ,tm_bg_nv number(18,8) -- 期初净值
    ,term_end_dt date -- 期末日期
    ,term_end_nv number(18,8) -- 期末净值
    ,fund_lot number(30,8) -- 基金份额
    ,subscr_amt number(30,2) -- 认购金额
    ,subscr_cfm_amt number(30,2) -- 认购确认金额
    ,purch_amt number(30,2) -- 申购金额
    ,aip_amt number(30,2) -- 定投金额
    ,tran_in_amt number(30,2) -- 转换入金额
    ,turn_trust_in_amt number(30,2) -- 转托管入金额
    ,non_tran_tran_in_amt number(30,2) -- 非交易过户入金额
    ,lot_man_incre_convt_amt number(30,2) -- 份额强增折算金额
    ,redem_amt number(30,2) -- 赎回金额
    ,force_redem_amt number(30,2) -- 强制赎回金额
    ,tran_wdraw_lmt number(30,2) -- 转换出金额
    ,turn_trust_wdraw_lmt number(30,2) -- 转托管出金额
    ,non_tran_tran_wdraw_lmt number(30,2) -- 非交易过户出金额
    ,divd_lot_convt_amt number(30,2) -- 分红份额折算金额
    ,divd_lot number(30,8) -- 分红份额
    ,divd_amt number(30,2) -- 分红金额
    ,fund_liqd_and_termnt_amt number(30,2) -- 基金清盘及终止金额
    ,lot_man_reduc_convt_amt number(30,2) -- 份额强减折算金额
    ,invest_yld_rat number(30,8) -- 投资收益率
    ,acm_put_into_cap_lmt number(30,2) -- 累计投入资金额
    ,acm_invest_prft number(30,2) -- 累计投资收益
    ,avg_buy_price number(30,8) -- 平均买入价格
    ,yeb_adv_prft number(30,8) -- 余额宝垫资收益
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
grant select on ${iml_schema}.agt_consmt_fund_prft_loss_h to ${icl_schema};
grant select on ${iml_schema}.agt_consmt_fund_prft_loss_h to ${idl_schema};
grant select on ${iml_schema}.agt_consmt_fund_prft_loss_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_consmt_fund_prft_loss_h is '代销基金浮动盈亏历史';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.bank_id is '银行编号';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.fund_prod_id is '基金产品编号';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.tm_bg_dt is '期初日期';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.tm_bg_nv is '期初净值';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.term_end_dt is '期末日期';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.term_end_nv is '期末净值';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.fund_lot is '基金份额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.subscr_amt is '认购金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.subscr_cfm_amt is '认购确认金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.purch_amt is '申购金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.aip_amt is '定投金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.tran_in_amt is '转换入金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.turn_trust_in_amt is '转托管入金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.non_tran_tran_in_amt is '非交易过户入金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.lot_man_incre_convt_amt is '份额强增折算金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.redem_amt is '赎回金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.force_redem_amt is '强制赎回金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.tran_wdraw_lmt is '转换出金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.turn_trust_wdraw_lmt is '转托管出金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.non_tran_tran_wdraw_lmt is '非交易过户出金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.divd_lot_convt_amt is '分红份额折算金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.divd_lot is '分红份额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.divd_amt is '分红金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.fund_liqd_and_termnt_amt is '基金清盘及终止金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.lot_man_reduc_convt_amt is '份额强减折算金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.invest_yld_rat is '投资收益率';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.acm_put_into_cap_lmt is '累计投入资金额';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.acm_invest_prft is '累计投资收益';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.avg_buy_price is '平均买入价格';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.yeb_adv_prft is '余额宝垫资收益';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_consmt_fund_prft_loss_h.etl_timestamp is 'ETL处理时间戳';
