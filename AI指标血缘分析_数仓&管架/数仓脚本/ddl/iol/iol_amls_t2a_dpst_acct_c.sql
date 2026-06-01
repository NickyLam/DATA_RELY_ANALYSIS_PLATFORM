/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2a_dpst_acct_c
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2a_dpst_acct_c
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2a_dpst_acct_c purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_dpst_acct_c(
    acct_id varchar2(96) -- 账户编号
    ,cust_id varchar2(48) -- 客户编号
    ,cust_name varchar2(768) -- 客户名称
    ,org_id varchar2(24) -- 开户机构编号
    ,acct_type varchar2(9) -- 账户类型
    ,base_acct_type varchar2(2) -- 基本账户类型（参见[字典:aml0074]）
    ,ib_property_cd varchar2(6) -- 外汇账户性质代码
    ,acct_sts varchar2(2) -- 账户状态（参见[字典:aml0075]）
    ,subject_id varchar2(30) -- 科目编号
    ,prd_id varchar2(30) -- 产品编号
    ,corp_type varchar2(3) -- 企业账户类型（参见[字典:aml0076]）
    ,curr_iden varchar2(2) -- 钞汇标识（参见[字典:aml0077]）
    ,curr_cd varchar2(5) -- 币种
    ,open_amt number(30,4) -- 定期类存款开户金额
    ,bal_amt number(30,4) -- 余额
    ,last_bal_amt number(30,4) -- 昨日余额
    ,avl_amt number(30,4) -- 可用余额
    ,open_dt date -- 开户日期
    ,int_dt date -- 定期类存款当期起息日
    ,mature_dt date -- 定期类存款当期到期日
    ,term_cd number(6,0) -- 定期类存款存期代码
    ,close_dt date -- 销户日期
    ,agent_name varchar2(192) -- 代办人姓名
    ,agent_nat varchar2(144) -- 代办人国籍
    ,agent_cert_type varchar2(9) -- 代办人证件种类
    ,oth_agent_cert_type varchar2(192) -- 代办人其他身份证件/证明文件类型件类型编码
    ,agent_cert_no varchar2(192) -- 代办人证件号码
    ,rsrv_01 varchar2(48) -- 是否自贸区账户
    ,rsrv_02 varchar2(48) -- 备用字段2
    ,rsrv_03 varchar2(96) -- 备用字段3
    ,rsrv_04 varchar2(96) -- 备用字段4
    ,opr_id varchar2(96) -- 开户柜员号
    ,open_tm varchar2(21) -- 开户时间
    ,close_tm varchar2(21) -- 销户时间
    ,card_style varchar2(3) -- 借贷记卡标识
    ,oth_card_style varchar2(192) -- 银行卡其他类型
    ,card_no varchar2(96) -- 银行卡号码
    ,main_acct_id varchar2(96) -- 主账号
    ,is_merch varchar2(3) -- 银行卡收单账户标识(11：是；12：否)
    ,is_ebank varchar2(3) -- 账户网银标识（否0；是1）
    ,mobile_bank_phone varchar2(24) -- 手机银行电话号码
    ,open_chnl varchar2(3) -- 开户渠道
    ,agent_flag varchar2(3) -- 是否代理开户(代理11；本人12；批量开户13)
    ,agent_tel varchar2(90) -- 代理人联系方式
    ,last_occur_dt date -- 最后一次交易发生的时间
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
grant select on ${iol_schema}.amls_t2a_dpst_acct_c to ${iml_schema};
grant select on ${iol_schema}.amls_t2a_dpst_acct_c to ${icl_schema};
grant select on ${iol_schema}.amls_t2a_dpst_acct_c to ${idl_schema};
grant select on ${iol_schema}.amls_t2a_dpst_acct_c to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2a_dpst_acct_c is 't2a_对公存款账户';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.acct_id is '账户编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.org_id is '开户机构编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.acct_type is '账户类型';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.base_acct_type is '基本账户类型（参见[字典:aml0074]）';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.ib_property_cd is '外汇账户性质代码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.acct_sts is '账户状态（参见[字典:aml0075]）';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.subject_id is '科目编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.prd_id is '产品编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.corp_type is '企业账户类型（参见[字典:aml0076]）';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.curr_iden is '钞汇标识（参见[字典:aml0077]）';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.curr_cd is '币种';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.open_amt is '定期类存款开户金额';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.bal_amt is '余额';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.last_bal_amt is '昨日余额';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.avl_amt is '可用余额';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.open_dt is '开户日期';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.int_dt is '定期类存款当期起息日';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.mature_dt is '定期类存款当期到期日';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.term_cd is '定期类存款存期代码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.close_dt is '销户日期';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.agent_name is '代办人姓名';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.agent_nat is '代办人国籍';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.agent_cert_type is '代办人证件种类';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.oth_agent_cert_type is '代办人其他身份证件/证明文件类型件类型编码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.agent_cert_no is '代办人证件号码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.rsrv_01 is '是否自贸区账户';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.rsrv_02 is '备用字段2';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.rsrv_03 is '备用字段3';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.rsrv_04 is '备用字段4';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.opr_id is '开户柜员号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.open_tm is '开户时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.close_tm is '销户时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.card_style is '借贷记卡标识';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.oth_card_style is '银行卡其他类型';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.card_no is '银行卡号码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.main_acct_id is '主账号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.is_merch is '银行卡收单账户标识(11：是；12：否)';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.is_ebank is '账户网银标识（否0；是1）';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.mobile_bank_phone is '手机银行电话号码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.open_chnl is '开户渠道';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.agent_flag is '是否代理开户(代理11；本人12；批量开户13)';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.agent_tel is '代理人联系方式';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.last_occur_dt is '最后一次交易发生的时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t2a_dpst_acct_c.etl_timestamp is 'ETL处理时间戳';
