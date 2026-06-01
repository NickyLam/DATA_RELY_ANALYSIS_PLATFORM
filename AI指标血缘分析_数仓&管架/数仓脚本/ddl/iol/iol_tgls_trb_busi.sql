/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_trb_busi
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_trb_busi
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_trb_busi purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_trb_busi(
    stacid number(9) -- 账套
    ,systid varchar2(30) -- 来源系统编号
    ,trandt varchar2(8) -- 交易日期
    ,transq varchar2(50) -- 交易流水
    ,custcd varchar2(16) -- 客户编号
    ,tranbr varchar2(12) -- 交易机构编号
    ,acctbr varchar2(12) -- 账务机构编号
    ,typecd varchar2(20) -- 应税类别
    ,tranam number(20,2) -- 交易金额
    ,smrytx varchar2(255) -- 备注
    ,trstat varchar2(1) -- 状态（0：未处理1：已处理）
    ,prcscd varchar2(20) -- 交易码
    ,vatxrt number(17,8) -- 税率
    ,vatxam number(21,2) -- 税额
    ,pricam number(21,2) -- 净价格
    ,strkdt varchar2(8) -- 被冲正业务日期
    ,strksq varchar2(33) -- 被冲正业务流水号
    ,strkst varchar2(1) -- 流水标识（0：非冲正1：冲正流水2：补账流水）
    ,openam number(20,2) -- 交易金额
    ,prcsna varchar2(60) -- 交易码名称
    ,vchrsq varchar2(20) -- 传票流水
    ,crcycd varchar2(3) -- 币种（交易）
    ,crcyiv varchar2(3) -- 币种（开票）
    ,itemcd varchar2(30) -- 价税分离科目编号
    ,itemna varchar2(200) -- 价税分离科目名称
    ,sperdt varchar2(8) -- 价税分离日期
    ,sourst varchar2(4) -- 源业务交易流水
    ,sourdt varchar2(8) -- 源业务交易日期
    ,soursq varchar2(50) -- 源业务交易流水
    ,sourno varchar2(50) -- 源业务交易流水序号
    ,prodcd varchar2(12) -- 产品编号
    ,serino varchar2(20) -- 涉票流水序号
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
grant select on ${iol_schema}.tgls_trb_busi to ${iml_schema};
grant select on ${iol_schema}.tgls_trb_busi to ${icl_schema};
grant select on ${iol_schema}.tgls_trb_busi to ${idl_schema};
grant select on ${iol_schema}.tgls_trb_busi to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_trb_busi is '销项交易流水表';
comment on column ${iol_schema}.tgls_trb_busi.stacid is '账套';
comment on column ${iol_schema}.tgls_trb_busi.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_trb_busi.trandt is '交易日期';
comment on column ${iol_schema}.tgls_trb_busi.transq is '交易流水';
comment on column ${iol_schema}.tgls_trb_busi.custcd is '客户编号';
comment on column ${iol_schema}.tgls_trb_busi.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_trb_busi.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_trb_busi.typecd is '应税类别';
comment on column ${iol_schema}.tgls_trb_busi.tranam is '交易金额';
comment on column ${iol_schema}.tgls_trb_busi.smrytx is '备注';
comment on column ${iol_schema}.tgls_trb_busi.trstat is '状态（0：未处理1：已处理）';
comment on column ${iol_schema}.tgls_trb_busi.prcscd is '交易码';
comment on column ${iol_schema}.tgls_trb_busi.vatxrt is '税率';
comment on column ${iol_schema}.tgls_trb_busi.vatxam is '税额';
comment on column ${iol_schema}.tgls_trb_busi.pricam is '净价格';
comment on column ${iol_schema}.tgls_trb_busi.strkdt is '被冲正业务日期';
comment on column ${iol_schema}.tgls_trb_busi.strksq is '被冲正业务流水号';
comment on column ${iol_schema}.tgls_trb_busi.strkst is '流水标识（0：非冲正1：冲正流水2：补账流水）';
comment on column ${iol_schema}.tgls_trb_busi.openam is '交易金额';
comment on column ${iol_schema}.tgls_trb_busi.prcsna is '交易码名称';
comment on column ${iol_schema}.tgls_trb_busi.vchrsq is '传票流水';
comment on column ${iol_schema}.tgls_trb_busi.crcycd is '币种（交易）';
comment on column ${iol_schema}.tgls_trb_busi.crcyiv is '币种（开票）';
comment on column ${iol_schema}.tgls_trb_busi.itemcd is '价税分离科目编号';
comment on column ${iol_schema}.tgls_trb_busi.itemna is '价税分离科目名称';
comment on column ${iol_schema}.tgls_trb_busi.sperdt is '价税分离日期';
comment on column ${iol_schema}.tgls_trb_busi.sourst is '源业务交易流水';
comment on column ${iol_schema}.tgls_trb_busi.sourdt is '源业务交易日期';
comment on column ${iol_schema}.tgls_trb_busi.soursq is '源业务交易流水';
comment on column ${iol_schema}.tgls_trb_busi.sourno is '源业务交易流水序号';
comment on column ${iol_schema}.tgls_trb_busi.prodcd is '产品编号';
comment on column ${iol_schema}.tgls_trb_busi.serino is '涉票流水序号';
comment on column ${iol_schema}.tgls_trb_busi.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_trb_busi.etl_timestamp is 'ETL处理时间戳';
