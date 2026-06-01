/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_trb_txls
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_trb_txls
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_trb_txls purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_trb_txls(
    stacid number(9) -- 账套
    ,systid varchar2(30) -- 业务来源系统编号
    ,trandt varchar2(8) -- 交易日期
    ,tranbr varchar2(12) -- 交易机构编号
    ,transq varchar2(64) -- 交易流水
    ,acctbr varchar2(12) -- 账务机构编号
    ,vchrsq varchar2(20) -- 传票序号
    ,custcd varchar2(16) -- 客户编号
    ,busitp varchar2(10) -- 业务类别
    ,crcycd varchar2(3) -- 币种（交易）
    ,tranam number(20,2) -- 交易金额（含税）
    ,vatxrt number(17,8) -- 税率
    ,taxbam number(21,2) -- 税额
    ,pricam number(20,2) -- 交易金额（不含税）
    ,smrytx varchar2(200) -- 备注
    ,status varchar2(1) -- 状态
    ,catxtp varchar2(1) -- 计税方式（s：简易计税n：一般计税）
    ,exeptg varchar2(1) -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
    ,typecd varchar2(20) -- 税目代码
    ,crcyiv varchar2(3) -- 开票币种
    ,exchrt number(15,8) -- 折算汇率
    ,expram number(21,2) -- 净价折算金额
    ,itemcd varchar2(30) -- 科目编号
    ,itemna varchar2(200) -- 科目名称
    ,extxam number(21,2) -- 税额折算金额
    ,pritem varchar2(30) -- 净价科目编号
    ,txitem varchar2(30) -- 税额科目编号
    ,serino varchar2(20) -- 应税流水序号
    ,prodcd varchar2(12) -- 产品编号
    ,prodp1 varchar2(30) -- 产品属性1
    ,prodp2 varchar2(30) -- 产品属性2
    ,prodp3 varchar2(30) -- 产品属性3
    ,prodp4 varchar2(30) -- 产品属性4
    ,prodp5 varchar2(30) -- 产品属性5
    ,prodp6 varchar2(30) -- 产品属性6
    ,prodp7 varchar2(30) -- 产品属性7
    ,prodp8 varchar2(30) -- 产品属性8
    ,prodp9 varchar2(30) -- 产品属性9
    ,prodpa varchar2(30) -- 产品属性10
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
grant select on ${iol_schema}.tgls_trb_txls to ${iml_schema};
grant select on ${iol_schema}.tgls_trb_txls to ${icl_schema};
grant select on ${iol_schema}.tgls_trb_txls to ${idl_schema};
grant select on ${iol_schema}.tgls_trb_txls to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_trb_txls is '应税交易明细';
comment on column ${iol_schema}.tgls_trb_txls.stacid is '账套';
comment on column ${iol_schema}.tgls_trb_txls.systid is '业务来源系统编号';
comment on column ${iol_schema}.tgls_trb_txls.trandt is '交易日期';
comment on column ${iol_schema}.tgls_trb_txls.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_trb_txls.transq is '交易流水';
comment on column ${iol_schema}.tgls_trb_txls.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_trb_txls.vchrsq is '传票序号';
comment on column ${iol_schema}.tgls_trb_txls.custcd is '客户编号';
comment on column ${iol_schema}.tgls_trb_txls.busitp is '业务类别';
comment on column ${iol_schema}.tgls_trb_txls.crcycd is '币种（交易）';
comment on column ${iol_schema}.tgls_trb_txls.tranam is '交易金额（含税）';
comment on column ${iol_schema}.tgls_trb_txls.vatxrt is '税率';
comment on column ${iol_schema}.tgls_trb_txls.taxbam is '税额';
comment on column ${iol_schema}.tgls_trb_txls.pricam is '交易金额（不含税）';
comment on column ${iol_schema}.tgls_trb_txls.smrytx is '备注';
comment on column ${iol_schema}.tgls_trb_txls.status is '状态';
comment on column ${iol_schema}.tgls_trb_txls.catxtp is '计税方式（s：简易计税n：一般计税）';
comment on column ${iol_schema}.tgls_trb_txls.exeptg is '应税标识（0：零税率1：是n：免税*：无效）——对销项适用';
comment on column ${iol_schema}.tgls_trb_txls.typecd is '税目代码';
comment on column ${iol_schema}.tgls_trb_txls.crcyiv is '开票币种';
comment on column ${iol_schema}.tgls_trb_txls.exchrt is '折算汇率';
comment on column ${iol_schema}.tgls_trb_txls.expram is '净价折算金额';
comment on column ${iol_schema}.tgls_trb_txls.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_trb_txls.itemna is '科目名称';
comment on column ${iol_schema}.tgls_trb_txls.extxam is '税额折算金额';
comment on column ${iol_schema}.tgls_trb_txls.pritem is '净价科目编号';
comment on column ${iol_schema}.tgls_trb_txls.txitem is '税额科目编号';
comment on column ${iol_schema}.tgls_trb_txls.serino is '应税流水序号';
comment on column ${iol_schema}.tgls_trb_txls.prodcd is '产品编号';
comment on column ${iol_schema}.tgls_trb_txls.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_trb_txls.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_trb_txls.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_trb_txls.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_trb_txls.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_trb_txls.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_trb_txls.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_trb_txls.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_trb_txls.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_trb_txls.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_trb_txls.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_trb_txls.etl_timestamp is 'ETL处理时间戳';
