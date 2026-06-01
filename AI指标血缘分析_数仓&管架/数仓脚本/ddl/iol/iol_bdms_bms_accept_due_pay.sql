/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_accept_due_pay
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_accept_due_pay
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_accept_due_pay purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_accept_due_pay(
    id varchar2(60) -- ID
    ,branch_no varchar2(18) -- 交易机构编号
    ,acpt_id varchar2(60) -- 清单ID
    ,draft_id varchar2(60) -- 票据信息ID
    ,isse_curcd varchar2(5) -- 票据币种： CNY 人民币
    ,draft_amount number(18,2) -- 票据金额
    ,mesg_type varchar2(5) -- 报文种类
    ,apply_date varchar2(12) -- 提示付款/逾期提示付款申请日期
    ,ovrdue_rsn varchar2(375) -- 逾期原因说明
    ,apply_curcd varchar2(5) -- 提示付款币种： CNY 人民币
    ,apply_amount number(18,2) -- 提示付款金额
    ,sttlm_mk varchar2(6) -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,voc_cnt number(22,0) -- 所附凭证张数
    ,accept_curcd varchar2(5) -- 兑付币种： CNY 人民币
    ,accept_amount number(18,2) -- 兑付金额
    ,payee_bank_no varchar2(18) -- 解付申请人开户行行号
    ,payee_bank_name varchar2(300) -- 解付申请人开户行
    ,payee_name varchar2(225) -- 解付申请人
    ,payee_account varchar2(60) -- 解付申请人帐号
    ,receive_date varchar2(12) -- 提示付款申请日期
    ,operator_no varchar2(45) -- 回复操作员号
    ,repay_sig_mk varchar2(6) -- 回复意见： SU00 同意 SU01 拒绝
    ,dish_code varchar2(6) -- 拒付代码： DC00 与自己有直接债权债务关系的持票人未履行约定义务 DC01 持票人以欺诈、偷盗或者胁迫等手段取得票据 DC02 持票人明知有欺诈、偷盗或者胁迫等情形，出于恶意取得票据 DC03 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 DC04 持票人因重大过失取得不符合《票据法》规定的票据 DC05 超过提示付款期 DC06 被法院冻结或收到法院止付通知书 DC07 票据未到期 DC08 商业承兑汇票承兑人账户余额不足 DC09 其他（必须注明）
    ,appstatus varchar2(3) -- 审批状态： 0 已接收未提交 1 受理已提交 2 记账 3 已拒付(处理纸票拒付交易时增加)
    ,acpay_status varchar2(3) -- 发出签收明细状态： 00 到期付款时我方未签收 11 到期付款时签收通讯中 12 到期付款时签收通讯成功 21 到期付款时签收通讯失败 22 到期付款时签收已确认失败 25 线上清算失败 26 清分失败回复 31 到期付款时签收已确认成功 90 到期付款已交易成功(记账) 91 到期付款时对方已撤回申请
    ,endst_date date -- 签收日期
    ,sig_mk varchar2(6) -- 签收意见： SU00 同意 SU01 拒绝
    ,cancel_date varchar2(12) -- 撤销日期
    ,account_date varchar2(12) -- 记账日期
    ,account_flag varchar2(3) -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,trf_ref varchar2(30) -- 线上清算结果-特许参与者号码
    ,trf_id varchar2(30) -- 线上清算结果-支付交易序号
    ,dualcontrol_lockstatus varchar2(2) -- 双杠复核锁标记
    ,reserve1 varchar2(768) -- 备注1
    ,reserve2 varchar2(150) -- 备注2
    ,endor_num number(22,0) -- 背书次数
    ,payee_type varchar2(15) -- 解付类型： A 正常 B 提前
    ,payee_reserve varchar2(150) -- 提前解付原因
    ,dish_rsn varchar2(384) -- 拒付备注
    ,drft_hldr_cmonid varchar2(45) -- 提示付款人组织机构代码
    ,drft_hldr_role varchar2(6) -- 提示付款人类别RC00接入行RC01企业RC02人民银行RC03被代理行RC04被代理财务公司RC05接入财务公司
    ,last_upd_oper_id number(22,0) -- 最后修改操作员号
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,position_audit_status varchar2(2) -- 头寸审批状态
    ,position_seqno varchar2(30) -- 头寸交易流水
    ,req_remark varchar2(1152) -- 请求方申请备注
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
grant select on ${iol_schema}.bdms_bms_accept_due_pay to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_accept_due_pay to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_accept_due_pay to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_accept_due_pay to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_accept_due_pay is '';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.id is 'ID';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.branch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.acpt_id is '清单ID';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.draft_id is '票据信息ID';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.isse_curcd is '票据币种： CNY 人民币';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.mesg_type is '报文种类';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.apply_date is '提示付款/逾期提示付款申请日期';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.ovrdue_rsn is '逾期原因说明';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.apply_curcd is '提示付款币种： CNY 人民币';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.apply_amount is '提示付款金额';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.sttlm_mk is '线上清算标记： SM00 线上清算 SM01 线下清算';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.voc_cnt is '所附凭证张数';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.accept_curcd is '兑付币种： CNY 人民币';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.accept_amount is '兑付金额';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.payee_bank_no is '解付申请人开户行行号';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.payee_bank_name is '解付申请人开户行';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.payee_name is '解付申请人';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.payee_account is '解付申请人帐号';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.receive_date is '提示付款申请日期';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.operator_no is '回复操作员号';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.repay_sig_mk is '回复意见： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.dish_code is '拒付代码： DC00 与自己有直接债权债务关系的持票人未履行约定义务 DC01 持票人以欺诈、偷盗或者胁迫等手段取得票据 DC02 持票人明知有欺诈、偷盗或者胁迫等情形，出于恶意取得票据 DC03 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 DC04 持票人因重大过失取得不符合《票据法》规定的票据 DC05 超过提示付款期 DC06 被法院冻结或收到法院止付通知书 DC07 票据未到期 DC08 商业承兑汇票承兑人账户余额不足 DC09 其他（必须注明）';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.appstatus is '审批状态： 0 已接收未提交 1 受理已提交 2 记账 3 已拒付(处理纸票拒付交易时增加)';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.acpay_status is '发出签收明细状态： 00 到期付款时我方未签收 11 到期付款时签收通讯中 12 到期付款时签收通讯成功 21 到期付款时签收通讯失败 22 到期付款时签收已确认失败 25 线上清算失败 26 清分失败回复 31 到期付款时签收已确认成功 90 到期付款已交易成功(记账) 91 到期付款时对方已撤回申请';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.endst_date is '签收日期';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.sig_mk is '签收意见： SU00 同意 SU01 拒绝';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.cancel_date is '撤销日期';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.account_date is '记账日期';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.account_flag is '记账状态： 0 未记账 1 记账中 2 记账完成';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.trf_ref is '线上清算结果-特许参与者号码';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.trf_id is '线上清算结果-支付交易序号';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.dualcontrol_lockstatus is '双杠复核锁标记';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.endor_num is '背书次数';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.payee_type is '解付类型： A 正常 B 提前';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.payee_reserve is '提前解付原因';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.dish_rsn is '拒付备注';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.drft_hldr_cmonid is '提示付款人组织机构代码';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.drft_hldr_role is '提示付款人类别RC00接入行RC01企业RC02人民银行RC03被代理行RC04被代理财务公司RC05接入财务公司';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.last_upd_oper_id is '最后修改操作员号';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.position_audit_status is '头寸审批状态';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.position_seqno is '头寸交易流水';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.req_remark is '请求方申请备注';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_accept_due_pay.etl_timestamp is 'ETL处理时间戳';
