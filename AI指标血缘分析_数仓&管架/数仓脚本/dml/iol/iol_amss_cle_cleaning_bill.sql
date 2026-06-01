/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_cle_cleaning_bill
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.amss_cle_cleaning_bill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_cle_cleaning_bill
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cle_cleaning_bill_op purge;
drop table ${iol_schema}.amss_cle_cleaning_bill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cle_cleaning_bill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cle_cleaning_bill where 0=1;

create table ${iol_schema}.amss_cle_cleaning_bill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_cle_cleaning_bill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cle_cleaning_bill_cl(
            cleaning_bill_id -- 清分账单ID.
            ,acc_task_id -- 任务批次号.
            ,cleaning_serial_number -- 清分操作流水号.
            ,accept_org_id -- 受理机构ID.
            ,acc_date -- 结算日期.
            ,cleaning_date -- 清分日期.
            ,serial_number -- 发往银行流水号
            ,org_name -- 机构名称.即商户名称或渠道名称
            ,org_id -- 机构ID.即商户编号或渠道编号
            ,pay_center_id -- 支付中心ID.
            ,pay_type_id -- 支付类型.
            ,contact_line -- 联行号.网点号、联行号
            ,remit_account_code -- 汇出方银行卡号.
            ,payee_account_code -- 收款人银行卡号.
            ,payee_bank_name -- 收款人开户银行名称.
            ,payee_account_name -- 收款人开户人.账户名
            ,export_amount -- 汇出金额.
            ,fee_type -- 币种.
            ,summary -- 摘要.
            ,remark -- 备注.
            ,data_sign -- 数据签名.
            ,return_serial_number -- 银行返回的流水号.
            ,return_code -- 银行返回的结果码.
            ,return_msg -- 银行返回的结果信息.
            ,cleaning_type -- 清分类型.1：渠道清分；2：商户清分；3：补贴清分
            ,cleaning_status -- 清分状态.1:未清分;2:清分中;3:清分成功;4:清分失败;5:处理异常
            ,physics_flag -- 物理标识.1:正常,2:删除,99:冻结
            ,fld_n2 -- 回盘标识字段 用于首次记录生成一条差错款清分记录
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,api_provider -- 接口提供方
            ,bank_code -- 银行代码（兴业提供的广义联行号）
            ,cleaning_type_detail -- 1表示收支商户 冗余
            ,private_cleaning_bill_id -- 私有云清分ID，私有云回导公有云时copy私有云清分ID
            ,org_properties -- 商户标识.1：普通商户；2：月结商户
            ,cleaning_error_status -- 差错清分状态：1.差错待处理，2.差错待清分，3.差错清分中，4.差错清分成功
            ,cleaning_error_time -- 差错清分发起时间
            ,cleaning_export_status -- 清分导出状态：0-未导出 1-已导出
            ,cleaning_error_check_time -- 差错清分记录审核时间
            ,modify_chfee_flag -- 是否编辑过打款金额
            ,cleaning_process_time -- 
            ,pay_channel_type -- 代付通路
            ,fee_code -- 费项代码
            ,acc_way -- D0批量标识,（1、标准[T1结算]默认；2、D1提现；11、D0提现；12、D0秒到；13、D0批量)
            ,parent_org_id -- 父机构id
            ,negative_type -- 清分负数标记 商户清分金额为0标记 后面可扩展
            ,negative_status -- 清分负数状态1-需合并、2-已合并,对于被合并的记录保留合并的清分记录id更用字段
            ,branch_org_id -- 分行机构号
            ,remit_status -- 汇款状态，1：未汇款；2：已汇款
            ,pay_account_type -- 付款方账户类型
            ,remit_contact_line -- 付款方行号
            ,remit_org_id -- 付款方机构号
            ,remit_org_name -- 付款方名称
            ,remit_account_name -- 付款方账户名
            ,create_user -- 创建用户
            ,create_emp -- 创建人
            ,account_id -- 结算账户ID
            ,bookkeeping_code -- 记账代号
            ,remit_bank_channel_id -- 付款方银行机构号
            ,payee_bank_channel_id -- 收款方银行机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cle_cleaning_bill_op(
            cleaning_bill_id -- 清分账单ID.
            ,acc_task_id -- 任务批次号.
            ,cleaning_serial_number -- 清分操作流水号.
            ,accept_org_id -- 受理机构ID.
            ,acc_date -- 结算日期.
            ,cleaning_date -- 清分日期.
            ,serial_number -- 发往银行流水号
            ,org_name -- 机构名称.即商户名称或渠道名称
            ,org_id -- 机构ID.即商户编号或渠道编号
            ,pay_center_id -- 支付中心ID.
            ,pay_type_id -- 支付类型.
            ,contact_line -- 联行号.网点号、联行号
            ,remit_account_code -- 汇出方银行卡号.
            ,payee_account_code -- 收款人银行卡号.
            ,payee_bank_name -- 收款人开户银行名称.
            ,payee_account_name -- 收款人开户人.账户名
            ,export_amount -- 汇出金额.
            ,fee_type -- 币种.
            ,summary -- 摘要.
            ,remark -- 备注.
            ,data_sign -- 数据签名.
            ,return_serial_number -- 银行返回的流水号.
            ,return_code -- 银行返回的结果码.
            ,return_msg -- 银行返回的结果信息.
            ,cleaning_type -- 清分类型.1：渠道清分；2：商户清分；3：补贴清分
            ,cleaning_status -- 清分状态.1:未清分;2:清分中;3:清分成功;4:清分失败;5:处理异常
            ,physics_flag -- 物理标识.1:正常,2:删除,99:冻结
            ,fld_n2 -- 回盘标识字段 用于首次记录生成一条差错款清分记录
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,api_provider -- 接口提供方
            ,bank_code -- 银行代码（兴业提供的广义联行号）
            ,cleaning_type_detail -- 1表示收支商户 冗余
            ,private_cleaning_bill_id -- 私有云清分ID，私有云回导公有云时copy私有云清分ID
            ,org_properties -- 商户标识.1：普通商户；2：月结商户
            ,cleaning_error_status -- 差错清分状态：1.差错待处理，2.差错待清分，3.差错清分中，4.差错清分成功
            ,cleaning_error_time -- 差错清分发起时间
            ,cleaning_export_status -- 清分导出状态：0-未导出 1-已导出
            ,cleaning_error_check_time -- 差错清分记录审核时间
            ,modify_chfee_flag -- 是否编辑过打款金额
            ,cleaning_process_time -- 
            ,pay_channel_type -- 代付通路
            ,fee_code -- 费项代码
            ,acc_way -- D0批量标识,（1、标准[T1结算]默认；2、D1提现；11、D0提现；12、D0秒到；13、D0批量)
            ,parent_org_id -- 父机构id
            ,negative_type -- 清分负数标记 商户清分金额为0标记 后面可扩展
            ,negative_status -- 清分负数状态1-需合并、2-已合并,对于被合并的记录保留合并的清分记录id更用字段
            ,branch_org_id -- 分行机构号
            ,remit_status -- 汇款状态，1：未汇款；2：已汇款
            ,pay_account_type -- 付款方账户类型
            ,remit_contact_line -- 付款方行号
            ,remit_org_id -- 付款方机构号
            ,remit_org_name -- 付款方名称
            ,remit_account_name -- 付款方账户名
            ,create_user -- 创建用户
            ,create_emp -- 创建人
            ,account_id -- 结算账户ID
            ,bookkeeping_code -- 记账代号
            ,remit_bank_channel_id -- 付款方银行机构号
            ,payee_bank_channel_id -- 收款方银行机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cleaning_bill_id, o.cleaning_bill_id) as cleaning_bill_id -- 清分账单ID.
    ,nvl(n.acc_task_id, o.acc_task_id) as acc_task_id -- 任务批次号.
    ,nvl(n.cleaning_serial_number, o.cleaning_serial_number) as cleaning_serial_number -- 清分操作流水号.
    ,nvl(n.accept_org_id, o.accept_org_id) as accept_org_id -- 受理机构ID.
    ,nvl(n.acc_date, o.acc_date) as acc_date -- 结算日期.
    ,nvl(n.cleaning_date, o.cleaning_date) as cleaning_date -- 清分日期.
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 发往银行流水号
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称.即商户名称或渠道名称
    ,nvl(n.org_id, o.org_id) as org_id -- 机构ID.即商户编号或渠道编号
    ,nvl(n.pay_center_id, o.pay_center_id) as pay_center_id -- 支付中心ID.
    ,nvl(n.pay_type_id, o.pay_type_id) as pay_type_id -- 支付类型.
    ,nvl(n.contact_line, o.contact_line) as contact_line -- 联行号.网点号、联行号
    ,nvl(n.remit_account_code, o.remit_account_code) as remit_account_code -- 汇出方银行卡号.
    ,nvl(n.payee_account_code, o.payee_account_code) as payee_account_code -- 收款人银行卡号.
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收款人开户银行名称.
    ,nvl(n.payee_account_name, o.payee_account_name) as payee_account_name -- 收款人开户人.账户名
    ,nvl(n.export_amount, o.export_amount) as export_amount -- 汇出金额.
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 币种.
    ,nvl(n.summary, o.summary) as summary -- 摘要.
    ,nvl(n.remark, o.remark) as remark -- 备注.
    ,nvl(n.data_sign, o.data_sign) as data_sign -- 数据签名.
    ,nvl(n.return_serial_number, o.return_serial_number) as return_serial_number -- 银行返回的流水号.
    ,nvl(n.return_code, o.return_code) as return_code -- 银行返回的结果码.
    ,nvl(n.return_msg, o.return_msg) as return_msg -- 银行返回的结果信息.
    ,nvl(n.cleaning_type, o.cleaning_type) as cleaning_type -- 清分类型.1：渠道清分；2：商户清分；3：补贴清分
    ,nvl(n.cleaning_status, o.cleaning_status) as cleaning_status -- 清分状态.1:未清分;2:清分中;3:清分成功;4:清分失败;5:处理异常
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识.1:正常,2:删除,99:冻结
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- 回盘标识字段 用于首次记录生成一条差错款清分记录
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间.
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间.
    ,nvl(n.account_type, o.account_type) as account_type -- 账户类型.账户类型：1企业,2个人
    ,nvl(n.api_provider, o.api_provider) as api_provider -- 接口提供方
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 银行代码（兴业提供的广义联行号）
    ,nvl(n.cleaning_type_detail, o.cleaning_type_detail) as cleaning_type_detail -- 1表示收支商户 冗余
    ,nvl(n.private_cleaning_bill_id, o.private_cleaning_bill_id) as private_cleaning_bill_id -- 私有云清分ID，私有云回导公有云时copy私有云清分ID
    ,nvl(n.org_properties, o.org_properties) as org_properties -- 商户标识.1：普通商户；2：月结商户
    ,nvl(n.cleaning_error_status, o.cleaning_error_status) as cleaning_error_status -- 差错清分状态：1.差错待处理，2.差错待清分，3.差错清分中，4.差错清分成功
    ,nvl(n.cleaning_error_time, o.cleaning_error_time) as cleaning_error_time -- 差错清分发起时间
    ,nvl(n.cleaning_export_status, o.cleaning_export_status) as cleaning_export_status -- 清分导出状态：0-未导出 1-已导出
    ,nvl(n.cleaning_error_check_time, o.cleaning_error_check_time) as cleaning_error_check_time -- 差错清分记录审核时间
    ,nvl(n.modify_chfee_flag, o.modify_chfee_flag) as modify_chfee_flag -- 是否编辑过打款金额
    ,nvl(n.cleaning_process_time, o.cleaning_process_time) as cleaning_process_time -- 
    ,nvl(n.pay_channel_type, o.pay_channel_type) as pay_channel_type -- 代付通路
    ,nvl(n.fee_code, o.fee_code) as fee_code -- 费项代码
    ,nvl(n.acc_way, o.acc_way) as acc_way -- D0批量标识,（1、标准[T1结算]默认；2、D1提现；11、D0提现；12、D0秒到；13、D0批量)
    ,nvl(n.parent_org_id, o.parent_org_id) as parent_org_id -- 父机构id
    ,nvl(n.negative_type, o.negative_type) as negative_type -- 清分负数标记 商户清分金额为0标记 后面可扩展
    ,nvl(n.negative_status, o.negative_status) as negative_status -- 清分负数状态1-需合并、2-已合并,对于被合并的记录保留合并的清分记录id更用字段
    ,nvl(n.branch_org_id, o.branch_org_id) as branch_org_id -- 分行机构号
    ,nvl(n.remit_status, o.remit_status) as remit_status -- 汇款状态，1：未汇款；2：已汇款
    ,nvl(n.pay_account_type, o.pay_account_type) as pay_account_type -- 付款方账户类型
    ,nvl(n.remit_contact_line, o.remit_contact_line) as remit_contact_line -- 付款方行号
    ,nvl(n.remit_org_id, o.remit_org_id) as remit_org_id -- 付款方机构号
    ,nvl(n.remit_org_name, o.remit_org_name) as remit_org_name -- 付款方名称
    ,nvl(n.remit_account_name, o.remit_account_name) as remit_account_name -- 付款方账户名
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人
    ,nvl(n.account_id, o.account_id) as account_id -- 结算账户ID
    ,nvl(n.bookkeeping_code, o.bookkeeping_code) as bookkeeping_code -- 记账代号
    ,nvl(n.remit_bank_channel_id, o.remit_bank_channel_id) as remit_bank_channel_id -- 付款方银行机构号
    ,nvl(n.payee_bank_channel_id, o.payee_bank_channel_id) as payee_bank_channel_id -- 收款方银行机构号
    ,case when
            n.cleaning_bill_id is null
            and n.acc_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cleaning_bill_id is null
            and n.acc_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cleaning_bill_id is null
            and n.acc_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_cle_cleaning_bill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_cle_cleaning_bill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cleaning_bill_id = n.cleaning_bill_id
            and o.acc_date = n.acc_date
