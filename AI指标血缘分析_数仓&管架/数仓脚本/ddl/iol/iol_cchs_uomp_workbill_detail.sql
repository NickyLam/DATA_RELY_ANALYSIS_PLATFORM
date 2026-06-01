/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cchs_uomp_workbill_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cchs_uomp_workbill_detail
whenever sqlerror continue none;
drop table ${iol_schema}.cchs_uomp_workbill_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cchs_uomp_workbill_detail(
    code varchar2(40) -- 流水号 YYYYMMDDhhmmss+随机数
    ,workbill_no varchar2(30) -- 工单编号
    ,workbill_type varchar2(4) -- 工单类型
    ,workbill_sub_type varchar2(4) -- 子工单类型
    ,deal_node_code varchar2(30) -- 当前节点编号
    ,next_node_code varchar2(30) -- 下一节点编号
    ,prev_node_code varchar2(30) -- 上一节点编号
    ,prev_org_code varchar2(20) -- 上一处理机构Code
    ,prev_emp_code varchar2(20) -- 上一处理人工号
    ,deal_org_code varchar2(20) -- 当前节点处理机构Code
    ,deal_emp_code varchar2(20) -- 当前节点处理人工号
    ,deal_content varchar2(3700) -- 处理正文
    ,reason varchar2(50) -- 节点流转原因
    ,deal_date date -- 当前节点处理时间
    ,last_deal_date date -- 预计回复日期
    ,is_late_flag varchar2(4) -- 是否逾期标识0逾期1正常
    ,prev_emp_name varchar2(50) -- 上一处理人姓名
    ,deal_emp_name varchar2(50) -- 当前节点处理人姓名
    ,next_org_code varchar2(20) -- 下一节点处理机构Code
    ,accept_date date -- 当前节点受理时间
    ,deal_node_name varchar2(30) -- 当前节点名称
    ,workbill_status varchar2(4) -- 工单当前状态(参数配置)
    ,deal_org_name varchar2(100) -- 当前节点处理机构Name
    ,init_date date -- 当前节点初始时间(上一节点结束时间)
    ,complain varchar2(10) -- 是否有责
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
grant select on ${iol_schema}.cchs_uomp_workbill_detail to ${iml_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_detail to ${icl_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_detail to ${idl_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.cchs_uomp_workbill_detail is '工单运作信息表';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.code is '流水号 YYYYMMDDhhmmss+随机数';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.workbill_no is '工单编号';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.workbill_type is '工单类型';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.workbill_sub_type is '子工单类型';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.deal_node_code is '当前节点编号';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.next_node_code is '下一节点编号';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.prev_node_code is '上一节点编号';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.prev_org_code is '上一处理机构Code';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.prev_emp_code is '上一处理人工号';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.deal_org_code is '当前节点处理机构Code';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.deal_emp_code is '当前节点处理人工号';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.deal_content is '处理正文';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.reason is '节点流转原因';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.deal_date is '当前节点处理时间';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.last_deal_date is '预计回复日期';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.is_late_flag is '是否逾期标识0逾期1正常';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.prev_emp_name is '上一处理人姓名';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.deal_emp_name is '当前节点处理人姓名';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.next_org_code is '下一节点处理机构Code';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.accept_date is '当前节点受理时间';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.deal_node_name is '当前节点名称';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.workbill_status is '工单当前状态(参数配置)';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.deal_org_name is '当前节点处理机构Name';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.init_date is '当前节点初始时间(上一节点结束时间)';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.complain is '是否有责';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cchs_uomp_workbill_detail.etl_timestamp is 'ETL处理时间戳';
