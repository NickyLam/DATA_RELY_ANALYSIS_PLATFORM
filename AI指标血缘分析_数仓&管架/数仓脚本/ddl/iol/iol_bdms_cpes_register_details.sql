/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_register_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_register_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_register_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_register_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 协议表ID
    ,reg_type varchar2(3) -- 登记类型： 0 手工 1 自动
    ,draft_id varchar2(60) -- 票据ID
    ,busi_date varchar2(12) -- 交易日期
    ,trader_type varchar2(6) -- 交易对手类型： RC00 同业客户 RC01 企业客户
    ,trader_cust_no varchar2(30) -- 交易对手客户号
    ,trader_name varchar2(300) -- 交易对手名称
    ,trader_account varchar2(75) -- 交易对手账号
    ,trader_credit_no varchar2(27) -- 交易对手社会信用代码
    ,trader_bank_no varchar2(18) -- 交易对手大额行号
    ,trader_brh_no varchar2(15) -- 交易对手机构代码
    ,collection_bank_no varchar2(18) -- 托收行大额行号
    ,busi_brh_no varchar2(15) -- 业务机构
    ,register_brh_no varchar2(15) -- 登记机构
    ,payment_date varchar2(12) -- 付款日期
    ,stop_pay_type varchar2(6) -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,stop_pay_reason varchar2(675) -- 止付原因
    ,relieve_stp_type varchar2(6) -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,relieve_stp_rsn varchar2(675) -- 解除止付原因
    ,revoke_type varchar2(6) -- 撤回类型： RV01 未用退回 RV02 信息作废 RV03 票据作废
    ,revoke_inf varchar2(6) -- 撤回信息： RI00 承兑登记信息撤回 RI01 质押登记信息撤回 RI02 质押解除登记信息撤回 RI03 承兑保证登记信息撤回 RI04 贴现登记信息撤回 RI05 权属登记信息撤回 RI06 结清登记信息撤回 RI07 止付登记信息撤回 RI08 止付解除登记信息撤回
    ,revoke_rsn varchar2(675) -- 撤回原因
    ,recovery_type varchar2(9) -- 线下追偿类型： 00 线下追偿登记 01 线下偿付登记 02 追偿结清登记
    ,industry varchar2(8) -- 行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry
    ,corp_scale varchar2(6) -- 企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale
    ,arc_flag varchar2(2) -- 是否三农企业： 0 否 1 是
    ,area varchar2(3) -- 地区
    ,grn_flag varchar2(2) -- 是否绿色企业： 0 否 1 是
    ,err_code varchar2(30) -- 错误码
    ,err_msg varchar2(384) -- 错误信息
    ,deal_status varchar2(3) -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,last_upd_opr varchar2(45) -- 最后修改操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
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
grant select on ${iol_schema}.bdms_cpes_register_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_register_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_register_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_register_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_register_details is '登记类批次明细表';
comment on column ${iol_schema}.bdms_cpes_register_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_register_details.contract_id is '协议表ID';
comment on column ${iol_schema}.bdms_cpes_register_details.reg_type is '登记类型： 0 手工 1 自动';
comment on column ${iol_schema}.bdms_cpes_register_details.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_cpes_register_details.busi_date is '交易日期';
comment on column ${iol_schema}.bdms_cpes_register_details.trader_type is '交易对手类型： RC00 同业客户 RC01 企业客户';
comment on column ${iol_schema}.bdms_cpes_register_details.trader_cust_no is '交易对手客户号';
comment on column ${iol_schema}.bdms_cpes_register_details.trader_name is '交易对手名称';
comment on column ${iol_schema}.bdms_cpes_register_details.trader_account is '交易对手账号';
comment on column ${iol_schema}.bdms_cpes_register_details.trader_credit_no is '交易对手社会信用代码';
comment on column ${iol_schema}.bdms_cpes_register_details.trader_bank_no is '交易对手大额行号';
comment on column ${iol_schema}.bdms_cpes_register_details.trader_brh_no is '交易对手机构代码';
comment on column ${iol_schema}.bdms_cpes_register_details.collection_bank_no is '托收行大额行号';
comment on column ${iol_schema}.bdms_cpes_register_details.busi_brh_no is '业务机构';
comment on column ${iol_schema}.bdms_cpes_register_details.register_brh_no is '登记机构';
comment on column ${iol_schema}.bdms_cpes_register_details.payment_date is '付款日期';
comment on column ${iol_schema}.bdms_cpes_register_details.stop_pay_type is '止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结';
comment on column ${iol_schema}.bdms_cpes_register_details.stop_pay_reason is '止付原因';
comment on column ${iol_schema}.bdms_cpes_register_details.relieve_stp_type is '解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除';
comment on column ${iol_schema}.bdms_cpes_register_details.relieve_stp_rsn is '解除止付原因';
comment on column ${iol_schema}.bdms_cpes_register_details.revoke_type is '撤回类型： RV01 未用退回 RV02 信息作废 RV03 票据作废';
comment on column ${iol_schema}.bdms_cpes_register_details.revoke_inf is '撤回信息： RI00 承兑登记信息撤回 RI01 质押登记信息撤回 RI02 质押解除登记信息撤回 RI03 承兑保证登记信息撤回 RI04 贴现登记信息撤回 RI05 权属登记信息撤回 RI06 结清登记信息撤回 RI07 止付登记信息撤回 RI08 止付解除登记信息撤回';
comment on column ${iol_schema}.bdms_cpes_register_details.revoke_rsn is '撤回原因';
comment on column ${iol_schema}.bdms_cpes_register_details.recovery_type is '线下追偿类型： 00 线下追偿登记 01 线下偿付登记 02 追偿结清登记';
comment on column ${iol_schema}.bdms_cpes_register_details.industry is '行业分类：见中国票据交易系统直连接口规范【概述分册】的数据类型Industry';
comment on column ${iol_schema}.bdms_cpes_register_details.corp_scale is '企业规模：见中国票据交易系统直连接口规范【概述分册】的数据类型CorpScale';
comment on column ${iol_schema}.bdms_cpes_register_details.arc_flag is '是否三农企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_register_details.area is '地区';
comment on column ${iol_schema}.bdms_cpes_register_details.grn_flag is '是否绿色企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_register_details.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_register_details.err_msg is '错误信息';
comment on column ${iol_schema}.bdms_cpes_register_details.deal_status is '处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败';
comment on column ${iol_schema}.bdms_cpes_register_details.last_upd_opr is '最后修改操作员';
comment on column ${iol_schema}.bdms_cpes_register_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_register_details.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_register_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_register_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_register_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_register_details.etl_timestamp is 'ETL处理时间戳';
