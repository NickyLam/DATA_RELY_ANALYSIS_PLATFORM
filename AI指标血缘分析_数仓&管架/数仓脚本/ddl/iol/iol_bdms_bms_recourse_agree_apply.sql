/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_recourse_agree_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_recourse_agree_apply
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_recourse_agree_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_recourse_agree_apply(
    id varchar2(60) -- ID
    ,draft_id varchar2(60) -- 业务明细ID
    ,draft_number varchar2(45) -- 票号
    ,isse_curcd varchar2(5) -- 票据币种： CNY 人民币
    ,isse_amt number(18,2) -- 票据金额
    ,apply_date varchar2(12) -- 同意清偿日期
    ,rcrs_curcd varchar2(5) -- 同意清偿币种： CNY 人民币
    ,rcrs_amt number(18,2) -- 同意清偿金额
    ,rcrs_role varchar2(6) -- 同意清偿人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,rcrs_name varchar2(270) -- 同意清偿人名称
    ,rcrs_cmonid varchar2(45) -- 同意清偿人组织机构代码
    ,rcrs_actno varchar2(48) -- 同意清偿人账号(如发起行为同意清偿行，填写一个‘0’；如为人民银行的，也填写一个‘0’；其他情况下，填写同意清偿人账号)
    ,rcrs_ubank varchar2(18) -- 同意清偿人开户行行号
    ,rcrs_agcy_ubank varchar2(18) -- 同意清偿人承接行行号
    ,req_remark varchar2(1152) -- 同意清偿申请备注
    ,rcv_remark varchar2(1152) -- 同意清偿签收备注
    ,rcv_prxy_sgntr varchar2(6) -- 保证代理回复标识： PS01 客户自己签章
    ,endst_date varchar2(12) -- 签收日期
    ,sig_mk varchar2(6) -- 签收意见： SU00 同意签收 SU01 拒绝签收
    ,receive_status varchar2(3) -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,details_status varchar2(3) -- 明细状态： 00 未处理 01 处理中 02 处理完成
    ,cancel_date varchar2(12) -- 撤销日期
    ,recourse_id varchar2(60) -- 发出追索登记薄id
    ,last_operator_no varchar2(45) -- 最后修改柜员号
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,purpose varchar2(2) -- 用途： Y 银行端 W 网银端
    ,account_flag varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,account_date varchar2(12) -- 
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
grant select on ${iol_schema}.bdms_bms_recourse_agree_apply to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_recourse_agree_apply to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_recourse_agree_apply to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_recourse_agree_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_recourse_agree_apply is '追索同意清偿申请表';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.id is 'ID';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.draft_id is '业务明细ID';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.draft_number is '票号';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.isse_curcd is '票据币种： CNY 人民币';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.isse_amt is '票据金额';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.apply_date is '同意清偿日期';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcrs_curcd is '同意清偿币种： CNY 人民币';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcrs_amt is '同意清偿金额';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcrs_role is '同意清偿人类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcrs_name is '同意清偿人名称';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcrs_cmonid is '同意清偿人组织机构代码';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcrs_actno is '同意清偿人账号(如发起行为同意清偿行，填写一个‘0’；如为人民银行的，也填写一个‘0’；其他情况下，填写同意清偿人账号)';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcrs_ubank is '同意清偿人开户行行号';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcrs_agcy_ubank is '同意清偿人承接行行号';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.req_remark is '同意清偿申请备注';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcv_remark is '同意清偿签收备注';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.rcv_prxy_sgntr is '保证代理回复标识： PS01 客户自己签章';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.endst_date is '签收日期';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.sig_mk is '签收意见： SU00 同意签收 SU01 拒绝签收';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.receive_status is '报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.details_status is '明细状态： 00 未处理 01 处理中 02 处理完成';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.cancel_date is '撤销日期';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.recourse_id is '发出追索登记薄id';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.last_operator_no is '最后修改柜员号';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.purpose is '用途： Y 银行端 W 网银端';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.account_flag is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.account_date is '';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_recourse_agree_apply.etl_timestamp is 'ETL处理时间戳';
