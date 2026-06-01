/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_nature_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_nature_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_nature_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_nature_def(
    acct_nature varchar2(10) -- 存款账户类型
    ,company varchar2(20) -- 法人
    ,description varchar2(50) -- 结构属性说明
    ,nature_class varchar2(2) -- 账户属性分类
    ,libra_op_time number(15) -- libra执行次数
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
grant select on ${iol_schema}.ncbs_cl_acct_nature_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_nature_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_nature_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_nature_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_nature_def is '账户属性定义';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.description is '结构属性说明';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.nature_class is '账户属性分类';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_nature_def.etl_timestamp is 'ETL处理时间戳';
