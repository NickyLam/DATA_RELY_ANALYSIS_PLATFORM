/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cle_cleaning_bill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cle_cleaning_bill
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cle_cleaning_bill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cle_cleaning_bill(
    cleaning_bill_id number(10,0) -- 清分账单ID.
    ,acc_task_id varchar2(64) -- 任务批次号.
    ,cleaning_serial_number number(10,0) -- 清分操作流水号.
    ,accept_org_id varchar2(32) -- 受理机构ID.
    ,acc_date timestamp -- 结算日期.
    ,cleaning_date timestamp -- 清分日期.
    ,serial_number varchar2(64) -- 发往银行流水号
    ,org_name varchar2(64) -- 机构名称.即商户名称或渠道名称
    ,org_id varchar2(32) -- 机构ID.即商户编号或渠道编号
    ,pay_center_id number(10,0) -- 支付中心ID.
    ,pay_type_id number(11,0) -- 支付类型.
    ,contact_line varchar2(64) -- 联行号.网点号、联行号
    ,remit_account_code varchar2(128) -- 汇出方银行卡号.
    ,payee_account_code varchar2(128) -- 收款人银行卡号.
    ,payee_bank_name varchar2(128) -- 收款人开户银行名称.
    ,payee_account_name varchar2(128) -- 收款人开户人.账户名
    ,export_amount number(20,2) -- 汇出金额.
    ,fee_type varchar2(6) -- 币种.
    ,summary varchar2(64) -- 摘要.
    ,remark varchar2(512) -- 备注.
    ,data_sign varchar2(128) -- 数据签名.
    ,return_serial_number varchar2(128) -- 银行返回的流水号.
    ,return_code varchar2(32) -- 银行返回的结果码.
    ,return_msg varchar2(256) -- 银行返回的结果信息.
    ,cleaning_type number(4,0) -- 清分类型.1：渠道清分；2：商户清分；3：补贴清分
    ,cleaning_status number(4,0) -- 清分状态.1:未清分;2:清分中;3:清分成功;4:清分失败;5:处理异常
    ,physics_flag number(4,0) -- 物理标识.1:正常,2:删除,99:冻结
    ,fld_n2 number(10,0) -- 回盘标识字段 用于首次记录生成一条差错款清分记录
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,account_type number(4,0) -- 账户类型.账户类型：1企业,2个人
    ,api_provider number(4,0) -- 接口提供方
    ,bank_code varchar2(16) -- 银行代码（兴业提供的广义联行号）
    ,cleaning_type_detail number(4,0) -- 1表示收支商户 冗余
    ,private_cleaning_bill_id number(10,0) -- 私有云清分ID，私有云回导公有云时copy私有云清分ID
    ,org_properties number(4,0) -- 商户标识.1：普通商户；2：月结商户
    ,cleaning_error_status number(4,0) -- 差错清分状态：1.差错待处理，2.差错待清分，3.差错清分中，4.差错清分成功
    ,cleaning_error_time timestamp -- 差错清分发起时间
    ,cleaning_export_status number(2,0) -- 清分导出状态：0-未导出 1-已导出
    ,cleaning_error_check_time timestamp -- 差错清分记录审核时间
    ,modify_chfee_flag number(4,0) -- 是否编辑过打款金额
    ,cleaning_process_time timestamp -- 
    ,pay_channel_type varchar2(20) -- 代付通路
    ,fee_code varchar2(32) -- 费项代码
    ,acc_way number(4,0) -- D0批量标识,（1、标准[T1结算]默认；2、D1提现；11、D0提现；12、D0秒到；13、D0批量)
    ,parent_org_id varchar2(32) -- 父机构id
    ,negative_type number(1,0) -- 清分负数标记 商户清分金额为0标记 后面可扩展
    ,negative_status number(10,0) -- 清分负数状态1-需合并、2-已合并,对于被合并的记录保留合并的清分记录id更用字段
    ,branch_org_id varchar2(32) -- 分行机构号
    ,remit_status number(4,0) -- 汇款状态，1：未汇款；2：已汇款
    ,pay_account_type number(2,0) -- 付款方账户类型
    ,remit_contact_line varchar2(32) -- 付款方行号
    ,remit_org_id varchar2(32) -- 付款方机构号
    ,remit_org_name varchar2(64) -- 付款方名称
    ,remit_account_name varchar2(128) -- 付款方账户名
    ,create_user number(10,0) -- 创建用户
    ,create_emp varchar2(32) -- 创建人
    ,account_id varchar2(16) -- 结算账户ID
    ,bookkeeping_code varchar2(16) -- 记账代号
    ,remit_bank_channel_id varchar2(16) -- 付款方银行机构号
    ,payee_bank_channel_id varchar2(16) -- 收款方银行机构号
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
grant select on ${iol_schema}.amss_cle_cleaning_bill to ${iml_schema};
grant select on ${iol_schema}.amss_cle_cleaning_bill to ${icl_schema};
grant select on ${iol_schema}.amss_cle_cleaning_bill to ${idl_schema};
grant select on ${iol_schema}.amss_cle_cleaning_bill to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cle_cleaning_bill is '清分表';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_bill_id is '清分账单ID.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.acc_task_id is '任务批次号.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_serial_number is '清分操作流水号.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.accept_org_id is '受理机构ID.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.acc_date is '结算日期.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_date is '清分日期.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.serial_number is '发往银行流水号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.org_name is '机构名称.即商户名称或渠道名称';
comment on column ${iol_schema}.amss_cle_cleaning_bill.org_id is '机构ID.即商户编号或渠道编号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.pay_center_id is '支付中心ID.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.pay_type_id is '支付类型.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.contact_line is '联行号.网点号、联行号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.remit_account_code is '汇出方银行卡号.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.payee_account_code is '收款人银行卡号.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.payee_bank_name is '收款人开户银行名称.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.payee_account_name is '收款人开户人.账户名';
comment on column ${iol_schema}.amss_cle_cleaning_bill.export_amount is '汇出金额.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.fee_type is '币种.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.summary is '摘要.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.remark is '备注.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.data_sign is '数据签名.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.return_serial_number is '银行返回的流水号.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.return_code is '银行返回的结果码.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.return_msg is '银行返回的结果信息.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_type is '清分类型.1：渠道清分；2：商户清分；3：补贴清分';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_status is '清分状态.1:未清分;2:清分中;3:清分成功;4:清分失败;5:处理异常';
comment on column ${iol_schema}.amss_cle_cleaning_bill.physics_flag is '物理标识.1:正常,2:删除,99:冻结';
comment on column ${iol_schema}.amss_cle_cleaning_bill.fld_n2 is '回盘标识字段 用于首次记录生成一条差错款清分记录';
comment on column ${iol_schema}.amss_cle_cleaning_bill.create_time is '创建时间.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.update_time is '更新时间.';
comment on column ${iol_schema}.amss_cle_cleaning_bill.account_type is '账户类型.账户类型：1企业,2个人';
comment on column ${iol_schema}.amss_cle_cleaning_bill.api_provider is '接口提供方';
comment on column ${iol_schema}.amss_cle_cleaning_bill.bank_code is '银行代码（兴业提供的广义联行号）';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_type_detail is '1表示收支商户 冗余';
comment on column ${iol_schema}.amss_cle_cleaning_bill.private_cleaning_bill_id is '私有云清分ID，私有云回导公有云时copy私有云清分ID';
comment on column ${iol_schema}.amss_cle_cleaning_bill.org_properties is '商户标识.1：普通商户；2：月结商户';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_error_status is '差错清分状态：1.差错待处理，2.差错待清分，3.差错清分中，4.差错清分成功';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_error_time is '差错清分发起时间';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_export_status is '清分导出状态：0-未导出 1-已导出';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_error_check_time is '差错清分记录审核时间';
comment on column ${iol_schema}.amss_cle_cleaning_bill.modify_chfee_flag is '是否编辑过打款金额';
comment on column ${iol_schema}.amss_cle_cleaning_bill.cleaning_process_time is '';
comment on column ${iol_schema}.amss_cle_cleaning_bill.pay_channel_type is '代付通路';
comment on column ${iol_schema}.amss_cle_cleaning_bill.fee_code is '费项代码';
comment on column ${iol_schema}.amss_cle_cleaning_bill.acc_way is 'D0批量标识,（1、标准[T1结算]默认；2、D1提现；11、D0提现；12、D0秒到；13、D0批量)';
comment on column ${iol_schema}.amss_cle_cleaning_bill.parent_org_id is '父机构id';
comment on column ${iol_schema}.amss_cle_cleaning_bill.negative_type is '清分负数标记 商户清分金额为0标记 后面可扩展';
comment on column ${iol_schema}.amss_cle_cleaning_bill.negative_status is '清分负数状态1-需合并、2-已合并,对于被合并的记录保留合并的清分记录id更用字段';
comment on column ${iol_schema}.amss_cle_cleaning_bill.branch_org_id is '分行机构号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.remit_status is '汇款状态，1：未汇款；2：已汇款';
comment on column ${iol_schema}.amss_cle_cleaning_bill.pay_account_type is '付款方账户类型';
comment on column ${iol_schema}.amss_cle_cleaning_bill.remit_contact_line is '付款方行号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.remit_org_id is '付款方机构号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.remit_org_name is '付款方名称';
comment on column ${iol_schema}.amss_cle_cleaning_bill.remit_account_name is '付款方账户名';
comment on column ${iol_schema}.amss_cle_cleaning_bill.create_user is '创建用户';
comment on column ${iol_schema}.amss_cle_cleaning_bill.create_emp is '创建人';
comment on column ${iol_schema}.amss_cle_cleaning_bill.account_id is '结算账户ID';
comment on column ${iol_schema}.amss_cle_cleaning_bill.bookkeeping_code is '记账代号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.remit_bank_channel_id is '付款方银行机构号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.payee_bank_channel_id is '收款方银行机构号';
comment on column ${iol_schema}.amss_cle_cleaning_bill.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cle_cleaning_bill.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cle_cleaning_bill.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cle_cleaning_bill.etl_timestamp is 'ETL处理时间戳';
