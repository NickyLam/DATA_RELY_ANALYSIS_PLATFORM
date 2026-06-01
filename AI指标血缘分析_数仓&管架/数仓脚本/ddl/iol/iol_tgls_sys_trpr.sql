/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_trpr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_trpr
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_trpr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_trpr(
    module varchar2(20) -- 业务类型
    ,trprcd varchar2(10) -- 金额类型代码
    ,trprna varchar2(120) -- 金额类型名称
    ,usedtp varchar2(1) -- 使用状态（0未使用1已使用）
    ,desctx varchar2(255) -- 描述说明
    ,tablcl varchar2(10) -- 余额类型对应的表列字段（目前未使用）
    ,sortno number(10) -- 余额类型对应的排序（目前未使用）
    ,chcktp varchar2(1) -- 第三次总分核对是否需要核对该余额（y-是n-否）
    ,stacid number(19) -- 账套
    ,startp varchar2(1) -- 启用标识（0停用1启用）
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
grant select on ${iol_schema}.tgls_sys_trpr to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_trpr to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_trpr to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_trpr to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_trpr is '子交易属性';
comment on column ${iol_schema}.tgls_sys_trpr.module is '业务类型';
comment on column ${iol_schema}.tgls_sys_trpr.trprcd is '金额类型代码';
comment on column ${iol_schema}.tgls_sys_trpr.trprna is '金额类型名称';
comment on column ${iol_schema}.tgls_sys_trpr.usedtp is '使用状态（0未使用1已使用）';
comment on column ${iol_schema}.tgls_sys_trpr.desctx is '描述说明';
comment on column ${iol_schema}.tgls_sys_trpr.tablcl is '余额类型对应的表列字段（目前未使用）';
comment on column ${iol_schema}.tgls_sys_trpr.sortno is '余额类型对应的排序（目前未使用）';
comment on column ${iol_schema}.tgls_sys_trpr.chcktp is '第三次总分核对是否需要核对该余额（y-是n-否）';
comment on column ${iol_schema}.tgls_sys_trpr.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_trpr.startp is '启用标识（0停用1启用）';
comment on column ${iol_schema}.tgls_sys_trpr.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_trpr.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_trpr.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_trpr.etl_timestamp is 'ETL处理时间戳';
