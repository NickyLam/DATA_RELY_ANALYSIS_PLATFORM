/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gab_adjt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gab_adjt
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gab_adjt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_adjt(
    stacid number(19) -- 账套
    ,adjtdt varchar2(8) -- 审计调账会计日期
    ,glisdt varchar2(8) -- 总账会计日期
    ,status varchar2(1) -- 审计调账状态,0记账进行中1记账已完成2指令已发送
    ,usercd varchar2(16) -- 操作员
    ,opratm date -- 操作时间
    ,mastac number(19) -- 主帐套
    ,fetcdt varchar2(8) -- 报表取数日期
    ,adtype varchar2(1) -- 审计调账类型，h-半年报表，y-年报
    ,begindt varchar2(8) -- 开始日期
    ,enddt varchar2(8) -- 结束日期
    ,bathid varchar2(7) -- 调整批次号
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
grant select on ${iol_schema}.tgls_gab_adjt to ${iml_schema};
grant select on ${iol_schema}.tgls_gab_adjt to ${icl_schema};
grant select on ${iol_schema}.tgls_gab_adjt to ${idl_schema};
grant select on ${iol_schema}.tgls_gab_adjt to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gab_adjt is '调账记录';
comment on column ${iol_schema}.tgls_gab_adjt.stacid is '账套';
comment on column ${iol_schema}.tgls_gab_adjt.adjtdt is '审计调账会计日期';
comment on column ${iol_schema}.tgls_gab_adjt.glisdt is '总账会计日期';
comment on column ${iol_schema}.tgls_gab_adjt.status is '审计调账状态,0记账进行中1记账已完成2指令已发送';
comment on column ${iol_schema}.tgls_gab_adjt.usercd is '操作员';
comment on column ${iol_schema}.tgls_gab_adjt.opratm is '操作时间';
comment on column ${iol_schema}.tgls_gab_adjt.mastac is '主帐套';
comment on column ${iol_schema}.tgls_gab_adjt.fetcdt is '报表取数日期';
comment on column ${iol_schema}.tgls_gab_adjt.adtype is '审计调账类型，h-半年报表，y-年报';
comment on column ${iol_schema}.tgls_gab_adjt.begindt is '开始日期';
comment on column ${iol_schema}.tgls_gab_adjt.enddt is '结束日期';
comment on column ${iol_schema}.tgls_gab_adjt.bathid is '调整批次号';
comment on column ${iol_schema}.tgls_gab_adjt.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gab_adjt.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gab_adjt.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gab_adjt.etl_timestamp is 'ETL处理时间戳';
