/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_ref_exch_rat_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_ref_exch_rat_h
whenever sqlerror continue none;
drop table ${idl_schema}.aml_ref_exch_rat_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_ref_exch_rat_h(
    curr_cd          varchar2(10)  -- 币种代码
    ,effect_dt        date          -- 生效日期
    ,invalid_dt       date          -- 失效日期
    ,status_cd        varchar2(10)  -- 状态代码
    ,cn_name          varchar2(200) -- 中文名称
    ,en_abbr          varchar2(10)  -- 英文简称
    ,convt_corp       number(10)    -- 换算单位
    ,cash_buy_price   number(18,8)  -- 钞买价
    ,cash_sell_price  number(18,8)  -- 钞卖价
    ,exch_buy_price   number(18,8)  -- 汇买价
    ,exch_sell_price  number(18,8)  -- 汇卖价
    ,mdl_p            number(18,8)  -- 中间价
    ,fori_exch_mdl_p  number(18,8)  -- 外管中间价
    ,start_dt         date          -- 开始日期
    ,end_dt           date          -- 结束日期
    ,id_mark          varchar2(10)  -- 删除标识
    ,src_table_name   varchar2(100) -- 源表名称
    ,job_cd           varchar2(10)  -- 任务代码
    ,etl_timestamp    timestamp -- 数据处理时间
    ,etl_dt date -- ETL处理日期
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_ref_exch_rat_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_ref_exch_rat_h is '汇率历史表';
comment on column ${idl_schema}.aml_ref_exch_rat_h.curr_cd          is '币种代码';
comment on column ${idl_schema}.aml_ref_exch_rat_h.effect_dt        is '生效日期';
comment on column ${idl_schema}.aml_ref_exch_rat_h.invalid_dt       is '失效日期';
comment on column ${idl_schema}.aml_ref_exch_rat_h.status_cd        is '状态代码';
comment on column ${idl_schema}.aml_ref_exch_rat_h.cn_name          is '中文名称';
comment on column ${idl_schema}.aml_ref_exch_rat_h.en_abbr          is '英文简称';
comment on column ${idl_schema}.aml_ref_exch_rat_h.convt_corp       is '换算单位';
comment on column ${idl_schema}.aml_ref_exch_rat_h.cash_buy_price   is '钞买价';
comment on column ${idl_schema}.aml_ref_exch_rat_h.cash_sell_price  is '钞卖价';
comment on column ${idl_schema}.aml_ref_exch_rat_h.exch_buy_price   is '汇买价';
comment on column ${idl_schema}.aml_ref_exch_rat_h.exch_sell_price  is '汇卖价';
comment on column ${idl_schema}.aml_ref_exch_rat_h.mdl_p            is '中间价';
comment on column ${idl_schema}.aml_ref_exch_rat_h.fori_exch_mdl_p  is '外管中间价';
comment on column ${idl_schema}.aml_ref_exch_rat_h.start_dt         is '开始日期';
comment on column ${idl_schema}.aml_ref_exch_rat_h.end_dt           is '结束日期';
comment on column ${idl_schema}.aml_ref_exch_rat_h.id_mark          is '删除标识';
comment on column ${idl_schema}.aml_ref_exch_rat_h.src_table_name   is '源表名称';
comment on column ${idl_schema}.aml_ref_exch_rat_h.job_cd           is '任务代码';
comment on column ${idl_schema}.aml_ref_exch_rat_h.etl_timestamp    is '数据处理时间';
comment on column ${idl_schema}.aml_ref_exch_rat_h.etl_dt is 'ETL处理日期';