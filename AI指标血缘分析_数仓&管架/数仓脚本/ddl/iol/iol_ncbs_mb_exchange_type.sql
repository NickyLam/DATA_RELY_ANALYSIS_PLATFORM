/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_exchange_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_exchange_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_exchange_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_exchange_type(
    company varchar2(20) -- 法人
    ,float_type varchar2(20) -- 利率浮动方式
    ,hbd_flag varchar2(1) -- 货币对汇率标志
    ,rate_type varchar2(10) -- 汇率类型
    ,rate_type_desc varchar2(50) -- 汇率类型描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,quote_ccy varchar2(3) -- 报价币种
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
grant select on ${iol_schema}.ncbs_mb_exchange_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_exchange_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_exchange_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_exchange_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_exchange_type is '汇率类型表';
comment on column ${iol_schema}.ncbs_mb_exchange_type.company is '法人';
comment on column ${iol_schema}.ncbs_mb_exchange_type.float_type is '利率浮动方式';
comment on column ${iol_schema}.ncbs_mb_exchange_type.hbd_flag is '货币对汇率标志';
comment on column ${iol_schema}.ncbs_mb_exchange_type.rate_type is '汇率类型';
comment on column ${iol_schema}.ncbs_mb_exchange_type.rate_type_desc is '汇率类型描述';
comment on column ${iol_schema}.ncbs_mb_exchange_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_exchange_type.quote_ccy is '报价币种';
comment on column ${iol_schema}.ncbs_mb_exchange_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_exchange_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_exchange_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_exchange_type.etl_timestamp is 'ETL处理时间戳';
