/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_txp_type_open
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_txp_type_open
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_txp_type_open purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_txp_type_open(
    stacid number(9) -- 账套
    ,propcd varchar2(10) -- 属性代号
    ,propna varchar2(20) -- 属性名称
    ,openst varchar2(1) -- 启用标识（0：不启用1：启用）
    ,ordrno number -- 顺序
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
grant select on ${iol_schema}.tgls_txp_type_open to ${iml_schema};
grant select on ${iol_schema}.tgls_txp_type_open to ${icl_schema};
grant select on ${iol_schema}.tgls_txp_type_open to ${idl_schema};
grant select on ${iol_schema}.tgls_txp_type_open to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_txp_type_open is '分离规则维度启用表';
comment on column ${iol_schema}.tgls_txp_type_open.stacid is '账套';
comment on column ${iol_schema}.tgls_txp_type_open.propcd is '属性代号';
comment on column ${iol_schema}.tgls_txp_type_open.propna is '属性名称';
comment on column ${iol_schema}.tgls_txp_type_open.openst is '启用标识（0：不启用1：启用）';
comment on column ${iol_schema}.tgls_txp_type_open.ordrno is '顺序';
comment on column ${iol_schema}.tgls_txp_type_open.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_txp_type_open.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_txp_type_open.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_txp_type_open.etl_timestamp is 'ETL处理时间戳';