where (
        o.cleaning_bill_id is null
        and o.acc_date is null
    )
    or (
        n.cleaning_bill_id is null
        and n.acc_date is null
    )
    or (
        o.acc_task_id <> n.acc_task_id
        or o.cleaning_serial_number <> n.cleaning_serial_number
        or o.accept_org_id <> n.accept_org_id
        or o.cleaning_date <> n.cleaning_date
        or o.serial_number <> n.serial_number
        or o.org_name <> n.org_name
        or o.org_id <> n.org_id
        or o.pay_center_id <> n.pay_center_id
        or o.pay_type_id <> n.pay_type_id
        or o.contact_line <> n.contact_line
        or o.remit_account_code <> n.remit_account_code
        or o.payee_account_code <> n.payee_account_code
        or o.payee_bank_name <> n.payee_bank_name
        or o.payee_account_name <> n.payee_account_name
        or o.export_amount <> n.export_amount
        or o.fee_type <> n.fee_type
        or o.summary <> n.summary
        or o.remark <> n.remark
        or o.data_sign <> n.data_sign
        or o.return_serial_number <> n.return_serial_number
        or o.return_code <> n.return_code
        or o.return_msg <> n.return_msg
        or o.cleaning_type <> n.cleaning_type
        or o.cleaning_status <> n.cleaning_status
        or o.physics_flag <> n.physics_flag
        or o.fld_n2 <> n.fld_n2
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.account_type <> n.account_type
        or o.api_provider <> n.api_provider
        or o.bank_code <> n.bank_code
        or o.cleaning_type_detail <> n.cleaning_type_detail
        or o.private_cleaning_bill_id <> n.private_cleaning_bill_id
        or o.org_properties <> n.org_properties
        or o.cleaning_error_status <> n.cleaning_error_status
        or o.cleaning_error_time <> n.cleaning_error_time
        or o.cleaning_export_status <> n.cleaning_export_status
        or o.cleaning_error_check_time <> n.cleaning_error_check_time
        or o.modify_chfee_flag <> n.modify_chfee_flag
        or o.cleaning_process_time <> n.cleaning_process_time
        or o.pay_channel_type <> n.pay_channel_type
        or o.fee_code <> n.fee_code
        or o.acc_way <> n.acc_way
        or o.parent_org_id <> n.parent_org_id
        or o.negative_type <> n.negative_type
        or o.negative_status <> n.negative_status
        or o.branch_org_id <> n.branch_org_id
        or o.remit_status <> n.remit_status
        or o.pay_account_type <> n.pay_account_type
        or o.remit_contact_line <> n.remit_contact_line
        or o.remit_org_id <> n.remit_org_id
        or o.remit_org_name <> n.remit_org_name
        or o.remit_account_name <> n.remit_account_name
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.account_id <> n.account_id
        or o.bookkeeping_code <> n.bookkeeping_code
        or o.remit_bank_channel_id <> n.remit_bank_channel_id
        or o.payee_bank_channel_id <> n.payee_bank_channel_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_cle_cleaning_bill_cl(
            cleaning_bill_id -- 清分账单ID.
            ,acc_task_id -- 任务批次号.
            ,cleaning_serial_number -- 清分操作流水号.
            ,accept_org_id -- 受理机构ID.
            ,acc_date -- 结算日期.
            ,cleaning_date -- 清分日期.
            ,serial_number -- 发往银行流水号
            ,org_name -- 机构名称.即商户名称或渠道名称
            ,org_id -- 机构ID.即商户编号或渠道编号
            ,pay_center_id -- 支付中心ID.
            ,pay_type_id -- 支付类型.
            ,contact_line -- 联行号.网点号、联行号
            ,remit_account_code -- 汇出方银行卡号.
            ,payee_account_code -- 收款人银行卡号.
            ,payee_bank_name -- 收款人开户银行名称.
            ,payee_account_name -- 收款人开户人.账户名
            ,export_amount -- 汇出金额.
            ,fee_type -- 币种.
            ,summary -- 摘要.
            ,remark -- 备注.
            ,data_sign -- 数据签名.
            ,return_serial_number -- 银行返回的流水号.
            ,return_code -- 银行返回的结果码.
            ,return_msg -- 银行返回的结果信息.
            ,cleaning_type -- 清分类型.1：渠道清分；2：商户清分；3：补贴清分
            ,cleaning_status -- 清分状态.1:未清分;2:清分中;3:清分成功;4:清分失败;5:处理异常
            ,physics_flag -- 物理标识.1:正常,2:删除,99:冻结
            ,fld_n2 -- 回盘标识字段 用于首次记录生成一条差错款清分记录
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,api_provider -- 接口提供方
            ,bank_code -- 银行代码（兴业提供的广义联行号）
            ,cleaning_type_detail -- 1表示收支商户 冗余
            ,private_cleaning_bill_id -- 私有云清分ID，私有云回导公有云时copy私有云清分ID
            ,org_properties -- 商户标识.1：普通商户；2：月结商户
            ,cleaning_error_status -- 差错清分状态：1.差错待处理，2.差错待清分，3.差错清分中，4.差错清分成功
            ,cleaning_error_time -- 差错清分发起时间
            ,cleaning_export_status -- 清分导出状态：0-未导出 1-已导出
            ,cleaning_error_check_time -- 差错清分记录审核时间
            ,modify_chfee_flag -- 是否编辑过打款金额
            ,cleaning_process_time -- 
            ,pay_channel_type -- 代付通路
            ,fee_code -- 费项代码
            ,acc_way -- D0批量标识,（1、标准[T1结算]默认；2、D1提现；11、D0提现；12、D0秒到；13、D0批量)
            ,parent_org_id -- 父机构id
            ,negative_type -- 清分负数标记 商户清分金额为0标记 后面可扩展
            ,negative_status -- 清分负数状态1-需合并、2-已合并,对于被合并的记录保留合并的清分记录id更用字段
            ,branch_org_id -- 分行机构号
            ,remit_status -- 汇款状态，1：未汇款；2：已汇款
            ,pay_account_type -- 付款方账户类型
            ,remit_contact_line -- 付款方行号
            ,remit_org_id -- 付款方机构号
            ,remit_org_name -- 付款方名称
            ,remit_account_name -- 付款方账户名
            ,create_user -- 创建用户
            ,create_emp -- 创建人
            ,account_id -- 结算账户ID
            ,bookkeeping_code -- 记账代号
            ,remit_bank_channel_id -- 付款方银行机构号
            ,payee_bank_channel_id -- 收款方银行机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_cle_cleaning_bill_op(
            cleaning_bill_id -- 清分账单ID.
            ,acc_task_id -- 任务批次号.
            ,cleaning_serial_number -- 清分操作流水号.
            ,accept_org_id -- 受理机构ID.
            ,acc_date -- 结算日期.
            ,cleaning_date -- 清分日期.
            ,serial_number -- 发往银行流水号
            ,org_name -- 机构名称.即商户名称或渠道名称
            ,org_id -- 机构ID.即商户编号或渠道编号
            ,pay_center_id -- 支付中心ID.
            ,pay_type_id -- 支付类型.
            ,contact_line -- 联行号.网点号、联行号
            ,remit_account_code -- 汇出方银行卡号.
            ,payee_account_code -- 收款人银行卡号.
            ,payee_bank_name -- 收款人开户银行名称.
            ,payee_account_name -- 收款人开户人.账户名
            ,export_amount -- 汇出金额.
            ,fee_type -- 币种.
            ,summary -- 摘要.
            ,remark -- 备注.
            ,data_sign -- 数据签名.
            ,return_serial_number -- 银行返回的流水号.
            ,return_code -- 银行返回的结果码.
            ,return_msg -- 银行返回的结果信息.
            ,cleaning_type -- 清分类型.1：渠道清分；2：商户清分；3：补贴清分
            ,cleaning_status -- 清分状态.1:未清分;2:清分中;3:清分成功;4:清分失败;5:处理异常
            ,physics_flag -- 物理标识.1:正常,2:删除,99:冻结
            ,fld_n2 -- 回盘标识字段 用于首次记录生成一条差错款清分记录
            ,create_time -- 创建时间.
            ,update_time -- 更新时间.
            ,account_type -- 账户类型.账户类型：1企业,2个人
            ,api_provider -- 接口提供方
            ,bank_code -- 银行代码（兴业提供的广义联行号）
            ,cleaning_type_detail -- 1表示收支商户 冗余
            ,private_cleaning_bill_id -- 私有云清分ID，私有云回导公有云时copy私有云清分ID
            ,org_properties -- 商户标识.1：普通商户；2：月结商户
            ,cleaning_error_status -- 差错清分状态：1.差错待处理，2.差错待清分，3.差错清分中，4.差错清分成功
            ,cleaning_error_time -- 差错清分发起时间
            ,cleaning_export_status -- 清分导出状态：0-未导出 1-已导出
            ,cleaning_error_check_time -- 差错清分记录审核时间
            ,modify_chfee_flag -- 是否编辑过打款金额
            ,cleaning_process_time -- 
            ,pay_channel_type -- 代付通路
            ,fee_code -- 费项代码
            ,acc_way -- D0批量标识,（1、标准[T1结算]默认；2、D1提现；11、D0提现；12、D0秒到；13、D0批量)
            ,parent_org_id -- 父机构id
            ,negative_type -- 清分负数标记 商户清分金额为0标记 后面可扩展
            ,negative_status -- 清分负数状态1-需合并、2-已合并,对于被合并的记录保留合并的清分记录id更用字段
            ,branch_org_id -- 分行机构号
            ,remit_status -- 汇款状态，1：未汇款；2：已汇款
            ,pay_account_type -- 付款方账户类型
            ,remit_contact_line -- 付款方行号
            ,remit_org_id -- 付款方机构号
            ,remit_org_name -- 付款方名称
            ,remit_account_name -- 付款方账户名
            ,create_user -- 创建用户
            ,create_emp -- 创建人
            ,account_id -- 结算账户ID
            ,bookkeeping_code -- 记账代号
            ,remit_bank_channel_id -- 付款方银行机构号
            ,payee_bank_channel_id -- 收款方银行机构号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cleaning_bill_id -- 清分账单ID.
    ,o.acc_task_id -- 任务批次号.
    ,o.cleaning_serial_number -- 清分操作流水号.
    ,o.accept_org_id -- 受理机构ID.
    ,o.acc_date -- 结算日期.
    ,o.cleaning_date -- 清分日期.
    ,o.serial_number -- 发往银行流水号
    ,o.org_name -- 机构名称.即商户名称或渠道名称
    ,o.org_id -- 机构ID.即商户编号或渠道编号
    ,o.pay_center_id -- 支付中心ID.
    ,o.pay_type_id -- 支付类型.
    ,o.contact_line -- 联行号.网点号、联行号
    ,o.remit_account_code -- 汇出方银行卡号.
    ,o.payee_account_code -- 收款人银行卡号.
    ,o.payee_bank_name -- 收款人开户银行名称.
    ,o.payee_account_name -- 收款人开户人.账户名
    ,o.export_amount -- 汇出金额.
    ,o.fee_type -- 币种.
    ,o.summary -- 摘要.
    ,o.remark -- 备注.
    ,o.data_sign -- 数据签名.
    ,o.return_serial_number -- 银行返回的流水号.
    ,o.return_code -- 银行返回的结果码.
    ,o.return_msg -- 银行返回的结果信息.
    ,o.cleaning_type -- 清分类型.1：渠道清分；2：商户清分；3：补贴清分
    ,o.cleaning_status -- 清分状态.1:未清分;2:清分中;3:清分成功;4:清分失败;5:处理异常
    ,o.physics_flag -- 物理标识.1:正常,2:删除,99:冻结
    ,o.fld_n2 -- 回盘标识字段 用于首次记录生成一条差错款清分记录
    ,o.create_time -- 创建时间.
    ,o.update_time -- 更新时间.
    ,o.account_type -- 账户类型.账户类型：1企业,2个人
    ,o.api_provider -- 接口提供方
    ,o.bank_code -- 银行代码（兴业提供的广义联行号）
    ,o.cleaning_type_detail -- 1表示收支商户 冗余
    ,o.private_cleaning_bill_id -- 私有云清分ID，私有云回导公有云时copy私有云清分ID
    ,o.org_properties -- 商户标识.1：普通商户；2：月结商户
    ,o.cleaning_error_status -- 差错清分状态：1.差错待处理，2.差错待清分，3.差错清分中，4.差错清分成功
    ,o.cleaning_error_time -- 差错清分发起时间
    ,o.cleaning_export_status -- 清分导出状态：0-未导出 1-已导出
    ,o.cleaning_error_check_time -- 差错清分记录审核时间
    ,o.modify_chfee_flag -- 是否编辑过打款金额
    ,o.cleaning_process_time -- 
    ,o.pay_channel_type -- 代付通路
    ,o.fee_code -- 费项代码
    ,o.acc_way -- D0批量标识,（1、标准[T1结算]默认；2、D1提现；11、D0提现；12、D0秒到；13、D0批量)
    ,o.parent_org_id -- 父机构id
    ,o.negative_type -- 清分负数标记 商户清分金额为0标记 后面可扩展
    ,o.negative_status -- 清分负数状态1-需合并、2-已合并,对于被合并的记录保留合并的清分记录id更用字段
    ,o.branch_org_id -- 分行机构号
    ,o.remit_status -- 汇款状态，1：未汇款；2：已汇款
    ,o.pay_account_type -- 付款方账户类型
    ,o.remit_contact_line -- 付款方行号
    ,o.remit_org_id -- 付款方机构号
    ,o.remit_org_name -- 付款方名称
    ,o.remit_account_name -- 付款方账户名
    ,o.create_user -- 创建用户
    ,o.create_emp -- 创建人
    ,o.account_id -- 结算账户ID
    ,o.bookkeeping_code -- 记账代号
    ,o.remit_bank_channel_id -- 付款方银行机构号
    ,o.payee_bank_channel_id -- 收款方银行机构号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.amss_cle_cleaning_bill_bk o
    left join ${iol_schema}.amss_cle_cleaning_bill_op n
        on
            o.cleaning_bill_id = n.cleaning_bill_id
            and o.acc_date = n.acc_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_cle_cleaning_bill_cl d
        on
            o.cleaning_bill_id = d.cleaning_bill_id
            and o.acc_date = d.acc_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_cle_cleaning_bill;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_cle_cleaning_bill') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_cle_cleaning_bill drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_cle_cleaning_bill add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_cle_cleaning_bill exchange partition p_${batch_date} with table ${iol_schema}.amss_cle_cleaning_bill_cl;
alter table ${iol_schema}.amss_cle_cleaning_bill exchange partition p_20991231 with table ${iol_schema}.amss_cle_cleaning_bill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_cle_cleaning_bill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_cle_cleaning_bill_op purge;
drop table ${iol_schema}.amss_cle_cleaning_bill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_cle_cleaning_bill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_cle_cleaning_bill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
