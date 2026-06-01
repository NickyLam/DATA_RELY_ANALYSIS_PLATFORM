/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_glb_dept_book
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_glb_dept_book
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_glb_dept_book purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_glb_dept_book(
    acctdt varchar2(8) -- 账务日期
    ,stacid number(19) -- 账套
    ,acctno varchar2(56) -- 协议编号
    ,systid varchar2(30) -- 系统代号
    ,brchcd varchar2(16) -- 账务机构编号
    ,prodcd varchar2(16) -- 解析产品
    ,loanp1 varchar2(25) -- 产品属性1
    ,loanp2 varchar2(16) -- 模块
    ,loanp3 varchar2(16) -- 产品属性3
    ,loanp4 varchar2(16) -- 产品属性4
    ,loanp5 varchar2(16) -- 产品属性5
    ,loanp6 varchar2(16) -- 产品属性6
    ,loanp7 varchar2(16) -- 产品属性7
    ,loanp8 varchar2(16) -- 产品属性8
    ,loanp9 varchar2(16) -- 产品属性9
    ,loanpa varchar2(16) -- 产品属性10
    ,trprcd varchar2(16) -- 金额类型
    ,captal number(20,2) -- 余额
    ,crcycd varchar2(3) -- 币种
    ,evetdn varchar2(16) -- 交易方向
    ,tranam number(20,2) -- 交易金额
    ,assis1 varchar2(30) -- 辅助字段1
    ,assis2 varchar2(30) -- 辅助字段2
    ,bathid varchar2(64) -- 批次号
    ,bathdt varchar2(8) -- 批次号日期
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
grant select on ${iol_schema}.tgls_glb_dept_book to ${iml_schema};
grant select on ${iol_schema}.tgls_glb_dept_book to ${icl_schema};
grant select on ${iol_schema}.tgls_glb_dept_book to ${idl_schema};
grant select on ${iol_schema}.tgls_glb_dept_book to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_glb_dept_book is '交易流水对账临时接口表';
comment on column ${iol_schema}.tgls_glb_dept_book.acctdt is '账务日期';
comment on column ${iol_schema}.tgls_glb_dept_book.stacid is '账套';
comment on column ${iol_schema}.tgls_glb_dept_book.acctno is '协议编号';
comment on column ${iol_schema}.tgls_glb_dept_book.systid is '系统代号';
comment on column ${iol_schema}.tgls_glb_dept_book.brchcd is '账务机构编号';
comment on column ${iol_schema}.tgls_glb_dept_book.prodcd is '解析产品';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp1 is '产品属性1';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp2 is '模块';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp3 is '产品属性3';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp4 is '产品属性4';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp5 is '产品属性5';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp6 is '产品属性6';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp7 is '产品属性7';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp8 is '产品属性8';
comment on column ${iol_schema}.tgls_glb_dept_book.loanp9 is '产品属性9';
comment on column ${iol_schema}.tgls_glb_dept_book.loanpa is '产品属性10';
comment on column ${iol_schema}.tgls_glb_dept_book.trprcd is '金额类型';
comment on column ${iol_schema}.tgls_glb_dept_book.captal is '余额';
comment on column ${iol_schema}.tgls_glb_dept_book.crcycd is '币种';
comment on column ${iol_schema}.tgls_glb_dept_book.evetdn is '交易方向';
comment on column ${iol_schema}.tgls_glb_dept_book.tranam is '交易金额';
comment on column ${iol_schema}.tgls_glb_dept_book.assis1 is '辅助字段1';
comment on column ${iol_schema}.tgls_glb_dept_book.assis2 is '辅助字段2';
comment on column ${iol_schema}.tgls_glb_dept_book.bathid is '批次号';
comment on column ${iol_schema}.tgls_glb_dept_book.bathdt is '批次号日期';
comment on column ${iol_schema}.tgls_glb_dept_book.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_glb_dept_book.etl_timestamp is 'ETL处理时间戳';
