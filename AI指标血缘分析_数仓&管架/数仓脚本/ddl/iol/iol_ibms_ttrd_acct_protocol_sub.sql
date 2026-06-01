/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_acct_protocol_sub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_acct_protocol_sub
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_acct_protocol_sub purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acct_protocol_sub(
    id varchar2(30) -- 主键
    ,masterid varchar2(30) -- 主协议ID
    ,start_date varchar2(30) -- 开始日期
    ,end_date varchar2(30) -- 结束日期
    ,amount_rate number(10,6) -- 约期金额利率
    ,current_rate number(10,6) -- 约期活期利率
    ,sub_contract_no varchar2(180) -- 子序列号
    ,usable_flag number -- 是否已生效：1： 正常 0： 新增
    ,operate varchar2(8) -- 操作状态 add 新增  edit 修改
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
grant select on ${iol_schema}.ibms_ttrd_acct_protocol_sub to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_acct_protocol_sub to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_acct_protocol_sub to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_acct_protocol_sub to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_acct_protocol_sub is '子协议账户表';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.id is '主键';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.masterid is '主协议ID';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.start_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.end_date is '结束日期';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.amount_rate is '约期金额利率';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.current_rate is '约期活期利率';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.sub_contract_no is '子序列号';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.usable_flag is '是否已生效：1： 正常 0： 新增';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.operate is '操作状态 add 新增  edit 修改';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_acct_protocol_sub.etl_timestamp is 'ETL处理时间戳';
