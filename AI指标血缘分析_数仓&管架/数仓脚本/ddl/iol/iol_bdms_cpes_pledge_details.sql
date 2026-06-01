/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_pledge_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_pledge_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_pledge_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_pledge_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 批次表ID
    ,draft_type varchar2(6) -- 票据类别： AC01 银承 AC02 商承
    ,draft_id varchar2(60) -- 票据ID
    ,apply_id varchar2(60) -- 解析表ID
    ,draft_amount number(18,2) -- 票面金额
    ,remit_date varchar2(12) -- 出票日
    ,maturity_date varchar2(12) -- 到期日
    ,payer_bank_no varchar2(18) -- 付款行行号
    ,sign_mk varchar2(6) -- 签收标识
    ,deal_status varchar2(3) -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,err_code varchar2(30) -- 错误码
    ,err_msg varchar2(384) -- 错误信息
    ,last_upd_id varchar2(45) -- 最后操作人ID
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,cd_range varchar2(38) -- 子票区间
    ,standard_amt number(18,2) -- 标准金额
    ,org_draft_id varchar2(60) -- 原票据id
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,org_draft_amount number(18,2) -- 原始票据（包）金额
    ,split_range varchar2(38) -- 拆前区间
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
grant select on ${iol_schema}.bdms_cpes_pledge_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_pledge_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_pledge_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_pledge_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_pledge_details is '质押批次明细信息表';
comment on column ${iol_schema}.bdms_cpes_pledge_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_pledge_details.contract_id is '批次表ID';
comment on column ${iol_schema}.bdms_cpes_pledge_details.draft_type is '票据类别： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_pledge_details.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_cpes_pledge_details.apply_id is '解析表ID';
comment on column ${iol_schema}.bdms_cpes_pledge_details.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_cpes_pledge_details.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cpes_pledge_details.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cpes_pledge_details.payer_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_cpes_pledge_details.sign_mk is '签收标识';
comment on column ${iol_schema}.bdms_cpes_pledge_details.deal_status is '处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败';
comment on column ${iol_schema}.bdms_cpes_pledge_details.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_pledge_details.err_msg is '错误信息';
comment on column ${iol_schema}.bdms_cpes_pledge_details.last_upd_id is '最后操作人ID';
comment on column ${iol_schema}.bdms_cpes_pledge_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_pledge_details.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_cpes_pledge_details.standard_amt is '标准金额';
comment on column ${iol_schema}.bdms_cpes_pledge_details.org_draft_id is '原票据id';
comment on column ${iol_schema}.bdms_cpes_pledge_details.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_pledge_details.org_draft_amount is '原始票据（包）金额';
comment on column ${iol_schema}.bdms_cpes_pledge_details.split_range is '拆前区间';
comment on column ${iol_schema}.bdms_cpes_pledge_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_pledge_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_pledge_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_pledge_details.etl_timestamp is 'ETL处理时间戳';
