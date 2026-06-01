/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_csrs_uomp_workbill_info
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
create table ${iol_schema}.csrs_uomp_workbill_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.csrs_uomp_workbill_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.csrs_uomp_workbill_info_op purge;
drop table ${iol_schema}.csrs_uomp_workbill_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.csrs_uomp_workbill_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.csrs_uomp_workbill_info where 0=1;

create table ${iol_schema}.csrs_uomp_workbill_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.csrs_uomp_workbill_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.csrs_uomp_workbill_info_cl(
            workbill_no -- 主键，工单编号
            ,workbill_type -- 工单类型
            ,workbill_sub_type -- 工单子类型
            ,work_sum_no -- 来电小结编号
            ,call_no -- 来电号码
            ,call_type -- 呼叫类型
            ,connection_id -- 呼叫流水号
            ,creater_code -- 创建者empcode
            ,create_date -- 创建日期
            ,workbill_level -- 紧急程度
            ,status -- 数据状态
            ,workbill_status -- 工单状态(1-编辑 4-已重置 5-延期申请中 2-提交 3-办结 0-删除)
            ,over_time -- 最后归档时间
            ,over_org_code -- 最后归档机构code
            ,over_code -- 最后归档人empcode
            ,cust_no -- 客户号
            ,cust_name -- 联系人姓名
            ,cust_sex -- 联系人性别
            ,card_no -- 客户账号
            ,card_type -- 账户类型
            ,cust_phone -- 联系电话
            ,cust_paper_id -- 证件号
            ,cust_paper_type -- 证件类型
            ,cust_email -- 客户电子邮箱
            ,flow_code -- 绑定流程code
            ,event_type -- 事件类型
            ,workbill_channel -- 接入方式 来电、邮件
            ,dead_line_date -- 整个工单最后处理时限日
            ,over_flag -- 逾期标志(0逾期1正常办结工单不计逾期)
            ,creater_name -- 创建者empname
            ,over_name -- 最后归档人empname
            ,call_name -- 来电人姓名
            ,buss_type -- 业务类型
            ,buss_sub_type -- 业务明细
            ,dev_condition -- 机具情况
            ,device_no -- 机具设备号
            ,card_attach -- 卡种类
            ,workbill_content -- 受理内容
            ,re_complain -- 重复投诉(标志)
            ,complain -- 投诉认定
            ,templ_code -- 模板code
            ,node_code -- 当前节点code
            ,detail_code -- 当前流转code
            ,org_code -- 目标处理机构
            ,submit_code -- 提交人empcode
            ,submit_name -- 提交人empname
            ,submit_date -- 提交时间
            ,mistake_sign -- 是否差错工单(0否1是)
            ,acct_name -- 户主姓名
            ,org_name -- 目标处理机构
            ,satisfied -- 满意度
            ,complaintype_first -- 投诉分类一级
            ,complaintype_sec -- 投诉分类二级
            ,complaintype_third -- 投诉分类三级
            ,complaintype_first_name -- 投诉分类一级名称
            ,complaintype_sec_name -- 投诉分类二级名称
            ,complaintype_third_name -- 投诉分类三级名称
            ,complainchannel_first -- 投诉渠道一级
            ,complainchannel_first_name -- 投诉渠道一级名称
            ,complainchannel_sec -- 投诉渠道二级
            ,complainchannel_sec_name -- 投诉渠道二级名称
            ,complainchannel_third -- 投诉渠道三级
            ,complainchannel_third_name -- 投诉渠道三级名称
            ,complainreason_first -- 投诉原因一级
            ,complainreason_first_name -- 投诉原因一级名称
            ,complainreason_sec -- 投诉原因二级
            ,complainreason_sec_name -- 投诉原因二级名称
            ,return_visit_date -- 回访时间
            ,return_visit_content -- 回访内容
            ,fallback_status -- 是否撤回
            ,fallback_date -- 撤回时间
            ,fallback_content -- 撤回备注
            ,call_sex -- 来电人性别
            ,remark -- 注意事项
            ,bank_name -- 开户行
            ,survey_handle_unit_first_code -- 调查处理单位(一级机构)
            ,survey_handle_unit_first_name -- 调查处理单位名称(一级机构)
            ,survey_handle_unit_sec_code -- 调查处理单位(二级机构)
            ,survey_handle_unit_sec_name -- 调查处理单位名称(二级机构)
            ,is_need_trans -- 工单是否需要流转(0否1是)
            ,complain_date -- 客户投诉时间
            ,risk_hidden -- 薄弱环节/风险隐患
            ,is_supervise_org_trans -- 是否监管部门转办
            ,supervise_org -- 具体监管部门
            ,branch_begin_date -- 分行开始处理时间
            ,branch_end_date -- 分行处理结束时间
            ,workbill_from -- 工单来源
            ,delete_remark -- 删除备注
            ,read_status -- 阅读状态
            ,complain_deal_remark -- 调查处理情况
            ,is_solved -- 是否化解(0否1是)
            ,is_upgrade -- 是否升级(0否1是)
            ,is_skipgrade -- 是否越级(0否1是)
            ,extend -- 扩展
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.csrs_uomp_workbill_info_op(
            workbill_no -- 主键，工单编号
            ,workbill_type -- 工单类型
            ,workbill_sub_type -- 工单子类型
            ,work_sum_no -- 来电小结编号
            ,call_no -- 来电号码
            ,call_type -- 呼叫类型
            ,connection_id -- 呼叫流水号
            ,creater_code -- 创建者empcode
            ,create_date -- 创建日期
            ,workbill_level -- 紧急程度
            ,status -- 数据状态
            ,workbill_status -- 工单状态(1-编辑 4-已重置 5-延期申请中 2-提交 3-办结 0-删除)
            ,over_time -- 最后归档时间
            ,over_org_code -- 最后归档机构code
            ,over_code -- 最后归档人empcode
            ,cust_no -- 客户号
            ,cust_name -- 联系人姓名
            ,cust_sex -- 联系人性别
            ,card_no -- 客户账号
            ,card_type -- 账户类型
            ,cust_phone -- 联系电话
            ,cust_paper_id -- 证件号
            ,cust_paper_type -- 证件类型
            ,cust_email -- 客户电子邮箱
            ,flow_code -- 绑定流程code
            ,event_type -- 事件类型
            ,workbill_channel -- 接入方式 来电、邮件
            ,dead_line_date -- 整个工单最后处理时限日
            ,over_flag -- 逾期标志(0逾期1正常办结工单不计逾期)
            ,creater_name -- 创建者empname
            ,over_name -- 最后归档人empname
            ,call_name -- 来电人姓名
            ,buss_type -- 业务类型
            ,buss_sub_type -- 业务明细
            ,dev_condition -- 机具情况
            ,device_no -- 机具设备号
            ,card_attach -- 卡种类
            ,workbill_content -- 受理内容
            ,re_complain -- 重复投诉(标志)
            ,complain -- 投诉认定
            ,templ_code -- 模板code
            ,node_code -- 当前节点code
            ,detail_code -- 当前流转code
            ,org_code -- 目标处理机构
            ,submit_code -- 提交人empcode
            ,submit_name -- 提交人empname
            ,submit_date -- 提交时间
            ,mistake_sign -- 是否差错工单(0否1是)
            ,acct_name -- 户主姓名
            ,org_name -- 目标处理机构
            ,satisfied -- 满意度
            ,complaintype_first -- 投诉分类一级
            ,complaintype_sec -- 投诉分类二级
            ,complaintype_third -- 投诉分类三级
            ,complaintype_first_name -- 投诉分类一级名称
            ,complaintype_sec_name -- 投诉分类二级名称
            ,complaintype_third_name -- 投诉分类三级名称
            ,complainchannel_first -- 投诉渠道一级
            ,complainchannel_first_name -- 投诉渠道一级名称
            ,complainchannel_sec -- 投诉渠道二级
            ,complainchannel_sec_name -- 投诉渠道二级名称
            ,complainchannel_third -- 投诉渠道三级
            ,complainchannel_third_name -- 投诉渠道三级名称
            ,complainreason_first -- 投诉原因一级
            ,complainreason_first_name -- 投诉原因一级名称
            ,complainreason_sec -- 投诉原因二级
            ,complainreason_sec_name -- 投诉原因二级名称
            ,return_visit_date -- 回访时间
            ,return_visit_content -- 回访内容
            ,fallback_status -- 是否撤回
            ,fallback_date -- 撤回时间
            ,fallback_content -- 撤回备注
            ,call_sex -- 来电人性别
            ,remark -- 注意事项
            ,bank_name -- 开户行
            ,survey_handle_unit_first_code -- 调查处理单位(一级机构)
            ,survey_handle_unit_first_name -- 调查处理单位名称(一级机构)
            ,survey_handle_unit_sec_code -- 调查处理单位(二级机构)
            ,survey_handle_unit_sec_name -- 调查处理单位名称(二级机构)
            ,is_need_trans -- 工单是否需要流转(0否1是)
            ,complain_date -- 客户投诉时间
            ,risk_hidden -- 薄弱环节/风险隐患
            ,is_supervise_org_trans -- 是否监管部门转办
            ,supervise_org -- 具体监管部门
            ,branch_begin_date -- 分行开始处理时间
            ,branch_end_date -- 分行处理结束时间
            ,workbill_from -- 工单来源
            ,delete_remark -- 删除备注
            ,read_status -- 阅读状态
            ,complain_deal_remark -- 调查处理情况
            ,is_solved -- 是否化解(0否1是)
            ,is_upgrade -- 是否升级(0否1是)
            ,is_skipgrade -- 是否越级(0否1是)
            ,extend -- 扩展
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.workbill_no, o.workbill_no) as workbill_no -- 主键，工单编号
    ,nvl(n.workbill_type, o.workbill_type) as workbill_type -- 工单类型
    ,nvl(n.workbill_sub_type, o.workbill_sub_type) as workbill_sub_type -- 工单子类型
    ,nvl(n.work_sum_no, o.work_sum_no) as work_sum_no -- 来电小结编号
    ,nvl(n.call_no, o.call_no) as call_no -- 来电号码
    ,nvl(n.call_type, o.call_type) as call_type -- 呼叫类型
    ,nvl(n.connection_id, o.connection_id) as connection_id -- 呼叫流水号
    ,nvl(n.creater_code, o.creater_code) as creater_code -- 创建者empcode
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.workbill_level, o.workbill_level) as workbill_level -- 紧急程度
    ,nvl(n.status, o.status) as status -- 数据状态
    ,nvl(n.workbill_status, o.workbill_status) as workbill_status -- 工单状态(1-编辑 4-已重置 5-延期申请中 2-提交 3-办结 0-删除)
    ,nvl(n.over_time, o.over_time) as over_time -- 最后归档时间
    ,nvl(n.over_org_code, o.over_org_code) as over_org_code -- 最后归档机构code
    ,nvl(n.over_code, o.over_code) as over_code -- 最后归档人empcode
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 联系人姓名
    ,nvl(n.cust_sex, o.cust_sex) as cust_sex -- 联系人性别
    ,nvl(n.card_no, o.card_no) as card_no -- 客户账号
    ,nvl(n.card_type, o.card_type) as card_type -- 账户类型
    ,nvl(n.cust_phone, o.cust_phone) as cust_phone -- 联系电话
    ,nvl(n.cust_paper_id, o.cust_paper_id) as cust_paper_id -- 证件号
    ,nvl(n.cust_paper_type, o.cust_paper_type) as cust_paper_type -- 证件类型
    ,nvl(n.cust_email, o.cust_email) as cust_email -- 客户电子邮箱
    ,nvl(n.flow_code, o.flow_code) as flow_code -- 绑定流程code
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.workbill_channel, o.workbill_channel) as workbill_channel -- 接入方式 来电、邮件
    ,nvl(n.dead_line_date, o.dead_line_date) as dead_line_date -- 整个工单最后处理时限日
    ,nvl(n.over_flag, o.over_flag) as over_flag -- 逾期标志(0逾期1正常办结工单不计逾期)
    ,nvl(n.creater_name, o.creater_name) as creater_name -- 创建者empname
    ,nvl(n.over_name, o.over_name) as over_name -- 最后归档人empname
    ,nvl(n.call_name, o.call_name) as call_name -- 来电人姓名
    ,nvl(n.buss_type, o.buss_type) as buss_type -- 业务类型
    ,nvl(n.buss_sub_type, o.buss_sub_type) as buss_sub_type -- 业务明细
    ,nvl(n.dev_condition, o.dev_condition) as dev_condition -- 机具情况
    ,nvl(n.device_no, o.device_no) as device_no -- 机具设备号
    ,nvl(n.card_attach, o.card_attach) as card_attach -- 卡种类
    ,nvl(n.workbill_content, o.workbill_content) as workbill_content -- 受理内容
    ,nvl(n.re_complain, o.re_complain) as re_complain -- 重复投诉(标志)
    ,nvl(n.complain, o.complain) as complain -- 投诉认定
    ,nvl(n.templ_code, o.templ_code) as templ_code -- 模板code
    ,nvl(n.node_code, o.node_code) as node_code -- 当前节点code
    ,nvl(n.detail_code, o.detail_code) as detail_code -- 当前流转code
    ,nvl(n.org_code, o.org_code) as org_code -- 目标处理机构
    ,nvl(n.submit_code, o.submit_code) as submit_code -- 提交人empcode
    ,nvl(n.submit_name, o.submit_name) as submit_name -- 提交人empname
    ,nvl(n.submit_date, o.submit_date) as submit_date -- 提交时间
    ,nvl(n.mistake_sign, o.mistake_sign) as mistake_sign -- 是否差错工单(0否1是)
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 户主姓名
    ,nvl(n.org_name, o.org_name) as org_name -- 目标处理机构
    ,nvl(n.satisfied, o.satisfied) as satisfied -- 满意度
    ,nvl(n.complaintype_first, o.complaintype_first) as complaintype_first -- 投诉分类一级
    ,nvl(n.complaintype_sec, o.complaintype_sec) as complaintype_sec -- 投诉分类二级
    ,nvl(n.complaintype_third, o.complaintype_third) as complaintype_third -- 投诉分类三级
    ,nvl(n.complaintype_first_name, o.complaintype_first_name) as complaintype_first_name -- 投诉分类一级名称
    ,nvl(n.complaintype_sec_name, o.complaintype_sec_name) as complaintype_sec_name -- 投诉分类二级名称
    ,nvl(n.complaintype_third_name, o.complaintype_third_name) as complaintype_third_name -- 投诉分类三级名称
    ,nvl(n.complainchannel_first, o.complainchannel_first) as complainchannel_first -- 投诉渠道一级
    ,nvl(n.complainchannel_first_name, o.complainchannel_first_name) as complainchannel_first_name -- 投诉渠道一级名称
    ,nvl(n.complainchannel_sec, o.complainchannel_sec) as complainchannel_sec -- 投诉渠道二级
    ,nvl(n.complainchannel_sec_name, o.complainchannel_sec_name) as complainchannel_sec_name -- 投诉渠道二级名称
    ,nvl(n.complainchannel_third, o.complainchannel_third) as complainchannel_third -- 投诉渠道三级
    ,nvl(n.complainchannel_third_name, o.complainchannel_third_name) as complainchannel_third_name -- 投诉渠道三级名称
    ,nvl(n.complainreason_first, o.complainreason_first) as complainreason_first -- 投诉原因一级
    ,nvl(n.complainreason_first_name, o.complainreason_first_name) as complainreason_first_name -- 投诉原因一级名称
    ,nvl(n.complainreason_sec, o.complainreason_sec) as complainreason_sec -- 投诉原因二级
    ,nvl(n.complainreason_sec_name, o.complainreason_sec_name) as complainreason_sec_name -- 投诉原因二级名称
    ,nvl(n.return_visit_date, o.return_visit_date) as return_visit_date -- 回访时间
    ,nvl(n.return_visit_content, o.return_visit_content) as return_visit_content -- 回访内容
    ,nvl(n.fallback_status, o.fallback_status) as fallback_status -- 是否撤回
    ,nvl(n.fallback_date, o.fallback_date) as fallback_date -- 撤回时间
    ,nvl(n.fallback_content, o.fallback_content) as fallback_content -- 撤回备注
    ,nvl(n.call_sex, o.call_sex) as call_sex -- 来电人性别
    ,nvl(n.remark, o.remark) as remark -- 注意事项
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 开户行
    ,nvl(n.survey_handle_unit_first_code, o.survey_handle_unit_first_code) as survey_handle_unit_first_code -- 调查处理单位(一级机构)
    ,nvl(n.survey_handle_unit_first_name, o.survey_handle_unit_first_name) as survey_handle_unit_first_name -- 调查处理单位名称(一级机构)
    ,nvl(n.survey_handle_unit_sec_code, o.survey_handle_unit_sec_code) as survey_handle_unit_sec_code -- 调查处理单位(二级机构)
    ,nvl(n.survey_handle_unit_sec_name, o.survey_handle_unit_sec_name) as survey_handle_unit_sec_name -- 调查处理单位名称(二级机构)
    ,nvl(n.is_need_trans, o.is_need_trans) as is_need_trans -- 工单是否需要流转(0否1是)
    ,nvl(n.complain_date, o.complain_date) as complain_date -- 客户投诉时间
    ,nvl(n.risk_hidden, o.risk_hidden) as risk_hidden -- 薄弱环节/风险隐患
    ,nvl(n.is_supervise_org_trans, o.is_supervise_org_trans) as is_supervise_org_trans -- 是否监管部门转办
    ,nvl(n.supervise_org, o.supervise_org) as supervise_org -- 具体监管部门
    ,nvl(n.branch_begin_date, o.branch_begin_date) as branch_begin_date -- 分行开始处理时间
    ,nvl(n.branch_end_date, o.branch_end_date) as branch_end_date -- 分行处理结束时间
    ,nvl(n.workbill_from, o.workbill_from) as workbill_from -- 工单来源
    ,nvl(n.delete_remark, o.delete_remark) as delete_remark -- 删除备注
    ,nvl(n.read_status, o.read_status) as read_status -- 阅读状态
    ,nvl(n.complain_deal_remark, o.complain_deal_remark) as complain_deal_remark -- 调查处理情况
    ,nvl(n.is_solved, o.is_solved) as is_solved -- 是否化解(0否1是)
    ,nvl(n.is_upgrade, o.is_upgrade) as is_upgrade -- 是否升级(0否1是)
    ,nvl(n.is_skipgrade, o.is_skipgrade) as is_skipgrade -- 是否越级(0否1是)
    ,nvl(n.extend, o.extend) as extend -- 扩展
    ,case when
            n.workbill_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.workbill_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.workbill_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.csrs_uomp_workbill_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.csrs_uomp_workbill_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.workbill_no = n.workbill_no
