/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_countparty_bankacct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_countparty_bankacct
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_countparty_bankacct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_countparty_bankacct(
    id number(22,0) -- 
    ,i_id number(22,0) -- 
    ,host_i_id number(22,0) -- 
    ,bank_acct varchar2(75) -- 
    ,bank_acct_name varchar2(300) -- 
    ,currency varchar2(5) -- 货币类型
    ,b_i_id number(22,0) -- 
    ,mid_bank_acct_code varchar2(75) -- 中间行账号
    ,mid_bank_name varchar2(300) -- 中间行名称
    ,mid_swift_code varchar2(75) -- 中间行swift代码
    ,bank_code varchar2(18) -- 开户行行号
    ,bank_name varchar2(150) -- 开户行名称
    ,swift_code varchar2(75) -- 开户行swift代码
    ,remark varchar2(75) -- 
    ,recv_bank_name varchar2(383) -- 本方收款行账户名
    ,recv_bank_swift_code varchar2(75) -- 本方收款行swiftcode
    ,acc_code_type varchar2(15) -- 代码类型:0-cnaps,8-swift,9-cfxps
    ,swift_type varchar2(15) -- 交割报文
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_countparty_bankacct to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_countparty_bankacct to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_countparty_bankacct to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_countparty_bankacct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_countparty_bankacct is '客户信息银行账户表';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.id is '';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.i_id is '';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.host_i_id is '';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.bank_acct is '';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.bank_acct_name is '';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.currency is '货币类型';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.b_i_id is '';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.mid_bank_acct_code is '中间行账号';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.mid_bank_name is '中间行名称';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.mid_swift_code is '中间行swift代码';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.bank_code is '开户行行号';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.bank_name is '开户行名称';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.swift_code is '开户行swift代码';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.remark is '';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.recv_bank_name is '本方收款行账户名';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.recv_bank_swift_code is '本方收款行swiftcode';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.acc_code_type is '代码类型:0-cnaps,8-swift,9-cfxps';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.swift_type is '交割报文';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_countparty_bankacct.etl_timestamp is 'ETL处理时间戳';
