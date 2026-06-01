/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_eg_prod_val_index
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_eg_prod_val_index
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_eg_prod_val_index purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_eg_prod_val_index(
    tran_date date -- 交易日期
    ,seq_no varchar2(50) -- 序号
    ,project_no varchar2(50) -- 项目编号
    ,project_name varchar2(200) -- 项目名称
    ,start_date date -- 开始日期
    ,dept_name varchar2(50) -- 部门名称
    ,belong_system varchar2(200) -- 归属系统
    ,system_name varchar2(50) -- 系统名称
    ,amount number(17,2) -- 金额
    ,amend_seq_no varchar2(50) -- 变更序号
    ,part_type varchar2(20) -- 指标类型
    ,weight varchar2(20) -- 权重
    ,param_part varchar2(30) -- 指标名称
    ,unit varchar2(20) -- 单位
    ,data_value varchar2(50) -- 数据值
    ,current_value number(17,2) -- 当前值
    ,term_type varchar2(1) -- 期限单位
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
grant select on ${iol_schema}.ncbs_eg_prod_val_index to ${iml_schema};
grant select on ${iol_schema}.ncbs_eg_prod_val_index to ${icl_schema};
grant select on ${iol_schema}.ncbs_eg_prod_val_index to ${idl_schema};
grant select on ${iol_schema}.ncbs_eg_prod_val_index to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_eg_prod_val_index is '项目后评价表';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.seq_no is '序号';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.project_no is '项目编号';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.project_name is '项目名称';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.dept_name is '部门名称';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.belong_system is '归属系统';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.system_name is '系统名称';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.amount is '金额';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.amend_seq_no is '变更序号';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.part_type is '指标类型';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.weight is '权重';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.param_part is '指标名称';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.unit is '单位';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.data_value is '数据值';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.current_value is '当前值';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_eg_prod_val_index.etl_timestamp is 'ETL处理时间戳';