where (
        o.workbill_no is null
    )
    or (
        n.workbill_no is null
    )
    or (
        o.workbill_type <> n.workbill_type
        or o.workbill_sub_type <> n.workbill_sub_type
        or o.work_sum_no <> n.work_sum_no
        or o.call_no <> n.call_no
        or o.call_type <> n.call_type
        or o.connection_id <> n.connection_id
        or o.creater_code <> n.creater_code
        or o.create_date <> n.create_date
        or o.workbill_level <> n.workbill_level
        or o.status <> n.status
        or o.workbill_status <> n.workbill_status
        or o.over_time <> n.over_time
        or o.over_org_code <> n.over_org_code
        or o.over_code <> n.over_code
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.cust_sex <> n.cust_sex
        or o.card_no <> n.card_no
        or o.card_type <> n.card_type
        or o.cust_phone <> n.cust_phone
        or o.cust_paper_id <> n.cust_paper_id
        or o.cust_paper_type <> n.cust_paper_type
        or o.cust_email <> n.cust_email
        or o.flow_code <> n.flow_code
        or o.event_type <> n.event_type
        or o.workbill_channel <> n.workbill_channel
        or o.dead_line_date <> n.dead_line_date
        or o.over_flag <> n.over_flag
        or o.creater_name <> n.creater_name
        or o.over_name <> n.over_name
        or o.call_name <> n.call_name
        or o.buss_type <> n.buss_type
        or o.buss_sub_type <> n.buss_sub_type
        or o.dev_condition <> n.dev_condition
        or o.device_no <> n.device_no
        or o.card_attach <> n.card_attach
        or o.workbill_content <> n.workbill_content
        or o.re_complain <> n.re_complain
        or o.complain <> n.complain
        or o.templ_code <> n.templ_code
        or o.node_code <> n.node_code
        or o.detail_code <> n.detail_code
        or o.org_code <> n.org_code
        or o.submit_code <> n.submit_code
        or o.submit_name <> n.submit_name
        or o.submit_date <> n.submit_date
        or o.mistake_sign <> n.mistake_sign
        or o.acct_name <> n.acct_name
        or o.org_name <> n.org_name
        or o.satisfied <> n.satisfied
        or o.complaintype_first <> n.complaintype_first
        or o.complaintype_sec <> n.complaintype_sec
        or o.complaintype_third <> n.complaintype_third
        or o.complaintype_first_name <> n.complaintype_first_name
        or o.complaintype_sec_name <> n.complaintype_sec_name
        or o.complaintype_third_name <> n.complaintype_third_name
        or o.complainchannel_first <> n.complainchannel_first
        or o.complainchannel_first_name <> n.complainchannel_first_name
        or o.complainchannel_sec <> n.complainchannel_sec
        or o.complainchannel_sec_name <> n.complainchannel_sec_name
        or o.complainchannel_third <> n.complainchannel_third
        or o.complainchannel_third_name <> n.complainchannel_third_name
        or o.complainreason_first <> n.complainreason_first
        or o.complainreason_first_name <> n.complainreason_first_name
        or o.complainreason_sec <> n.complainreason_sec
        or o.complainreason_sec_name <> n.complainreason_sec_name
        or o.return_visit_date <> n.return_visit_date
        or o.return_visit_content <> n.return_visit_content
        or o.fallback_status <> n.fallback_status
        or o.fallback_date <> n.fallback_date
        or o.fallback_content <> n.fallback_content
        or o.call_sex <> n.call_sex
        or o.remark <> n.remark
        or o.bank_name <> n.bank_name
        or o.survey_handle_unit_first_code <> n.survey_handle_unit_first_code
        or o.survey_handle_unit_first_name <> n.survey_handle_unit_first_name
        or o.survey_handle_unit_sec_code <> n.survey_handle_unit_sec_code
        or o.survey_handle_unit_sec_name <> n.survey_handle_unit_sec_name
        or o.is_need_trans <> n.is_need_trans
        or o.complain_date <> n.complain_date
        or o.risk_hidden <> n.risk_hidden
        or o.is_supervise_org_trans <> n.is_supervise_org_trans
        or o.supervise_org <> n.supervise_org
        or o.branch_begin_date <> n.branch_begin_date
        or o.branch_end_date <> n.branch_end_date
        or o.workbill_from <> n.workbill_from
        or o.delete_remark <> n.delete_remark
        or o.read_status <> n.read_status
        or o.complain_deal_remark <> n.complain_deal_remark
        or o.is_solved <> n.is_solved
        or o.is_upgrade <> n.is_upgrade
        or o.is_skipgrade <> n.is_skipgrade
        or o.extend <> n.extend
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.csrs_uomp_workbill_info_cl(
            workbill_no -- 主键，工单编号
            ,workbill_type -- 工单类型
            ,workbill_sub_type -- 工单子类型
            ,work_sum_no -- 来电小结编号
            ,call_no -- 来电号码
            ,call_type -- 呼叫类型
            ,connection_id -- 呼叫流水号
            ,creater_code -- 创建者empcode
            ,create_date -- 创建日期
            ,workbill_level -- 紧急程度
            ,status -- 数据状态
            ,workbill_status -- 工单状态(1-编辑 4-已重置 5-延期申请中 2-提交 3-办结 0-删除)
            ,over_time -- 最后归档时间
            ,over_org_code -- 最后归档机构code
            ,over_code -- 最后归档人empcode
            ,cust_no -- 客户号
            ,cust_name -- 联系人姓名
            ,cust_sex -- 联系人性别
            ,card_no -- 客户账号
            ,card_type -- 账户类型
            ,cust_phone -- 联系电话
            ,cust_paper_id -- 证件号
            ,cust_paper_type -- 证件类型
            ,cust_email -- 客户电子邮箱
            ,flow_code -- 绑定流程code
            ,event_type -- 事件类型
            ,workbill_channel -- 接入方式 来电、邮件
            ,dead_line_date -- 整个工单最后处理时限日
            ,over_flag -- 逾期标志(0逾期1正常办结工单不计逾期)
            ,creater_name -- 创建者empname
            ,over_name -- 最后归档人empname
            ,call_name -- 来电人姓名
            ,buss_type -- 业务类型
            ,buss_sub_type -- 业务明细
            ,dev_condition -- 机具情况
            ,device_no -- 机具设备号
            ,card_attach -- 卡种类
            ,workbill_content -- 受理内容
            ,re_complain -- 重复投诉(标志)
            ,complain -- 投诉认定
            ,templ_code -- 模板code
            ,node_code -- 当前节点code
            ,detail_code -- 当前流转code
            ,org_code -- 目标处理机构
            ,submit_code -- 提交人empcode
            ,submit_name -- 提交人empname
            ,submit_date -- 提交时间
            ,mistake_sign -- 是否差错工单(0否1是)
            ,acct_name -- 户主姓名
            ,org_name -- 目标处理机构
            ,satisfied -- 满意度
            ,complaintype_first -- 投诉分类一级
            ,complaintype_sec -- 投诉分类二级
            ,complaintype_third -- 投诉分类三级
            ,complaintype_first_name -- 投诉分类一级名称
            ,complaintype_sec_name -- 投诉分类二级名称
            ,complaintype_third_name -- 投诉分类三级名称
            ,complainchannel_first -- 投诉渠道一级
            ,complainchannel_first_name -- 投诉渠道一级名称
            ,complainchannel_sec -- 投诉渠道二级
            ,complainchannel_sec_name -- 投诉渠道二级名称
            ,complainchannel_third -- 投诉渠道三级
            ,complainchannel_third_name -- 投诉渠道三级名称
            ,complainreason_first -- 投诉原因一级
            ,complainreason_first_name -- 投诉原因一级名称
            ,complainreason_sec -- 投诉原因二级
            ,complainreason_sec_name -- 投诉原因二级名称
            ,return_visit_date -- 回访时间
            ,return_visit_content -- 回访内容
            ,fallback_status -- 是否撤回
            ,fallback_date -- 撤回时间
            ,fallback_content -- 撤回备注
            ,call_sex -- 来电人性别
            ,remark -- 注意事项
            ,bank_name -- 开户行
            ,survey_handle_unit_first_code -- 调查处理单位(一级机构)
            ,survey_handle_unit_first_name -- 调查处理单位名称(一级机构)
            ,survey_handle_unit_sec_code -- 调查处理单位(二级机构)
            ,survey_handle_unit_sec_name -- 调查处理单位名称(二级机构)
            ,is_need_trans -- 工单是否需要流转(0否1是)
            ,complain_date -- 客户投诉时间
            ,risk_hidden -- 薄弱环节/风险隐患
            ,is_supervise_org_trans -- 是否监管部门转办
            ,supervise_org -- 具体监管部门
            ,branch_begin_date -- 分行开始处理时间
            ,branch_end_date -- 分行处理结束时间
            ,workbill_from -- 工单来源
            ,delete_remark -- 删除备注
            ,read_status -- 阅读状态
            ,complain_deal_remark -- 调查处理情况
            ,is_solved -- 是否化解(0否1是)
            ,is_upgrade -- 是否升级(0否1是)
            ,is_skipgrade -- 是否越级(0否1是)
            ,extend -- 扩展
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.csrs_uomp_workbill_info_op(
            workbill_no -- 主键，工单编号
            ,workbill_type -- 工单类型
            ,workbill_sub_type -- 工单子类型
            ,work_sum_no -- 来电小结编号
            ,call_no -- 来电号码
            ,call_type -- 呼叫类型
            ,connection_id -- 呼叫流水号
            ,creater_code -- 创建者empcode
            ,create_date -- 创建日期
            ,workbill_level -- 紧急程度
            ,status -- 数据状态
            ,workbill_status -- 工单状态(1-编辑 4-已重置 5-延期申请中 2-提交 3-办结 0-删除)
            ,over_time -- 最后归档时间
            ,over_org_code -- 最后归档机构code
            ,over_code -- 最后归档人empcode
            ,cust_no -- 客户号
            ,cust_name -- 联系人姓名
            ,cust_sex -- 联系人性别
            ,card_no -- 客户账号
            ,card_type -- 账户类型
            ,cust_phone -- 联系电话
            ,cust_paper_id -- 证件号
            ,cust_paper_type -- 证件类型
            ,cust_email -- 客户电子邮箱
            ,flow_code -- 绑定流程code
            ,event_type -- 事件类型
            ,workbill_channel -- 接入方式 来电、邮件
            ,dead_line_date -- 整个工单最后处理时限日
            ,over_flag -- 逾期标志(0逾期1正常办结工单不计逾期)
            ,creater_name -- 创建者empname
            ,over_name -- 最后归档人empname
            ,call_name -- 来电人姓名
            ,buss_type -- 业务类型
            ,buss_sub_type -- 业务明细
            ,dev_condition -- 机具情况
            ,device_no -- 机具设备号
            ,card_attach -- 卡种类
            ,workbill_content -- 受理内容
            ,re_complain -- 重复投诉(标志)
            ,complain -- 投诉认定
            ,templ_code -- 模板code
            ,node_code -- 当前节点code
            ,detail_code -- 当前流转code
            ,org_code -- 目标处理机构
            ,submit_code -- 提交人empcode
            ,submit_name -- 提交人empname
            ,submit_date -- 提交时间
            ,mistake_sign -- 是否差错工单(0否1是)
            ,acct_name -- 户主姓名
            ,org_name -- 目标处理机构
            ,satisfied -- 满意度
            ,complaintype_first -- 投诉分类一级
            ,complaintype_sec -- 投诉分类二级
            ,complaintype_third -- 投诉分类三级
            ,complaintype_first_name -- 投诉分类一级名称
            ,complaintype_sec_name -- 投诉分类二级名称
            ,complaintype_third_name -- 投诉分类三级名称
            ,complainchannel_first -- 投诉渠道一级
            ,complainchannel_first_name -- 投诉渠道一级名称
            ,complainchannel_sec -- 投诉渠道二级
            ,complainchannel_sec_name -- 投诉渠道二级名称
            ,complainchannel_third -- 投诉渠道三级
            ,complainchannel_third_name -- 投诉渠道三级名称
            ,complainreason_first -- 投诉原因一级
            ,complainreason_first_name -- 投诉原因一级名称
            ,complainreason_sec -- 投诉原因二级
            ,complainreason_sec_name -- 投诉原因二级名称
            ,return_visit_date -- 回访时间
            ,return_visit_content -- 回访内容
            ,fallback_status -- 是否撤回
            ,fallback_date -- 撤回时间
            ,fallback_content -- 撤回备注
            ,call_sex -- 来电人性别
            ,remark -- 注意事项
            ,bank_name -- 开户行
            ,survey_handle_unit_first_code -- 调查处理单位(一级机构)
            ,survey_handle_unit_first_name -- 调查处理单位名称(一级机构)
            ,survey_handle_unit_sec_code -- 调查处理单位(二级机构)
            ,survey_handle_unit_sec_name -- 调查处理单位名称(二级机构)
            ,is_need_trans -- 工单是否需要流转(0否1是)
            ,complain_date -- 客户投诉时间
            ,risk_hidden -- 薄弱环节/风险隐患
            ,is_supervise_org_trans -- 是否监管部门转办
            ,supervise_org -- 具体监管部门
            ,branch_begin_date -- 分行开始处理时间
            ,branch_end_date -- 分行处理结束时间
            ,workbill_from -- 工单来源
            ,delete_remark -- 删除备注
            ,read_status -- 阅读状态
            ,complain_deal_remark -- 调查处理情况
            ,is_solved -- 是否化解(0否1是)
            ,is_upgrade -- 是否升级(0否1是)
            ,is_skipgrade -- 是否越级(0否1是)
            ,extend -- 扩展
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.workbill_no -- 主键，工单编号
    ,o.workbill_type -- 工单类型
    ,o.workbill_sub_type -- 工单子类型
    ,o.work_sum_no -- 来电小结编号
    ,o.call_no -- 来电号码
    ,o.call_type -- 呼叫类型
    ,o.connection_id -- 呼叫流水号
    ,o.creater_code -- 创建者empcode
    ,o.create_date -- 创建日期
    ,o.workbill_level -- 紧急程度
    ,o.status -- 数据状态
    ,o.workbill_status -- 工单状态(1-编辑 4-已重置 5-延期申请中 2-提交 3-办结 0-删除)
    ,o.over_time -- 最后归档时间
    ,o.over_org_code -- 最后归档机构code
    ,o.over_code -- 最后归档人empcode
    ,o.cust_no -- 客户号
    ,o.cust_name -- 联系人姓名
    ,o.cust_sex -- 联系人性别
    ,o.card_no -- 客户账号
    ,o.card_type -- 账户类型
    ,o.cust_phone -- 联系电话
    ,o.cust_paper_id -- 证件号
    ,o.cust_paper_type -- 证件类型
    ,o.cust_email -- 客户电子邮箱
    ,o.flow_code -- 绑定流程code
    ,o.event_type -- 事件类型
    ,o.workbill_channel -- 接入方式 来电、邮件
    ,o.dead_line_date -- 整个工单最后处理时限日
    ,o.over_flag -- 逾期标志(0逾期1正常办结工单不计逾期)
    ,o.creater_name -- 创建者empname
    ,o.over_name -- 最后归档人empname
    ,o.call_name -- 来电人姓名
    ,o.buss_type -- 业务类型
    ,o.buss_sub_type -- 业务明细
    ,o.dev_condition -- 机具情况
    ,o.device_no -- 机具设备号
    ,o.card_attach -- 卡种类
    ,o.workbill_content -- 受理内容
    ,o.re_complain -- 重复投诉(标志)
    ,o.complain -- 投诉认定
    ,o.templ_code -- 模板code
    ,o.node_code -- 当前节点code
    ,o.detail_code -- 当前流转code
    ,o.org_code -- 目标处理机构
    ,o.submit_code -- 提交人empcode
    ,o.submit_name -- 提交人empname
    ,o.submit_date -- 提交时间
    ,o.mistake_sign -- 是否差错工单(0否1是)
    ,o.acct_name -- 户主姓名
    ,o.org_name -- 目标处理机构
    ,o.satisfied -- 满意度
    ,o.complaintype_first -- 投诉分类一级
    ,o.complaintype_sec -- 投诉分类二级
    ,o.complaintype_third -- 投诉分类三级
    ,o.complaintype_first_name -- 投诉分类一级名称
    ,o.complaintype_sec_name -- 投诉分类二级名称
    ,o.complaintype_third_name -- 投诉分类三级名称
    ,o.complainchannel_first -- 投诉渠道一级
    ,o.complainchannel_first_name -- 投诉渠道一级名称
    ,o.complainchannel_sec -- 投诉渠道二级
    ,o.complainchannel_sec_name -- 投诉渠道二级名称
    ,o.complainchannel_third -- 投诉渠道三级
    ,o.complainchannel_third_name -- 投诉渠道三级名称
    ,o.complainreason_first -- 投诉原因一级
    ,o.complainreason_first_name -- 投诉原因一级名称
    ,o.complainreason_sec -- 投诉原因二级
    ,o.complainreason_sec_name -- 投诉原因二级名称
    ,o.return_visit_date -- 回访时间
    ,o.return_visit_content -- 回访内容
    ,o.fallback_status -- 是否撤回
    ,o.fallback_date -- 撤回时间
    ,o.fallback_content -- 撤回备注
    ,o.call_sex -- 来电人性别
    ,o.remark -- 注意事项
    ,o.bank_name -- 开户行
    ,o.survey_handle_unit_first_code -- 调查处理单位(一级机构)
    ,o.survey_handle_unit_first_name -- 调查处理单位名称(一级机构)
    ,o.survey_handle_unit_sec_code -- 调查处理单位(二级机构)
    ,o.survey_handle_unit_sec_name -- 调查处理单位名称(二级机构)
    ,o.is_need_trans -- 工单是否需要流转(0否1是)
    ,o.complain_date -- 客户投诉时间
    ,o.risk_hidden -- 薄弱环节/风险隐患
    ,o.is_supervise_org_trans -- 是否监管部门转办
    ,o.supervise_org -- 具体监管部门
    ,o.branch_begin_date -- 分行开始处理时间
    ,o.branch_end_date -- 分行处理结束时间
    ,o.workbill_from -- 工单来源
    ,o.delete_remark -- 删除备注
    ,o.read_status -- 阅读状态
    ,o.complain_deal_remark -- 调查处理情况
    ,o.is_solved -- 是否化解(0否1是)
    ,o.is_upgrade -- 是否升级(0否1是)
    ,o.is_skipgrade -- 是否越级(0否1是)
    ,o.extend -- 扩展
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
from ${iol_schema}.csrs_uomp_workbill_info_bk o
    left join ${iol_schema}.csrs_uomp_workbill_info_op n
        on
            o.workbill_no = n.workbill_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.csrs_uomp_workbill_info_cl d
        on
            o.workbill_no = d.workbill_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.csrs_uomp_workbill_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('csrs_uomp_workbill_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.csrs_uomp_workbill_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.csrs_uomp_workbill_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.csrs_uomp_workbill_info exchange partition p_${batch_date} with table ${iol_schema}.csrs_uomp_workbill_info_cl;
alter table ${iol_schema}.csrs_uomp_workbill_info exchange partition p_20991231 with table ${iol_schema}.csrs_uomp_workbill_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.csrs_uomp_workbill_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.csrs_uomp_workbill_info_op purge;
drop table ${iol_schema}.csrs_uomp_workbill_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.csrs_uomp_workbill_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'csrs_uomp_workbill_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
