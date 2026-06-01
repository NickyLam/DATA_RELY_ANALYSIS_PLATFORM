/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cas_settle_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cas_settle_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cas_settle_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cas_settle_info(
    id varchar2(60) -- ID
    ,brh_no varchar2(15) -- 机构代码
    ,settle_req_no varchar2(36) -- 结算请求编号/交割单编号
    ,settle_tm varchar2(21) -- 结算时间
    ,buss_type varchar2(2) -- 业务类型： 1 查询 2 通知 3 出入金 4 结息
    ,settle_type varchar2(9) -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,settle_req_type varchar2(9) -- 结算业务类型： RE1011 转贴现 RE1021 质押式回购首期 RE1022 质押式回购到期 RE1031 买断式回购首期 RE1032 买断式回购到期 RE2011 托收 RE2021 追索 T10008 扣费 RE1023 质押式回购提前赎回 RE1024 质押式回购逾期赎回 RE3011 再贴现买断 RE3021再贴现质押式回购首期 RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回
    ,clear_type varchar2(6) -- 清算类型： CT01 全额清算 CT02 净额清算
    ,trade_direct varchar2(8) -- 交易方向： 1 买入或接收方 2 卖出或发起方
    ,settle_amt number(18,2) -- 结算金额
    ,pay_interest number(18,2) -- 应付利息
    ,draft_count number(8,0) -- 票据张数
    ,deal_no varchar2(45) -- 成交单编号
    ,ccpc_msg_id varchar2(53) -- 大额支付系统报文标识号
    ,draft_number varchar2(45) -- 票据（包）号
    ,rcv_brh_no varchar2(14) -- 收款方机构代码
    ,rcv_tacct_no varchar2(48) -- 收款方托管账号
    ,rcv_tacct_name varchar2(675) -- 收款方托管账户名称
    ,rcv_facct_no varchar2(48) -- 收款方资金账号
    ,rcv_facct_name varchar2(675) -- 收款方资金账户名称
    ,pay_brh_no varchar2(14) -- 付款方机构代码
    ,pay_tacct_no varchar2(48) -- 付款方托管账号
    ,pay_tacct_name varchar2(675) -- 付款方托管账户名称
    ,pay_facct_no varchar2(48) -- 付款方资金账号
    ,pay_facct_name varchar2(675) -- 付款方资金账户名称
    ,settle_status varchar2(6) -- 结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功
    ,queue_no varchar2(30) -- 队列编号
    ,fee_no varchar2(30) -- 扣费编号
    ,queue_seq varchar2(30) -- 排队顺序号
    ,que_adj_rst varchar2(6) -- 排队调整结果
    ,pro_code varchar2(14) -- 队列调整结果码
    ,settle_result varchar2(5) -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,settle_frsn varchar2(6) -- 结算失败原因
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,rcv_corp_br_id varchar2(14) -- 收款方企业开户行机构代码
    ,rcv_op_bk_id varchar2(18) -- 收款方企业开户行行号
    ,rcv_corp_name varchar2(675) -- 收款方企业账户名称
    ,rcv_corp_acct varchar2(48) -- 收款方企业账号
    ,rcv_corp_soc_code varchar2(27) -- 收款方统一社会信用代码
    ,pay_corp_br_id varchar2(14) -- 付款方企业开户行机构代码
    ,pay_op_bk_id varchar2(18) -- 付款方企业开户行行号
    ,pay_corp_name varchar2(675) -- 付款方企业账户名称
    ,pay_corp_acct varchar2(48) -- 付款方企业账号
    ,pay_corp_soc_code varchar2(27) -- 付款方统一社会信用代码
    ,is_batch varchar2(6) -- 是否批量清算
    ,pay_cd_acct_no varchar2(48) -- 付款方企业票据账户账号
    ,rcv_cd_acct_no varchar2(48) -- 收款方企业票据账户账号
    ,cd_range varchar2(38) -- 票据子区间
    ,analysis_id varchar2(60) -- 业务报文解析表ID
    ,create_by varchar2(45) -- 创建人
    ,create_time varchar2(21) -- 创建时间
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
grant select on ${iol_schema}.bdms_cas_settle_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cas_settle_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cas_settle_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cas_settle_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cas_settle_info is '票据业务结算信息表';
comment on column ${iol_schema}.bdms_cas_settle_info.id is 'ID';
comment on column ${iol_schema}.bdms_cas_settle_info.brh_no is '机构代码';
comment on column ${iol_schema}.bdms_cas_settle_info.settle_req_no is '结算请求编号/交割单编号';
comment on column ${iol_schema}.bdms_cas_settle_info.settle_tm is '结算时间';
comment on column ${iol_schema}.bdms_cas_settle_info.buss_type is '业务类型： 1 查询 2 通知 3 出入金 4 结息';
comment on column ${iol_schema}.bdms_cas_settle_info.settle_type is '结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）';
comment on column ${iol_schema}.bdms_cas_settle_info.settle_req_type is '结算业务类型： RE1011 转贴现 RE1021 质押式回购首期 RE1022 质押式回购到期 RE1031 买断式回购首期 RE1032 买断式回购到期 RE2011 托收 RE2021 追索 T10008 扣费 RE1023 质押式回购提前赎回 RE1024 质押式回购逾期赎回 RE3011 再贴现买断 RE3021再贴现质押式回购首期 RE3022 再贴现质押式回购到期 RE3023 再贴现质押式回购提前赎回 RE3024 再贴现质押式回购逾期赎回';
comment on column ${iol_schema}.bdms_cas_settle_info.clear_type is '清算类型： CT01 全额清算 CT02 净额清算';
comment on column ${iol_schema}.bdms_cas_settle_info.trade_direct is '交易方向： 1 买入或接收方 2 卖出或发起方';
comment on column ${iol_schema}.bdms_cas_settle_info.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cas_settle_info.draft_count is '票据张数';
comment on column ${iol_schema}.bdms_cas_settle_info.deal_no is '成交单编号';
comment on column ${iol_schema}.bdms_cas_settle_info.ccpc_msg_id is '大额支付系统报文标识号';
comment on column ${iol_schema}.bdms_cas_settle_info.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_brh_no is '收款方机构代码';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_tacct_no is '收款方托管账号';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_tacct_name is '收款方托管账户名称';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_facct_no is '收款方资金账号';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_facct_name is '收款方资金账户名称';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_brh_no is '付款方机构代码';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_tacct_no is '付款方托管账号';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_tacct_name is '付款方托管账户名称';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_facct_no is '付款方资金账号';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_facct_name is '付款方资金账户名称';
comment on column ${iol_schema}.bdms_cas_settle_info.settle_status is '结算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销 MS07 提前赎回结算成功 MS08 逾期赎回结算成功';
comment on column ${iol_schema}.bdms_cas_settle_info.queue_no is '队列编号';
comment on column ${iol_schema}.bdms_cas_settle_info.fee_no is '扣费编号';
comment on column ${iol_schema}.bdms_cas_settle_info.queue_seq is '排队顺序号';
comment on column ${iol_schema}.bdms_cas_settle_info.que_adj_rst is '排队调整结果';
comment on column ${iol_schema}.bdms_cas_settle_info.pro_code is '队列调整结果码';
comment on column ${iol_schema}.bdms_cas_settle_info.settle_result is '结算结果： R20 结算成功 R21 结算失败 R23 已撤销';
comment on column ${iol_schema}.bdms_cas_settle_info.settle_frsn is '结算失败原因';
comment on column ${iol_schema}.bdms_cas_settle_info.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cas_settle_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cas_settle_info.misc is '备注';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_corp_br_id is '收款方企业开户行机构代码';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_op_bk_id is '收款方企业开户行行号';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_corp_name is '收款方企业账户名称';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_corp_acct is '收款方企业账号';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_corp_soc_code is '收款方统一社会信用代码';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_corp_br_id is '付款方企业开户行机构代码';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_op_bk_id is '付款方企业开户行行号';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_corp_name is '付款方企业账户名称';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_corp_acct is '付款方企业账号';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_corp_soc_code is '付款方统一社会信用代码';
comment on column ${iol_schema}.bdms_cas_settle_info.is_batch is '是否批量清算';
comment on column ${iol_schema}.bdms_cas_settle_info.pay_cd_acct_no is '付款方企业票据账户账号';
comment on column ${iol_schema}.bdms_cas_settle_info.rcv_cd_acct_no is '收款方企业票据账户账号';
comment on column ${iol_schema}.bdms_cas_settle_info.cd_range is '票据子区间';
comment on column ${iol_schema}.bdms_cas_settle_info.analysis_id is '业务报文解析表ID';
comment on column ${iol_schema}.bdms_cas_settle_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_cas_settle_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_cas_settle_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cas_settle_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cas_settle_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cas_settle_info.etl_timestamp is 'ETL处理时间戳';
