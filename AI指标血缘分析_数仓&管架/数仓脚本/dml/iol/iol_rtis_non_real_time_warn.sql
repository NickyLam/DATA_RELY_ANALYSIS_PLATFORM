/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_non_real_time_warn
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
create table ${iol_schema}.rtis_non_real_time_warn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rtis_non_real_time_warn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_non_real_time_warn_op purge;
drop table ${iol_schema}.rtis_non_real_time_warn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_non_real_time_warn_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_non_real_time_warn where 0=1;

create table ${iol_schema}.rtis_non_real_time_warn_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_non_real_time_warn where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_non_real_time_warn_cl(
            warn_id -- ID
            ,classify_id -- 预警分类ID
            ,oper_chnl -- 操作时间
            ,early_warning_dimension -- 预警维度
            ,order_mainstay_no -- 交易主体号
            ,order_mainstay_name -- 交易主体名
            ,warning_order_num -- 触发交易数
            ,risk_qualitative -- 风险定性（1有风险，2无风险）
            ,rate_level -- 评级
            ,early_warning_frequency -- 预警频率
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,exp_time -- 过期时间
            ,collect_start_date -- 汇总周期开始日期(包含该日期)
            ,collect_end_date -- 汇总周期结束日期(包含该日期)
            ,trans_vol -- 交易金额
            ,risk_level -- 风险级别
            ,list_status -- 受理状态(0待处理、1处理中、2已完结、3待审核)
            ,oper_user_name -- 操作类型 （注册-0登陆-1登出-2授信申请-3 绑卡-4 解绑-5 注销-6 提现-7 支付/消费-8 更改手机号-9）
            ,control -- 管控
            ,list_strategy -- 名单策略
            ,remark -- 备注
            ,deal_dept -- 处理机构
            ,deal_dept_name -- 处理机构名称
            ,develop_dept -- 运营机构
            ,develop_dept_name -- 运营机构名称
            ,deal_dept_path -- 处理路径
            ,develop_dept_path -- 运营路径
            ,latest_handle_by -- 最新受理人
            ,audit_by -- 审核人
            ,data_source -- 数据来源(0-系统，1-人工)
            ,task_id -- activiti流程执行对应ID
            ,act_variable -- 流程变量信息
            ,approve_result -- 审核结果(1:有风险，2：无风险)
            ,oper_ip_addr -- 操作时间
            ,oper_city -- 操作时间
            ,qua_type -- 确认有无风险类型：默认值为0；待确认、确认无风险->确认有风险，值为1；确认有风险->确认无风险，值为-1
            ,cust_id -- 客户号
            ,trans_time -- 交易时间
            ,rule_code_num -- 去重触发规则协查条数
            ,rule_code_str -- 触发规则编号
            ,isexamine -- 是否核查（1:是，0：否）
            ,account_organ -- 账户归属机构
            ,account_organ_id -- 账户归属机构ID
            ,pro_inform_sources -- 处理信息来源
            ,rule_code_e_num -- 去重触发规则协查条数
            ,score -- 分数
            ,warnkey -- 预警key
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_non_real_time_warn_op(
            warn_id -- ID
            ,classify_id -- 预警分类ID
            ,oper_chnl -- 操作时间
            ,early_warning_dimension -- 预警维度
            ,order_mainstay_no -- 交易主体号
            ,order_mainstay_name -- 交易主体名
            ,warning_order_num -- 触发交易数
            ,risk_qualitative -- 风险定性（1有风险，2无风险）
            ,rate_level -- 评级
            ,early_warning_frequency -- 预警频率
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,exp_time -- 过期时间
            ,collect_start_date -- 汇总周期开始日期(包含该日期)
            ,collect_end_date -- 汇总周期结束日期(包含该日期)
            ,trans_vol -- 交易金额
            ,risk_level -- 风险级别
            ,list_status -- 受理状态(0待处理、1处理中、2已完结、3待审核)
            ,oper_user_name -- 操作类型 （注册-0登陆-1登出-2授信申请-3 绑卡-4 解绑-5 注销-6 提现-7 支付/消费-8 更改手机号-9）
            ,control -- 管控
            ,list_strategy -- 名单策略
            ,remark -- 备注
            ,deal_dept -- 处理机构
            ,deal_dept_name -- 处理机构名称
            ,develop_dept -- 运营机构
            ,develop_dept_name -- 运营机构名称
            ,deal_dept_path -- 处理路径
            ,develop_dept_path -- 运营路径
            ,latest_handle_by -- 最新受理人
            ,audit_by -- 审核人
            ,data_source -- 数据来源(0-系统，1-人工)
            ,task_id -- activiti流程执行对应ID
            ,act_variable -- 流程变量信息
            ,approve_result -- 审核结果(1:有风险，2：无风险)
            ,oper_ip_addr -- 操作时间
            ,oper_city -- 操作时间
            ,qua_type -- 确认有无风险类型：默认值为0；待确认、确认无风险->确认有风险，值为1；确认有风险->确认无风险，值为-1
            ,cust_id -- 客户号
            ,trans_time -- 交易时间
            ,rule_code_num -- 去重触发规则协查条数
            ,rule_code_str -- 触发规则编号
            ,isexamine -- 是否核查（1:是，0：否）
            ,account_organ -- 账户归属机构
            ,account_organ_id -- 账户归属机构ID
            ,pro_inform_sources -- 处理信息来源
            ,rule_code_e_num -- 去重触发规则协查条数
            ,score -- 分数
            ,warnkey -- 预警key
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.warn_id, o.warn_id) as warn_id -- ID
    ,nvl(n.classify_id, o.classify_id) as classify_id -- 预警分类ID
    ,nvl(n.oper_chnl, o.oper_chnl) as oper_chnl -- 操作时间
    ,nvl(n.early_warning_dimension, o.early_warning_dimension) as early_warning_dimension -- 预警维度
    ,nvl(n.order_mainstay_no, o.order_mainstay_no) as order_mainstay_no -- 交易主体号
    ,nvl(n.order_mainstay_name, o.order_mainstay_name) as order_mainstay_name -- 交易主体名
    ,nvl(n.warning_order_num, o.warning_order_num) as warning_order_num -- 触发交易数
    ,nvl(n.risk_qualitative, o.risk_qualitative) as risk_qualitative -- 风险定性（1有风险，2无风险）
    ,nvl(n.rate_level, o.rate_level) as rate_level -- 评级
    ,nvl(n.early_warning_frequency, o.early_warning_frequency) as early_warning_frequency -- 预警频率
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.exp_time, o.exp_time) as exp_time -- 过期时间
    ,nvl(n.collect_start_date, o.collect_start_date) as collect_start_date -- 汇总周期开始日期(包含该日期)
    ,nvl(n.collect_end_date, o.collect_end_date) as collect_end_date -- 汇总周期结束日期(包含该日期)
    ,nvl(n.trans_vol, o.trans_vol) as trans_vol -- 交易金额
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险级别
    ,nvl(n.list_status, o.list_status) as list_status -- 受理状态(0待处理、1处理中、2已完结、3待审核)
    ,nvl(n.oper_user_name, o.oper_user_name) as oper_user_name -- 操作类型 （注册-0登陆-1登出-2授信申请-3 绑卡-4 解绑-5 注销-6 提现-7 支付/消费-8 更改手机号-9）
    ,nvl(n.control, o.control) as control -- 管控
    ,nvl(n.list_strategy, o.list_strategy) as list_strategy -- 名单策略
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.deal_dept, o.deal_dept) as deal_dept -- 处理机构
    ,nvl(n.deal_dept_name, o.deal_dept_name) as deal_dept_name -- 处理机构名称
    ,nvl(n.develop_dept, o.develop_dept) as develop_dept -- 运营机构
    ,nvl(n.develop_dept_name, o.develop_dept_name) as develop_dept_name -- 运营机构名称
    ,nvl(n.deal_dept_path, o.deal_dept_path) as deal_dept_path -- 处理路径
    ,nvl(n.develop_dept_path, o.develop_dept_path) as develop_dept_path -- 运营路径
    ,nvl(n.latest_handle_by, o.latest_handle_by) as latest_handle_by -- 最新受理人
    ,nvl(n.audit_by, o.audit_by) as audit_by -- 审核人
    ,nvl(n.data_source, o.data_source) as data_source -- 数据来源(0-系统，1-人工)
    ,nvl(n.task_id, o.task_id) as task_id -- activiti流程执行对应ID
    ,nvl(n.act_variable, o.act_variable) as act_variable -- 流程变量信息
    ,nvl(n.approve_result, o.approve_result) as approve_result -- 审核结果(1:有风险，2：无风险)
    ,nvl(n.oper_ip_addr, o.oper_ip_addr) as oper_ip_addr -- 操作时间
    ,nvl(n.oper_city, o.oper_city) as oper_city -- 操作时间
    ,nvl(n.qua_type, o.qua_type) as qua_type -- 确认有无风险类型：默认值为0；待确认、确认无风险->确认有风险，值为1；确认有风险->确认无风险，值为-1
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.rule_code_num, o.rule_code_num) as rule_code_num -- 去重触发规则协查条数
    ,nvl(n.rule_code_str, o.rule_code_str) as rule_code_str -- 触发规则编号
    ,nvl(n.isexamine, o.isexamine) as isexamine -- 是否核查（1:是，0：否）
    ,nvl(n.account_organ, o.account_organ) as account_organ -- 账户归属机构
    ,nvl(n.account_organ_id, o.account_organ_id) as account_organ_id -- 账户归属机构ID
    ,nvl(n.pro_inform_sources, o.pro_inform_sources) as pro_inform_sources -- 处理信息来源
    ,nvl(n.rule_code_e_num, o.rule_code_e_num) as rule_code_e_num -- 去重触发规则协查条数
    ,nvl(n.score, o.score) as score -- 分数
    ,nvl(n.warnkey, o.warnkey) as warnkey -- 预警key
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型
    ,case when
            n.warn_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.warn_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.warn_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rtis_non_real_time_warn_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rtis_non_real_time_warn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.warn_id = n.warn_id
