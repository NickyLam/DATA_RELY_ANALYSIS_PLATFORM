/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefcharge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefcharge
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefcharge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefcharge(
    bthseq varchar2(15) -- 批次日期
    ,bthdate varchar2(12) -- 批次流水
    ,strdate varchar2(12) -- 计费开始日期
    ,enddate varchar2(12) -- 计费终止日期
    ,upbrn varchar2(18) -- 直接清算行行号
    ,paybrn varchar2(18) -- 支付行号
    ,txntype varchar2(9) -- 交易类型细分
    ,filenum varchar2(15) -- 文件包数
    ,trxnum varchar2(15) -- 交易笔数
    ,trxccy varchar2(5) -- 交易币种
    ,trxamt number(22,2) -- 交易金额
    ,chrgccy varchar2(5) -- 计费币种
    ,chrgamt number(22,2) -- 计费金额
    ,status varchar2(3) -- 状态
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
grant select on ${iol_schema}.mpcs_a49tefcharge to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefcharge to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefcharge to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefcharge to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefcharge is '计费表';
comment on column ${iol_schema}.mpcs_a49tefcharge.bthseq is '批次日期';
comment on column ${iol_schema}.mpcs_a49tefcharge.bthdate is '批次流水';
comment on column ${iol_schema}.mpcs_a49tefcharge.strdate is '计费开始日期';
comment on column ${iol_schema}.mpcs_a49tefcharge.enddate is '计费终止日期';
comment on column ${iol_schema}.mpcs_a49tefcharge.upbrn is '直接清算行行号';
comment on column ${iol_schema}.mpcs_a49tefcharge.paybrn is '支付行号';
comment on column ${iol_schema}.mpcs_a49tefcharge.txntype is '交易类型细分';
comment on column ${iol_schema}.mpcs_a49tefcharge.filenum is '文件包数';
comment on column ${iol_schema}.mpcs_a49tefcharge.trxnum is '交易笔数';
comment on column ${iol_schema}.mpcs_a49tefcharge.trxccy is '交易币种';
comment on column ${iol_schema}.mpcs_a49tefcharge.trxamt is '交易金额';
comment on column ${iol_schema}.mpcs_a49tefcharge.chrgccy is '计费币种';
comment on column ${iol_schema}.mpcs_a49tefcharge.chrgamt is '计费金额';
comment on column ${iol_schema}.mpcs_a49tefcharge.status is '状态';
comment on column ${iol_schema}.mpcs_a49tefcharge.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefcharge.etl_timestamp is 'ETL处理时间戳';
