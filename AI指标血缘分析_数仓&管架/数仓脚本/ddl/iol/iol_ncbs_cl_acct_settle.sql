/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_settle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_settle
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_settle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_settle(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,auto_blocking varchar2(1) -- 自动锁定标志
    ,bank_in_out varchar2(1) -- 是否行内行外
    ,company varchar2(20) -- 法人
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,event_type varchar2(20) -- 事件类型
    ,freeze_type varchar2(1) -- 受托人账户冻结方式
    ,pay_rec_ind varchar2(3) -- 收付款标志
    ,priority varchar2(20) -- 优先级
    ,receipt_no varchar2(50) -- 回收号
    ,recover_flag varchar2(1) -- 实时追缴标志字段
    ,restraint_seq_no varchar2(50) -- 冻结编号
    ,self_support_flag varchar2(1) -- 是否自营
    ,settle_acct_class varchar2(3) -- 结算账户分类
    ,settle_bank_flag varchar2(1) -- 资金转移账户银行标识
    ,settle_method varchar2(3) -- 结算方法
    ,settle_mobile_phone varchar2(20) -- 绑定账户手机号码
    ,settle_no varchar2(50) -- 结算编号
    ,settle_weight number(5,2) -- 结算权重
    ,settle_xrate_id varchar2(1) -- 结算汇兑方式
    ,trusted_pay_no varchar2(50) -- 受托支付编号
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,contributive_ratio number(11,7) -- 出资比例
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,payee_bank_code varchar2(20) -- 收款人开户行行号
    ,payee_bank_name varchar2(400) -- 收款行名称
    ,profit_ratio number(11,7) -- 分润比例
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_internal_key number(15) -- 结算账户标志符
    ,settle_acct_name varchar2(200) -- 结算账户户名
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_bank_name varchar2(100) -- 清算账号开户行行名
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_branch varchar2(12) -- 清算机构
    ,settle_ccy varchar2(3) -- 结算币种
    ,settle_client varchar2(16) -- 结算客户号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,settle_xrate number(15,8) -- 结算汇率
    ,hang_seq_no varchar2(50) -- 挂账序列号
    ,hang_operate_type1 varchar2(1) -- 挂账操作类型
    ,acct_res_operate_type varchar2(2) -- 账户限制操作类型|账户限制操作类型|01-新增,02-修改,03-解限,04-追加,05-部分解限,06-续冻
    ,acct_nature_desc varchar2(200) -- 账户属性描述
    ,acct_nature varchar2(10) -- 存款账户类型
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
grant select on ${iol_schema}.ncbs_cl_acct_settle to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_settle to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_settle to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_settle to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_settle is '账户结算信息表';
comment on column ${iol_schema}.ncbs_cl_acct_settle.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_acct_settle.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_settle.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_acct_settle.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.auto_blocking is '自动锁定标志';
comment on column ${iol_schema}.ncbs_cl_acct_settle.bank_in_out is '是否行内行外';
comment on column ${iol_schema}.ncbs_cl_acct_settle.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_settle.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_cl_acct_settle.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_acct_settle.freeze_type is '受托人账户冻结方式';
comment on column ${iol_schema}.ncbs_cl_acct_settle.pay_rec_ind is '收付款标志';
comment on column ${iol_schema}.ncbs_cl_acct_settle.priority is '优先级';
comment on column ${iol_schema}.ncbs_cl_acct_settle.receipt_no is '回收号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.recover_flag is '实时追缴标志字段';
comment on column ${iol_schema}.ncbs_cl_acct_settle.restraint_seq_no is '冻结编号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.self_support_flag is '是否自营';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_acct_class is '结算账户分类';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_bank_flag is '资金转移账户银行标识';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_method is '结算方法';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_mobile_phone is '绑定账户手机号码';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_no is '结算编号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_weight is '结算权重';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_xrate_id is '结算汇兑方式';
comment on column ${iol_schema}.ncbs_cl_acct_settle.trusted_pay_no is '受托支付编号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct_settle.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_settle.contributive_ratio is '出资比例';
comment on column ${iol_schema}.ncbs_cl_acct_settle.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_acct_settle.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.payee_bank_code is '收款人开户行行号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.payee_bank_name is '收款行名称';
comment on column ${iol_schema}.ncbs_cl_acct_settle.profit_ratio is '分润比例';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_acct_internal_key is '结算账户标志符';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_acct_name is '结算账户户名';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_bank_name is '清算账号开户行行名';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_branch is '清算机构';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_ccy is '结算币种';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_client is '结算客户号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_acct_settle.settle_xrate is '结算汇率';
comment on column ${iol_schema}.ncbs_cl_acct_settle.hang_seq_no is '挂账序列号';
comment on column ${iol_schema}.ncbs_cl_acct_settle.hang_operate_type1 is '挂账操作类型';
comment on column ${iol_schema}.ncbs_cl_acct_settle.acct_res_operate_type is '账户限制操作类型|账户限制操作类型|01-新增,02-修改,03-解限,04-追加,05-部分解限,06-续冻';
comment on column ${iol_schema}.ncbs_cl_acct_settle.acct_nature_desc is '账户属性描述';
comment on column ${iol_schema}.ncbs_cl_acct_settle.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_cl_acct_settle.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_settle.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_settle.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_settle.etl_timestamp is 'ETL处理时间戳';
