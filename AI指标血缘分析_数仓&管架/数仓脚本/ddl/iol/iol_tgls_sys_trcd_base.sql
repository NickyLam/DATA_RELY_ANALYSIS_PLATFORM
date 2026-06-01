/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_trcd_base
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_trcd_base
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_trcd_base purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_trcd_base(
    trancd varchar2(20) -- 子交易代码
    ,tranna varchar2(50) -- 子交易名称
    ,module varchar2(20) -- 业务类型
    ,desctx varchar2(255) -- 说明
    ,vermod number(19) -- 版本模式
    ,usedtp varchar2(1) -- 使用状态（0未使用，1已使用）
    ,startp varchar2(1) -- 启用标识（0停用，1已启用）
    ,stacid number(19) -- 账套
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
grant select on ${iol_schema}.tgls_sys_trcd_base to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_trcd_base to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_trcd_base to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_trcd_base to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_trcd_base is '子交易基础信息表';
comment on column ${iol_schema}.tgls_sys_trcd_base.trancd is '子交易代码';
comment on column ${iol_schema}.tgls_sys_trcd_base.tranna is '子交易名称';
comment on column ${iol_schema}.tgls_sys_trcd_base.module is '业务类型';
comment on column ${iol_schema}.tgls_sys_trcd_base.desctx is '说明';
comment on column ${iol_schema}.tgls_sys_trcd_base.vermod is '版本模式';
comment on column ${iol_schema}.tgls_sys_trcd_base.usedtp is '使用状态（0未使用，1已使用）';
comment on column ${iol_schema}.tgls_sys_trcd_base.startp is '启用标识（0停用，1已启用）';
comment on column ${iol_schema}.tgls_sys_trcd_base.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_trcd_base.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_trcd_base.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_trcd_base.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_trcd_base.etl_timestamp is 'ETL处理时间戳';
