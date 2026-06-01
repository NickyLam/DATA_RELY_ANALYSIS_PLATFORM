/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_acct_open
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_acct_open
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_acct_open purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_acct_open(
    stacid number(9) -- 账套标识
    ,systid varchar2(30) -- 来源系统编号
    ,acctbr varchar2(12) -- 账务机构编号
    ,crcycd varchar2(3) -- 源系统币种
    ,itemcd varchar2(30) -- 总账科目编号
    ,acctcl varchar2(1) -- 账户类别(1手工账户2基准账户3专用账户)
    ,maxisq number -- 当前已被使用的最大的账号序号+1
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
grant select on ${iol_schema}.tgls_gla_acct_open to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_acct_open to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_acct_open to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_acct_open to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_acct_open is '开户记录表';
comment on column ${iol_schema}.tgls_gla_acct_open.stacid is '账套标识';
comment on column ${iol_schema}.tgls_gla_acct_open.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_gla_acct_open.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gla_acct_open.crcycd is '源系统币种';
comment on column ${iol_schema}.tgls_gla_acct_open.itemcd is '总账科目编号';
comment on column ${iol_schema}.tgls_gla_acct_open.acctcl is '账户类别(1手工账户2基准账户3专用账户)';
comment on column ${iol_schema}.tgls_gla_acct_open.maxisq is '当前已被使用的最大的账号序号+1';
comment on column ${iol_schema}.tgls_gla_acct_open.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gla_acct_open.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gla_acct_open.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gla_acct_open.etl_timestamp is 'ETL处理时间戳';
