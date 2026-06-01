/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_tgls_prod_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_tgls_prod_acct_info
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_tgls_prod_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_tgls_prod_acct_info(
    acctdt varchar2(12) -- 账务日期
    ,acctno varchar2(150) -- 协议编号
    ,systid varchar2(150) -- 系统代号
    ,brchcd varchar2(150) -- 账务机构编号
    ,prodcd varchar2(150) -- 解析产品
    ,loanp1 varchar2(150) -- 产品属性1
    ,loanp2 varchar2(150) -- 产品属性2
    ,loanp3 varchar2(150) -- 产品属性3
    ,loanp4 varchar2(150) -- 产品属性4
    ,loanp5 varchar2(150) -- 产品属性5
    ,loanp6 varchar2(150) -- 产品属性6
    ,loanp7 varchar2(150) -- 产品属性7
    ,loanp8 varchar2(150) -- 产品属性8
    ,loanp9 varchar2(150) -- 产品属性9
    ,loanpa varchar2(150) -- 产品属性10
    ,trprcd varchar2(150) -- 金额类型
    ,captal number(20,2) -- 余额
    ,crcycd varchar2(150) -- 币种
    ,evetdn varchar2(150) -- 交易方向
    ,tranam number(20,2) -- 交易金额
    ,assis1 varchar2(150) -- 可售产品
    ,assis2 varchar2(150) -- 辅助核算2
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
grant select on ${iol_schema}.ifcs_tgls_prod_acct_info to ${iml_schema};
grant select on ${iol_schema}.ifcs_tgls_prod_acct_info to ${icl_schema};
grant select on ${iol_schema}.ifcs_tgls_prod_acct_info to ${idl_schema};
grant select on ${iol_schema}.ifcs_tgls_prod_acct_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_tgls_prod_acct_info is '核算中台分户信息表';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.acctdt is '账务日期';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.acctno is '协议编号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.systid is '系统代号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.brchcd is '账务机构编号';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.prodcd is '解析产品';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp1 is '产品属性1';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp2 is '产品属性2';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp3 is '产品属性3';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp4 is '产品属性4';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp5 is '产品属性5';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp6 is '产品属性6';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp7 is '产品属性7';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp8 is '产品属性8';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanp9 is '产品属性9';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.loanpa is '产品属性10';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.trprcd is '金额类型';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.captal is '余额';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.crcycd is '币种';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.evetdn is '交易方向';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.tranam is '交易金额';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.assis1 is '可售产品';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.assis2 is '辅助核算2';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_tgls_prod_acct_info.etl_timestamp is 'ETL处理时间戳';
