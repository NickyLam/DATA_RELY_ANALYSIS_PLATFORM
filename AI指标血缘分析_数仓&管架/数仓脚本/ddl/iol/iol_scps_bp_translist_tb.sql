/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_translist_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_translist_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_translist_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_translist_tb(
    task_id varchar2(50) -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
    ,subtask_id varchar2(50) -- 子任务号(事后补扫，Pad端，影像补扫)
    ,tradecode varchar2(18) -- 交易码
    ,scene_code varchar2(20) -- 业务场景id
    ,begin_userno varchar2(10) -- 发起柜员
    ,begin_orgno varchar2(10) -- 发起机构
    ,trans_time varchar2(6) -- 交易时间(HHmmss)
    ,trans_date date -- 交易日期(yyyyMMdd)
    ,doc_id varchar2(64) -- 影像流水号
    ,bank_no varchar2(10) -- 银行号
    ,system_no varchar2(10) -- 系统编号
    ,task_state varchar2(2) -- 01-处理中、02-已成功、03-已终止、04-异常状态、05-已回退
    ,account_no varchar2(100) -- 本行账号
    ,account_name varchar2(200) -- 本行名称
    ,end_time varchar2(21) -- 结束时间
    ,end_date date -- 结束日期
    ,adjust_priority varchar2(2) -- 业务处理中心
    ,mode_type varchar2(4) -- 作业模式 1-集中作业；2-远程授权
    ,amount number(20,4) -- 金额
    ,glob_scan_no varchar2(33) -- 全局流水号
    ,cust_no varchar2(150) -- 客户号
    ,operation_status varchar2(8) -- 问题发起端，01-回退，02-终止，03-拒绝，04-事中补扫，05-事后补扫
    ,y_task_id varchar2(50) -- 原任务号(重提交易)
    ,channel_id varchar2(10) -- 渠道id
    ,trans_type varchar2(10) -- 业务大类
    ,drawee_acct_no varchar2(50) -- 交易对手账号
    ,draw_name varchar2(200) -- 付款人名称
    ,payee_acct_no varchar2(50) -- 收款人账号
    ,payee_name varchar2(200) -- 收款人名称
    ,acct_date varchar2(14) -- 记账日期(如果跟结束日期一样的话，就一样)
    ,acct_time varchar2(21) -- 记账时间(如果跟结束时间一样的话，就一样)
    ,point_bitmap varchar2(100) -- 优先级位图
    ,priority varchar2(5) -- 优先级分数
    ,refusal_reason varchar2(500) -- 原因
    ,sqzg_userno varchar2(64) -- 授权主管号（本地授权或者远程授权的用户号）
    ,trans_subclass varchar2(64) -- 交易子类
    ,tally_flow_no varchar2(64) -- 记账流水
    ,model_code varchar2(10) -- 影像模型
    ,busi_start_date varchar2(16) -- 影像上传时间
    ,business_serial varchar2(64) -- 业务流水
    ,opidtype varchar2(12) -- 证件类型
    ,opidno varchar2(32) -- 证件号码
    ,reason_for_termination varchar2(1024) -- 终止原因（显示回退或终止的原因具体信息）
    ,remark varchar2(1024) -- 备注
    ,cust_name varchar2(200) -- 客户名称
    ,back_reason varchar2(1024) -- 回退原因
    ,back_remark varchar2(1024) -- 回退备注
    ,center_no varchar2(10) -- 中心号
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
grant select on ${iol_schema}.scps_bp_translist_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_translist_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_translist_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_translist_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_translist_tb is '业务流水表';
comment on column ${iol_schema}.scps_bp_translist_tb.task_id is '任务号(集中作业取ESC订单号，远程授权放授权任务号)';
comment on column ${iol_schema}.scps_bp_translist_tb.subtask_id is '子任务号(事后补扫，Pad端，影像补扫)';
comment on column ${iol_schema}.scps_bp_translist_tb.tradecode is '交易码';
comment on column ${iol_schema}.scps_bp_translist_tb.scene_code is '业务场景id';
comment on column ${iol_schema}.scps_bp_translist_tb.begin_userno is '发起柜员';
comment on column ${iol_schema}.scps_bp_translist_tb.begin_orgno is '发起机构';
comment on column ${iol_schema}.scps_bp_translist_tb.trans_time is '交易时间(HHmmss)';
comment on column ${iol_schema}.scps_bp_translist_tb.trans_date is '交易日期(yyyyMMdd)';
comment on column ${iol_schema}.scps_bp_translist_tb.doc_id is '影像流水号';
comment on column ${iol_schema}.scps_bp_translist_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_bp_translist_tb.system_no is '系统编号';
comment on column ${iol_schema}.scps_bp_translist_tb.task_state is '01-处理中、02-已成功、03-已终止、04-异常状态、05-已回退';
comment on column ${iol_schema}.scps_bp_translist_tb.account_no is '本行账号';
comment on column ${iol_schema}.scps_bp_translist_tb.account_name is '本行名称';
comment on column ${iol_schema}.scps_bp_translist_tb.end_time is '结束时间';
comment on column ${iol_schema}.scps_bp_translist_tb.end_date is '结束日期';
comment on column ${iol_schema}.scps_bp_translist_tb.adjust_priority is '业务处理中心';
comment on column ${iol_schema}.scps_bp_translist_tb.mode_type is '作业模式 1-集中作业；2-远程授权';
comment on column ${iol_schema}.scps_bp_translist_tb.amount is '金额';
comment on column ${iol_schema}.scps_bp_translist_tb.glob_scan_no is '全局流水号';
comment on column ${iol_schema}.scps_bp_translist_tb.cust_no is '客户号';
comment on column ${iol_schema}.scps_bp_translist_tb.operation_status is '问题发起端，01-回退，02-终止，03-拒绝，04-事中补扫，05-事后补扫';
comment on column ${iol_schema}.scps_bp_translist_tb.y_task_id is '原任务号(重提交易)';
comment on column ${iol_schema}.scps_bp_translist_tb.channel_id is '渠道id';
comment on column ${iol_schema}.scps_bp_translist_tb.trans_type is '业务大类';
comment on column ${iol_schema}.scps_bp_translist_tb.drawee_acct_no is '交易对手账号';
comment on column ${iol_schema}.scps_bp_translist_tb.draw_name is '付款人名称';
comment on column ${iol_schema}.scps_bp_translist_tb.payee_acct_no is '收款人账号';
comment on column ${iol_schema}.scps_bp_translist_tb.payee_name is '收款人名称';
comment on column ${iol_schema}.scps_bp_translist_tb.acct_date is '记账日期(如果跟结束日期一样的话，就一样)';
comment on column ${iol_schema}.scps_bp_translist_tb.acct_time is '记账时间(如果跟结束时间一样的话，就一样)';
comment on column ${iol_schema}.scps_bp_translist_tb.point_bitmap is '优先级位图';
comment on column ${iol_schema}.scps_bp_translist_tb.priority is '优先级分数';
comment on column ${iol_schema}.scps_bp_translist_tb.refusal_reason is '原因';
comment on column ${iol_schema}.scps_bp_translist_tb.sqzg_userno is '授权主管号（本地授权或者远程授权的用户号）';
comment on column ${iol_schema}.scps_bp_translist_tb.trans_subclass is '交易子类';
comment on column ${iol_schema}.scps_bp_translist_tb.tally_flow_no is '记账流水';
comment on column ${iol_schema}.scps_bp_translist_tb.model_code is '影像模型';
comment on column ${iol_schema}.scps_bp_translist_tb.busi_start_date is '影像上传时间';
comment on column ${iol_schema}.scps_bp_translist_tb.business_serial is '业务流水';
comment on column ${iol_schema}.scps_bp_translist_tb.opidtype is '证件类型';
comment on column ${iol_schema}.scps_bp_translist_tb.opidno is '证件号码';
comment on column ${iol_schema}.scps_bp_translist_tb.reason_for_termination is '终止原因（显示回退或终止的原因具体信息）';
comment on column ${iol_schema}.scps_bp_translist_tb.remark is '备注';
comment on column ${iol_schema}.scps_bp_translist_tb.cust_name is '客户名称';
comment on column ${iol_schema}.scps_bp_translist_tb.back_reason is '回退原因';
comment on column ${iol_schema}.scps_bp_translist_tb.back_remark is '回退备注';
comment on column ${iol_schema}.scps_bp_translist_tb.center_no is '中心号';
comment on column ${iol_schema}.scps_bp_translist_tb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.scps_bp_translist_tb.etl_timestamp is 'ETL处理时间戳';
