/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_itdn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_itdn
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_itdn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_itdn(
    itdnpk varchar2(32) -- 主键
    ,stacid number(19) -- 账套标识
    ,itemcd varchar2(30) -- 科目编号
    ,itdnfm varchar2(1) -- 科目余额方向调整前
    ,itdnto varchar2(1) -- 科目余额方向调整后
    ,efctdt varchar2(8) -- 生效日期
    ,transt varchar2(1) -- 状态(1、已调整0、未调整）
    ,usercd varchar2(20) -- 操作员
    ,userbr varchar2(12) -- 操作员所属机构编号
    ,tranti date -- 操作时间
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
grant select on ${iol_schema}.tgls_com_itdn to ${iml_schema};
grant select on ${iol_schema}.tgls_com_itdn to ${icl_schema};
grant select on ${iol_schema}.tgls_com_itdn to ${idl_schema};
grant select on ${iol_schema}.tgls_com_itdn to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_itdn is '科目余额方向调整记录表';
comment on column ${iol_schema}.tgls_com_itdn.itdnpk is '主键';
comment on column ${iol_schema}.tgls_com_itdn.stacid is '账套标识';
comment on column ${iol_schema}.tgls_com_itdn.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_com_itdn.itdnfm is '科目余额方向调整前';
comment on column ${iol_schema}.tgls_com_itdn.itdnto is '科目余额方向调整后';
comment on column ${iol_schema}.tgls_com_itdn.efctdt is '生效日期';
comment on column ${iol_schema}.tgls_com_itdn.transt is '状态(1、已调整0、未调整）';
comment on column ${iol_schema}.tgls_com_itdn.usercd is '操作员';
comment on column ${iol_schema}.tgls_com_itdn.userbr is '操作员所属机构编号';
comment on column ${iol_schema}.tgls_com_itdn.tranti is '操作时间';
comment on column ${iol_schema}.tgls_com_itdn.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_itdn.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_itdn.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_itdn.etl_timestamp is 'ETL处理时间戳';
