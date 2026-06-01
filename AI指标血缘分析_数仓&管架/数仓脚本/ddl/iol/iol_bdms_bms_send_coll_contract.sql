/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_send_coll_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_send_coll_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_send_coll_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_send_coll_contract(
    id varchar2(60) -- ID
    ,protocol_no varchar2(45) -- 发托协议号
    ,product_no varchar2(12) -- 产品类型编码
    ,sned_state varchar2(2) -- 发托状态： 1 发托 2 款到 3 托收退票
    ,drft_hldr_no varchar2(30) -- 提示付款人客户号
    ,drft_hldr_name varchar2(300) -- 提示入款人全称
    ,drft_hldr_account varchar2(150) -- 提示付款人入账帐号
    ,drft_hldr_bank_no varchar2(18) -- 提示付款人开户行行号
    ,drft_hldr_bank_name varchar2(300) -- 提示付款人开户行名称
    ,apply_date varchar2(12) -- 托收申请日
    ,valet_flag varchar2(2) -- 是否代客托收： 0 否 1 是
    ,fee_mode varchar2(2) -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
    ,operator_no varchar2(45) -- 业务发起人编号
    ,txn_date varchar2(12) -- 交易日期
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date timestamp -- 最后操作日期
    ,check_status varchar2(3) -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,contract_status varchar2(3) -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
    ,account_status varchar2(3) -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,reserve1 varchar2(375) -- 备注1
    ,reserve2 varchar2(375) -- 备注2
    ,reserve3 varchar2(375) -- 备注3
    ,busi_branch_no varchar2(30) -- BUSI_BRANCH_NO
    ,top_branch_no varchar2(30) -- 总行机构号
    ,branch_id varchar2(30) -- 机构id 0：人工（默认）1：批量
    ,cust_address varchar2(270) -- 客户地址
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
grant select on ${iol_schema}.bdms_bms_send_coll_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_send_coll_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_send_coll_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_send_coll_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_send_coll_contract is '托收批次表';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.id is 'ID';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.protocol_no is '发托协议号';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.product_no is '产品类型编码';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.sned_state is '发托状态： 1 发托 2 款到 3 托收退票';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.drft_hldr_no is '提示付款人客户号';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.drft_hldr_name is '提示入款人全称';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.drft_hldr_account is '提示付款人入账帐号';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.drft_hldr_bank_no is '提示付款人开户行行号';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.drft_hldr_bank_name is '提示付款人开户行名称';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.apply_date is '托收申请日';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.valet_flag is '是否代客托收： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.fee_mode is '手续费模式： 1 按票面金额 2 按票据张数 3 客户指定';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.operator_no is '业务发起人编号';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.txn_date is '交易日期';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.check_status is '业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.contract_status is '批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.account_status is '记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.busi_branch_no is 'BUSI_BRANCH_NO';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.branch_id is '机构id 0：人工（默认）1：批量';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.cust_address is '客户地址';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_send_coll_contract.etl_timestamp is 'ETL处理时间戳';
