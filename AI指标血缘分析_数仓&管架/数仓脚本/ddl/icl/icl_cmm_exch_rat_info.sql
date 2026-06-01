/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_exch_rat_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_exch_rat_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_exch_rat_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_exch_rat_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,curr_cd varchar2(10) -- 币种代码
    ,curr_name varchar2(100) -- 币种名称
    ,mdl_price number(18,8) -- 中间价
    ,exch_rat_mdl_price number(18,8) -- 汇率中间价
    ,base_price number(18,8) -- 基准价
    ,cash_buy_price number(18,8) -- 钞买价
    ,cash_sell_price number(18,8) -- 钞卖价
    ,exch_buy_price number(18,8) -- 汇买价
    ,exch_sell_price number(18,8) -- 汇卖价
    ,convt_corp number(10) -- 换算单位
    ,cny_exch_rat number(18,8) -- 折人民币汇率
    ,usd_exch_rat number(18,8) -- 折美元汇率
    ,eur_exch_rat number(18,8) -- 折欧元汇率
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
grant select on ${icl_schema}.cmm_exch_rat_info to ${idl_schema};
grant select on ${icl_schema}.cmm_exch_rat_info to ${iel_schema};
grant select on ${icl_schema}.cmm_exch_rat_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_exch_rat_info is '汇率信息';
comment on column ${icl_schema}.cmm_exch_rat_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_exch_rat_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_exch_rat_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_exch_rat_info.curr_name is '币种名称';
comment on column ${icl_schema}.cmm_exch_rat_info.mdl_price is '中间价';
comment on column ${icl_schema}.cmm_exch_rat_info.exch_rat_mdl_price is '汇率中间价';
comment on column ${icl_schema}.cmm_exch_rat_info.base_price is '基准价';
comment on column ${icl_schema}.cmm_exch_rat_info.cash_buy_price is '钞买价';
comment on column ${icl_schema}.cmm_exch_rat_info.cash_sell_price is '钞卖价';
comment on column ${icl_schema}.cmm_exch_rat_info.exch_buy_price is '汇买价';
comment on column ${icl_schema}.cmm_exch_rat_info.exch_sell_price is '汇卖价';
comment on column ${icl_schema}.cmm_exch_rat_info.convt_corp is '换算单位';
comment on column ${icl_schema}.cmm_exch_rat_info.cny_exch_rat is '折人民币汇率';
comment on column ${icl_schema}.cmm_exch_rat_info.usd_exch_rat is '折美元汇率';
comment on column ${icl_schema}.cmm_exch_rat_info.eur_exch_rat is '折欧元汇率';
comment on column ${icl_schema}.cmm_exch_rat_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_exch_rat_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_exch_rat_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_exch_rat_info.etl_timestamp is 'ETL处理时间戳';
