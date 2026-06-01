/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t05_pub_product_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t05_pub_product_sign
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t05_pub_product_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t05_pub_product_sign(
    sign_contract_id varchar2(45) -- 签约id
    ,agreement_id varchar2(30) -- 签约编号
    ,agreement_item_seq_id varchar2(30) -- 协议项编号
    ,taxpayers_no varchar2(30) -- 纳税人编号
    ,cust_type_cd varchar2(2) -- 客户类型
    ,account_name varchar2(180) -- 户名
    ,suffix varchar2(30) -- 后缀
    ,sign_id varchar2(90) -- 协议书编号
    ,sp_id varchar2(90) -- 第三方机构代码
    ,sp_name varchar2(135) -- 第三方机构代码名称
    ,sp_sign_id varchar2(90) -- 第三方机构协议号
    ,txn_limit_single number(19,2) -- 单笔交易限额
    ,txn_credit_smy number(19,2) -- 累计发生额
    ,day_limit number(19,2) -- 客户日累计限额
    ,day_actual_amount number(19,2) -- 客户日累计实际金额
    ,day_txn_limit_frequency varchar2(30) -- 当日交易发起频率上限
    ,day_txn_actual_frequency varchar2(30) -- 当日交易发起实际频率
    ,cup_txn_date varchar2(12) -- 银联交易日期
    ,month_limit number(19,2) -- 月累计限额
    ,account_id varchar2(30) -- 账户标志号
    ,act_char varchar2(30) -- 账户性质
    ,curr_cd varchar2(5) -- 币种
    ,last_business_no varchar2(30) -- 上一次业务编号
    ,last_business_amount number(19,2) -- 上一次业务金额
    ,last_business_name varchar2(180) -- 上一次业务名称
    ,cust_financial_type varchar2(30) -- 客户理财类型
    ,last_evaluate_bank varchar2(180) -- 上一次评估银行
    ,evaluate_time varchar2(30) -- 评估时间
    ,work_unit varchar2(180) -- 工作单位
    ,cash_trans_cd varchar2(30) -- 钞汇标志
    ,sign_amt number(19,2) -- 客户签约金额
    ,settle_act varchar2(90) -- 业务结算账号
    ,sign_speic_payment_acct varchar2(30) -- 签约指定还款账号
    ,sign_speic_payment_item varchar2(180) -- 签约指定还款名称
    ,sp_fund_act varchar2(90) -- 第三方资金账号
    ,sp_entrust_act varchar2(90) -- 第三方托管账号
    ,sign_control_ind varchar2(30) -- 签约服务控制码
    ,txn_limit number(19,2) -- 交易限额
    ,sign_face varchar2(2) -- 面签标志
    ,year_limit number(19,2) -- 年累计限额
    ,txn_times_limit varchar2(30) -- 交易笔数限额
    ,create_te varchar2(12) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
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
grant select on ${iol_schema}.eifs_t05_pub_product_sign to ${iml_schema};
grant select on ${iol_schema}.eifs_t05_pub_product_sign to ${icl_schema};
grant select on ${iol_schema}.eifs_t05_pub_product_sign to ${idl_schema};
grant select on ${iol_schema}.eifs_t05_pub_product_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t05_pub_product_sign is '产品服务签约信息';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sign_contract_id is '签约id';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.agreement_id is '签约编号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.agreement_item_seq_id is '协议项编号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.taxpayers_no is '纳税人编号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.cust_type_cd is '客户类型';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.account_name is '户名';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.suffix is '后缀';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sign_id is '协议书编号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sp_id is '第三方机构代码';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sp_name is '第三方机构代码名称';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sp_sign_id is '第三方机构协议号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.txn_limit_single is '单笔交易限额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.txn_credit_smy is '累计发生额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.day_limit is '客户日累计限额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.day_actual_amount is '客户日累计实际金额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.day_txn_limit_frequency is '当日交易发起频率上限';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.day_txn_actual_frequency is '当日交易发起实际频率';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.cup_txn_date is '银联交易日期';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.month_limit is '月累计限额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.account_id is '账户标志号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.act_char is '账户性质';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.curr_cd is '币种';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_business_no is '上一次业务编号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_business_amount is '上一次业务金额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_business_name is '上一次业务名称';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.cust_financial_type is '客户理财类型';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_evaluate_bank is '上一次评估银行';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.evaluate_time is '评估时间';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.work_unit is '工作单位';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.cash_trans_cd is '钞汇标志';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sign_amt is '客户签约金额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.settle_act is '业务结算账号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sign_speic_payment_acct is '签约指定还款账号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sign_speic_payment_item is '签约指定还款名称';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sp_fund_act is '第三方资金账号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sp_entrust_act is '第三方托管账号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sign_control_ind is '签约服务控制码';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.txn_limit is '交易限额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.sign_face is '面签标志';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.year_limit is '年累计限额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.txn_times_limit is '交易笔数限额';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t05_pub_product_sign.etl_timestamp is 'ETL处理时间戳';
