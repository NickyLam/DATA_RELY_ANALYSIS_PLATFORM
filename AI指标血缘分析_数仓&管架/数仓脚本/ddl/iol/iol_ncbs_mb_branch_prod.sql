/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_branch_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_branch_prod
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_branch_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_branch_prod(
    branch varchar2(12) -- 机构编号
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,prod_desc varchar2(200) -- 产品名称
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
grant select on ${iol_schema}.ncbs_mb_branch_prod to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_branch_prod to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_branch_prod to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_branch_prod to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_branch_prod is '机构产品关联表';
comment on column ${iol_schema}.ncbs_mb_branch_prod.branch is '机构编号';
comment on column ${iol_schema}.ncbs_mb_branch_prod.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_mb_branch_prod.company is '法人';
comment on column ${iol_schema}.ncbs_mb_branch_prod.prod_desc is '产品名称';
comment on column ${iol_schema}.ncbs_mb_branch_prod.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_branch_prod.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_branch_prod.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_branch_prod.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_branch_prod.etl_timestamp is 'ETL处理时间戳';
