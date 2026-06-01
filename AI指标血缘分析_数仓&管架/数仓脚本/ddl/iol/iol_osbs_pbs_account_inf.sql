/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_account_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_account_inf
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_account_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_account_inf(
    pai_ecifno varchar2(32) -- 全行统一客户号
    ,pai_userno varchar2(32) -- 用户顺序号
    ,pai_accno varchar2(32) -- 账号
    ,pai_acctype varchar2(10) -- 账号类型
    ,pai_accname varchar2(128) -- 账户名称
    ,pai_currency varchar2(3) -- 币种
    ,pai_authorization varchar2(8) -- 账户权限
    ,pai_opendate varchar2(14) -- 账户挂入日期
    ,pai_opennode varchar2(8) -- 账户开户机构
    ,pai_openbranch varchar2(256) -- 账户开户网点名称
    ,pai_addnode varchar2(8) -- 账户加挂机构
    ,pai_addbranch varchar2(256) -- 账户加挂网点名称
    ,pai_state varchar2(4) -- 状态
    ,pai_accalias varchar2(128) -- 账户别名
    ,pai_signway varchar2(1) -- 签约方式
    ,pai_signchannel varchar2(3) -- 签约渠道
    ,pai_pauserremark varchar2(120) -- 账户暂停原因
    ,pai_cardtype varchar2(12) -- 合作卡类型
    ,pai_accountorder varchar2(2) -- 
    ,pai_asacno varchar2(64) -- 卡折关联账号
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
grant select on ${iol_schema}.osbs_pbs_account_inf to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_account_inf to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_account_inf to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_account_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_account_inf is '个人客户加挂账户表';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_accno is '账号';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_acctype is '账号类型';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_accname is '账户名称';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_currency is '币种';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_authorization is '账户权限';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_opendate is '账户挂入日期';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_opennode is '账户开户机构';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_openbranch is '账户开户网点名称';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_addnode is '账户加挂机构';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_addbranch is '账户加挂网点名称';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_state is '状态';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_accalias is '账户别名';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_signway is '签约方式';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_signchannel is '签约渠道';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_pauserremark is '账户暂停原因';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_cardtype is '合作卡类型';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_accountorder is '';
comment on column ${iol_schema}.osbs_pbs_account_inf.pai_asacno is '卡折关联账号';
comment on column ${iol_schema}.osbs_pbs_account_inf.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_pbs_account_inf.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_pbs_account_inf.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_pbs_account_inf.etl_timestamp is 'ETL处理时间戳';
