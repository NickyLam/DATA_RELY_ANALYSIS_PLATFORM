/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_exchange_tran_code
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_exchange_tran_code
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_exchange_tran_code purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_exchange_tran_code(
    company varchar2(20) -- 法人
    ,inc_exp_ind varchar2(1) -- 收支标志
    ,tran_code varchar2(50) -- 传输代码
    ,tran_code_desc varchar2(200) -- 结售汇项目编码描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_fm_exchange_tran_code to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_exchange_tran_code to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_exchange_tran_code to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_exchange_tran_code to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_exchange_tran_code is '结售汇项目编码表';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.company is '法人';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.inc_exp_ind is '收支标志';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.tran_code is '传输代码';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.tran_code_desc is '结售汇项目编码描述';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_exchange_tran_code.etl_timestamp is 'ETL处理时间戳';
