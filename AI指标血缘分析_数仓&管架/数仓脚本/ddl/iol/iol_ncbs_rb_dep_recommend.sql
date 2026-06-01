/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dep_recommend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dep_recommend
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dep_recommend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dep_recommend(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,percent number(11,7) -- 比例
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,user_name varchar2(200) -- 柜员名称
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
grant select on ${iol_schema}.ncbs_rb_dep_recommend to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dep_recommend to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dep_recommend to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dep_recommend to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dep_recommend is '揽存信息表';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.percent is '比例';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.user_name is '柜员名称';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dep_recommend.etl_timestamp is 'ETL处理时间戳';
