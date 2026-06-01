/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_txa_glis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_txa_glis
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_txa_glis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_txa_glis(
    stacid number(19) -- 账套id
    ,acctdt varchar2(6) -- 纳税期间
    ,brchcd varchar2(12) -- 机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种
    ,drltbl number(20,2) -- 上期借方余额
    ,crltbl number(20,2) -- 上期贷方余额
    ,drtsam number(20,2) -- 本期借方发生额
    ,crtsam number(20,2) -- 本期贷方发生额
    ,drctbl number(20,2) -- 本期借方余额
    ,crctbl number(20,2) -- 本期贷方余额
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
grant select on ${iol_schema}.tgls_txa_glis to ${iml_schema};
grant select on ${iol_schema}.tgls_txa_glis to ${icl_schema};
grant select on ${iol_schema}.tgls_txa_glis to ${idl_schema};
grant select on ${iol_schema}.tgls_txa_glis to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_txa_glis is '传票汇总登记簿';
comment on column ${iol_schema}.tgls_txa_glis.stacid is '账套id';
comment on column ${iol_schema}.tgls_txa_glis.acctdt is '纳税期间';
comment on column ${iol_schema}.tgls_txa_glis.brchcd is '机构编号';
comment on column ${iol_schema}.tgls_txa_glis.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_txa_glis.crcycd is '币种';
comment on column ${iol_schema}.tgls_txa_glis.drltbl is '上期借方余额';
comment on column ${iol_schema}.tgls_txa_glis.crltbl is '上期贷方余额';
comment on column ${iol_schema}.tgls_txa_glis.drtsam is '本期借方发生额';
comment on column ${iol_schema}.tgls_txa_glis.crtsam is '本期贷方发生额';
comment on column ${iol_schema}.tgls_txa_glis.drctbl is '本期借方余额';
comment on column ${iol_schema}.tgls_txa_glis.crctbl is '本期贷方余额';
comment on column ${iol_schema}.tgls_txa_glis.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_txa_glis.prducd is '产品编号';
comment on column ${iol_schema}.tgls_txa_glis.centcd is '责任中心';
comment on column ${iol_schema}.tgls_txa_glis.prlncd is '产品线';
comment on column ${iol_schema}.tgls_txa_glis.custcd is '客户编号';
comment on column ${iol_schema}.tgls_txa_glis.acctno is '账户';
comment on column ${iol_schema}.tgls_txa_glis.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_txa_glis.etl_timestamp is 'ETL处理时间戳';
