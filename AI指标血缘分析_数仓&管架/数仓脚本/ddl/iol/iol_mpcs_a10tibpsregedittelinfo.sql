/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a10tibpsregedittelinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a10tibpsregedittelinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a10tibpsregedittelinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a10tibpsregedittelinfo(
    tel varchar2(75) -- 手机号
    ,idtype varchar2(6) -- 证件类型
    ,idcode varchar2(105) -- 证件号
    ,acctno varchar2(96) -- 账号
    ,acctname varchar2(180) -- 户名
    ,dftaccttp varchar2(6) -- 账号注册属性
    ,rejectbank varchar2(18) -- 开户行所属网银系统行号
    ,acctopenbrn varchar2(18) -- 账户开户行
    ,sdficode varchar2(18) -- 账户清算行
    ,regedittm varchar2(29) -- 登记时间
    ,status varchar2(3) -- 状态：0_已注销，1_已注册
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
grant select on ${iol_schema}.mpcs_a10tibpsregedittelinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a10tibpsregedittelinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a10tibpsregedittelinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a10tibpsregedittelinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a10tibpsregedittelinfo is '客户账户注册手机号信息表';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.tel is '手机号';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.idcode is '证件号';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.acctno is '账号';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.acctname is '户名';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.dftaccttp is '账号注册属性';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.rejectbank is '开户行所属网银系统行号';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.acctopenbrn is '账户开户行';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.sdficode is '账户清算行';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.regedittm is '登记时间';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.status is '状态：0_已注销，1_已注册';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a10tibpsregedittelinfo.etl_timestamp is 'ETL处理时间戳';
