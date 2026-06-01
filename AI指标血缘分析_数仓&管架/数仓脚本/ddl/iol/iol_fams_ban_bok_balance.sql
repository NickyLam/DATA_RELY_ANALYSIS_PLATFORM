/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ban_bok_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ban_bok_balance
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ban_bok_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_bok_balance(
    bookset_id varchar2(50) -- 账套代码
    ,balance_date date -- 余额日期
    ,subject_no varchar2(300) -- 科目号
    ,bal_flag varchar2(50) -- 借贷方向
    ,amt number(30,2) -- 科目余额
    ,damt number(30,2) -- 借方金额
    ,camt number(30,2) -- 贷方金额
    ,ccy varchar2(50) -- 币种
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_ban_bok_balance to ${iml_schema};
grant select on ${iol_schema}.fams_ban_bok_balance to ${icl_schema};
grant select on ${iol_schema}.fams_ban_bok_balance to ${idl_schema};
grant select on ${iol_schema}.fams_ban_bok_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ban_bok_balance is '银行账科目余额';
comment on column ${iol_schema}.fams_ban_bok_balance.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_ban_bok_balance.balance_date is '余额日期';
comment on column ${iol_schema}.fams_ban_bok_balance.subject_no is '科目号';
comment on column ${iol_schema}.fams_ban_bok_balance.bal_flag is '借贷方向';
comment on column ${iol_schema}.fams_ban_bok_balance.amt is '科目余额';
comment on column ${iol_schema}.fams_ban_bok_balance.damt is '借方金额';
comment on column ${iol_schema}.fams_ban_bok_balance.camt is '贷方金额';
comment on column ${iol_schema}.fams_ban_bok_balance.ccy is '币种';
comment on column ${iol_schema}.fams_ban_bok_balance.create_user is '创建人';
comment on column ${iol_schema}.fams_ban_bok_balance.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ban_bok_balance.create_time is '创建时间';
comment on column ${iol_schema}.fams_ban_bok_balance.update_user is '更新人';
comment on column ${iol_schema}.fams_ban_bok_balance.update_time is '更新时间';
comment on column ${iol_schema}.fams_ban_bok_balance.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ban_bok_balance.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ban_bok_balance.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ban_bok_balance.etl_timestamp is 'ETL处理时间戳';
