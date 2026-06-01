/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_tzbl_a_zfdkzl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_tzbl_a_zfdkzl
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_tzbl_a_zfdkzl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_tzbl_a_zfdkzl(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,serialno varchar2(40) -- 申请流水号
    ,create_time varchar2(20) -- 创建时间
    ,a_ln_mog_am_inm_max number(10,0) -- 住房贷款账龄最大值
    ,a_ln_mog_am_mob_nd_max number(10,0) -- 住房贷款从未逾期账户的最大账龄
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_tzbl_a_zfdkzl to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_zfdkzl to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_zfdkzl to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_tzbl_a_zfdkzl to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_tzbl_a_zfdkzl is '贷款（住房）账龄';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.serialno is '申请流水号';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.create_time is '创建时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.a_ln_mog_am_inm_max is '住房贷款账龄最大值';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.a_ln_mog_am_mob_nd_max is '住房贷款从未逾期账户的最大账龄';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_tzbl_a_zfdkzl.etl_timestamp is 'ETL处理时间戳';
