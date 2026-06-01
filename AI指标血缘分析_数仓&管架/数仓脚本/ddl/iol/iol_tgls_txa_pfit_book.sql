/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_txa_pfit_book
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_txa_pfit_book
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_txa_pfit_book purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_txa_pfit_book(
    stacid number(9) -- 账套
    ,txisyr varchar2(4) -- 年度
    ,txismh varchar2(6) -- 纳税期
    ,brchcd varchar2(12) -- 机构编号
    ,crcycd varchar2(3) -- 币种
    ,prodcd varchar2(30) -- 类别
    ,lastbl number(21,2) -- 期初数
    ,tranam number(21,2) -- 本期发生额
    ,onlnbl number(21,2) -- 期末数
    ,yronbl number(21,2) -- 年累计数
    ,lstxam number(21,2) -- 上年销项税额
    ,vatxam number(21,2) -- 本期销项税额
    ,typecd varchar2(20) -- 税目
    ,vatxrt number(17,8) -- 税率
    ,yrtxbl number(21,2) -- 本年累计税额
    ,prsncd varchar2(8) -- 员工编号
    ,prducd varchar2(12) -- 产品编号
    ,centcd varchar2(16) -- 责任中心
    ,prlncd varchar2(16) -- 产品线
    ,custcd varchar2(16) -- 客户编号
    ,acctno varchar2(30) -- 账户
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
grant select on ${iol_schema}.tgls_txa_pfit_book to ${iml_schema};
grant select on ${iol_schema}.tgls_txa_pfit_book to ${icl_schema};
grant select on ${iol_schema}.tgls_txa_pfit_book to ${idl_schema};
grant select on ${iol_schema}.tgls_txa_pfit_book to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_txa_pfit_book is '汇总价税分离登记簿';
comment on column ${iol_schema}.tgls_txa_pfit_book.stacid is '账套';
comment on column ${iol_schema}.tgls_txa_pfit_book.txisyr is '年度';
comment on column ${iol_schema}.tgls_txa_pfit_book.txismh is '纳税期';
comment on column ${iol_schema}.tgls_txa_pfit_book.brchcd is '机构编号';
comment on column ${iol_schema}.tgls_txa_pfit_book.crcycd is '币种';
comment on column ${iol_schema}.tgls_txa_pfit_book.prodcd is '类别';
comment on column ${iol_schema}.tgls_txa_pfit_book.lastbl is '期初数';
comment on column ${iol_schema}.tgls_txa_pfit_book.tranam is '本期发生额';
comment on column ${iol_schema}.tgls_txa_pfit_book.onlnbl is '期末数';
comment on column ${iol_schema}.tgls_txa_pfit_book.yronbl is '年累计数';
comment on column ${iol_schema}.tgls_txa_pfit_book.lstxam is '上年销项税额';
comment on column ${iol_schema}.tgls_txa_pfit_book.vatxam is '本期销项税额';
comment on column ${iol_schema}.tgls_txa_pfit_book.typecd is '税目';
comment on column ${iol_schema}.tgls_txa_pfit_book.vatxrt is '税率';
comment on column ${iol_schema}.tgls_txa_pfit_book.yrtxbl is '本年累计税额';
comment on column ${iol_schema}.tgls_txa_pfit_book.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_txa_pfit_book.prducd is '产品编号';
comment on column ${iol_schema}.tgls_txa_pfit_book.centcd is '责任中心';
comment on column ${iol_schema}.tgls_txa_pfit_book.prlncd is '产品线';
comment on column ${iol_schema}.tgls_txa_pfit_book.custcd is '客户编号';
comment on column ${iol_schema}.tgls_txa_pfit_book.acctno is '账户';
comment on column ${iol_schema}.tgls_txa_pfit_book.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_txa_pfit_book.etl_timestamp is 'ETL处理时间戳';
