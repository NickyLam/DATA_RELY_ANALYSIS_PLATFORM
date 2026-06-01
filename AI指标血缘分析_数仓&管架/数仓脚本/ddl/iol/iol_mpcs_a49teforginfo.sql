/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49teforginfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49teforginfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49teforginfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49teforginfo(
    deptcd varchar2(18) -- 机构代码
    ,deptnm varchar2(90) -- 机构名称
    ,zoneid varchar2(6) -- 地区代码
    ,trantype varchar2(8) -- 业务种类
    ,txntype varchar2(9) -- 交易类型细分
    ,currencycd varchar2(5) -- 交易货币
    ,opnbrn varchar2(18) -- 开户行行号
    ,payeeacc varchar2(53) -- 收款人账号
    ,payeename varchar2(150) -- 收款人名称
    ,phone varchar2(30) -- 联系电话
    ,linkman varchar2(90) -- 联系人
    ,effdate varchar2(12) -- 生效日期
    ,invdate varchar2(12) -- 停用日期
    ,status varchar2(3) -- 状态
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
grant select on ${iol_schema}.mpcs_a49teforginfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49teforginfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49teforginfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49teforginfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49teforginfo is '机构信息主表';
comment on column ${iol_schema}.mpcs_a49teforginfo.deptcd is '机构代码';
comment on column ${iol_schema}.mpcs_a49teforginfo.deptnm is '机构名称';
comment on column ${iol_schema}.mpcs_a49teforginfo.zoneid is '地区代码';
comment on column ${iol_schema}.mpcs_a49teforginfo.trantype is '业务种类';
comment on column ${iol_schema}.mpcs_a49teforginfo.txntype is '交易类型细分';
comment on column ${iol_schema}.mpcs_a49teforginfo.currencycd is '交易货币';
comment on column ${iol_schema}.mpcs_a49teforginfo.opnbrn is '开户行行号';
comment on column ${iol_schema}.mpcs_a49teforginfo.payeeacc is '收款人账号';
comment on column ${iol_schema}.mpcs_a49teforginfo.payeename is '收款人名称';
comment on column ${iol_schema}.mpcs_a49teforginfo.phone is '联系电话';
comment on column ${iol_schema}.mpcs_a49teforginfo.linkman is '联系人';
comment on column ${iol_schema}.mpcs_a49teforginfo.effdate is '生效日期';
comment on column ${iol_schema}.mpcs_a49teforginfo.invdate is '停用日期';
comment on column ${iol_schema}.mpcs_a49teforginfo.status is '状态';
comment on column ${iol_schema}.mpcs_a49teforginfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49teforginfo.etl_timestamp is 'ETL处理时间戳';
