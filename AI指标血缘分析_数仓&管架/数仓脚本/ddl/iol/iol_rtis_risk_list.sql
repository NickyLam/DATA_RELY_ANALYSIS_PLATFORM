/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_risk_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_risk_list
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_risk_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_risk_list(
    list_id number(20) -- 风险触发记录列表ID
    ,order_id varchar2(64) -- 交易单号
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,trans_time timestamp -- 交易时间
    ,trans_vol number(18) -- 交易金额
    ,risk_level number(16) -- 风险级别
    ,list_status number(8) -- 受理状态(0待处理、1处理中、2已处理)
    ,oper_user_name varchar2(50) -- 操作者
    ,verifi_strategy varchar2(255) -- 验证策略
    ,notify_strategy varchar2(255) -- 通知策略
    ,score number(8) -- 分值
    ,risk_flag_times number(8) -- 确认有风险次数
    ,riskless_flag_times number(8) -- 确认无风险次数
    ,pay_user_id varchar2(128) -- 付款账号
    ,rec_user_id varchar2(128) -- 收款账户，没有则默认为商户号
    ,biz_code varchar2(200) -- 业务类型(代码)
    ,pay_user_name varchar2(200) -- 支付方用户姓名
    ,rec_user_name varchar2(200) -- 商户名
    ,risk_type varchar2(4000) -- 风险类型
    ,rule_code varchar2(4000) -- 规则编码
    ,risk_qualitative number(8) -- 风险定性（1有风险，2无风险）
    ,oper_ip varchar2(255) -- 操作用户
    ,oper_ip_addr varchar2(128) -- 操作人
    ,gps_info varchar2(255) -- GPS地址
    ,base_station_info varchar2(255) -- 基站地址
    ,succ_control varchar2(128) -- 成功管控
    ,finger_print varchar2(200) -- 设备指纹
    ,oper_chnl varchar2(200) -- 标记人员
    ,develop_dept varchar2(255) -- 运营机构
    ,deal_dept varchar2(255) -- 处理机构
    ,order_status varchar2(2) -- 交易状态：0-成功，1-失败，2-可疑
    ,merchant_id varchar2(50) -- 商户号
    ,id_card_number varchar2(200) -- 身份证号
    ,mobile_number varchar2(200) -- 手机号
    ,list_strategy varchar2(300) -- 名单策略
    ,oper_city varchar2(128) -- 操作用户
    ,merchant_name varchar2(200) -- 商户名称
    ,cust_id varchar2(20) -- 客户号
    ,warn_id number(22) -- 预警ID
    ,verify_code varchar2(100) -- 验证策略编码
    ,rule_count number(16) -- 触发规则数量
    ,account_organ varchar2(1000) -- 账户归属机构
    ,account_organ_id varchar2(30) -- 账户归属机构ID
    ,trade_remarks varchar2(2000) -- 交易备注
    ,trade_purpose varchar2(2000) -- 交易用途
    ,rec_bank_name varchar2(1000) -- 对手账户行名称
    ,trade_channel varchar2(1000) -- 交易渠道信息
    ,trans_data varchar2(20) -- 交易日期
    ,cust_type varchar2(20) -- 客户类型
    ,aum_m_avg_bal number(36) -- AUM月均值
    ,model_type varchar2(400) -- 模型类型
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
grant select on ${iol_schema}.rtis_risk_list to ${iml_schema};
grant select on ${iol_schema}.rtis_risk_list to ${icl_schema};
grant select on ${iol_schema}.rtis_risk_list to ${idl_schema};
grant select on ${iol_schema}.rtis_risk_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_risk_list is '风控风险信息表';
comment on column ${iol_schema}.rtis_risk_list.list_id is '风险触发记录列表ID';
comment on column ${iol_schema}.rtis_risk_list.order_id is '交易单号';
comment on column ${iol_schema}.rtis_risk_list.create_time is '创建时间';
comment on column ${iol_schema}.rtis_risk_list.update_time is '更新时间';
comment on column ${iol_schema}.rtis_risk_list.trans_time is '交易时间';
comment on column ${iol_schema}.rtis_risk_list.trans_vol is '交易金额';
comment on column ${iol_schema}.rtis_risk_list.risk_level is '风险级别';
comment on column ${iol_schema}.rtis_risk_list.list_status is '受理状态(0待处理、1处理中、2已处理)';
comment on column ${iol_schema}.rtis_risk_list.oper_user_name is '操作者';
comment on column ${iol_schema}.rtis_risk_list.verifi_strategy is '验证策略';
comment on column ${iol_schema}.rtis_risk_list.notify_strategy is '通知策略';
comment on column ${iol_schema}.rtis_risk_list.score is '分值';
comment on column ${iol_schema}.rtis_risk_list.risk_flag_times is '确认有风险次数';
comment on column ${iol_schema}.rtis_risk_list.riskless_flag_times is '确认无风险次数';
comment on column ${iol_schema}.rtis_risk_list.pay_user_id is '付款账号';
comment on column ${iol_schema}.rtis_risk_list.rec_user_id is '收款账户，没有则默认为商户号';
comment on column ${iol_schema}.rtis_risk_list.biz_code is '业务类型(代码)';
comment on column ${iol_schema}.rtis_risk_list.pay_user_name is '支付方用户姓名';
comment on column ${iol_schema}.rtis_risk_list.rec_user_name is '商户名';
comment on column ${iol_schema}.rtis_risk_list.risk_type is '风险类型';
comment on column ${iol_schema}.rtis_risk_list.rule_code is '规则编码';
comment on column ${iol_schema}.rtis_risk_list.risk_qualitative is '风险定性（1有风险，2无风险）';
comment on column ${iol_schema}.rtis_risk_list.oper_ip is '操作用户';
comment on column ${iol_schema}.rtis_risk_list.oper_ip_addr is '操作人';
comment on column ${iol_schema}.rtis_risk_list.gps_info is 'GPS地址';
comment on column ${iol_schema}.rtis_risk_list.base_station_info is '基站地址';
comment on column ${iol_schema}.rtis_risk_list.succ_control is '成功管控';
comment on column ${iol_schema}.rtis_risk_list.finger_print is '设备指纹';
comment on column ${iol_schema}.rtis_risk_list.oper_chnl is '标记人员';
comment on column ${iol_schema}.rtis_risk_list.develop_dept is '运营机构';
comment on column ${iol_schema}.rtis_risk_list.deal_dept is '处理机构';
comment on column ${iol_schema}.rtis_risk_list.order_status is '交易状态：0-成功，1-失败，2-可疑';
comment on column ${iol_schema}.rtis_risk_list.merchant_id is '商户号';
comment on column ${iol_schema}.rtis_risk_list.id_card_number is '身份证号';
comment on column ${iol_schema}.rtis_risk_list.mobile_number is '手机号';
comment on column ${iol_schema}.rtis_risk_list.list_strategy is '名单策略';
comment on column ${iol_schema}.rtis_risk_list.oper_city is '操作用户';
comment on column ${iol_schema}.rtis_risk_list.merchant_name is '商户名称';
comment on column ${iol_schema}.rtis_risk_list.cust_id is '客户号';
comment on column ${iol_schema}.rtis_risk_list.warn_id is '预警ID';
comment on column ${iol_schema}.rtis_risk_list.verify_code is '验证策略编码';
comment on column ${iol_schema}.rtis_risk_list.rule_count is '触发规则数量';
comment on column ${iol_schema}.rtis_risk_list.account_organ is '账户归属机构';
comment on column ${iol_schema}.rtis_risk_list.account_organ_id is '账户归属机构ID';
comment on column ${iol_schema}.rtis_risk_list.trade_remarks is '交易备注';
comment on column ${iol_schema}.rtis_risk_list.trade_purpose is '交易用途';
comment on column ${iol_schema}.rtis_risk_list.rec_bank_name is '对手账户行名称';
comment on column ${iol_schema}.rtis_risk_list.trade_channel is '交易渠道信息';
comment on column ${iol_schema}.rtis_risk_list.trans_data is '交易日期';
comment on column ${iol_schema}.rtis_risk_list.cust_type is '客户类型';
comment on column ${iol_schema}.rtis_risk_list.aum_m_avg_bal is 'AUM月均值';
comment on column ${iol_schema}.rtis_risk_list.model_type is '模型类型';
comment on column ${iol_schema}.rtis_risk_list.start_dt is '开始时间';
comment on column ${iol_schema}.rtis_risk_list.end_dt is '结束时间';
comment on column ${iol_schema}.rtis_risk_list.id_mark is '增删标志';
comment on column ${iol_schema}.rtis_risk_list.etl_timestamp is 'ETL处理时间戳';
