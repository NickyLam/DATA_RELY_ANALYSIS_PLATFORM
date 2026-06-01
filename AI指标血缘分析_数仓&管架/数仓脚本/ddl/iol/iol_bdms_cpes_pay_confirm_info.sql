/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_pay_confirm_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_pay_confirm_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_pay_confirm_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_pay_confirm_info(
    id varchar2(60) -- 
    ,top_branch_no varchar2(15) -- 总行机构号
    ,branch_no varchar2(15) -- 业务机构号
    ,product_no varchar2(12) -- 产品号
    ,buss_flag varchar2(3) -- 交易方向标识： 01 申请 02 签收
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,apply_date varchar2(12) -- 申请日期
    ,pay_confirm_name varchar2(180) -- 交易对手名称
    ,pay_confirm_brh_no varchar2(14) -- 交易对手机构代码
    ,pay_confirm_acct_no varchar2(48) -- 交易对手账号
    ,pay_confirm_address varchar2(384) -- 交易对手地址
    ,pay_confirm_type varchar2(6) -- 付款确认类型： VM01 影像验证 VM02 实物验证
    ,pay_confirm_add_type varchar2(6) -- 付款确认申请类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
    ,conf_pay_apv_opi varchar2(900) -- 付款确认审批意见
    ,draft_id varchar2(60) -- 票据ID
    ,apply_id varchar2(60) -- 任务池表ID
    ,sign_mk varchar2(6) -- 签收标识： SU00 同意 SU01 拒绝
    ,sign_date varchar2(12) -- 签收日期
    ,refuse_reason varchar2(6) -- 拒绝原因代码： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,ems_no varchar2(90) -- EMS编号
    ,deal_status varchar2(3) -- 处理状态： 00 无效 01 未检查完成 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
    ,message_status varchar2(3) -- 报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,err_code varchar2(14) -- 错误码
    ,err_msg varchar2(384) -- 错误信息
    ,last_upd_opr varchar2(45) -- 最后操作员号
    ,last_upd_time varchar2(21) -- 最后操作时间
    ,misc varchar2(675) -- 备注域
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
grant select on ${iol_schema}.bdms_cpes_pay_confirm_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_pay_confirm_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_pay_confirm_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_pay_confirm_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_pay_confirm_info is '付款确认业务表';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.id is '';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.buss_flag is '交易方向标识： 01 申请 02 签收';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.apply_date is '申请日期';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.pay_confirm_name is '交易对手名称';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.pay_confirm_brh_no is '交易对手机构代码';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.pay_confirm_acct_no is '交易对手账号';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.pay_confirm_address is '交易对手地址';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.pay_confirm_type is '付款确认类型： VM01 影像验证 VM02 实物验证';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.pay_confirm_add_type is '付款确认申请类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.conf_pay_apv_opi is '付款确认审批意见';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.apply_id is '任务池表ID';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.sign_mk is '签收标识： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.sign_date is '签收日期';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.refuse_reason is '拒绝原因代码： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.ems_no is 'EMS编号';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.deal_status is '处理状态： 00 无效 01 未检查完成 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.message_status is '报文处理状态： 00 未处理 01 已发送申请报文 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 12 已发送签收收到人行确认成功 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 66 已生成对话报价（意向询价使用）';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.err_msg is '错误信息';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.last_upd_opr is '最后操作员号';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.last_upd_time is '最后操作时间';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.misc is '备注域';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_info.etl_timestamp is 'ETL处理时间戳';
