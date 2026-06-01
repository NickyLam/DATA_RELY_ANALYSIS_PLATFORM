/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cchs_uomp_workbill_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cchs_uomp_workbill_info
whenever sqlerror continue none;
drop table ${iol_schema}.cchs_uomp_workbill_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cchs_uomp_workbill_info(
    workbill_no varchar2(40) -- 主键，工单编号
    ,workbill_type varchar2(4) -- 工单类型（参数配置）
    ,workbill_sub_type varchar2(4) -- 工单子类型（参数配置）
    ,work_sum_no varchar2(20) -- 来电小结编号
    ,call_no varchar2(20) -- 来电号码
    ,call_type varchar2(10) -- 呼叫类型（参数配置）
    ,connection_id varchar2(30) -- 呼叫流水号
    ,creater_code varchar2(20) -- 创建者EmpCode
    ,create_date date -- 创建日期
    ,workbill_level varchar2(4) -- 紧急程度（参数配置）
    ,status varchar2(4) -- 数据状态（参数配置）
    ,workbill_status varchar2(4) -- 工单状态（参数配置）
    ,over_time date -- 最后归档时间
    ,over_org_code varchar2(20) -- 最后归档机构Code
    ,over_code varchar2(20) -- 最后归档人EmpCode
    ,cust_no varchar2(20) -- 客户号
    ,cust_name varchar2(50) -- 联系人姓名
    ,cust_sex varchar2(4) -- 联系人性别(参数配置)
    ,card_no varchar2(30) -- 客户账号
    ,card_type varchar2(10) -- 账户类型（参数配置）
    ,cust_phone varchar2(20) -- 联系电话
    ,cust_paper_id varchar2(30) -- 证件号
    ,cust_paper_type varchar2(4) -- 证件类型(参数配置)
    ,cust_email varchar2(200) -- 客户电子邮箱
    ,flow_code varchar2(30) -- 绑定流程CODE
    ,event_type varchar2(4) -- 事件类型（参数配置）
    ,workbill_channel varchar2(4) -- 接入方式（参数配置）来电、邮件
    ,dead_line_date date -- 整个工单最后处理时限日
    ,over_flag varchar2(4) -- 逾期标志(0逾期1正常办结工单不计逾期)
    ,creater_name varchar2(50) -- 创建者EmpName
    ,over_name varchar2(50) -- 最后归档人EmpName
    ,call_name varchar2(50) -- 来电人姓名
    ,buss_type varchar2(4) -- 业务类型(参数配置)
    ,buss_sub_type varchar2(10) -- 业务明细(参数配置)
    ,dev_condition varchar2(4) -- 机具情况(参数配置)
    ,device_no varchar2(10) -- 机具设备号
    ,card_attach varchar2(4) -- 卡种类(参数配置)
    ,workbill_content varchar2(4000) -- 受理内容
    ,re_complain varchar2(4) -- 重复投诉(标志)
    ,complain varchar2(4) -- 投诉认定(参数配置)
    ,templ_code varchar2(30) -- 模板Code
    ,node_code varchar2(30) -- 当前节点CODE
    ,detail_code varchar2(30) -- 当前流转Code
    ,org_code varchar2(20) -- 目标处理机构
    ,submit_code varchar2(40) -- 提交人EmpCode
    ,submit_name varchar2(50) -- 提交人EmpName
    ,submit_date date -- 提交时间
    ,mistake_sign varchar2(4) -- 是否差错工单(0否1是)
    ,acct_name varchar2(100) -- 户主姓名
    ,org_name varchar2(100) -- 目标处理机构
    ,satisfied varchar2(5) -- 满意度
    ,complaintype_first varchar2(30) -- 投诉分类一级
    ,complaintype_sec varchar2(30) -- 投诉分类二级
    ,complaintype_third varchar2(30) -- 投诉分类三级
    ,complaintype_first_name varchar2(100) -- 投诉分类一级名称
    ,complaintype_sec_name varchar2(100) -- 投诉分类二级名称
    ,complaintype_third_name varchar2(100) -- 投诉分类三级名称
    ,complainchannel_first varchar2(30) -- 投诉渠道一级
    ,complainchannel_first_name varchar2(100) -- 投诉渠道一级名称
    ,complainchannel_sec varchar2(30) -- 投诉渠道二级
    ,complainchannel_sec_name varchar2(100) -- 投诉渠道二级名称
    ,complainchannel_third varchar2(30) -- 投诉渠道三级
    ,complainchannel_third_name varchar2(100) -- 投诉渠道三级名称
    ,complainreason_first varchar2(30) -- 投诉原因一级
    ,complainreason_first_name varchar2(100) -- 投诉原因一级名称
    ,complainreason_sec varchar2(30) -- 投诉原因二级
    ,complainreason_sec_name varchar2(100) -- 投诉原因二级名称
    ,return_visit_date varchar2(20) -- 回访时间
    ,return_visit_content varchar2(500) -- 回访内容
    ,fallback_status varchar2(5) -- 是否撤回
    ,fallback_date varchar2(20) -- 撤回时间
    ,fallback_content varchar2(500) -- 撤回备注
    ,call_sex varchar2(10) -- 来电人性别
    ,remark varchar2(1000) -- 注意事项
    ,bank_name varchar2(200) -- 开户行
    ,survey_handle_unit_first_code varchar2(20) -- 调查处理单位(一级机构)
    ,survey_handle_unit_first_name varchar2(100) -- 调查处理单位名称(一级机构)
    ,survey_handle_unit_sec_code varchar2(20) -- 调查处理单位(二级机构)
    ,survey_handle_unit_sec_name varchar2(100) -- 调查处理单位名称(二级机构)
    ,is_need_trans varchar2(4) -- 工单是否需要流转(0否1是)
    ,complain_date date -- 客户投诉时间
    ,risk_hidden varchar2(200) -- 薄弱环节/风险隐患
    ,is_supervise_org_trans varchar2(4) -- 是否监管部门转办
    ,supervise_org varchar2(40) -- 具体监管部门
    ,branch_begin_date date -- 分行开始处理时间
    ,branch_end_date date -- 分行处理结束时间
    ,workbill_from varchar2(10) -- 工单来源
    ,delete_remark varchar2(1000) -- 删除备注
    ,read_status varchar2(4) -- 阅读状态
    ,complain_deal_remark varchar2(1000) -- 调查处理情况
    ,is_trans varchar2(4) -- 是否转办(0否1是)-20230824弃用字段，与是否监管转办重复
    ,is_solved varchar2(4) -- 是否化解(0否1是)
    ,is_upgrade varchar2(4) -- 是否升级(0否1是)
    ,is_skipgrade varchar2(4) -- 是否越级(0否1是)
    ,extend varchar2(1000) -- 扩展
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cchs_uomp_workbill_info to ${iml_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_info to ${icl_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_info to ${idl_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.cchs_uomp_workbill_info is '投诉登记台账报表';
comment on column ${iol_schema}.cchs_uomp_workbill_info.workbill_no is '主键，工单编号';
comment on column ${iol_schema}.cchs_uomp_workbill_info.workbill_type is '工单类型（参数配置）';
comment on column ${iol_schema}.cchs_uomp_workbill_info.workbill_sub_type is '工单子类型（参数配置）';
comment on column ${iol_schema}.cchs_uomp_workbill_info.work_sum_no is '来电小结编号';
comment on column ${iol_schema}.cchs_uomp_workbill_info.call_no is '来电号码';
comment on column ${iol_schema}.cchs_uomp_workbill_info.call_type is '呼叫类型（参数配置）';
comment on column ${iol_schema}.cchs_uomp_workbill_info.connection_id is '呼叫流水号';
comment on column ${iol_schema}.cchs_uomp_workbill_info.creater_code is '创建者EmpCode';
comment on column ${iol_schema}.cchs_uomp_workbill_info.create_date is '创建日期';
comment on column ${iol_schema}.cchs_uomp_workbill_info.workbill_level is '紧急程度（参数配置）';
comment on column ${iol_schema}.cchs_uomp_workbill_info.status is '数据状态（参数配置）';
comment on column ${iol_schema}.cchs_uomp_workbill_info.workbill_status is '工单状态（参数配置）';
comment on column ${iol_schema}.cchs_uomp_workbill_info.over_time is '最后归档时间';
comment on column ${iol_schema}.cchs_uomp_workbill_info.over_org_code is '最后归档机构Code';
comment on column ${iol_schema}.cchs_uomp_workbill_info.over_code is '最后归档人EmpCode';
comment on column ${iol_schema}.cchs_uomp_workbill_info.cust_no is '客户号';
comment on column ${iol_schema}.cchs_uomp_workbill_info.cust_name is '联系人姓名';
comment on column ${iol_schema}.cchs_uomp_workbill_info.cust_sex is '联系人性别(参数配置)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.card_no is '客户账号';
comment on column ${iol_schema}.cchs_uomp_workbill_info.card_type is '账户类型（参数配置）';
comment on column ${iol_schema}.cchs_uomp_workbill_info.cust_phone is '联系电话';
comment on column ${iol_schema}.cchs_uomp_workbill_info.cust_paper_id is '证件号';
comment on column ${iol_schema}.cchs_uomp_workbill_info.cust_paper_type is '证件类型(参数配置)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.cust_email is '客户电子邮箱';
comment on column ${iol_schema}.cchs_uomp_workbill_info.flow_code is '绑定流程CODE';
comment on column ${iol_schema}.cchs_uomp_workbill_info.event_type is '事件类型（参数配置）';
comment on column ${iol_schema}.cchs_uomp_workbill_info.workbill_channel is '接入方式（参数配置）来电、邮件';
comment on column ${iol_schema}.cchs_uomp_workbill_info.dead_line_date is '整个工单最后处理时限日';
comment on column ${iol_schema}.cchs_uomp_workbill_info.over_flag is '逾期标志(0逾期1正常办结工单不计逾期)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.creater_name is '创建者EmpName';
comment on column ${iol_schema}.cchs_uomp_workbill_info.over_name is '最后归档人EmpName';
comment on column ${iol_schema}.cchs_uomp_workbill_info.call_name is '来电人姓名';
comment on column ${iol_schema}.cchs_uomp_workbill_info.buss_type is '业务类型(参数配置)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.buss_sub_type is '业务明细(参数配置)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.dev_condition is '机具情况(参数配置)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.device_no is '机具设备号';
comment on column ${iol_schema}.cchs_uomp_workbill_info.card_attach is '卡种类(参数配置)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.workbill_content is '受理内容';
comment on column ${iol_schema}.cchs_uomp_workbill_info.re_complain is '重复投诉(标志)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complain is '投诉认定(参数配置)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.templ_code is '模板Code';
comment on column ${iol_schema}.cchs_uomp_workbill_info.node_code is '当前节点CODE';
comment on column ${iol_schema}.cchs_uomp_workbill_info.detail_code is '当前流转Code';
comment on column ${iol_schema}.cchs_uomp_workbill_info.org_code is '目标处理机构';
comment on column ${iol_schema}.cchs_uomp_workbill_info.submit_code is '提交人EmpCode';
comment on column ${iol_schema}.cchs_uomp_workbill_info.submit_name is '提交人EmpName';
comment on column ${iol_schema}.cchs_uomp_workbill_info.submit_date is '提交时间';
comment on column ${iol_schema}.cchs_uomp_workbill_info.mistake_sign is '是否差错工单(0否1是)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.acct_name is '户主姓名';
comment on column ${iol_schema}.cchs_uomp_workbill_info.org_name is '目标处理机构';
comment on column ${iol_schema}.cchs_uomp_workbill_info.satisfied is '满意度';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complaintype_first is '投诉分类一级';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complaintype_sec is '投诉分类二级';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complaintype_third is '投诉分类三级';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complaintype_first_name is '投诉分类一级名称';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complaintype_sec_name is '投诉分类二级名称';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complaintype_third_name is '投诉分类三级名称';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainchannel_first is '投诉渠道一级';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainchannel_first_name is '投诉渠道一级名称';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainchannel_sec is '投诉渠道二级';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainchannel_sec_name is '投诉渠道二级名称';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainchannel_third is '投诉渠道三级';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainchannel_third_name is '投诉渠道三级名称';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainreason_first is '投诉原因一级';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainreason_first_name is '投诉原因一级名称';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainreason_sec is '投诉原因二级';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complainreason_sec_name is '投诉原因二级名称';
comment on column ${iol_schema}.cchs_uomp_workbill_info.return_visit_date is '回访时间';
comment on column ${iol_schema}.cchs_uomp_workbill_info.return_visit_content is '回访内容';
comment on column ${iol_schema}.cchs_uomp_workbill_info.fallback_status is '是否撤回';
comment on column ${iol_schema}.cchs_uomp_workbill_info.fallback_date is '撤回时间';
comment on column ${iol_schema}.cchs_uomp_workbill_info.fallback_content is '撤回备注';
comment on column ${iol_schema}.cchs_uomp_workbill_info.call_sex is '来电人性别';
comment on column ${iol_schema}.cchs_uomp_workbill_info.remark is '注意事项';
comment on column ${iol_schema}.cchs_uomp_workbill_info.bank_name is '开户行';
comment on column ${iol_schema}.cchs_uomp_workbill_info.survey_handle_unit_first_code is '调查处理单位(一级机构)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.survey_handle_unit_first_name is '调查处理单位名称(一级机构)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.survey_handle_unit_sec_code is '调查处理单位(二级机构)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.survey_handle_unit_sec_name is '调查处理单位名称(二级机构)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.is_need_trans is '工单是否需要流转(0否1是)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complain_date is '客户投诉时间';
comment on column ${iol_schema}.cchs_uomp_workbill_info.risk_hidden is '薄弱环节/风险隐患';
comment on column ${iol_schema}.cchs_uomp_workbill_info.is_supervise_org_trans is '是否监管部门转办';
comment on column ${iol_schema}.cchs_uomp_workbill_info.supervise_org is '具体监管部门';
comment on column ${iol_schema}.cchs_uomp_workbill_info.branch_begin_date is '分行开始处理时间';
comment on column ${iol_schema}.cchs_uomp_workbill_info.branch_end_date is '分行处理结束时间';
comment on column ${iol_schema}.cchs_uomp_workbill_info.workbill_from is '工单来源';
comment on column ${iol_schema}.cchs_uomp_workbill_info.delete_remark is '删除备注';
comment on column ${iol_schema}.cchs_uomp_workbill_info.read_status is '阅读状态';
comment on column ${iol_schema}.cchs_uomp_workbill_info.complain_deal_remark is '调查处理情况';
comment on column ${iol_schema}.cchs_uomp_workbill_info.is_trans is '是否转办(0否1是)-20230824弃用字段，与是否监管转办重复';
comment on column ${iol_schema}.cchs_uomp_workbill_info.is_solved is '是否化解(0否1是)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.is_upgrade is '是否升级(0否1是)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.is_skipgrade is '是否越级(0否1是)';
comment on column ${iol_schema}.cchs_uomp_workbill_info.extend is '扩展';
comment on column ${iol_schema}.cchs_uomp_workbill_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cchs_uomp_workbill_info.etl_timestamp is 'ETL处理时间戳';
