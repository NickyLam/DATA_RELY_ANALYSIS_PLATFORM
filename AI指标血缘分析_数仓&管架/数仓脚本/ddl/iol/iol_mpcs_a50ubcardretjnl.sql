/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a50ubcardretjnl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a50ubcardretjnl
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a50ubcardretjnl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubcardretjnl(
    trsdate varchar2(12) -- 交易日期
    ,trstime varchar2(9) -- 交易时间
    ,hosttrace varchar2(96) -- 交易流水号
    ,ctrscode varchar2(5) -- atmc交易码
    ,trscode varchar2(15) -- 后台交易码
    ,occunit varchar2(17) -- 代理机构
    ,termid varchar2(12) -- 终端标识
    ,systrace varchar2(12) -- 网点流水号
    ,cardno1 varchar2(48) -- 卡号1
    ,cardno2 varchar2(48) -- 卡号2
    ,trssum number(11,2) -- 交易发生额
    ,balance1 number(16,2) -- 余额1
    ,balance2 number(16,2) -- 余额2
    ,response varchar2(8) -- 后台响应码
    ,recflag varchar2(2) -- 标志
    ,desunit number(11,0) -- 领卡机构
    ,tell varchar2(30) -- 领卡柜员
    ,memo1 varchar2(30) -- 备注1
    ,memo2 varchar2(30) -- 备注2
    ,errmsg varchar2(93) -- 吞卡原因
    ,nkcarddt varchar2(12) -- 领卡日期
    ,identp varchar2(6) -- 证件类型
    ,idennbr varchar2(32) -- 证件号码
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
grant select on ${iol_schema}.mpcs_a50ubcardretjnl to ${iml_schema};
grant select on ${iol_schema}.mpcs_a50ubcardretjnl to ${icl_schema};
grant select on ${iol_schema}.mpcs_a50ubcardretjnl to ${idl_schema};
grant select on ${iol_schema}.mpcs_a50ubcardretjnl to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a50ubcardretjnl is 'ATM/CDM吞卡登记表';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.trsdate is '交易日期';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.trstime is '交易时间';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.hosttrace is '交易流水号';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.ctrscode is 'atmc交易码';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.trscode is '后台交易码';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.occunit is '代理机构';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.termid is '终端标识';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.systrace is '网点流水号';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.cardno1 is '卡号1';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.cardno2 is '卡号2';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.trssum is '交易发生额';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.balance1 is '余额1';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.balance2 is '余额2';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.response is '后台响应码';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.recflag is '标志';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.desunit is '领卡机构';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.tell is '领卡柜员';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.memo1 is '备注1';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.memo2 is '备注2';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.errmsg is '吞卡原因';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.nkcarddt is '领卡日期';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.identp is '证件类型';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.idennbr is '证件号码';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a50ubcardretjnl.etl_timestamp is 'ETL处理时间戳';
