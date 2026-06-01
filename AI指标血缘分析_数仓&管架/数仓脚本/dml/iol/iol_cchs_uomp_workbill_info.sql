/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cchs_uomp_workbill_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cchs_uomp_workbill_info_ex purge;
alter table ${iol_schema}.cchs_uomp_workbill_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.cchs_uomp_workbill_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.cchs_uomp_workbill_info_ex nologging
compress
as
select * from ${iol_schema}.cchs_uomp_workbill_info where 0=1;

insert /*+ append */ into ${iol_schema}.cchs_uomp_workbill_info_ex(
    workbill_no -- 主键，工单编号
    ,workbill_type -- 工单类型（参数配置）
    ,workbill_sub_type -- 工单子类型（参数配置）
    ,work_sum_no -- 来电小结编号
    ,call_no -- 来电号码
    ,call_type -- 呼叫类型（参数配置）
    ,connection_id -- 呼叫流水号
    ,creater_code -- 创建者EmpCode
    ,create_date -- 创建日期
    ,workbill_level -- 紧急程度（参数配置）
    ,status -- 数据状态（参数配置）
    ,workbill_status -- 工单状态（参数配置）
    ,over_time -- 最后归档时间
    ,over_org_code -- 最后归档机构Code
    ,over_code -- 最后归档人EmpCode
    ,cust_no -- 客户号
    ,cust_name -- 联系人姓名
    ,cust_sex -- 联系人性别(参数配置)
    ,card_no -- 客户账号
    ,card_type -- 账户类型（参数配置）
    ,cust_phone -- 联系电话
    ,cust_paper_id -- 证件号
    ,cust_paper_type -- 证件类型(参数配置)
    ,cust_email -- 客户电子邮箱
    ,flow_code -- 绑定流程CODE
    ,event_type -- 事件类型（参数配置）
    ,workbill_channel -- 接入方式（参数配置）来电、邮件
    ,dead_line_date -- 整个工单最后处理时限日
    ,over_flag -- 逾期标志(0逾期1正常办结工单不计逾期)
    ,creater_name -- 创建者EmpName
    ,over_name -- 最后归档人EmpName
    ,call_name -- 来电人姓名
    ,buss_type -- 业务类型(参数配置)
    ,buss_sub_type -- 业务明细(参数配置)
    ,dev_condition -- 机具情况(参数配置)
    ,device_no -- 机具设备号
    ,card_attach -- 卡种类(参数配置)
    ,workbill_content -- 受理内容
    ,re_complain -- 重复投诉(标志)
    ,complain -- 投诉认定(参数配置)
    ,templ_code -- 模板Code
    ,node_code -- 当前节点CODE
    ,detail_code -- 当前流转Code
    ,org_code -- 目标处理机构
    ,submit_code -- 提交人EmpCode
    ,submit_name -- 提交人EmpName
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
    ,is_trans -- 是否转办(0否1是)-20230824弃用字段，与是否监管转办重复
    ,is_solved -- 是否化解(0否1是)
    ,is_upgrade -- 是否升级(0否1是)
    ,is_skipgrade -- 是否越级(0否1是)
    ,extend -- 扩展
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    workbill_no -- 主键，工单编号
    ,workbill_type -- 工单类型（参数配置）
    ,workbill_sub_type -- 工单子类型（参数配置）
    ,work_sum_no -- 来电小结编号
    ,call_no -- 来电号码
    ,call_type -- 呼叫类型（参数配置）
    ,connection_id -- 呼叫流水号
    ,creater_code -- 创建者EmpCode
    ,create_date -- 创建日期
    ,workbill_level -- 紧急程度（参数配置）
    ,status -- 数据状态（参数配置）
    ,workbill_status -- 工单状态（参数配置）
    ,over_time -- 最后归档时间
    ,over_org_code -- 最后归档机构Code
    ,over_code -- 最后归档人EmpCode
    ,cust_no -- 客户号
    ,cust_name -- 联系人姓名
    ,cust_sex -- 联系人性别(参数配置)
    ,card_no -- 客户账号
    ,card_type -- 账户类型（参数配置）
    ,cust_phone -- 联系电话
    ,cust_paper_id -- 证件号
    ,cust_paper_type -- 证件类型(参数配置)
    ,cust_email -- 客户电子邮箱
    ,flow_code -- 绑定流程CODE
    ,event_type -- 事件类型（参数配置）
    ,workbill_channel -- 接入方式（参数配置）来电、邮件
    ,dead_line_date -- 整个工单最后处理时限日
    ,over_flag -- 逾期标志(0逾期1正常办结工单不计逾期)
    ,creater_name -- 创建者EmpName
    ,over_name -- 最后归档人EmpName
    ,call_name -- 来电人姓名
    ,buss_type -- 业务类型(参数配置)
    ,buss_sub_type -- 业务明细(参数配置)
    ,dev_condition -- 机具情况(参数配置)
    ,device_no -- 机具设备号
    ,card_attach -- 卡种类(参数配置)
    ,workbill_content -- 受理内容
    ,re_complain -- 重复投诉(标志)
    ,complain -- 投诉认定(参数配置)
    ,templ_code -- 模板Code
    ,node_code -- 当前节点CODE
    ,detail_code -- 当前流转Code
    ,org_code -- 目标处理机构
    ,submit_code -- 提交人EmpCode
    ,submit_name -- 提交人EmpName
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
    ,is_trans -- 是否转办(0否1是)-20230824弃用字段，与是否监管转办重复
    ,is_solved -- 是否化解(0否1是)
    ,is_upgrade -- 是否升级(0否1是)
    ,is_skipgrade -- 是否越级(0否1是)
    ,extend -- 扩展
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cchs_uomp_workbill_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cchs_uomp_workbill_info exchange partition p_${batch_date} with table ${iol_schema}.cchs_uomp_workbill_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cchs_uomp_workbill_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cchs_uomp_workbill_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cchs_uomp_workbill_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);