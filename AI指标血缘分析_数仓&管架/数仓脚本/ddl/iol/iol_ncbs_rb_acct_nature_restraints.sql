/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_nature_restraints
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_nature_restraints
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_nature_restraints purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_nature_restraints(
    restraint_type varchar2(3) -- 限制类型
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,acct_nature varchar2(10) -- 存款账户类型
    ,company varchar2(20) -- 法人
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
grant select on ${iol_schema}.ncbs_rb_acct_nature_restraints to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_nature_restraints to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_nature_restraints to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_nature_restraints to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_nature_restraints is '账户属性与账户限制关联配置';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.term is '存期';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_nature_restraints.etl_timestamp is 'ETL处理时间戳';
