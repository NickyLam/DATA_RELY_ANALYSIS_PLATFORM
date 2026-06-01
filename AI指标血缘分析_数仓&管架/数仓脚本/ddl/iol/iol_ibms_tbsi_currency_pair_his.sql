/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tbsi_currency_pair_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tbsi_currency_pair_his
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tbsi_currency_pair_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbsi_currency_pair_his(
    currency_1 varchar2(5) -- 货币1
    ,currency_2 varchar2(5) -- 货币2
    ,pe_code varchar2(45) -- 定价环境
    ,tg_code varchar2(15) -- 任务组代码
    ,beg_date varchar2(15) -- 生效日期
    ,end_date varchar2(15) -- 失效日期
    ,mk_eprice number(38,6) -- 估值，1单位货币1转货币2的估值
    ,mk_eprice_type varchar2(2) -- 估值价格类型，0：无估值；1：市值估值；2：模型估值
    ,mk_cur_book varchar2(5) -- 估值币种
    ,imp_time varchar2(29) -- 导入时间
    ,task_rst_id varchar2(75) -- 任务结果id
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_tbsi_currency_pair_his to ${iml_schema};
grant select on ${iol_schema}.ibms_tbsi_currency_pair_his to ${icl_schema};
grant select on ${iol_schema}.ibms_tbsi_currency_pair_his to ${idl_schema};
grant select on ${iol_schema}.ibms_tbsi_currency_pair_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tbsi_currency_pair_his is '货币对计算结果历史表';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.currency_1 is '货币1';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.currency_2 is '货币2';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.pe_code is '定价环境';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.tg_code is '任务组代码';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.beg_date is '生效日期';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.end_date is '失效日期';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.mk_eprice is '估值，1单位货币1转货币2的估值';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.mk_eprice_type is '估值价格类型，0：无估值；1：市值估值；2：模型估值';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.mk_cur_book is '估值币种';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.imp_time is '导入时间';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.task_rst_id is '任务结果id';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tbsi_currency_pair_his.etl_timestamp is 'ETL处理时间戳';
