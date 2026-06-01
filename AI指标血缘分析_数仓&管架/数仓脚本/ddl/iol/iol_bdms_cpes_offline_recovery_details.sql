/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_offline_recovery_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_offline_recovery_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_offline_recovery_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_offline_recovery_details(
    id varchar2(60) -- 
    ,contract_id varchar2(60) -- 批次表ID
    ,recovery_type varchar2(9) -- 追偿类型： OLRT01 追偿发起登记 OLRT02 追偿偿付登记
    ,draft_type varchar2(6) -- 票据类别： AC01 银承 AC02 商承
    ,draft_id varchar2(60) -- 票据ID
    ,draft_amount number(18,2) -- 票面金额
    ,remit_date varchar2(12) -- 出票日
    ,maturity_date varchar2(12) -- 到期日
    ,payer_bank_no varchar2(18) -- 付款行行号
    ,prmt_date varchar2(12) -- 提示付款日期
    ,prmt_ref_code varchar2(6) -- 提示付款拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
    ,err_code varchar2(30) -- 错误码
    ,err_msg varchar2(384) -- 错误信息
    ,last_upd_opr varchar2(45) -- 最后修改操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,deal_status varchar2(3) -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
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
grant select on ${iol_schema}.bdms_cpes_offline_recovery_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_offline_recovery_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_offline_recovery_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_offline_recovery_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_offline_recovery_details is '线下追偿批次明细信息表';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.id is '';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.contract_id is '批次表ID';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.recovery_type is '追偿类型： OLRT01 追偿发起登记 OLRT02 追偿偿付登记';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.draft_type is '票据类别： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.payer_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.prmt_date is '提示付款日期';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.prmt_ref_code is '提示付款拒绝原因代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.err_msg is '错误信息';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.last_upd_opr is '最后修改操作员';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.deal_status is '处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_offline_recovery_details.etl_timestamp is 'ETL处理时间戳';
