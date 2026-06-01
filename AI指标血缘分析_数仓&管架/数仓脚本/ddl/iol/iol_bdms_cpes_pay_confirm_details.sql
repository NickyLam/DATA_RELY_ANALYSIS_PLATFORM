/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_pay_confirm_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_pay_confirm_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_pay_confirm_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_pay_confirm_details(
    id varchar2(60) -- 
    ,contract_id varchar2(60) -- 批次表ID
    ,draft_id varchar2(60) -- 票据表ID
    ,apply_id varchar2(60) -- 解析表ID
    ,apply_date varchar2(12) -- 业务申请日期
    ,draft_amount number(18,2) -- 票面金额
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,refuse_reason varchar2(6) -- 拒绝原因： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
    ,deal_status varchar2(3) -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,sig_mk varchar2(6) -- 应答标识： SU00 同意 SU01 拒绝
    ,err_code varchar2(30) -- 错误码
    ,err_mesg varchar2(384) -- 错误原因
    ,last_upd_opr varchar2(15) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(384) -- 备注
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
grant select on ${iol_schema}.bdms_cpes_pay_confirm_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_pay_confirm_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_pay_confirm_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_pay_confirm_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_pay_confirm_details is '付款确认批次明细信息表';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.id is '';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.contract_id is '批次表ID';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.apply_id is '解析表ID';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.apply_date is '业务申请日期';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.refuse_reason is '拒绝原因： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.deal_status is '处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.sig_mk is '应答标识： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.err_mesg is '错误原因';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_pay_confirm_details.etl_timestamp is 'ETL处理时间戳';
