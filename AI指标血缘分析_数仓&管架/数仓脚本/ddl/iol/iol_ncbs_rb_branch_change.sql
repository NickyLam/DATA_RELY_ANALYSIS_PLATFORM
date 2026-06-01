/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_branch_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_branch_change
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_branch_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_branch_change(
    client_no varchar2(16) -- 客户编号
    ,file_name varchar2(200) -- 文件名称
    ,prod_type varchar2(12) -- 产品编号
    ,amend_seq_no varchar2(50) -- 变更序号
    ,change_flag varchar2(1) -- 更换标志
    ,company varchar2(20) -- 法人
    ,effect_date date -- 产品生效日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,new_branch varchar2(12) -- 变更后机构
    ,old_branch varchar2(12) -- 变更前机构
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_branch_change to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_branch_change to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_branch_change to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_branch_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_branch_change is '日终批处理机构变更记录表';
comment on column ${iol_schema}.ncbs_rb_branch_change.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_branch_change.file_name is '文件名称';
comment on column ${iol_schema}.ncbs_rb_branch_change.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_branch_change.amend_seq_no is '变更序号';
comment on column ${iol_schema}.ncbs_rb_branch_change.change_flag is '更换标志';
comment on column ${iol_schema}.ncbs_rb_branch_change.company is '法人';
comment on column ${iol_schema}.ncbs_rb_branch_change.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_branch_change.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_branch_change.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_branch_change.new_branch is '变更后机构';
comment on column ${iol_schema}.ncbs_rb_branch_change.old_branch is '变更前机构';
comment on column ${iol_schema}.ncbs_rb_branch_change.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_branch_change.etl_timestamp is 'ETL处理时间戳';
