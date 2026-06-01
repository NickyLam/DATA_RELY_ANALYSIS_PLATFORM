/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a01tbatmanage
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a01tbatmanage
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a01tbatmanage purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a01tbatmanage(
    chnlid varchar2(5) -- 
    ,batchtype varchar2(3) -- 
    ,batchdt varchar2(12) -- 
    ,batchno varchar2(30) -- 批次号
    ,fntdt varchar2(12) -- 
    ,fntseqno varchar2(12) -- 
    ,filename varchar2(48) -- 
    ,custno varchar2(15) -- 
    ,payacctno varchar2(48) -- 
    ,payacctname varchar2(384) -- 
    ,ccy varchar2(5) -- 
    ,totalnum varchar2(15) -- 
    ,succnum varchar2(15) -- 
    ,failnum varchar2(15) -- 
    ,totalamt varchar2(23) -- 
    ,succamt varchar2(23) -- 
    ,failamt varchar2(23) -- 
    ,trndtts varchar2(21) -- 
    ,tmpflag varchar2(3) -- 
    ,tmpacctno varchar2(48) -- 
    ,tmpacctname varchar2(384) -- 
    ,memo varchar2(600) -- 
    ,stat varchar2(3) -- 
    ,reserve varchar2(600) -- 
    ,crossflag varchar2(2) -- 跨行标识:0-本行1-跨行
    ,otherflag varchar2(2) -- 他行标识
    ,inneracno varchar2(30) -- 过渡内部户账号
    ,inneracna varchar2(384) -- 过渡内部户户名
    ,rspcd varchar2(30) -- 返回码
    ,dataid varchar2(96) -- 核心外围流水号
    ,hostseqno varchar2(96) -- 核心流水号
    ,hostseqdt varchar2(12) -- 核心日期
    ,brcno varchar2(9) -- 开户机构
    ,tlrno varchar2(12) -- 交易柜员
    ,realchn varchar2(2) -- 实际代发系统标识 1-薪酬服务平台 0-企业网银
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
grant select on ${iol_schema}.mpcs_a01tbatmanage to ${iml_schema};
grant select on ${iol_schema}.mpcs_a01tbatmanage to ${icl_schema};
grant select on ${iol_schema}.mpcs_a01tbatmanage to ${idl_schema};
grant select on ${iol_schema}.mpcs_a01tbatmanage to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a01tbatmanage is '企业网银代发批次表';
comment on column ${iol_schema}.mpcs_a01tbatmanage.chnlid is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.batchtype is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.batchdt is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.batchno is '批次号';
comment on column ${iol_schema}.mpcs_a01tbatmanage.fntdt is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.fntseqno is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.filename is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.custno is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.payacctno is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.payacctname is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.ccy is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.totalnum is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.succnum is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.failnum is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.totalamt is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.succamt is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.failamt is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.trndtts is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.tmpflag is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.tmpacctno is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.tmpacctname is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.memo is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.stat is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.reserve is '';
comment on column ${iol_schema}.mpcs_a01tbatmanage.crossflag is '跨行标识:0-本行1-跨行';
comment on column ${iol_schema}.mpcs_a01tbatmanage.otherflag is '他行标识';
comment on column ${iol_schema}.mpcs_a01tbatmanage.inneracno is '过渡内部户账号';
comment on column ${iol_schema}.mpcs_a01tbatmanage.inneracna is '过渡内部户户名';
comment on column ${iol_schema}.mpcs_a01tbatmanage.rspcd is '返回码';
comment on column ${iol_schema}.mpcs_a01tbatmanage.dataid is '核心外围流水号';
comment on column ${iol_schema}.mpcs_a01tbatmanage.hostseqno is '核心流水号';
comment on column ${iol_schema}.mpcs_a01tbatmanage.hostseqdt is '核心日期';
comment on column ${iol_schema}.mpcs_a01tbatmanage.brcno is '开户机构';
comment on column ${iol_schema}.mpcs_a01tbatmanage.tlrno is '交易柜员';
comment on column ${iol_schema}.mpcs_a01tbatmanage.realchn is '实际代发系统标识 1-薪酬服务平台 0-企业网银';
comment on column ${iol_schema}.mpcs_a01tbatmanage.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a01tbatmanage.etl_timestamp is 'ETL处理时间戳';
