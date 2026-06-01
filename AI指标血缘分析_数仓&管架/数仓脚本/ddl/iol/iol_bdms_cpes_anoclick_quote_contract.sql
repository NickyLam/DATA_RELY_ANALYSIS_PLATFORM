/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_anoclick_quote_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_anoclick_quote_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_anoclick_quote_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_anoclick_quote_contract(
    id varchar2(60) -- ID
    ,contract_no varchar2(60) -- 批次号
    ,product_no varchar2(12) -- 产品号
    ,busi_date varchar2(12) -- 业务日期
    ,busi_type varchar2(6) -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,trade_direct varchar2(8) -- 交易方向： CRD01 逆回购 CRD02 正回购
    ,top_branch_no varchar2(15) -- 总行机构号
    ,busi_branch_no varchar2(15) -- 业务机构号
    ,own_user_id varchar2(15) -- 我方交易员
    ,draft_type varchar2(6) -- 票据类型 AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,rebuy_rate number(7,6) -- 回购利率
    ,rebuy_amt number(18,2) -- 回购金额
    ,rebuy_tenor_days number(8,0) -- 回购期限
    ,tenor_code varchar2(8) -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
    ,settle_date varchar2(12) -- 首期结算日
    ,due_settle_date varchar2(12) -- 到期结算日
    ,clear_speed varchar2(6) -- 清算速度 CS00 T+0 CS01 T+1
    ,settle_mode varchar2(6) -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,clear_type varchar2(6) -- 清算类型 CT01 全额清算 CT02 净额清算
    ,credit_type varchar2(5) -- 信用主体类型  201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,department_no varchar2(15) -- 所属部门
    ,manager_no varchar2(30) -- 客户经理
    ,contract_status varchar2(3) -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,message_status varchar2(3) -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
    ,quote_no varchar2(30) -- 报价单编号
    ,quote_status varchar2(8) -- 报价单状态： AQS01 已保存 AQS02 已发送 AQS03 全部成交 AQS05 已作废 AQS06 发送待确认 AQS07 建立失败 AQS08 部分撤销待确认 AQS09 全部撤销待确认 AQS10 已部分撤销 AQS11 已全部撤销 AQS12 部分成交
    ,created_by varchar2(45) -- 创建人
    ,last_upd_opr varchar2(45) -- 最后修改人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,i9_type varchar2(15) -- 三分类标识
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
grant select on ${iol_schema}.bdms_cpes_anoclick_quote_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_quote_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_quote_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_anoclick_quote_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_anoclick_quote_contract is '匿名点击批次表';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.busi_date is '业务日期';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.busi_type is '业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.trade_direct is '交易方向： CRD01 逆回购 CRD02 正回购';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.own_user_id is '我方交易员';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.draft_type is '票据类型 AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.rebuy_rate is '回购利率';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.rebuy_amt is '回购金额';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.rebuy_tenor_days is '回购期限';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.tenor_code is '期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.settle_date is '首期结算日';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.due_settle_date is '到期结算日';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.clear_speed is '清算速度 CS00 T+0 CS01 T+1';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.settle_mode is '结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.clear_type is '清算类型 CT01 全额清算 CT02 净额清算';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.credit_type is '信用主体类型  201	政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.department_no is '所属部门';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.manager_no is '客户经理';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.contract_status is '审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.message_status is '报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.quote_status is '报价单状态： AQS01 已保存 AQS02 已发送 AQS03 全部成交 AQS05 已作废 AQS06 发送待确认 AQS07 建立失败 AQS08 部分撤销待确认 AQS09 全部撤销待确认 AQS10 已部分撤销 AQS11 已全部撤销 AQS12 部分成交';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.last_upd_opr is '最后修改人';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.i9_type is '三分类标识';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_anoclick_quote_contract.etl_timestamp is 'ETL处理时间戳';
