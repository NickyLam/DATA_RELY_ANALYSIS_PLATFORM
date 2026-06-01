/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_branch_rev_meg_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_branch_rev_meg_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_branch_rev_meg_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_branch_rev_meg_register(
    file_name varchar2(200) -- 文件名称
    ,file_path varchar2(200) -- 文件路径
    ,apply_no varchar2(50) -- 申请编号
    ,company varchar2(20) -- 法人
    ,rev_meg_type varchar2(1) -- 机构拆并类型
    ,status varchar2(1) -- 状态
    ,apply_date date -- 申请日期
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,update_date date -- 更新日期
    ,in_branch varchar2(12) -- 拆入机构
    ,out_branch varchar2(12) -- 出库机构
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
grant select on ${iol_schema}.ncbs_cl_branch_rev_meg_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_branch_rev_meg_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_branch_rev_meg_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_branch_rev_meg_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_branch_rev_meg_register is '机构撤并申请登记表';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.file_name is '文件名称';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.file_path is '文件路径';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.apply_no is '申请编号';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.company is '法人';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.rev_meg_type is '机构拆并类型';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.status is '状态';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.apply_date is '申请日期';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.in_branch is '拆入机构';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.out_branch is '出库机构';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_branch_rev_meg_register.etl_timestamp is 'ETL处理时间戳';
