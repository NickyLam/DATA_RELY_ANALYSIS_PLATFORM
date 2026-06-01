/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_buy_source_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_buy_source_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_buy_source_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_buy_source_info(
    draftid varchar2(75) -- 票据id
    ,draftnumber varchar2(75) -- 票据号码
    ,cdrange varchar2(75) -- 子票区间
    ,srctype varchar2(75) -- 票据来源
    ,contractid varchar2(75) -- 买入批次id
    ,productno varchar2(75) -- 产品号
    ,busidate varchar2(12) -- 业务日期
    ,innerflag varchar2(2) -- 系统内外标识
    ,rate number(9,6) -- 买入利率
    ,firstsource varchar2(2) -- 买入来源
    ,remainterest number(18,2) -- 剩余摊销金额
    ,acctbranchno varchar2(75) -- 记账机构
    ,dealid varchar2(75) -- 成交单编号
    ,seq varchar2(2) -- 排序序号
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
grant select on ${iol_schema}.bdms_buy_source_info to ${iml_schema};
grant select on ${iol_schema}.bdms_buy_source_info to ${icl_schema};
grant select on ${iol_schema}.bdms_buy_source_info to ${idl_schema};
grant select on ${iol_schema}.bdms_buy_source_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_buy_source_info is '买入来源查询视图';
comment on column ${iol_schema}.bdms_buy_source_info.draftid is '票据id';
comment on column ${iol_schema}.bdms_buy_source_info.draftnumber is '票据号码';
comment on column ${iol_schema}.bdms_buy_source_info.cdrange is '子票区间';
comment on column ${iol_schema}.bdms_buy_source_info.srctype is '票据来源';
comment on column ${iol_schema}.bdms_buy_source_info.contractid is '买入批次id';
comment on column ${iol_schema}.bdms_buy_source_info.productno is '产品号';
comment on column ${iol_schema}.bdms_buy_source_info.busidate is '业务日期';
comment on column ${iol_schema}.bdms_buy_source_info.innerflag is '系统内外标识';
comment on column ${iol_schema}.bdms_buy_source_info.rate is '买入利率';
comment on column ${iol_schema}.bdms_buy_source_info.firstsource is '买入来源';
comment on column ${iol_schema}.bdms_buy_source_info.remainterest is '剩余摊销金额';
comment on column ${iol_schema}.bdms_buy_source_info.acctbranchno is '记账机构';
comment on column ${iol_schema}.bdms_buy_source_info.dealid is '成交单编号';
comment on column ${iol_schema}.bdms_buy_source_info.seq is '排序序号';
comment on column ${iol_schema}.bdms_buy_source_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_buy_source_info.etl_timestamp is 'ETL处理时间戳';
