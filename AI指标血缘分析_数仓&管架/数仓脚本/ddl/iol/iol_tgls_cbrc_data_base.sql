/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_data_base
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_data_base
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_data_base purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_data_base(
    brchno varchar2(12) -- 业务机构编号
    ,shetcd varchar2(32) -- 报表编码
    ,itemcd varchar2(32) -- 数据项编码
    ,itemvl varchar2(128) -- 数据项值
    ,adjtvl varchar2(128) -- 调整值
    ,adjttp varchar2(12) -- 调整方式1：手工2：公式3：数据重跑4:数据导入5:表间同步6:数据汇总
    ,tranus varchar2(32) -- 处理人
    ,trandt date -- 处理时间
    ,crcycd varchar2(3) -- 币种
    ,geldtp varchar2(1) -- 统计频度
    ,stacid number(19) -- 账套
    ,systid varchar2(4) -- 系统
    ,acctdt varchar2(8) -- 账务日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tgls_cbrc_data_base to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_data_base to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_data_base to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_data_base to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_data_base is '报表生成数据表';
comment on column ${iol_schema}.tgls_cbrc_data_base.brchno is '业务机构编号';
comment on column ${iol_schema}.tgls_cbrc_data_base.shetcd is '报表编码';
comment on column ${iol_schema}.tgls_cbrc_data_base.itemcd is '数据项编码';
comment on column ${iol_schema}.tgls_cbrc_data_base.itemvl is '数据项值';
comment on column ${iol_schema}.tgls_cbrc_data_base.adjtvl is '调整值';
comment on column ${iol_schema}.tgls_cbrc_data_base.adjttp is '调整方式1：手工2：公式3：数据重跑4:数据导入5:表间同步6:数据汇总';
comment on column ${iol_schema}.tgls_cbrc_data_base.tranus is '处理人';
comment on column ${iol_schema}.tgls_cbrc_data_base.trandt is '处理时间';
comment on column ${iol_schema}.tgls_cbrc_data_base.crcycd is '币种';
comment on column ${iol_schema}.tgls_cbrc_data_base.geldtp is '统计频度';
comment on column ${iol_schema}.tgls_cbrc_data_base.stacid is '账套';
comment on column ${iol_schema}.tgls_cbrc_data_base.systid is '系统';
comment on column ${iol_schema}.tgls_cbrc_data_base.acctdt is '账务日期';
comment on column ${iol_schema}.tgls_cbrc_data_base.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_cbrc_data_base.etl_timestamp is 'ETL处理时间戳';
