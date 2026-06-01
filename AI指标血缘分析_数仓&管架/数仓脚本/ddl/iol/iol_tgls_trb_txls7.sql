/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_trb_txls7
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_trb_txls7
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_trb_txls7 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_trb_txls7(
    stacid number(9) -- 账套
    ,systid varchar2(30) -- 来源系统编号
    ,trandt varchar2(8) -- 交易日期
    ,tranbr varchar2(12) -- 交易机构编号
    ,transq varchar2(50) -- 交易流水号
    ,custcd varchar2(16) -- 客户编号
    ,busitp varchar2(10) -- 业务类别
    ,tranam number(20,2) -- 交易金额
    ,taxbam number(21,7) -- 税额
    ,smrytx varchar2(255) -- 备注
    ,status varchar2(1) -- 状态
    ,acctbr varchar2(12) -- 账务机构编号
    ,vchrsq varchar2(20) -- 传票序号
    ,catxtp varchar2(1) -- 计税方式
    ,exeptg varchar2(1) -- 应税标识——对销项适用
    ,vatxrt number(17,8) -- 税率
    ,pricam number(20,2) -- 交易金额
    ,typecd varchar2(20) -- 税目代码
    ,crcycd varchar2(3) -- 币种代码
    ,crcysd varchar2(3) -- 开票币种
    ,extxam number(19,7) -- 税额（开票币种）
    ,exchrt number(15,8) -- 折算汇率
    ,itemcd varchar2(30) -- 价税分离科目编号
    ,itemna varchar2(200) -- 价税分离科目名称
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
grant select on ${iol_schema}.tgls_trb_txls7 to ${iml_schema};
grant select on ${iol_schema}.tgls_trb_txls7 to ${icl_schema};
grant select on ${iol_schema}.tgls_trb_txls7 to ${idl_schema};
grant select on ${iol_schema}.tgls_trb_txls7 to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_trb_txls7 is '应税交易明细（零税率）';
comment on column ${iol_schema}.tgls_trb_txls7.stacid is '账套';
comment on column ${iol_schema}.tgls_trb_txls7.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_trb_txls7.trandt is '交易日期';
comment on column ${iol_schema}.tgls_trb_txls7.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_trb_txls7.transq is '交易流水号';
comment on column ${iol_schema}.tgls_trb_txls7.custcd is '客户编号';
comment on column ${iol_schema}.tgls_trb_txls7.busitp is '业务类别';
comment on column ${iol_schema}.tgls_trb_txls7.tranam is '交易金额';
comment on column ${iol_schema}.tgls_trb_txls7.taxbam is '税额';
comment on column ${iol_schema}.tgls_trb_txls7.smrytx is '备注';
comment on column ${iol_schema}.tgls_trb_txls7.status is '状态';
comment on column ${iol_schema}.tgls_trb_txls7.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_trb_txls7.vchrsq is '传票序号';
comment on column ${iol_schema}.tgls_trb_txls7.catxtp is '计税方式';
comment on column ${iol_schema}.tgls_trb_txls7.exeptg is '应税标识——对销项适用';
comment on column ${iol_schema}.tgls_trb_txls7.vatxrt is '税率';
comment on column ${iol_schema}.tgls_trb_txls7.pricam is '交易金额';
comment on column ${iol_schema}.tgls_trb_txls7.typecd is '税目代码';
comment on column ${iol_schema}.tgls_trb_txls7.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_trb_txls7.crcysd is '开票币种';
comment on column ${iol_schema}.tgls_trb_txls7.extxam is '税额（开票币种）';
comment on column ${iol_schema}.tgls_trb_txls7.exchrt is '折算汇率';
comment on column ${iol_schema}.tgls_trb_txls7.itemcd is '价税分离科目编号';
comment on column ${iol_schema}.tgls_trb_txls7.itemna is '价税分离科目名称';
comment on column ${iol_schema}.tgls_trb_txls7.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_trb_txls7.etl_timestamp is 'ETL处理时间戳';
