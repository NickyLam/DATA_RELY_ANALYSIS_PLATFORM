/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_rlvpledge_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_rlvpledge_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_rlvpledge_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_rlvpledge_contract(
    id varchar2(60) -- ID
    ,buss_flag varchar2(3) -- 业务方向： 01 申请 02 签收
    ,contract_no varchar2(60) -- 批次号
    ,product_no varchar2(12) -- 产品号
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(15) -- 机构号
    ,recept_brh_id varchar2(15) -- 承接行机构代码
    ,busi_date varchar2(12) -- 业务发生日期
    ,pledgor_name varchar2(675) -- 出质人名称
    ,pledgor_account varchar2(48) -- 出质人账号
    ,pledgor_bank_no varchar2(18) -- 出质人行行号
    ,pledgor_brh_no varchar2(15) -- 出质人机构代码
    ,acct_branch_no varchar2(15) -- 财务机构号
    ,manager_no varchar2(30) -- 客户经理
    ,department_no varchar2(15) -- 部门编号
    ,contract_status varchar2(3) -- 审批状态: 00   未处理 01   审批中 02   审核成功 03   审核失败 04   审核拒绝
    ,message_status varchar2(3) -- 报文处理状态: 01 已发送 02 收到确认 21 收到确认失败
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,credit_check_status varchar2(3) -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,created_by varchar2(45) -- 创建人
    ,cust_type varchar2(2) -- 客户类别： 1 对公客户 2 同业客户 3 理财客户
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
grant select on ${iol_schema}.bdms_cpes_rlvpledge_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_rlvpledge_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_rlvpledge_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_rlvpledge_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_rlvpledge_contract is '质押解除批次信息表';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.buss_flag is '业务方向： 01 申请 02 签收';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.recept_brh_id is '承接行机构代码';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.busi_date is '业务发生日期';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.pledgor_name is '出质人名称';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.pledgor_account is '出质人账号';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.pledgor_bank_no is '出质人行行号';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.pledgor_brh_no is '出质人机构代码';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.acct_branch_no is '财务机构号';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.manager_no is '客户经理';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.department_no is '部门编号';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.contract_status is '审批状态: 00   未处理 01   审批中 02   审核成功 03   审核失败 04   审核拒绝';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.message_status is '报文处理状态: 01 已发送 02 收到确认 21 收到确认失败';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.credit_check_status is '额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.cust_type is '客户类别： 1 对公客户 2 同业客户 3 理财客户';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_rlvpledge_contract.etl_timestamp is 'ETL处理时间戳';
