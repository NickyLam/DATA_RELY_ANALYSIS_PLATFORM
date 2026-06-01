/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_offline_recovery_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_offline_recovery_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_offline_recovery_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_offline_recovery_contract(
    id varchar2(60) -- 
    ,contract_no varchar2(60) -- 批次号
    ,product_no varchar2(12) -- 产品号
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(18) -- 机构号
    ,recept_brh_id varchar2(15) -- 承接行机构代码
    ,busi_date varchar2(12) -- 业务发生日期
    ,pay_date varchar2(12) -- 偿付日期
    ,trader_name varchar2(300) -- 交易对手名称
    ,trader_credit_no varchar2(27) -- 交易对手社会信用代码
    ,trader_account varchar2(75) -- 交易对手账号
    ,trader_bank_no varchar2(18) -- 交易对手行行号
    ,trader_brh_no varchar2(15) -- 交易对手机构代码
    ,busi_branch_no varchar2(15) -- 业务机构号
    ,acct_branch_no varchar2(15) -- 财务机构号
    ,manager_no varchar2(30) -- 客户经理
    ,department_no varchar2(15) -- 部门编号
    ,contract_status varchar2(3) -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,cust_type varchar2(2) -- 客户类别： 1 对公客户 2 同业客户 3 理财客户
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
grant select on ${iol_schema}.bdms_cpes_offline_recovery_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_offline_recovery_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_offline_recovery_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_offline_recovery_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_offline_recovery_contract is '线下追偿批次信息表';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.id is '';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.recept_brh_id is '承接行机构代码';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.busi_date is '业务发生日期';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.pay_date is '偿付日期';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.trader_name is '交易对手名称';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.trader_credit_no is '交易对手社会信用代码';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.trader_account is '交易对手账号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.trader_bank_no is '交易对手行行号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.trader_brh_no is '交易对手机构代码';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.acct_branch_no is '财务机构号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.manager_no is '客户经理';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.department_no is '部门编号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.contract_status is '审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.cust_type is '客户类别： 1 对公客户 2 同业客户 3 理财客户';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_contract.etl_timestamp is 'ETL处理时间戳';