where (
        o.warn_id is null
    )
    or (
        n.warn_id is null
    )
    or (
        o.classify_id <> n.classify_id
        or o.oper_chnl <> n.oper_chnl
        or o.early_warning_dimension <> n.early_warning_dimension
        or o.order_mainstay_no <> n.order_mainstay_no
        or o.order_mainstay_name <> n.order_mainstay_name
        or o.warning_order_num <> n.warning_order_num
        or o.risk_qualitative <> n.risk_qualitative
        or o.rate_level <> n.rate_level
        or o.early_warning_frequency <> n.early_warning_frequency
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.exp_time <> n.exp_time
        or o.collect_start_date <> n.collect_start_date
        or o.collect_end_date <> n.collect_end_date
        or o.trans_vol <> n.trans_vol
        or o.risk_level <> n.risk_level
        or o.list_status <> n.list_status
        or o.oper_user_name <> n.oper_user_name
        or o.control <> n.control
        or o.list_strategy <> n.list_strategy
        or o.remark <> n.remark
        or o.deal_dept <> n.deal_dept
        or o.deal_dept_name <> n.deal_dept_name
        or o.develop_dept <> n.develop_dept
        or o.develop_dept_name <> n.develop_dept_name
        or o.deal_dept_path <> n.deal_dept_path
        or o.develop_dept_path <> n.develop_dept_path
        or o.latest_handle_by <> n.latest_handle_by
        or o.audit_by <> n.audit_by
        or o.data_source <> n.data_source
        or o.task_id <> n.task_id
        or o.act_variable <> n.act_variable
        or o.approve_result <> n.approve_result
        or o.oper_ip_addr <> n.oper_ip_addr
        or o.oper_city <> n.oper_city
        or o.qua_type <> n.qua_type
        or o.cust_id <> n.cust_id
        or o.trans_time <> n.trans_time
        or o.rule_code_num <> n.rule_code_num
        or o.rule_code_str <> n.rule_code_str
        or o.isexamine <> n.isexamine
        or o.account_organ <> n.account_organ
        or o.account_organ_id <> n.account_organ_id
        or o.pro_inform_sources <> n.pro_inform_sources
        or o.rule_code_e_num <> n.rule_code_e_num
        or o.score <> n.score
        or o.warnkey <> n.warnkey
        or o.cust_type <> n.cust_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_non_real_time_warn_cl(
            warn_id -- ID
            ,classify_id -- 预警分类ID
            ,oper_chnl -- 操作时间
            ,early_warning_dimension -- 预警维度
            ,order_mainstay_no -- 交易主体号
            ,order_mainstay_name -- 交易主体名
            ,warning_order_num -- 触发交易数
            ,risk_qualitative -- 风险定性（1有风险，2无风险）
            ,rate_level -- 评级
            ,early_warning_frequency -- 预警频率
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,exp_time -- 过期时间
            ,collect_start_date -- 汇总周期开始日期(包含该日期)
            ,collect_end_date -- 汇总周期结束日期(包含该日期)
            ,trans_vol -- 交易金额
            ,risk_level -- 风险级别
            ,list_status -- 受理状态(0待处理、1处理中、2已完结、3待审核)
            ,oper_user_name -- 操作类型 （注册-0登陆-1登出-2授信申请-3 绑卡-4 解绑-5 注销-6 提现-7 支付/消费-8 更改手机号-9）
            ,control -- 管控
            ,list_strategy -- 名单策略
            ,remark -- 备注
            ,deal_dept -- 处理机构
            ,deal_dept_name -- 处理机构名称
            ,develop_dept -- 运营机构
            ,develop_dept_name -- 运营机构名称
            ,deal_dept_path -- 处理路径
            ,develop_dept_path -- 运营路径
            ,latest_handle_by -- 最新受理人
            ,audit_by -- 审核人
            ,data_source -- 数据来源(0-系统，1-人工)
            ,task_id -- activiti流程执行对应ID
            ,act_variable -- 流程变量信息
            ,approve_result -- 审核结果(1:有风险，2：无风险)
            ,oper_ip_addr -- 操作时间
            ,oper_city -- 操作时间
            ,qua_type -- 确认有无风险类型：默认值为0；待确认、确认无风险->确认有风险，值为1；确认有风险->确认无风险，值为-1
            ,cust_id -- 客户号
            ,trans_time -- 交易时间
            ,rule_code_num -- 去重触发规则协查条数
            ,rule_code_str -- 触发规则编号
            ,isexamine -- 是否核查（1:是，0：否）
            ,account_organ -- 账户归属机构
            ,account_organ_id -- 账户归属机构ID
            ,pro_inform_sources -- 处理信息来源
            ,rule_code_e_num -- 去重触发规则协查条数
            ,score -- 分数
            ,warnkey -- 预警key
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_non_real_time_warn_op(
            warn_id -- ID
            ,classify_id -- 预警分类ID
            ,oper_chnl -- 操作时间
            ,early_warning_dimension -- 预警维度
            ,order_mainstay_no -- 交易主体号
            ,order_mainstay_name -- 交易主体名
            ,warning_order_num -- 触发交易数
            ,risk_qualitative -- 风险定性（1有风险，2无风险）
            ,rate_level -- 评级
            ,early_warning_frequency -- 预警频率
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,exp_time -- 过期时间
            ,collect_start_date -- 汇总周期开始日期(包含该日期)
            ,collect_end_date -- 汇总周期结束日期(包含该日期)
            ,trans_vol -- 交易金额
            ,risk_level -- 风险级别
            ,list_status -- 受理状态(0待处理、1处理中、2已完结、3待审核)
            ,oper_user_name -- 操作类型 （注册-0登陆-1登出-2授信申请-3 绑卡-4 解绑-5 注销-6 提现-7 支付/消费-8 更改手机号-9）
            ,control -- 管控
            ,list_strategy -- 名单策略
            ,remark -- 备注
            ,deal_dept -- 处理机构
            ,deal_dept_name -- 处理机构名称
            ,develop_dept -- 运营机构
            ,develop_dept_name -- 运营机构名称
            ,deal_dept_path -- 处理路径
            ,develop_dept_path -- 运营路径
            ,latest_handle_by -- 最新受理人
            ,audit_by -- 审核人
            ,data_source -- 数据来源(0-系统，1-人工)
            ,task_id -- activiti流程执行对应ID
            ,act_variable -- 流程变量信息
            ,approve_result -- 审核结果(1:有风险，2：无风险)
            ,oper_ip_addr -- 操作时间
            ,oper_city -- 操作时间
            ,qua_type -- 确认有无风险类型：默认值为0；待确认、确认无风险->确认有风险，值为1；确认有风险->确认无风险，值为-1
            ,cust_id -- 客户号
            ,trans_time -- 交易时间
            ,rule_code_num -- 去重触发规则协查条数
            ,rule_code_str -- 触发规则编号
            ,isexamine -- 是否核查（1:是，0：否）
            ,account_organ -- 账户归属机构
            ,account_organ_id -- 账户归属机构ID
            ,pro_inform_sources -- 处理信息来源
            ,rule_code_e_num -- 去重触发规则协查条数
            ,score -- 分数
            ,warnkey -- 预警key
            ,cust_type -- 客户类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.warn_id -- ID
    ,o.classify_id -- 预警分类ID
    ,o.oper_chnl -- 操作时间
    ,o.early_warning_dimension -- 预警维度
    ,o.order_mainstay_no -- 交易主体号
    ,o.order_mainstay_name -- 交易主体名
    ,o.warning_order_num -- 触发交易数
    ,o.risk_qualitative -- 风险定性（1有风险，2无风险）
    ,o.rate_level -- 评级
    ,o.early_warning_frequency -- 预警频率
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.exp_time -- 过期时间
    ,o.collect_start_date -- 汇总周期开始日期(包含该日期)
    ,o.collect_end_date -- 汇总周期结束日期(包含该日期)
    ,o.trans_vol -- 交易金额
    ,o.risk_level -- 风险级别
    ,o.list_status -- 受理状态(0待处理、1处理中、2已完结、3待审核)
    ,o.oper_user_name -- 操作类型 （注册-0登陆-1登出-2授信申请-3 绑卡-4 解绑-5 注销-6 提现-7 支付/消费-8 更改手机号-9）
    ,o.control -- 管控
    ,o.list_strategy -- 名单策略
    ,o.remark -- 备注
    ,o.deal_dept -- 处理机构
    ,o.deal_dept_name -- 处理机构名称
    ,o.develop_dept -- 运营机构
    ,o.develop_dept_name -- 运营机构名称
    ,o.deal_dept_path -- 处理路径
    ,o.develop_dept_path -- 运营路径
    ,o.latest_handle_by -- 最新受理人
    ,o.audit_by -- 审核人
    ,o.data_source -- 数据来源(0-系统，1-人工)
    ,o.task_id -- activiti流程执行对应ID
    ,o.act_variable -- 流程变量信息
    ,o.approve_result -- 审核结果(1:有风险，2：无风险)
    ,o.oper_ip_addr -- 操作时间
    ,o.oper_city -- 操作时间
    ,o.qua_type -- 确认有无风险类型：默认值为0；待确认、确认无风险->确认有风险，值为1；确认有风险->确认无风险，值为-1
    ,o.cust_id -- 客户号
    ,o.trans_time -- 交易时间
    ,o.rule_code_num -- 去重触发规则协查条数
    ,o.rule_code_str -- 触发规则编号
    ,o.isexamine -- 是否核查（1:是，0：否）
    ,o.account_organ -- 账户归属机构
    ,o.account_organ_id -- 账户归属机构ID
    ,o.pro_inform_sources -- 处理信息来源
    ,o.rule_code_e_num -- 去重触发规则协查条数
    ,o.score -- 分数
    ,o.warnkey -- 预警key
    ,o.cust_type -- 客户类型
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
from ${iol_schema}.rtis_non_real_time_warn_bk o
    left join ${iol_schema}.rtis_non_real_time_warn_op n
        on
            o.warn_id = n.warn_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rtis_non_real_time_warn_cl d
        on
            o.warn_id = d.warn_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rtis_non_real_time_warn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rtis_non_real_time_warn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rtis_non_real_time_warn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rtis_non_real_time_warn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rtis_non_real_time_warn exchange partition p_${batch_date} with table ${iol_schema}.rtis_non_real_time_warn_cl;
alter table ${iol_schema}.rtis_non_real_time_warn exchange partition p_20991231 with table ${iol_schema}.rtis_non_real_time_warn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_non_real_time_warn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_non_real_time_warn_op purge;
drop table ${iol_schema}.rtis_non_real_time_warn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rtis_non_real_time_warn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_non_real_time_warn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
