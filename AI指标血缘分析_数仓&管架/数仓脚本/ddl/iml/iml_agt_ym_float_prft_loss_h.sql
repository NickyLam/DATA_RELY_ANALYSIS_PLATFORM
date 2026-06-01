/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ym_float_prft_loss_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ym_float_prft_loss_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ym_float_prft_loss_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ym_float_prft_loss_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,fund_cd varchar2(30) -- 基金代码
    ,fund_name varchar2(750) -- 基金名称
    ,fund_abbr varchar2(750) -- 基金简称
    ,fund_type_cd varchar2(30) -- 基金类型代码
    ,fund_lot number(18,6) -- 基金份额
    ,lot_dt date -- 份额日期
    ,nv number(18,6) -- 净值
    ,nv_dt date -- 净值日期
    ,divd_amt number(18,6) -- 分红金额
    ,ld_lot number(18,6) -- 上日份额
    ,ld_lot_dt date -- 上日份额日期
    ,ld_nv number(18,6) -- 上日净值
    ,ld_nv_dt date -- 上日净值日期
    ,ld_divd_amt number(18,6) -- 上日分红金额
    ,invest_amt number(18,6) -- 投资金额
    ,exclude_divd_prft number(18,6) -- 不含分红收益
    ,divd_prft number(18,6) -- 分红收益
    ,ld_invest_amt number(18,6) -- 上日投资金额
    ,ld_exclude_divd_prft number(18,6) -- 上日不含分红收益
    ,ld_divd_prft number(18,6) -- 上日分红收益
    ,nv_calc_latest_prft number(18,6) -- 净值计算最新收益
    ,float_prft_loss_amt number(18,6) -- 浮动盈亏金额
    ,ld_float_prft_loss_amt number(18,6) -- 上日浮动盈亏金额
    ,float_prft_loss_calc_latest number(18,6) -- 浮动盈亏计算最新收益
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
grant select on ${iml_schema}.agt_ym_float_prft_loss_h to ${icl_schema};
grant select on ${iml_schema}.agt_ym_float_prft_loss_h to ${idl_schema};
grant select on ${iml_schema}.agt_ym_float_prft_loss_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ym_float_prft_loss_h is '盈米浮动盈亏历史';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.fund_cd is '基金代码';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.fund_name is '基金名称';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.fund_abbr is '基金简称';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.fund_type_cd is '基金类型代码';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.fund_lot is '基金份额';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.lot_dt is '份额日期';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.nv is '净值';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.nv_dt is '净值日期';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.divd_amt is '分红金额';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_lot is '上日份额';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_lot_dt is '上日份额日期';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_nv is '上日净值';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_nv_dt is '上日净值日期';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_divd_amt is '上日分红金额';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.invest_amt is '投资金额';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.exclude_divd_prft is '不含分红收益';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.divd_prft is '分红收益';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_invest_amt is '上日投资金额';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_exclude_divd_prft is '上日不含分红收益';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_divd_prft is '上日分红收益';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.nv_calc_latest_prft is '净值计算最新收益';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.float_prft_loss_amt is '浮动盈亏金额';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.ld_float_prft_loss_amt is '上日浮动盈亏金额';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.float_prft_loss_calc_latest is '浮动盈亏计算最新收益';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ym_float_prft_loss_h.etl_timestamp is 'ETL处理时间戳';
