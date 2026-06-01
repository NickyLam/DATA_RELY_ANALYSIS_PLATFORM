/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_glb_cler
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_glb_cler
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_glb_cler purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_glb_cler(
    stacid number(9) -- 账套
    ,bsnsdt varchar2(8) -- 清算日期
    ,bsnssq varchar2(33) -- 清算批次号
    ,brchcd varchar2(12) -- 账务机构编号
    ,clerty varchar2(4) -- 清算层级
    ,crcycd varchar2(3) -- 币种
    ,drtsam number(21,2) -- 借方交易金额
    ,crtsam number(21,2) -- 贷方交易金额
    ,clerbr varchar2(12) -- 清算机构编号
    ,amntcd varchar2(9) -- 清算方向
    ,tranam number(21,2) -- 清算金额
    ,trandt varchar2(8) -- 记账会计日期
    ,transq varchar2(20) -- 记账流水
    ,dealst varchar2(1) -- 处理状态(0,未记账、1,已记账、2,记账失败)
    ,reason varchar2(200) -- 作废原因
    ,bathid varchar2(20) -- 批次号
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(64) -- 源系统流水号
    ,cnclst varchar2(1) -- 作废状态
    ,odbssq varchar2(20) -- 作废原批次
    ,odbsdt varchar2(8) -- 作废原日期
    ,tranbr varchar2(20) -- 交易机构
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
grant select on ${iol_schema}.tgls_glb_cler to ${iml_schema};
grant select on ${iol_schema}.tgls_glb_cler to ${icl_schema};
grant select on ${iol_schema}.tgls_glb_cler to ${idl_schema};
grant select on ${iol_schema}.tgls_glb_cler to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_glb_cler is '清算登记簿';
comment on column ${iol_schema}.tgls_glb_cler.stacid is '账套';
comment on column ${iol_schema}.tgls_glb_cler.bsnsdt is '清算日期';
comment on column ${iol_schema}.tgls_glb_cler.bsnssq is '清算批次号';
comment on column ${iol_schema}.tgls_glb_cler.brchcd is '账务机构编号';
comment on column ${iol_schema}.tgls_glb_cler.clerty is '清算层级';
comment on column ${iol_schema}.tgls_glb_cler.crcycd is '币种';
comment on column ${iol_schema}.tgls_glb_cler.drtsam is '借方交易金额';
comment on column ${iol_schema}.tgls_glb_cler.crtsam is '贷方交易金额';
comment on column ${iol_schema}.tgls_glb_cler.clerbr is '清算机构编号';
comment on column ${iol_schema}.tgls_glb_cler.amntcd is '清算方向';
comment on column ${iol_schema}.tgls_glb_cler.tranam is '清算金额';
comment on column ${iol_schema}.tgls_glb_cler.trandt is '记账会计日期';
comment on column ${iol_schema}.tgls_glb_cler.transq is '记账流水';
comment on column ${iol_schema}.tgls_glb_cler.dealst is '处理状态(0,未记账、1,已记账、2,记账失败)';
comment on column ${iol_schema}.tgls_glb_cler.reason is '作废原因';
comment on column ${iol_schema}.tgls_glb_cler.bathid is '批次号';
comment on column ${iol_schema}.tgls_glb_cler.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_glb_cler.soursq is '源系统流水号';
comment on column ${iol_schema}.tgls_glb_cler.cnclst is '作废状态';
comment on column ${iol_schema}.tgls_glb_cler.odbssq is '作废原批次';
comment on column ${iol_schema}.tgls_glb_cler.odbsdt is '作废原日期';
comment on column ${iol_schema}.tgls_glb_cler.tranbr is '交易机构';
comment on column ${iol_schema}.tgls_glb_cler.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_glb_cler.etl_timestamp is 'ETL处理时间戳';
