/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_am_ibank_dep
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_am_ibank_dep
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_am_ibank_dep purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_ibank_dep(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,am_prod_id varchar2(60) -- 资管产品编号
    ,am_prod_name varchar2(500) -- 资管产品名称
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,indus_type_cd varchar2(10) -- 行业类型代码
    ,cntpty_type_id varchar2(60) -- 交易对手类型编号
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_float_point number(18,8) -- 利率浮动点数
    ,base_rat_id varchar2(60) -- 基准利率编号
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,pay_int_freq number(18,0) -- 付息频率
    ,int_rat_reset_freq number(18,0) -- 利率重置频率
    ,holiday_rule_cd varchar2(10) -- 节假日规则代码
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,exec_int_rat number(18,8) -- 执行利率
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,exp_amt number(30,2) -- 到期金额
    ,acru_int number(30,2) -- 应计利息
    ,currt_bal number(30,2) -- 当期余额
    ,td_acru_int number(30,2) -- 当日应计利息
    ,currt_acru_int number(30,2) -- 当期应计利息
    ,dealer_id varchar2(60) -- 交易员编号
    ,cntpty_dealer_id varchar2(250) -- 对方交易员编号
    ,onl_tran_flg varchar2(10) -- 线上交易标志
    ,bag_id varchar2(60) -- 成交编号
    ,tran_id varchar2(60) -- 交易编号
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
grant select on ${icl_schema}.cmm_am_ibank_dep to ${idl_schema};
grant select on ${icl_schema}.cmm_am_ibank_dep to ${iel_schema};
grant select on ${icl_schema}.cmm_am_ibank_dep to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_am_ibank_dep is '资管同业存放';
comment on column ${icl_schema}.cmm_am_ibank_dep.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_am_ibank_dep.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.am_prod_id is '资管产品编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.am_prod_name is '资管产品名称';
comment on column ${icl_schema}.cmm_am_ibank_dep.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_am_ibank_dep.indus_type_cd is '行业类型代码';
comment on column ${icl_schema}.cmm_am_ibank_dep.cntpty_type_id is '交易对手类型编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_am_ibank_dep.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_am_ibank_dep.int_rat_float_point is '利率浮动点数';
comment on column ${icl_schema}.cmm_am_ibank_dep.base_rat_id is '基准利率编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.tran_dir_cd is '交易方向代码';
comment on column ${icl_schema}.cmm_am_ibank_dep.pay_int_freq is '付息频率';
comment on column ${icl_schema}.cmm_am_ibank_dep.int_rat_reset_freq is '利率重置频率';
comment on column ${icl_schema}.cmm_am_ibank_dep.holiday_rule_cd is '节假日规则代码';
comment on column ${icl_schema}.cmm_am_ibank_dep.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_am_ibank_dep.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_am_ibank_dep.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_am_ibank_dep.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_am_ibank_dep.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_am_ibank_dep.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_am_ibank_dep.exp_amt is '到期金额';
comment on column ${icl_schema}.cmm_am_ibank_dep.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_am_ibank_dep.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_am_ibank_dep.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_am_ibank_dep.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_am_ibank_dep.dealer_id is '交易员编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.cntpty_dealer_id is '对方交易员编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.onl_tran_flg is '线上交易标志';
comment on column ${icl_schema}.cmm_am_ibank_dep.bag_id is '成交编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.tran_id is '交易编号';
comment on column ${icl_schema}.cmm_am_ibank_dep.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_am_ibank_dep.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_am_ibank_dep.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_am_ibank_dep.etl_timestamp is 'ETL处理时间戳';
