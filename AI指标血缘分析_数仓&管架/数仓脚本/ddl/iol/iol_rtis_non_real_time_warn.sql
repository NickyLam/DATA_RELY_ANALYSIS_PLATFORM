/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_non_real_time_warn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_non_real_time_warn
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_non_real_time_warn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_non_real_time_warn(
    warn_id number(20) -- ID
    ,classify_id number(20) -- 预警分类ID
    ,oper_chnl varchar2(200) -- 操作时间
    ,early_warning_dimension varchar2(20) -- 预警维度
    ,order_mainstay_no varchar2(90) -- 交易主体号
    ,order_mainstay_name varchar2(255) -- 交易主体名
    ,warning_order_num number(22) -- 触发交易数
    ,risk_qualitative number(8) -- 风险定性（1有风险，2无风险）
    ,rate_level varchar2(10) -- 评级
    ,early_warning_frequency number(4) -- 预警频率
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,exp_time timestamp -- 过期时间
    ,collect_start_date date -- 汇总周期开始日期(包含该日期)
    ,collect_end_date date -- 汇总周期结束日期(包含该日期)
    ,trans_vol number(30) -- 交易金额
    ,risk_level number(16) -- 风险级别
    ,list_status number(8) -- 受理状态(0待处理、1处理中、2已完结、3待审核)
    ,oper_user_name varchar2(50) -- 操作类型 （注册-0登陆-1登出-2授信申请-3 绑卡-4 解绑-5 注销-6 提现-7 支付/消费-8 更改手机号-9）
    ,control varchar2(255) -- 管控
    ,list_strategy varchar2(300) -- 名单策略
    ,remark varchar2(600) -- 备注
    ,deal_dept varchar2(255) -- 处理机构
    ,deal_dept_name varchar2(255) -- 处理机构名称
    ,develop_dept varchar2(255) -- 运营机构
    ,develop_dept_name varchar2(255) -- 运营机构名称
    ,deal_dept_path varchar2(200) -- 处理路径
    ,develop_dept_path varchar2(200) -- 运营路径
    ,latest_handle_by varchar2(150) -- 最新受理人
    ,audit_by varchar2(150) -- 审核人
    ,data_source varchar2(150) -- 数据来源(0-系统，1-人工)
    ,task_id varchar2(64) -- activiti流程执行对应ID
    ,act_variable varchar2(4000) -- 流程变量信息
    ,approve_result varchar2(50) -- 审核结果(1:有风险，2：无风险)
    ,oper_ip_addr varchar2(128) -- 操作时间
    ,oper_city varchar2(128) -- 操作时间
    ,qua_type number(2) -- 确认有无风险类型：默认值为0；待确认、确认无风险->确认有风险，值为1；确认有风险->确认无风险，值为-1
    ,cust_id varchar2(20) -- 客户号
    ,trans_time timestamp -- 交易时间
    ,rule_code_num varchar2(30) -- 去重触发规则协查条数
    ,rule_code_str varchar2(4000) -- 触发规则编号
    ,isexamine number(2) -- 是否核查（1:是，0：否）
    ,account_organ varchar2(1000) -- 账户归属机构
    ,account_organ_id varchar2(50) -- 账户归属机构ID
    ,pro_inform_sources varchar2(30) -- 处理信息来源
    ,rule_code_e_num varchar2(30) -- 去重触发规则协查条数
    ,score varchar2(1000) -- 分数
    ,warnkey varchar2(4000) -- 预警key
    ,cust_type varchar2(20) -- 客户类型
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
grant select on ${iol_schema}.rtis_non_real_time_warn to ${iml_schema};
grant select on ${iol_schema}.rtis_non_real_time_warn to ${icl_schema};
grant select on ${iol_schema}.rtis_non_real_time_warn to ${idl_schema};
grant select on ${iol_schema}.rtis_non_real_time_warn to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_non_real_time_warn is '预警名单汇总';
comment on column ${iol_schema}.rtis_non_real_time_warn.warn_id is 'ID';
comment on column ${iol_schema}.rtis_non_real_time_warn.classify_id is '预警分类ID';
comment on column ${iol_schema}.rtis_non_real_time_warn.oper_chnl is '操作时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.early_warning_dimension is '预警维度';
comment on column ${iol_schema}.rtis_non_real_time_warn.order_mainstay_no is '交易主体号';
comment on column ${iol_schema}.rtis_non_real_time_warn.order_mainstay_name is '交易主体名';
comment on column ${iol_schema}.rtis_non_real_time_warn.warning_order_num is '触发交易数';
comment on column ${iol_schema}.rtis_non_real_time_warn.risk_qualitative is '风险定性（1有风险，2无风险）';
comment on column ${iol_schema}.rtis_non_real_time_warn.rate_level is '评级';
comment on column ${iol_schema}.rtis_non_real_time_warn.early_warning_frequency is '预警频率';
comment on column ${iol_schema}.rtis_non_real_time_warn.create_time is '创建时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.update_time is '更新时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.exp_time is '过期时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.collect_start_date is '汇总周期开始日期(包含该日期)';
comment on column ${iol_schema}.rtis_non_real_time_warn.collect_end_date is '汇总周期结束日期(包含该日期)';
comment on column ${iol_schema}.rtis_non_real_time_warn.trans_vol is '交易金额';
comment on column ${iol_schema}.rtis_non_real_time_warn.risk_level is '风险级别';
comment on column ${iol_schema}.rtis_non_real_time_warn.list_status is '受理状态(0待处理、1处理中、2已完结、3待审核)';
comment on column ${iol_schema}.rtis_non_real_time_warn.oper_user_name is '操作类型 （注册-0登陆-1登出-2授信申请-3 绑卡-4 解绑-5 注销-6 提现-7 支付/消费-8 更改手机号-9）';
comment on column ${iol_schema}.rtis_non_real_time_warn.control is '管控';
comment on column ${iol_schema}.rtis_non_real_time_warn.list_strategy is '名单策略';
comment on column ${iol_schema}.rtis_non_real_time_warn.remark is '备注';
comment on column ${iol_schema}.rtis_non_real_time_warn.deal_dept is '处理机构';
comment on column ${iol_schema}.rtis_non_real_time_warn.deal_dept_name is '处理机构名称';
comment on column ${iol_schema}.rtis_non_real_time_warn.develop_dept is '运营机构';
comment on column ${iol_schema}.rtis_non_real_time_warn.develop_dept_name is '运营机构名称';
comment on column ${iol_schema}.rtis_non_real_time_warn.deal_dept_path is '处理路径';
comment on column ${iol_schema}.rtis_non_real_time_warn.develop_dept_path is '运营路径';
comment on column ${iol_schema}.rtis_non_real_time_warn.latest_handle_by is '最新受理人';
comment on column ${iol_schema}.rtis_non_real_time_warn.audit_by is '审核人';
comment on column ${iol_schema}.rtis_non_real_time_warn.data_source is '数据来源(0-系统，1-人工)';
comment on column ${iol_schema}.rtis_non_real_time_warn.task_id is 'activiti流程执行对应ID';
comment on column ${iol_schema}.rtis_non_real_time_warn.act_variable is '流程变量信息';
comment on column ${iol_schema}.rtis_non_real_time_warn.approve_result is '审核结果(1:有风险，2：无风险)';
comment on column ${iol_schema}.rtis_non_real_time_warn.oper_ip_addr is '操作时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.oper_city is '操作时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.qua_type is '确认有无风险类型：默认值为0；待确认、确认无风险->确认有风险，值为1；确认有风险->确认无风险，值为-1';
comment on column ${iol_schema}.rtis_non_real_time_warn.cust_id is '客户号';
comment on column ${iol_schema}.rtis_non_real_time_warn.trans_time is '交易时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.rule_code_num is '去重触发规则协查条数';
comment on column ${iol_schema}.rtis_non_real_time_warn.rule_code_str is '触发规则编号';
comment on column ${iol_schema}.rtis_non_real_time_warn.isexamine is '是否核查（1:是，0：否）';
comment on column ${iol_schema}.rtis_non_real_time_warn.account_organ is '账户归属机构';
comment on column ${iol_schema}.rtis_non_real_time_warn.account_organ_id is '账户归属机构ID';
comment on column ${iol_schema}.rtis_non_real_time_warn.pro_inform_sources is '处理信息来源';
comment on column ${iol_schema}.rtis_non_real_time_warn.rule_code_e_num is '去重触发规则协查条数';
comment on column ${iol_schema}.rtis_non_real_time_warn.score is '分数';
comment on column ${iol_schema}.rtis_non_real_time_warn.warnkey is '预警key';
comment on column ${iol_schema}.rtis_non_real_time_warn.cust_type is '客户类型';
comment on column ${iol_schema}.rtis_non_real_time_warn.start_dt is '开始时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.end_dt is '结束时间';
comment on column ${iol_schema}.rtis_non_real_time_warn.id_mark is '增删标志';
comment on column ${iol_schema}.rtis_non_real_time_warn.etl_timestamp is 'ETL处理时间戳';
