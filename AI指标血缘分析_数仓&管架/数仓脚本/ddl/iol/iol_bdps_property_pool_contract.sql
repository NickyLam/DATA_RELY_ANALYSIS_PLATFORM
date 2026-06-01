/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_property_pool_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_property_pool_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_property_pool_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_property_pool_contract(
    id number(22) -- 
    ,protocol_no varchar2(45) -- 资产池协议编号
    ,contract_type varchar2(2) -- 协议类型 1 -- 申请协议 2 -- 解除协议
    ,property_type varchar2(2) -- 1-理财产品
    ,branch_id number(22) -- 机构id
    ,operator_id number(22) -- 操作员号
    ,app_cust_id number(22) -- 申请客户号
    ,txn_date varchar2(12) -- 申请日期
    ,contract_status varchar2(2) -- 协议状态  0-已录入 1-审批中 2-审核成功 3-审核失败
    ,audit_status varchar2(2) -- 审核状态 0-未审核（默认） 2-审核中 3-审核成功 4-审核失败 5-审核退回
    ,logic_check_status varchar2(2) -- 业务逻辑查询状态 1-未业务逻辑查询（默认） 2-业务逻辑查询成功 3-业务逻辑查询失败
    ,manager_id number(22) -- 客户经理号
    ,depart_id number(22) -- 部门号
    ,appno varchar2(45) -- 申请编号
    ,misc varchar2(150) -- 信息域
    ,ebank_apply varchar2(2) -- 网银申请标志 0-否 1-是
    ,ebank_oper_name varchar2(150) -- 网银操作员名称
    ,last_upd_oper_id number(22) -- 最后修改操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,bail_account varchar2(33) -- 保证金账号
    ,applock varchar2(3) -- 00-未加锁 01--加锁
    ,auto_flag varchar2(2) -- 
    ,bsnssq varchar2(96) -- 全局流水号
    ,transq varchar2(96) -- 业务流水号
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
grant select on ${iol_schema}.bdps_property_pool_contract to ${iml_schema};
grant select on ${iol_schema}.bdps_property_pool_contract to ${icl_schema};
grant select on ${iol_schema}.bdps_property_pool_contract to ${idl_schema};
grant select on ${iol_schema}.bdps_property_pool_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_property_pool_contract is '资产池协议表';
comment on column ${iol_schema}.bdps_property_pool_contract.id is '';
comment on column ${iol_schema}.bdps_property_pool_contract.protocol_no is '资产池协议编号';
comment on column ${iol_schema}.bdps_property_pool_contract.contract_type is '协议类型 1 -- 申请协议 2 -- 解除协议';
comment on column ${iol_schema}.bdps_property_pool_contract.property_type is '1-理财产品';
comment on column ${iol_schema}.bdps_property_pool_contract.branch_id is '机构id';
comment on column ${iol_schema}.bdps_property_pool_contract.operator_id is '操作员号';
comment on column ${iol_schema}.bdps_property_pool_contract.app_cust_id is '申请客户号';
comment on column ${iol_schema}.bdps_property_pool_contract.txn_date is '申请日期';
comment on column ${iol_schema}.bdps_property_pool_contract.contract_status is '协议状态  0-已录入 1-审批中 2-审核成功 3-审核失败';
comment on column ${iol_schema}.bdps_property_pool_contract.audit_status is '审核状态 0-未审核（默认） 2-审核中 3-审核成功 4-审核失败 5-审核退回';
comment on column ${iol_schema}.bdps_property_pool_contract.logic_check_status is '业务逻辑查询状态 1-未业务逻辑查询（默认） 2-业务逻辑查询成功 3-业务逻辑查询失败';
comment on column ${iol_schema}.bdps_property_pool_contract.manager_id is '客户经理号';
comment on column ${iol_schema}.bdps_property_pool_contract.depart_id is '部门号';
comment on column ${iol_schema}.bdps_property_pool_contract.appno is '申请编号';
comment on column ${iol_schema}.bdps_property_pool_contract.misc is '信息域';
comment on column ${iol_schema}.bdps_property_pool_contract.ebank_apply is '网银申请标志 0-否 1-是';
comment on column ${iol_schema}.bdps_property_pool_contract.ebank_oper_name is '网银操作员名称';
comment on column ${iol_schema}.bdps_property_pool_contract.last_upd_oper_id is '最后修改操作员';
comment on column ${iol_schema}.bdps_property_pool_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdps_property_pool_contract.bail_account is '保证金账号';
comment on column ${iol_schema}.bdps_property_pool_contract.applock is '00-未加锁 01--加锁';
comment on column ${iol_schema}.bdps_property_pool_contract.auto_flag is '';
comment on column ${iol_schema}.bdps_property_pool_contract.bsnssq is '全局流水号';
comment on column ${iol_schema}.bdps_property_pool_contract.transq is '业务流水号';
comment on column ${iol_schema}.bdps_property_pool_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_property_pool_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_property_pool_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_property_pool_contract.etl_timestamp is 'ETL处理时间戳';
