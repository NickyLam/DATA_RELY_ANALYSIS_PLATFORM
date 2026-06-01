/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_prod_group
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_prod_group
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_prod_group purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_prod_group(
    prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,default_prod_flag varchar2(1) -- 是否默认产品
    ,seq_no varchar2(50) -- 序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,prod_sub_type varchar2(12) -- 产品子类型
    ,ratio number(17,2) -- 存益贷产品分层金额
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
grant select on ${iol_schema}.ncbs_mb_prod_group to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_prod_group to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_group to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_group to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_prod_group is '产品组定义表';
comment on column ${iol_schema}.ncbs_mb_prod_group.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_mb_prod_group.company is '法人';
comment on column ${iol_schema}.ncbs_mb_prod_group.default_prod_flag is '是否默认产品';
comment on column ${iol_schema}.ncbs_mb_prod_group.seq_no is '序号';
comment on column ${iol_schema}.ncbs_mb_prod_group.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_prod_group.prod_sub_type is '产品子类型';
comment on column ${iol_schema}.ncbs_mb_prod_group.ratio is '存益贷产品分层金额';
comment on column ${iol_schema}.ncbs_mb_prod_group.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_prod_group.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_prod_group.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_prod_group.etl_timestamp is 'ETL处理时间戳';
