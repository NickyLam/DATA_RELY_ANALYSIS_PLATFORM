/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_tran_attach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_tran_attach
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_tran_attach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_tran_attach(
    client_no varchar2(16) -- 客户编号
    ,attr_key varchar2(30) -- 参数key值
    ,attr_value varchar2(3000) -- 属性值
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
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
grant select on ${iol_schema}.ncbs_rb_batch_tran_attach to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_attach to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_attach to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_tran_attach to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_tran_attach is '批量交易子表';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.attr_key is '参数key值';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.attr_value is '属性值';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_tran_attach.etl_timestamp is 'ETL处理时间戳';
