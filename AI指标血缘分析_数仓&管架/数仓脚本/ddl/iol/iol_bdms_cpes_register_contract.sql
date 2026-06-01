/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_register_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_register_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_register_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_register_contract(
    id varchar2(60) -- 
    ,contract_no varchar2(60) -- 批次号
    ,product_no varchar2(12) -- 产品号
    ,branch_no varchar2(18) -- 机构号
    ,top_branch_no varchar2(15) -- 总行机构号
    ,recept_brh_id varchar2(15) -- 承接机构代码
    ,apply_date varchar2(12) -- 登记日期
    ,busi_type varchar2(5) -- 业务登记类型： 001 承兑登记 002 承兑保证登记 003 质押登记 004 质押解除登记 005 贴现登记 006 结清登记 007 止付登记 008 止付解除登记 009 线下追偿 010 追偿结清 011 初始权属登记
    ,contract_status varchar2(3) -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,message_status varchar2(3) -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,last_upd_opr varchar2(45) -- 最后修改操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,created_by varchar2(45) -- 创建人
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
grant select on ${iol_schema}.bdms_cpes_register_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_register_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_register_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_register_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_register_contract is '登记类批次表';
comment on column ${iol_schema}.bdms_cpes_register_contract.id is '';
comment on column ${iol_schema}.bdms_cpes_register_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_register_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_register_contract.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_register_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_register_contract.recept_brh_id is '承接机构代码';
comment on column ${iol_schema}.bdms_cpes_register_contract.apply_date is '登记日期';
comment on column ${iol_schema}.bdms_cpes_register_contract.busi_type is '业务登记类型： 001 承兑登记 002 承兑保证登记 003 质押登记 004 质押解除登记 005 贴现登记 006 结清登记 007 止付登记 008 止付解除登记 009 线下追偿 010 追偿结清 011 初始权属登记';
comment on column ${iol_schema}.bdms_cpes_register_contract.contract_status is '审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_register_contract.message_status is '报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）';
comment on column ${iol_schema}.bdms_cpes_register_contract.last_upd_opr is '最后修改操作员';
comment on column ${iol_schema}.bdms_cpes_register_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_register_contract.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_register_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_register_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_register_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_register_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_register_contract.etl_timestamp is 'ETL处理时间戳';
