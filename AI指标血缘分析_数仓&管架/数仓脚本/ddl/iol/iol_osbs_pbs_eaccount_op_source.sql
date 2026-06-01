/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_eaccount_op_source
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_eaccount_op_source
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_eaccount_op_source purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_eaccount_op_source(
    peos_accesstoken varchar2(64) -- 调用服务凭证
    ,peos_source varchar2(32) -- 开户来源，MPP小程序
    ,peos_extend_one varchar2(100) -- 备用字段1
    ,peos_extend_two varchar2(100) -- 备用字段2
    ,peos_extend_third varchar2(100) -- 备用字段3
    ,peos_createtime varchar2(14) -- 创建时间
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
grant select on ${iol_schema}.osbs_pbs_eaccount_op_source to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_eaccount_op_source to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_eaccount_op_source to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_eaccount_op_source to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_eaccount_op_source is '二类户开户来源表';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.peos_accesstoken is '调用服务凭证';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.peos_source is '开户来源，MPP小程序';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.peos_extend_one is '备用字段1';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.peos_extend_two is '备用字段2';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.peos_extend_third is '备用字段3';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.peos_createtime is '创建时间';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_pbs_eaccount_op_source.etl_timestamp is 'ETL处理时间戳';
