/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_quote_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_quote_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_quote_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_quote_contract(
    id varchar2(60) -- 
    ,top_branch_no varchar2(15) -- 总行机构号
    ,contract_no varchar2(60) -- 协议号
    ,apply_date varchar2(12) -- 申请日期
    ,product_no varchar2(12) -- 产品号
    ,cust_pro_no varchar2(14) -- 交易对手非法人产品号
    ,cust_pro_name varchar2(150) -- 交易对手非法人产品名称
    ,busi_date varchar2(12) -- 
    ,quote_no varchar2(24) -- 报价单编号
    ,busi_type varchar2(6) -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,inner_flag varchar2(2) -- 系统内外标识： 0 否 1 是
    ,is_send varchar2(2) -- 是否发送报文： 0 否 1 是
    ,quote_mode varchar2(2) -- 报价方式： 0 定向报价 1 全市场报价
    ,deal_id varchar2(30) -- 成交单编号
    ,trade_direct varchar2(8) -- 交易方向： TDD01 买入 TDD02 卖出
    ,busi_branch_no varchar2(18) -- 业务机构号
    ,branch_acct varchar2(48) -- 资金账户
    ,acct_branch_no varchar2(15) -- 账务机构号
    ,user_id varchar2(15) -- 交易员ID
    ,facct_no varchar2(75) -- 资金账号
    ,manager_no varchar2(30) -- 客户经理
    ,department_no varchar2(15) -- 部门编号
    ,cust_no varchar2(18) -- 客户号
    ,cust_user_id varchar2(15) -- 交易员ID
    ,cust_name varchar2(150) -- 客户名称
    ,cust_acct varchar2(48) -- 客户帐号
    ,cust_bank_no varchar2(18) -- 
    ,cust_brh_no varchar2(15) -- 
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,sum_count number(8,0) -- 票据张数
    ,sum_amount number(18,2) -- 票据总额
    ,buy_back_amt number(18,2) -- 回购金额
    ,tenor_days number(8,0) -- 持票期限
    ,sub_deal_flag varchar2(2) -- 部分成交选项： 0 否 1 是
    ,quote_valid_tm varchar2(21) -- 报价有效时间
    ,clear_speed varchar2(6) -- 清算速度： CS00 T+0 CS01 T+1
    ,clear_type varchar2(6) -- 清算类型： CT01 全额清算 CT02 净额清算
    ,settle_time varchar2(21) -- 最晚结算时间
    ,settle_mode varchar2(6) -- 结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,settle_amt number(18,2) -- 结算金额
    ,due_settle_amt number(18,2) -- 到期结算金额
    ,settle_date varchar2(12) -- 结算日期
    ,due_settle_date varchar2(12) -- 到期结算日期
    ,rate number(9,6) -- 利率
    ,due_rate number(7,6) -- 到期利率
    ,pay_interest number(18,2) -- 应付利息
    ,due_pay_interest number(18,2) -- 到期应付利息
    ,yield_rate number(13,6) -- 收益率
    ,select_type varchar2(8) -- 挑票类型： CSM01 单票 CSM02 票据包
    ,package_no varchar2(24) -- 票据包编号
    ,check_status varchar2(3) -- 检查状态
    ,credit_check_status varchar2(3) -- 额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,credit_no varchar2(60) -- 额度编号
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,message_status varchar2(3) -- 报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
    ,settle_status varchar2(6) -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,contract_status varchar2(3) -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,modify_flag varchar2(2) -- 是否修改： 0 否 1 是
    ,created_by varchar2(45) -- 创建人
    ,i9_type varchar2(15) -- I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
    ,own_pro_no varchar2(14) -- 本方非法人产品
    ,own_pro_name varchar2(150) -- 本方非法人产品名称
    ,bussiness_type varchar2(12) -- 业务所属分行
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
grant select on ${iol_schema}.bdms_cpes_quote_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_quote_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_quote_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_quote_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_quote_contract is '对话报价协议表';
comment on column ${iol_schema}.bdms_cpes_quote_contract.id is '';
comment on column ${iol_schema}.bdms_cpes_quote_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.contract_no is '协议号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.apply_date is '申请日期';
comment on column ${iol_schema}.bdms_cpes_quote_contract.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.cust_pro_no is '交易对手非法人产品号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.cust_pro_name is '交易对手非法人产品名称';
comment on column ${iol_schema}.bdms_cpes_quote_contract.busi_date is '';
comment on column ${iol_schema}.bdms_cpes_quote_contract.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.busi_type is '业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票';
comment on column ${iol_schema}.bdms_cpes_quote_contract.inner_flag is '系统内外标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_quote_contract.is_send is '是否发送报文： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_quote_contract.quote_mode is '报价方式： 0 定向报价 1 全市场报价';
comment on column ${iol_schema}.bdms_cpes_quote_contract.deal_id is '成交单编号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.trade_direct is '交易方向： TDD01 买入 TDD02 卖出';
comment on column ${iol_schema}.bdms_cpes_quote_contract.busi_branch_no is '业务机构号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.branch_acct is '资金账户';
comment on column ${iol_schema}.bdms_cpes_quote_contract.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.user_id is '交易员ID';
comment on column ${iol_schema}.bdms_cpes_quote_contract.facct_no is '资金账号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.manager_no is '客户经理';
comment on column ${iol_schema}.bdms_cpes_quote_contract.department_no is '部门编号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.cust_no is '客户号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.cust_user_id is '交易员ID';
comment on column ${iol_schema}.bdms_cpes_quote_contract.cust_name is '客户名称';
comment on column ${iol_schema}.bdms_cpes_quote_contract.cust_acct is '客户帐号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.cust_bank_no is '';
comment on column ${iol_schema}.bdms_cpes_quote_contract.cust_brh_no is '';
comment on column ${iol_schema}.bdms_cpes_quote_contract.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_quote_contract.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_quote_contract.sum_count is '票据张数';
comment on column ${iol_schema}.bdms_cpes_quote_contract.sum_amount is '票据总额';
comment on column ${iol_schema}.bdms_cpes_quote_contract.buy_back_amt is '回购金额';
comment on column ${iol_schema}.bdms_cpes_quote_contract.tenor_days is '持票期限';
comment on column ${iol_schema}.bdms_cpes_quote_contract.sub_deal_flag is '部分成交选项： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_quote_contract.quote_valid_tm is '报价有效时间';
comment on column ${iol_schema}.bdms_cpes_quote_contract.clear_speed is '清算速度： CS00 T+0 CS01 T+1';
comment on column ${iol_schema}.bdms_cpes_quote_contract.clear_type is '清算类型： CT01 全额清算 CT02 净额清算';
comment on column ${iol_schema}.bdms_cpes_quote_contract.settle_time is '最晚结算时间';
comment on column ${iol_schema}.bdms_cpes_quote_contract.settle_mode is '结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）';
comment on column ${iol_schema}.bdms_cpes_quote_contract.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpes_quote_contract.due_settle_amt is '到期结算金额';
comment on column ${iol_schema}.bdms_cpes_quote_contract.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpes_quote_contract.due_settle_date is '到期结算日期';
comment on column ${iol_schema}.bdms_cpes_quote_contract.rate is '利率';
comment on column ${iol_schema}.bdms_cpes_quote_contract.due_rate is '到期利率';
comment on column ${iol_schema}.bdms_cpes_quote_contract.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpes_quote_contract.due_pay_interest is '到期应付利息';
comment on column ${iol_schema}.bdms_cpes_quote_contract.yield_rate is '收益率';
comment on column ${iol_schema}.bdms_cpes_quote_contract.select_type is '挑票类型： CSM01 单票 CSM02 票据包';
comment on column ${iol_schema}.bdms_cpes_quote_contract.package_no is '票据包编号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.check_status is '检查状态';
comment on column ${iol_schema}.bdms_cpes_quote_contract.credit_check_status is '额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败';
comment on column ${iol_schema}.bdms_cpes_quote_contract.credit_no is '额度编号';
comment on column ${iol_schema}.bdms_cpes_quote_contract.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_quote_contract.message_status is '报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功';
comment on column ${iol_schema}.bdms_cpes_quote_contract.settle_status is '清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销';
comment on column ${iol_schema}.bdms_cpes_quote_contract.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_quote_contract.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_quote_contract.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_quote_contract.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_cpes_quote_contract.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_cpes_quote_contract.contract_status is '审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_quote_contract.modify_flag is '是否修改： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_quote_contract.created_by is '创建人';
comment on column ${iol_schema}.bdms_cpes_quote_contract.i9_type is 'I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类';
comment on column ${iol_schema}.bdms_cpes_quote_contract.own_pro_no is '本方非法人产品';
comment on column ${iol_schema}.bdms_cpes_quote_contract.own_pro_name is '本方非法人产品名称';
comment on column ${iol_schema}.bdms_cpes_quote_contract.bussiness_type is '业务所属分行';
comment on column ${iol_schema}.bdms_cpes_quote_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_quote_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_quote_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_quote_contract.etl_timestamp is 'ETL处理时间戳';
