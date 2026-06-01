/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_fms_cait
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_fms_cait
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_fms_cait purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_fms_cait(
    trandt varchar2(8) -- 交易日期
    ,transq varchar2(20) -- 交易流水
    ,insttp varchar2(1) -- 利息类型(1-上存2-下借3-备付金4-准备金)
    ,brchno varchar2(12) -- 机构编号
    ,crcycd varchar2(3) -- 币种
    ,cainam number(20,2) -- 应计提金额
    ,cainbl number(20,2) -- 已计提金额
    ,instam number(20,2) -- 本次计提金额
    ,stacid varchar2(20) -- 账套
    ,cntrno varchar2(30) -- 合同编号
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
grant select on ${iol_schema}.tgls_fms_cait to ${iml_schema};
grant select on ${iol_schema}.tgls_fms_cait to ${icl_schema};
grant select on ${iol_schema}.tgls_fms_cait to ${idl_schema};
grant select on ${iol_schema}.tgls_fms_cait to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_fms_cait is '内部资金计提登记簿';
comment on column ${iol_schema}.tgls_fms_cait.trandt is '交易日期';
comment on column ${iol_schema}.tgls_fms_cait.transq is '交易流水';
comment on column ${iol_schema}.tgls_fms_cait.insttp is '利息类型(1-上存2-下借3-备付金4-准备金)';
comment on column ${iol_schema}.tgls_fms_cait.brchno is '机构编号';
comment on column ${iol_schema}.tgls_fms_cait.crcycd is '币种';
comment on column ${iol_schema}.tgls_fms_cait.cainam is '应计提金额';
comment on column ${iol_schema}.tgls_fms_cait.cainbl is '已计提金额';
comment on column ${iol_schema}.tgls_fms_cait.instam is '本次计提金额';
comment on column ${iol_schema}.tgls_fms_cait.stacid is '账套';
comment on column ${iol_schema}.tgls_fms_cait.cntrno is '合同编号';
comment on column ${iol_schema}.tgls_fms_cait.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_fms_cait.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_fms_cait.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_fms_cait.etl_timestamp is 'ETL处理时间戳';
