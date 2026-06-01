/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_accept_unused_restitution
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_accept_unused_restitution
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_accept_unused_restitution purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_accept_unused_restitution(
    id varchar2(60) -- ID
    ,accept_id varchar2(60) -- 承兑明细ID
    ,draft_id varchar2(60) -- 清单ID
    ,branch_no varchar2(18) -- 交易机构编号
    ,withdraw_reason varchar2(300) -- 退回原因
    ,withdraw_date varchar2(12) -- 退回日期
    ,operator_no varchar2(45) -- 操作员
    ,status varchar2(3) -- 操作状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,account_status varchar2(3) -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,reserve1 varchar2(75) -- 备注1
    ,reserve2 varchar2(75) -- 备注2
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date date -- 最后操作日期
    ,txn_date varchar2(12) -- 申请日期
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
grant select on ${iol_schema}.bdms_bms_accept_unused_restitution to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_accept_unused_restitution to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_accept_unused_restitution to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_accept_unused_restitution to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_accept_unused_restitution is '未用退回表';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.id is 'ID';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.accept_id is '承兑明细ID';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.draft_id is '清单ID';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.branch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.withdraw_reason is '退回原因';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.withdraw_date is '退回日期';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.operator_no is '操作员';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.status is '操作状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.account_status is '记账状态： 0 未记账 1 记账中 2 记账完成';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.txn_date is '申请日期';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_accept_unused_restitution.etl_timestamp is 'ETL处理时间戳';
