/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_unbr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_unbr
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_unbr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_unbr(
    stacid number(19) -- 账套标识
    ,brchfm varchar2(12) -- 被合并机构编号
    ,brchto varchar2(12) -- 合并机构编号
    ,efctdt varchar2(8) -- 生效日期
    ,transt varchar2(1) -- 状态(1、已合并0、未合并)
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
grant select on ${iol_schema}.tgls_com_unbr to ${iml_schema};
grant select on ${iol_schema}.tgls_com_unbr to ${icl_schema};
grant select on ${iol_schema}.tgls_com_unbr to ${idl_schema};
grant select on ${iol_schema}.tgls_com_unbr to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_unbr is '机构合并';
comment on column ${iol_schema}.tgls_com_unbr.stacid is '账套标识';
comment on column ${iol_schema}.tgls_com_unbr.brchfm is '被合并机构编号';
comment on column ${iol_schema}.tgls_com_unbr.brchto is '合并机构编号';
comment on column ${iol_schema}.tgls_com_unbr.efctdt is '生效日期';
comment on column ${iol_schema}.tgls_com_unbr.transt is '状态(1、已合并0、未合并)';
comment on column ${iol_schema}.tgls_com_unbr.usercd is '操作员';
comment on column ${iol_schema}.tgls_com_unbr.userbr is '操作员所属机构编号';
comment on column ${iol_schema}.tgls_com_unbr.tranti is '操作时间';
comment on column ${iol_schema}.tgls_com_unbr.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_unbr.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_unbr.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_unbr.etl_timestamp is 'ETL处理时间戳';
