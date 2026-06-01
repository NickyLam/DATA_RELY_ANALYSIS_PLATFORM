/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbvirbankaccmap
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbvirbankaccmap
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbvirbankaccmap purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbvirbankaccmap(
    vir_bank_acc varchar2(48) -- 组合宝虚拟账户
    ,bank_no varchar2(32) -- 银行编号
    ,bank_acc varchar2(64) -- 客户银行账号
    ,in_client_no varchar2(30) -- 内部客户编号
    ,open_branch varchar2(80) -- 交易归属机构
    ,open_date number(22) -- 开户日期
    ,channel varchar2(2) -- 开户渠道号
    ,vir_type varchar2(5) -- 虚拟账户类型，000-非虚拟账户，001-虚拟账户
    ,amt1 number(18,3) -- 备用金额1
    ,amt2 number(18,3) -- 备用金额2
    ,reserve1 varchar2(375) -- 保留字段1
    ,reserve2 varchar2(375) -- 保留字段2
    ,reserve3 varchar2(375) -- 保留字段3
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
grant select on ${iol_schema}.ifms_tbvirbankaccmap to ${iml_schema};
grant select on ${iol_schema}.ifms_tbvirbankaccmap to ${icl_schema};
grant select on ${iol_schema}.ifms_tbvirbankaccmap to ${idl_schema};
grant select on ${iol_schema}.ifms_tbvirbankaccmap to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbvirbankaccmap is '组合宝银行账转换关系表';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.vir_bank_acc is '组合宝虚拟账户';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.bank_no is '银行编号';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.bank_acc is '客户银行账号';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.in_client_no is '内部客户编号';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.open_branch is '交易归属机构';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.open_date is '开户日期';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.channel is '开户渠道号';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.vir_type is '虚拟账户类型，000-非虚拟账户，001-虚拟账户';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.amt1 is '备用金额1';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.amt2 is '备用金额2';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.reserve1 is '保留字段1';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.reserve2 is '保留字段2';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.reserve3 is '保留字段3';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbvirbankaccmap.etl_timestamp is 'ETL处理时间戳';
