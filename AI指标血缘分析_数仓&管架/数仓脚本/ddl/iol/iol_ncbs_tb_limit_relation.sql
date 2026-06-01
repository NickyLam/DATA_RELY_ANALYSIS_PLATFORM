/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_limit_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_limit_relation
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_limit_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_limit_relation(
    remark varchar2(600) -- 备注
    ,company varchar2(20) -- 法人
    ,ctrl_id varchar2(50) -- 控制编号
    ,cv_flag varchar2(1) -- 现金/凭证标志
    ,lm_rela_type varchar2(1) -- 限额关系分类
    ,lm_rela_object_id varchar2(20) -- 限额关系对象id
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,branch varchar2(12) -- 交易机构编号
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
grant select on ${iol_schema}.ncbs_tb_limit_relation to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_limit_relation to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_limit_relation to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_limit_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_limit_relation is '尾箱限额关联表';
comment on column ${iol_schema}.ncbs_tb_limit_relation.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_limit_relation.company is '法人';
comment on column ${iol_schema}.ncbs_tb_limit_relation.ctrl_id is '控制编号';
comment on column ${iol_schema}.ncbs_tb_limit_relation.cv_flag is '现金/凭证标志';
comment on column ${iol_schema}.ncbs_tb_limit_relation.lm_rela_type is '限额关系分类';
comment on column ${iol_schema}.ncbs_tb_limit_relation.lm_rela_object_id is '限额关系对象id';
comment on column ${iol_schema}.ncbs_tb_limit_relation.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_tb_limit_relation.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_limit_relation.branch is '交易机构编号';
comment on column ${iol_schema}.ncbs_tb_limit_relation.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_limit_relation.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_limit_relation.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_limit_relation.etl_timestamp is 'ETL处理时间戳';
