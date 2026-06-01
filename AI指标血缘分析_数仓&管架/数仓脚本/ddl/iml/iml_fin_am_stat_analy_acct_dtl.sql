/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_am_stat_analy_acct_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_am_stat_analy_acct_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.fin_am_stat_analy_acct_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_stat_analy_acct_dtl(
    sob_id varchar2(100) -- 账套编号
    ,lp_id varchar2(60) -- 法人编号
    ,happ_dt date -- 发生日期
    ,enter_acct_dt date -- 入账日期
    ,acct_dtl_id varchar2(100) -- 账务明细编号
    ,proc_order_id varchar2(100) -- 处理序列编号
    ,sob_dt date -- 账套日期
    ,curr_post_amt number(30,14) -- 当前持仓金额
    ,provi_int_rat number(30,14) -- 计提利率
    ,day_amort_yld_rat number(30,14) -- 日摊销收益率
    ,td_happ_acru_int number(30,2) -- 当日发生应计利息
    ,td_acm_acru_int_bal number(30,2) -- 当日累计应计利息余额
    ,prod_cate_cd varchar2(30) -- 产品类别代码
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,pass_id varchar2(100) -- 通道编号
    ,invest_aim_cd varchar2(30) -- 投资目的代码
    ,td_provi_lot number(30,14) -- 当日计提份额
    ,td_cost_tot number(30,2) -- 当日成本总额
    ,td_evha_val_chag number(30,2) -- 当日公允价值变动
    ,surp_tenor number(10) -- 剩余期限
    ,surp_surviv_tenor number(10) -- 剩余存续期限
    ,fin_prod_id varchar2(100) -- 金融产品编号
    ,ext_evltion_dt date -- 外部估值日期
    ,td_acm_evha_val_chag number(30,2) -- 当日累计公允价值变动
    ,curr_cd varchar2(30) -- 币种代码
    ,dc_curr_cd varchar2(30) -- 本币币种代码
    ,dc_td_happ_acru_int number(30,2) -- 本币当日发生应计利息
    ,dc_td_cost_tot number(30,2) -- 本币当日成本总额
    ,dc_td_evha_val_chag number(30,2) -- 本币当日公允价值变动
    ,dc_td_acm_evha_val_chag number(30,2) -- 本币当日累计公允价值变动
    ,dc_td_acm_acru_int_bal number(30,2) -- 本币当日累计应计利息余额
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.fin_am_stat_analy_acct_dtl to ${icl_schema};
grant select on ${iml_schema}.fin_am_stat_analy_acct_dtl to ${idl_schema};
grant select on ${iml_schema}.fin_am_stat_analy_acct_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_am_stat_analy_acct_dtl is '资管统计分析账务明细';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.sob_id is '账套编号';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.happ_dt is '发生日期';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.enter_acct_dt is '入账日期';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.acct_dtl_id is '账务明细编号';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.proc_order_id is '处理序列编号';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.sob_dt is '账套日期';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.curr_post_amt is '当前持仓金额';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.provi_int_rat is '计提利率';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.day_amort_yld_rat is '日摊销收益率';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.td_happ_acru_int is '当日发生应计利息';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.td_acm_acru_int_bal is '当日累计应计利息余额';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.prod_cate_cd is '产品类别代码';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.value_dt is '起息日期';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.exp_dt is '到期日期';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.pass_id is '通道编号';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.invest_aim_cd is '投资目的代码';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.td_provi_lot is '当日计提份额';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.td_cost_tot is '当日成本总额';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.td_evha_val_chag is '当日公允价值变动';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.surp_tenor is '剩余期限';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.surp_surviv_tenor is '剩余存续期限';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.ext_evltion_dt is '外部估值日期';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.td_acm_evha_val_chag is '当日累计公允价值变动';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.dc_curr_cd is '本币币种代码';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.dc_td_happ_acru_int is '本币当日发生应计利息';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.dc_td_cost_tot is '本币当日成本总额';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.dc_td_evha_val_chag is '本币当日公允价值变动';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.dc_td_acm_evha_val_chag is '本币当日累计公允价值变动';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.dc_td_acm_acru_int_bal is '本币当日累计应计利息余额';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.fin_am_stat_analy_acct_dtl.etl_timestamp is 'ETL处理时间戳';
