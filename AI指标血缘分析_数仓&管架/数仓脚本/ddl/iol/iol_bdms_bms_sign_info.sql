/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_sign_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_sign_info(
    id varchar2(60) -- ID
    ,cust_no varchar2(30) -- 客户号
    ,cust_name varchar2(300) -- 客户名称
    ,sign_type varchar2(2) -- 签约类型
    ,sign_account varchar2(150) -- 签约账号
    ,sign_branch varchar2(30) -- 签约机构
    ,sign_date varchar2(12) -- 签约日期
    ,status varchar2(2) -- 有效标识： 0 无效 1 有效
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date date -- 最后操作日期
    ,dualcontrol_lockstatus varchar2(3) -- 双岗复核锁标记
    ,top_branch_no varchar2(30) -- 总行机构号
    ,one_key_flag varchar2(2) -- 是否开通一键多功能： 0 否 1 是
    ,auto_accept_sign_flag varchar2(2) -- 是否开通自动承兑签收
    ,cancel_date varchar2(12) -- 解约日期
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
grant select on ${iol_schema}.bdms_bms_sign_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_sign_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_sign_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_sign_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_sign_info is '签约信息表';
comment on column ${iol_schema}.bdms_bms_sign_info.id is 'ID';
comment on column ${iol_schema}.bdms_bms_sign_info.cust_no is '客户号';
comment on column ${iol_schema}.bdms_bms_sign_info.cust_name is '客户名称';
comment on column ${iol_schema}.bdms_bms_sign_info.sign_type is '签约类型';
comment on column ${iol_schema}.bdms_bms_sign_info.sign_account is '签约账号';
comment on column ${iol_schema}.bdms_bms_sign_info.sign_branch is '签约机构';
comment on column ${iol_schema}.bdms_bms_sign_info.sign_date is '签约日期';
comment on column ${iol_schema}.bdms_bms_sign_info.status is '有效标识： 0 无效 1 有效';
comment on column ${iol_schema}.bdms_bms_sign_info.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_sign_info.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_sign_info.dualcontrol_lockstatus is '双岗复核锁标记';
comment on column ${iol_schema}.bdms_bms_sign_info.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_bms_sign_info.one_key_flag is '是否开通一键多功能： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_sign_info.auto_accept_sign_flag is '是否开通自动承兑签收';
comment on column ${iol_schema}.bdms_bms_sign_info.cancel_date is '解约日期';
comment on column ${iol_schema}.bdms_bms_sign_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_sign_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_sign_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_sign_info.etl_timestamp is 'ETL处理时间戳';
