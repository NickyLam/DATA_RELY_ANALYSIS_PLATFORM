/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_phonecheck_tb
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
create table ${iol_schema}.scps_bp_phonecheck_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_phonecheck_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_phonecheck_tb_op purge;
drop table ${iol_schema}.scps_bp_phonecheck_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_phonecheck_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_phonecheck_tb where 0=1;

create table ${iol_schema}.scps_bp_phonecheck_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_phonecheck_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_phonecheck_tb_cl(
            task_id -- 任务号
            ,bus_serial_number -- 业务流水号
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,account -- 收款账号
            ,payee_name -- 收款账户名称
            ,payer_account -- 付款账号
            ,payer_name -- 付款人名称
            ,deal_code -- 交易码
            ,scene_code -- 场景号
            ,check_flag -- 查证标识（00-免查证，01-待查证，02-查证中，03-查证通过，04-查证不通过，05-无法联系，06-查证异常，07-撤销查证）
            ,onesecreason -- 二级原因
            ,onecheckresult -- 查证答案
            ,deal_time -- 交易日期
            ,check_expire_date -- 查证到期日
            ,check_company -- 查证公司
            ,amount -- 交易金额
            ,currency -- 币种
            ,use -- 用途
            ,channel -- 渠道编号
            ,vouchgroup -- 凭证组合
            ,doc_id -- 影像批次号
            ,check_type -- 查证类型(1-请求查证 2-撤销查证)
            ,ticket_issues_date -- 票据签发日期
            ,trans_bu_ser_no -- 办理柜员工号
            ,trans_bu_name -- 办理柜员姓名
            ,trans_bu_phone -- 办理柜员电话
            ,trans_bu_email -- 办理柜员邮箱
            ,cust_mgr_no -- 客户经理工号
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_phone -- 客户经理手机
            ,cust_mgr_email -- 客户经理邮箱
            ,cust_mgr_organ -- 客户经理所属机构
            ,give_money_date -- 放款日期
            ,give_money_count -- 放款金额
            ,give_money_product -- 放款产品
            ,begin_date -- 创建时间
            ,end_date -- 结束时间(外呼结果返回日期)
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,is_equal_bus -- 是否同业标识(0-否 1-是 由发起渠道传送)
            ,priority_grade -- 优先分数(人工设置)
            ,scene_name -- 场景
            ,operator_name -- 经办人姓名
            ,operator_tel -- 经办人电话
            ,extend -- 对公客户号
            ,check_way -- 查证方式（线上查证、线下查证）
            ,flow_tailafter -- 查证流程跟踪
            ,record_tailafter -- 信息补录跟踪
            ,check_call_user -- 查证人（拨号人）
            ,check_numbers -- 外呼中心查证次数
            ,is_overtime -- 呼叫是否超时限制（是、否）
            ,outcall_launch_time -- 外呼任务发起时间
            ,record_comment -- 补录备注（补录结果说明）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_phonecheck_tb_op(
            task_id -- 任务号
            ,bus_serial_number -- 业务流水号
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,account -- 收款账号
            ,payee_name -- 收款账户名称
            ,payer_account -- 付款账号
            ,payer_name -- 付款人名称
            ,deal_code -- 交易码
            ,scene_code -- 场景号
            ,check_flag -- 查证标识（00-免查证，01-待查证，02-查证中，03-查证通过，04-查证不通过，05-无法联系，06-查证异常，07-撤销查证）
            ,onesecreason -- 二级原因
            ,onecheckresult -- 查证答案
            ,deal_time -- 交易日期
            ,check_expire_date -- 查证到期日
            ,check_company -- 查证公司
            ,amount -- 交易金额
            ,currency -- 币种
            ,use -- 用途
            ,channel -- 渠道编号
            ,vouchgroup -- 凭证组合
            ,doc_id -- 影像批次号
            ,check_type -- 查证类型(1-请求查证 2-撤销查证)
            ,ticket_issues_date -- 票据签发日期
            ,trans_bu_ser_no -- 办理柜员工号
            ,trans_bu_name -- 办理柜员姓名
            ,trans_bu_phone -- 办理柜员电话
            ,trans_bu_email -- 办理柜员邮箱
            ,cust_mgr_no -- 客户经理工号
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_phone -- 客户经理手机
            ,cust_mgr_email -- 客户经理邮箱
            ,cust_mgr_organ -- 客户经理所属机构
            ,give_money_date -- 放款日期
            ,give_money_count -- 放款金额
            ,give_money_product -- 放款产品
            ,begin_date -- 创建时间
            ,end_date -- 结束时间(外呼结果返回日期)
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,is_equal_bus -- 是否同业标识(0-否 1-是 由发起渠道传送)
            ,priority_grade -- 优先分数(人工设置)
            ,scene_name -- 场景
            ,operator_name -- 经办人姓名
            ,operator_tel -- 经办人电话
            ,extend -- 对公客户号
            ,check_way -- 查证方式（线上查证、线下查证）
            ,flow_tailafter -- 查证流程跟踪
            ,record_tailafter -- 信息补录跟踪
            ,check_call_user -- 查证人（拨号人）
            ,check_numbers -- 外呼中心查证次数
            ,is_overtime -- 呼叫是否超时限制（是、否）
            ,outcall_launch_time -- 外呼任务发起时间
            ,record_comment -- 补录备注（补录结果说明）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.bus_serial_number, o.bus_serial_number) as bus_serial_number -- 业务流水号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.account, o.account) as account -- 收款账号
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 收款账户名称
    ,nvl(n.payer_account, o.payer_account) as payer_account -- 付款账号
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付款人名称
    ,nvl(n.deal_code, o.deal_code) as deal_code -- 交易码
    ,nvl(n.scene_code, o.scene_code) as scene_code -- 场景号
    ,nvl(n.check_flag, o.check_flag) as check_flag -- 查证标识（00-免查证，01-待查证，02-查证中，03-查证通过，04-查证不通过，05-无法联系，06-查证异常，07-撤销查证）
    ,nvl(n.onesecreason, o.onesecreason) as onesecreason -- 二级原因
    ,nvl(n.onecheckresult, o.onecheckresult) as onecheckresult -- 查证答案
    ,nvl(n.deal_time, o.deal_time) as deal_time -- 交易日期
    ,nvl(n.check_expire_date, o.check_expire_date) as check_expire_date -- 查证到期日
    ,nvl(n.check_company, o.check_company) as check_company -- 查证公司
    ,nvl(n.amount, o.amount) as amount -- 交易金额
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.use, o.use) as use -- 用途
    ,nvl(n.channel, o.channel) as channel -- 渠道编号
    ,nvl(n.vouchgroup, o.vouchgroup) as vouchgroup -- 凭证组合
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 影像批次号
    ,nvl(n.check_type, o.check_type) as check_type -- 查证类型(1-请求查证 2-撤销查证)
    ,nvl(n.ticket_issues_date, o.ticket_issues_date) as ticket_issues_date -- 票据签发日期
    ,nvl(n.trans_bu_ser_no, o.trans_bu_ser_no) as trans_bu_ser_no -- 办理柜员工号
    ,nvl(n.trans_bu_name, o.trans_bu_name) as trans_bu_name -- 办理柜员姓名
    ,nvl(n.trans_bu_phone, o.trans_bu_phone) as trans_bu_phone -- 办理柜员电话
    ,nvl(n.trans_bu_email, o.trans_bu_email) as trans_bu_email -- 办理柜员邮箱
    ,nvl(n.cust_mgr_no, o.cust_mgr_no) as cust_mgr_no -- 客户经理工号
    ,nvl(n.cust_mgr_name, o.cust_mgr_name) as cust_mgr_name -- 客户经理姓名
    ,nvl(n.cust_mgr_phone, o.cust_mgr_phone) as cust_mgr_phone -- 客户经理手机
    ,nvl(n.cust_mgr_email, o.cust_mgr_email) as cust_mgr_email -- 客户经理邮箱
    ,nvl(n.cust_mgr_organ, o.cust_mgr_organ) as cust_mgr_organ -- 客户经理所属机构
    ,nvl(n.give_money_date, o.give_money_date) as give_money_date -- 放款日期
    ,nvl(n.give_money_count, o.give_money_count) as give_money_count -- 放款金额
    ,nvl(n.give_money_product, o.give_money_product) as give_money_product -- 放款产品
    ,nvl(n.begin_date, o.begin_date) as begin_date -- 创建时间
    ,nvl(n.end_date, o.end_date) as end_date -- 结束时间(外呼结果返回日期)
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行号
    ,nvl(n.system_no, o.system_no) as system_no -- 系统号
    ,nvl(n.is_equal_bus, o.is_equal_bus) as is_equal_bus -- 是否同业标识(0-否 1-是 由发起渠道传送)
    ,nvl(n.priority_grade, o.priority_grade) as priority_grade -- 优先分数(人工设置)
    ,nvl(n.scene_name, o.scene_name) as scene_name -- 场景
    ,nvl(n.operator_name, o.operator_name) as operator_name -- 经办人姓名
    ,nvl(n.operator_tel, o.operator_tel) as operator_tel -- 经办人电话
    ,nvl(n.extend, o.extend) as extend -- 对公客户号
    ,nvl(n.check_way, o.check_way) as check_way -- 查证方式（线上查证、线下查证）
    ,nvl(n.flow_tailafter, o.flow_tailafter) as flow_tailafter -- 查证流程跟踪
    ,nvl(n.record_tailafter, o.record_tailafter) as record_tailafter -- 信息补录跟踪
    ,nvl(n.check_call_user, o.check_call_user) as check_call_user -- 查证人（拨号人）
    ,nvl(n.check_numbers, o.check_numbers) as check_numbers -- 外呼中心查证次数
    ,nvl(n.is_overtime, o.is_overtime) as is_overtime -- 呼叫是否超时限制（是、否）
    ,nvl(n.outcall_launch_time, o.outcall_launch_time) as outcall_launch_time -- 外呼任务发起时间
    ,nvl(n.record_comment, o.record_comment) as record_comment -- 补录备注（补录结果说明）
    ,case when
            n.bus_serial_number is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bus_serial_number is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bus_serial_number is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_phonecheck_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_phonecheck_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bus_serial_number = n.bus_serial_number
