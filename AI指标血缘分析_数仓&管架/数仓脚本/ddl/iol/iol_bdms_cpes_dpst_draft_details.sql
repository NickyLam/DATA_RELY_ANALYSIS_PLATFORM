/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_dpst_draft_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_dpst_draft_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_dpst_draft_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_dpst_draft_details(
    id varchar2(60) -- ID
    ,dpst_id varchar2(60) -- 存托申请表ID
    ,contract_id varchar2(60) -- 批次ID
    ,apply_id varchar2(30) -- 存托申请单编号
    ,draft_id varchar2(60) -- 票据表ID
    ,draft_number varchar2(45) -- 票号
    ,draft_amount number(18,2) -- 票据金额
    ,maturity_date varchar2(12) -- 到期日
    ,bp_no varchar2(45) -- 票据包编号
    ,bp_range varchar2(113) -- 子票据区间号
    ,dpst_range varchar2(113) -- 存托区间
    ,discount_date varchar2(12) -- 贴现日
    ,remit_date varchar2(12) -- 出票日
    ,remitter_name varchar2(270) -- 出票人名称
    ,acceptor_name varchar2(270) -- 承兑人名称
    ,acceptor_brh_no varchar2(270) -- 承兑人开户行机构代码
    ,discount_brh_no varchar2(14) -- 贴现行机构代码
    ,guarantee_brh_no varchar2(14) -- 保证增信行机构代码
    ,payer_confirm_brh_no varchar2(14) -- 承兑人开户行（确认）机构代码
    ,accept_gua_brh_no varchar2(14) -- 承兑保证行机构代码
    ,disc_gua_brh_no varchar2(14) -- 贴现保证人机构代码
    ,tenor_day varchar2(15) -- 剩余期限
    ,bp_amount number(18,2) -- 票据包金额
    ,dpst_amount number(18,2) -- 存托金额
    ,dpst_number varchar2(27) -- 存托数量
    ,bp_std_amount number(18,2) -- 标准金额
    ,pay_interest number(18,2) -- 应付利息
    ,adjust_pay_interest number(18,2) -- 调整后应付利息
    ,settle_amount number(18,2) -- 结算金额
    ,bp_due_date varchar2(12) -- 票据包到期日
    ,valid_flag varchar2(2) -- 有效标识： 0 否 1 是
    ,wthd_status varchar2(3) -- 退票状态： 00 未退票 01 主动退票 02 通知退票
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,message_status varchar2(3) -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,proc_code varchar2(14) -- 返回码
    ,proc_msg varchar2(1152) -- 返回结果
    ,wthd_info varchar2(4000) -- 退票说明
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
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
grant select on ${iol_schema}.bdms_cpes_dpst_draft_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_draft_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_draft_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_draft_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_dpst_draft_details is '存托票据业务明细表';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.dpst_id is '存托申请表ID';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.contract_id is '批次ID';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.apply_id is '存托申请单编号';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.draft_number is '票号';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.bp_no is '票据包编号';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.bp_range is '子票据区间号';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.dpst_range is '存托区间';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.discount_date is '贴现日';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.acceptor_brh_no is '承兑人开户行机构代码';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.discount_brh_no is '贴现行机构代码';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.guarantee_brh_no is '保证增信行机构代码';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.payer_confirm_brh_no is '承兑人开户行（确认）机构代码';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.accept_gua_brh_no is '承兑保证行机构代码';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.disc_gua_brh_no is '贴现保证人机构代码';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.tenor_day is '剩余期限';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.bp_amount is '票据包金额';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.dpst_amount is '存托金额';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.dpst_number is '存托数量';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.bp_std_amount is '标准金额';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.adjust_pay_interest is '调整后应付利息';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.settle_amount is '结算金额';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.bp_due_date is '票据包到期日';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.valid_flag is '有效标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.wthd_status is '退票状态： 00 未退票 01 主动退票 02 通知退票';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.message_status is '报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.proc_code is '返回码';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.proc_msg is '返回结果';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.wthd_info is '退票说明';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_dpst_draft_details.etl_timestamp is 'ETL处理时间戳';
