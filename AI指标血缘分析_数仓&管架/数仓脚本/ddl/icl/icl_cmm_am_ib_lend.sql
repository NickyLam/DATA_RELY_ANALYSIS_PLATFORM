/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_am_ib_lend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_am_ib_lend
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_am_ib_lend purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_ib_lend(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,acct_set_id varchar2(60) -- 账套编号
    ,am_prod_id varchar2(60) -- 资管产品编号
    ,am_prod_name varchar2(1000) -- 资管产品名称
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,am_prod_prft_type_cd varchar2(60) -- 资管产品收益类型代码
    ,asset_id varchar2(60) -- 资产编号
    ,asset_name varchar2(1000) -- 资产名称
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,asset_type_cd varchar2(60) -- 资产类型代码
    ,indus_type_cd varchar2(10) -- 行业类型代码
    ,cntpty_type_id varchar2(60) -- 交易对手类型编号
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,exec_int_rat number(18,8) -- 执行利率
    ,tenor number(18,0) -- 期限
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,exp_amt number(30,2) -- 到期金额
    ,acru_int number(30,2) -- 应计利息
    ,tran_fee number(30,2) -- 交易费用
    ,tran_tax number(30,2) -- 交易税金
    ,tran_comm number(30,2) -- 交易佣金
    ,currt_bal number(30,2) -- 当期余额
    ,td_acru_int number(30,2) -- 当日应计利息
    ,currt_acru_int number(30,2) -- 当期应计利息
    ,dealer_id varchar2(60) -- 交易员编号
    ,cntpty_dealer_id varchar2(60) -- 对方交易员编号
    ,onl_tran_flg varchar2(10) -- 线上交易标志
    ,bag_id varchar2(60) -- 成交编号
    ,tran_id varchar2(60) -- 交易编号
    ,crdt_out_acct_flow_num varchar2(60) -- 信贷出账流水号
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
grant select on ${icl_schema}.cmm_am_ib_lend to ${idl_schema};
grant select on ${icl_schema}.cmm_am_ib_lend to ${iel_schema};
grant select on ${icl_schema}.cmm_am_ib_lend to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_am_ib_lend is '资管同业拆借';
comment on column ${icl_schema}.cmm_am_ib_lend.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_am_ib_lend.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_am_ib_lend.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_am_ib_lend.acct_set_id is '账套编号';
comment on column ${icl_schema}.cmm_am_ib_lend.am_prod_id is '资管产品编号';
comment on column ${icl_schema}.cmm_am_ib_lend.am_prod_name is '资管产品名称';
comment on column ${icl_schema}.cmm_am_ib_lend.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_am_ib_lend.am_prod_prft_type_cd is '资管产品收益类型代码';
comment on column ${icl_schema}.cmm_am_ib_lend.asset_id is '资产编号';
comment on column ${icl_schema}.cmm_am_ib_lend.asset_name is '资产名称';
comment on column ${icl_schema}.cmm_am_ib_lend.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_am_ib_lend.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_am_ib_lend.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_am_ib_lend.asset_type_cd is '资产类型代码';
comment on column ${icl_schema}.cmm_am_ib_lend.indus_type_cd is '行业类型代码';
comment on column ${icl_schema}.cmm_am_ib_lend.cntpty_type_id is '交易对手类型编号';
comment on column ${icl_schema}.cmm_am_ib_lend.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_am_ib_lend.tran_dir_cd is '交易方向代码';
comment on column ${icl_schema}.cmm_am_ib_lend.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_am_ib_lend.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_am_ib_lend.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_am_ib_lend.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_am_ib_lend.tenor is '期限';
comment on column ${icl_schema}.cmm_am_ib_lend.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_am_ib_lend.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_am_ib_lend.exp_amt is '到期金额';
comment on column ${icl_schema}.cmm_am_ib_lend.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_am_ib_lend.tran_fee is '交易费用';
comment on column ${icl_schema}.cmm_am_ib_lend.tran_tax is '交易税金';
comment on column ${icl_schema}.cmm_am_ib_lend.tran_comm is '交易佣金';
comment on column ${icl_schema}.cmm_am_ib_lend.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_am_ib_lend.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_am_ib_lend.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_am_ib_lend.dealer_id is '交易员编号';
comment on column ${icl_schema}.cmm_am_ib_lend.cntpty_dealer_id is '对方交易员编号';
comment on column ${icl_schema}.cmm_am_ib_lend.onl_tran_flg is '线上交易标志';
comment on column ${icl_schema}.cmm_am_ib_lend.bag_id is '成交编号';
comment on column ${icl_schema}.cmm_am_ib_lend.tran_id is '交易编号';
comment on column ${icl_schema}.cmm_am_ib_lend.crdt_out_acct_flow_num is '信贷出账流水号';
comment on column ${icl_schema}.cmm_am_ib_lend.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_am_ib_lend.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_am_ib_lend.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_am_ib_lend.etl_timestamp is 'ETL处理时间戳';
