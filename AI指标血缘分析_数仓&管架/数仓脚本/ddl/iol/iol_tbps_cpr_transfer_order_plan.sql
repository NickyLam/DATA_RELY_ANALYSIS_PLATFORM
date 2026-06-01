/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_transfer_order_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_transfer_order_plan
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_transfer_order_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_transfer_order_plan(
    top_orderno varchar2(50) -- 预约号
    ,top_trade_flowno varchar2(32) -- 流水号
    ,top_transdate varchar2(14) -- 计划制定日期
    ,top_timertype varchar2(1) -- 定时种类
    ,top_timerfreq varchar2(1) -- 定时频率种类
    ,top_timerrule varchar2(256) -- 定时或者定频规则
    ,top_state varchar2(1) -- 状态
    ,top_begindate varchar2(14) -- 定时或定频起始日期
    ,top_enddate varchar2(14) -- 结束日期
    ,top_canceldate varchar2(14) -- 取消日期
    ,top_ordertimes number(22) -- 定制执行次数
    ,top_exetimes number(22) -- 已执行次数
    ,top_bookingtype varchar2(1) -- 预定类型(a预约发工资b预约转账)
    ,top_cui_ecifno varchar2(32) -- 全行统一客户号
    ,top_cui_userno varchar2(32) -- 用户顺序号
    ,top_authtype varchar2(1) -- 认证方式
    ,top_transauthtype varchar2(1) -- 安全工具类型
    ,top_transtime varchar2(14) -- 交易时间
    ,top_suctimes number(22) -- 成功次数
    ,top_sucamt number(15,2) -- 成功金额
    ,top_failtimes number(22) -- 失败次数
    ,top_failamt number(15,2) -- 失败金额
    ,top_remaintimes number(22) -- 未执行次数
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_transfer_order_plan to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_transfer_order_plan to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_transfer_order_plan to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_transfer_order_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_transfer_order_plan is '预约转账计划表';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_orderno is '预约号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_trade_flowno is '流水号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_transdate is '计划制定日期';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_timertype is '定时种类';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_timerfreq is '定时频率种类';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_timerrule is '定时或者定频规则';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_state is '状态';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_begindate is '定时或定频起始日期';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_enddate is '结束日期';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_canceldate is '取消日期';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_ordertimes is '定制执行次数';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_exetimes is '已执行次数';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_bookingtype is '预定类型(a预约发工资b预约转账)';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_cui_ecifno is '全行统一客户号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_cui_userno is '用户顺序号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_authtype is '认证方式';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_transauthtype is '安全工具类型';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_transtime is '交易时间';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_suctimes is '成功次数';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_sucamt is '成功金额';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_failtimes is '失败次数';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_failamt is '失败金额';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.top_remaintimes is '未执行次数';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_transfer_order_plan.etl_timestamp is 'ETL处理时间戳';
