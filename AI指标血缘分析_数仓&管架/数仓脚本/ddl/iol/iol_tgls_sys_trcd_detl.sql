/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_trcd_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_trcd_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_trcd_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_trcd_detl(
    trancd varchar2(20) -- 子交易类别代码
    ,tranna varchar2(50) -- 子交易类别名称
    ,varicd varchar2(20) -- 字段代码
    ,varina varchar2(50) -- 字段名称
    ,varitp varchar2(40) -- 字段类型(1:子交易数据结构2:金额类型3：金额类型(来自模块数据结构)
    ,stacid number(19) -- 账套
    ,sepatg varchar2(1) -- 是否待价税分离金额
    ,privat varchar2(1) -- 指定净价税额(0:非净价税额1:净价2：税额)
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
grant select on ${iol_schema}.tgls_sys_trcd_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_trcd_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_trcd_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_trcd_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_trcd_detl is '子交易配置明细表';
comment on column ${iol_schema}.tgls_sys_trcd_detl.trancd is '子交易类别代码';
comment on column ${iol_schema}.tgls_sys_trcd_detl.tranna is '子交易类别名称';
comment on column ${iol_schema}.tgls_sys_trcd_detl.varicd is '字段代码';
comment on column ${iol_schema}.tgls_sys_trcd_detl.varina is '字段名称';
comment on column ${iol_schema}.tgls_sys_trcd_detl.varitp is '字段类型(1:子交易数据结构2:金额类型3：金额类型(来自模块数据结构)';
comment on column ${iol_schema}.tgls_sys_trcd_detl.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_trcd_detl.sepatg is '是否待价税分离金额';
comment on column ${iol_schema}.tgls_sys_trcd_detl.privat is '指定净价税额(0:非净价税额1:净价2：税额)';
comment on column ${iol_schema}.tgls_sys_trcd_detl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_trcd_detl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_trcd_detl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_trcd_detl.etl_timestamp is 'ETL处理时间戳';
