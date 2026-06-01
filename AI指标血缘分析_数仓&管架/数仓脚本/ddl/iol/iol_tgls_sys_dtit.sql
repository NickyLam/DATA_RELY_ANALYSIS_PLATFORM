/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_dtit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_dtit
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_dtit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_dtit(
    stacid number(9) -- 账套
    ,typecd varchar2(30) -- 核算代码
    ,trprcd varchar2(10) -- 金额类型(核对时)
    ,itemcd varchar2(30) -- 科目编号
    ,reitem varchar2(200) -- 科目名称
    ,usedtp varchar2(1) -- 使用状态
    ,efctdt varchar2(10) -- 生效日期（目前未使用）
    ,inefdt varchar2(10) -- 失效日期（目前未使用）
    ,desctx varchar2(255) -- 描述
    ,module varchar2(20) -- 业务类型
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
grant select on ${iol_schema}.tgls_sys_dtit to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_dtit to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_dtit to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_dtit to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_dtit is '核算字段表';
comment on column ${iol_schema}.tgls_sys_dtit.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_dtit.typecd is '核算代码';
comment on column ${iol_schema}.tgls_sys_dtit.trprcd is '金额类型(核对时)';
comment on column ${iol_schema}.tgls_sys_dtit.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_sys_dtit.reitem is '科目名称';
comment on column ${iol_schema}.tgls_sys_dtit.usedtp is '使用状态';
comment on column ${iol_schema}.tgls_sys_dtit.efctdt is '生效日期（目前未使用）';
comment on column ${iol_schema}.tgls_sys_dtit.inefdt is '失效日期（目前未使用）';
comment on column ${iol_schema}.tgls_sys_dtit.desctx is '描述';
comment on column ${iol_schema}.tgls_sys_dtit.module is '业务类型';
comment on column ${iol_schema}.tgls_sys_dtit.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_dtit.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_dtit.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_dtit.etl_timestamp is 'ETL处理时间戳';
