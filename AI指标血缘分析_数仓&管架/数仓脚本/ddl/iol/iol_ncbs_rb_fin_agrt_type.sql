/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_fin_agrt_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_fin_agrt_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_fin_agrt_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fin_agrt_type(
    auto_transfer varchar2(1) -- 是否允许自动支取
    ,company varchar2(20) -- 法人
    ,fin_type varchar2(10) -- 理财类型
    ,fin_type_desc varchar2(50) -- 理财类型描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,keep_days number(5) -- 保留天数
    ,min_init_amt number(17,2) -- 起始最底金额
    ,term_amt number(17,2) -- 定期固定金额
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
grant select on ${iol_schema}.ncbs_rb_fin_agrt_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_fin_agrt_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_fin_agrt_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_fin_agrt_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_fin_agrt_type is '活期理财协议表';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.auto_transfer is '是否允许自动支取';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.company is '法人';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.fin_type is '理财类型';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.fin_type_desc is '理财类型描述';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.keep_days is '保留天数';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.min_init_amt is '起始最底金额';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.term_amt is '定期固定金额';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_fin_agrt_type.etl_timestamp is 'ETL处理时间戳';
