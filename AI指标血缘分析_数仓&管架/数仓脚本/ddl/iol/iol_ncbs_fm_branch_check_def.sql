/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_branch_check_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_branch_check_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_branch_check_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_branch_check_def(
    company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,branch_check_ref varchar2(50) -- 机构检查定义类
    ,branch_check_desc varchar2(100) -- 机构检查定义类描述
    ,branch_check_type varchar2(10) -- 机构检查定义类检查类型
    ,branch_check_item_type varchar2(10) -- 机构检查事项类型
    ,branch_check_item_status varchar2(1) -- 机构检查事项状态
    ,branch_check_item_message varchar2(200) -- 机构检查事项提示信息
    ,branch_check_item varchar2(50) -- 机构检查事项
    ,branch_check_item_desc varchar2(50) -- 机构检查事项描述
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
grant select on ${iol_schema}.ncbs_fm_branch_check_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_branch_check_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_branch_check_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_branch_check_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_branch_check_def is '机构关门撤并检查定义表';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.company is '法人';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.branch_check_ref is '机构检查定义类';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.branch_check_desc is '机构检查定义类描述';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.branch_check_type is '机构检查定义类检查类型';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.branch_check_item_type is '机构检查事项类型';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.branch_check_item_status is '机构检查事项状态';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.branch_check_item_message is '机构检查事项提示信息';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.branch_check_item is '机构检查事项';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.branch_check_item_desc is '机构检查事项描述';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_branch_check_def.etl_timestamp is 'ETL处理时间戳';