where (
        o.bus_serial_number is null
    )
    or (
        n.bus_serial_number is null
    )
    or (
        o.task_id <> n.task_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.account <> n.account
        or o.payee_name <> n.payee_name
        or o.payer_account <> n.payer_account
        or o.payer_name <> n.payer_name
        or o.deal_code <> n.deal_code
        or o.scene_code <> n.scene_code
        or o.check_flag <> n.check_flag
        or o.onesecreason <> n.onesecreason
        or o.onecheckresult <> n.onecheckresult
        or o.deal_time <> n.deal_time
        or o.check_expire_date <> n.check_expire_date
        or o.check_company <> n.check_company
        or o.amount <> n.amount
        or o.currency <> n.currency
        or o.use <> n.use
        or o.channel <> n.channel
        or o.vouchgroup <> n.vouchgroup
        or o.doc_id <> n.doc_id
        or o.check_type <> n.check_type
        or o.ticket_issues_date <> n.ticket_issues_date
        or o.trans_bu_ser_no <> n.trans_bu_ser_no
        or o.trans_bu_name <> n.trans_bu_name
        or o.trans_bu_phone <> n.trans_bu_phone
        or o.trans_bu_email <> n.trans_bu_email
        or o.cust_mgr_no <> n.cust_mgr_no
        or o.cust_mgr_name <> n.cust_mgr_name
        or o.cust_mgr_phone <> n.cust_mgr_phone
        or o.cust_mgr_email <> n.cust_mgr_email
        or o.cust_mgr_organ <> n.cust_mgr_organ
        or o.give_money_date <> n.give_money_date
        or o.give_money_count <> n.give_money_count
        or o.give_money_product <> n.give_money_product
        or o.begin_date <> n.begin_date
        or o.end_date <> n.end_date
        or o.bank_no <> n.bank_no
        or o.system_no <> n.system_no
        or o.is_equal_bus <> n.is_equal_bus
        or o.priority_grade <> n.priority_grade
        or o.scene_name <> n.scene_name
        or o.operator_name <> n.operator_name
        or o.operator_tel <> n.operator_tel
        or o.extend <> n.extend
        or o.check_way <> n.check_way
        or o.flow_tailafter <> n.flow_tailafter
        or o.record_tailafter <> n.record_tailafter
        or o.check_call_user <> n.check_call_user
        or o.check_numbers <> n.check_numbers
        or o.is_overtime <> n.is_overtime
        or o.outcall_launch_time <> n.outcall_launch_time
        or o.record_comment <> n.record_comment
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_phonecheck_tb_cl(
            task_id -- 任务号
            ,bus_serial_number -- 业务流水号
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,account -- 收款账号
            ,payee_name -- 收款账户名称
            ,payer_account -- 付款账号
            ,payer_name -- 付款人名称
            ,deal_code -- 交易码
            ,scene_code -- 场景号
            ,check_flag -- 查证标识（00-免查证，01-待查证，02-查证中，03-查证通过，04-查证不通过，05-无法联系，06-查证异常，07-撤销查证）
            ,onesecreason -- 二级原因
            ,onecheckresult -- 查证答案
            ,deal_time -- 交易日期
            ,check_expire_date -- 查证到期日
            ,check_company -- 查证公司
            ,amount -- 交易金额
            ,currency -- 币种
            ,use -- 用途
            ,channel -- 渠道编号
            ,vouchgroup -- 凭证组合
            ,doc_id -- 影像批次号
            ,check_type -- 查证类型(1-请求查证 2-撤销查证)
            ,ticket_issues_date -- 票据签发日期
            ,trans_bu_ser_no -- 办理柜员工号
            ,trans_bu_name -- 办理柜员姓名
            ,trans_bu_phone -- 办理柜员电话
            ,trans_bu_email -- 办理柜员邮箱
            ,cust_mgr_no -- 客户经理工号
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_phone -- 客户经理手机
            ,cust_mgr_email -- 客户经理邮箱
            ,cust_mgr_organ -- 客户经理所属机构
            ,give_money_date -- 放款日期
            ,give_money_count -- 放款金额
            ,give_money_product -- 放款产品
            ,begin_date -- 创建时间
            ,end_date -- 结束时间(外呼结果返回日期)
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,is_equal_bus -- 是否同业标识(0-否 1-是 由发起渠道传送)
            ,priority_grade -- 优先分数(人工设置)
            ,scene_name -- 场景
            ,operator_name -- 经办人姓名
            ,operator_tel -- 经办人电话
            ,extend -- 对公客户号
            ,check_way -- 查证方式（线上查证、线下查证）
            ,flow_tailafter -- 查证流程跟踪
            ,record_tailafter -- 信息补录跟踪
            ,check_call_user -- 查证人（拨号人）
            ,check_numbers -- 外呼中心查证次数
            ,is_overtime -- 呼叫是否超时限制（是、否）
            ,outcall_launch_time -- 外呼任务发起时间
            ,record_comment -- 补录备注（补录结果说明）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_phonecheck_tb_op(
            task_id -- 任务号
            ,bus_serial_number -- 业务流水号
            ,cust_id -- 客户号
            ,cust_name -- 客户名称
            ,account -- 收款账号
            ,payee_name -- 收款账户名称
            ,payer_account -- 付款账号
            ,payer_name -- 付款人名称
            ,deal_code -- 交易码
            ,scene_code -- 场景号
            ,check_flag -- 查证标识（00-免查证，01-待查证，02-查证中，03-查证通过，04-查证不通过，05-无法联系，06-查证异常，07-撤销查证）
            ,onesecreason -- 二级原因
            ,onecheckresult -- 查证答案
            ,deal_time -- 交易日期
            ,check_expire_date -- 查证到期日
            ,check_company -- 查证公司
            ,amount -- 交易金额
            ,currency -- 币种
            ,use -- 用途
            ,channel -- 渠道编号
            ,vouchgroup -- 凭证组合
            ,doc_id -- 影像批次号
            ,check_type -- 查证类型(1-请求查证 2-撤销查证)
            ,ticket_issues_date -- 票据签发日期
            ,trans_bu_ser_no -- 办理柜员工号
            ,trans_bu_name -- 办理柜员姓名
            ,trans_bu_phone -- 办理柜员电话
            ,trans_bu_email -- 办理柜员邮箱
            ,cust_mgr_no -- 客户经理工号
            ,cust_mgr_name -- 客户经理姓名
            ,cust_mgr_phone -- 客户经理手机
            ,cust_mgr_email -- 客户经理邮箱
            ,cust_mgr_organ -- 客户经理所属机构
            ,give_money_date -- 放款日期
            ,give_money_count -- 放款金额
            ,give_money_product -- 放款产品
            ,begin_date -- 创建时间
            ,end_date -- 结束时间(外呼结果返回日期)
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,is_equal_bus -- 是否同业标识(0-否 1-是 由发起渠道传送)
            ,priority_grade -- 优先分数(人工设置)
            ,scene_name -- 场景
            ,operator_name -- 经办人姓名
            ,operator_tel -- 经办人电话
            ,extend -- 对公客户号
            ,check_way -- 查证方式（线上查证、线下查证）
            ,flow_tailafter -- 查证流程跟踪
            ,record_tailafter -- 信息补录跟踪
            ,check_call_user -- 查证人（拨号人）
            ,check_numbers -- 外呼中心查证次数
            ,is_overtime -- 呼叫是否超时限制（是、否）
            ,outcall_launch_time -- 外呼任务发起时间
            ,record_comment -- 补录备注（补录结果说明）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_id -- 任务号
    ,o.bus_serial_number -- 业务流水号
    ,o.cust_id -- 客户号
    ,o.cust_name -- 客户名称
    ,o.account -- 收款账号
    ,o.payee_name -- 收款账户名称
    ,o.payer_account -- 付款账号
    ,o.payer_name -- 付款人名称
    ,o.deal_code -- 交易码
    ,o.scene_code -- 场景号
    ,o.check_flag -- 查证标识（00-免查证，01-待查证，02-查证中，03-查证通过，04-查证不通过，05-无法联系，06-查证异常，07-撤销查证）
    ,o.onesecreason -- 二级原因
    ,o.onecheckresult -- 查证答案
    ,o.deal_time -- 交易日期
    ,o.check_expire_date -- 查证到期日
    ,o.check_company -- 查证公司
    ,o.amount -- 交易金额
    ,o.currency -- 币种
    ,o.use -- 用途
    ,o.channel -- 渠道编号
    ,o.vouchgroup -- 凭证组合
    ,o.doc_id -- 影像批次号
    ,o.check_type -- 查证类型(1-请求查证 2-撤销查证)
    ,o.ticket_issues_date -- 票据签发日期
    ,o.trans_bu_ser_no -- 办理柜员工号
    ,o.trans_bu_name -- 办理柜员姓名
    ,o.trans_bu_phone -- 办理柜员电话
    ,o.trans_bu_email -- 办理柜员邮箱
    ,o.cust_mgr_no -- 客户经理工号
    ,o.cust_mgr_name -- 客户经理姓名
    ,o.cust_mgr_phone -- 客户经理手机
    ,o.cust_mgr_email -- 客户经理邮箱
    ,o.cust_mgr_organ -- 客户经理所属机构
    ,o.give_money_date -- 放款日期
    ,o.give_money_count -- 放款金额
    ,o.give_money_product -- 放款产品
    ,o.begin_date -- 创建时间
    ,o.end_date -- 结束时间(外呼结果返回日期)
    ,o.bank_no -- 银行号
    ,o.system_no -- 系统号
    ,o.is_equal_bus -- 是否同业标识(0-否 1-是 由发起渠道传送)
    ,o.priority_grade -- 优先分数(人工设置)
    ,o.scene_name -- 场景
    ,o.operator_name -- 经办人姓名
    ,o.operator_tel -- 经办人电话
    ,o.extend -- 对公客户号
    ,o.check_way -- 查证方式（线上查证、线下查证）
    ,o.flow_tailafter -- 查证流程跟踪
    ,o.record_tailafter -- 信息补录跟踪
    ,o.check_call_user -- 查证人（拨号人）
    ,o.check_numbers -- 外呼中心查证次数
    ,o.is_overtime -- 呼叫是否超时限制（是、否）
    ,o.outcall_launch_time -- 外呼任务发起时间
    ,o.record_comment -- 补录备注（补录结果说明）
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
from ${iol_schema}.scps_bp_phonecheck_tb_bk o
    left join ${iol_schema}.scps_bp_phonecheck_tb_op n
        on
            o.bus_serial_number = n.bus_serial_number
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_phonecheck_tb_cl d
        on
            o.bus_serial_number = d.bus_serial_number
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_phonecheck_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_phonecheck_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_phonecheck_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_phonecheck_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_phonecheck_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_phonecheck_tb_cl;
alter table ${iol_schema}.scps_bp_phonecheck_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_phonecheck_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_phonecheck_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_phonecheck_tb_op purge;
drop table ${iol_schema}.scps_bp_phonecheck_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_phonecheck_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_phonecheck_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
