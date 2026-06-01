/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2a_dpst_acct_i
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2a_dpst_acct_i
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2a_dpst_acct_i purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_dpst_acct_i(
    acct_id varchar2(96) -- 账户编号
    ,cust_id varchar2(48) -- 客户编号
    ,cust_name varchar2(768) -- 客户名称
    ,org_id varchar2(24) -- 开户机构编号
    ,acct_type varchar2(9) -- 账户类型
    ,acct_sts varchar2(2) -- 账户状态（参见[字典:aml0075]）
    ,subject_id varchar2(30) -- 科目编号
    ,prd_id varchar2(30) -- 产品编号
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
    ,card_no varchar2(96) -- 银行卡号码
    ,agent_name varchar2(192) -- 代办人姓名
    ,agent_nat varchar2(5) -- 代办人国籍
    ,agent_cert_type varchar2(9) -- 代办人证件种类
    ,agent_cert_no varchar2(192) -- 代办人证件号码
    ,rsrv_01 varchar2(48) -- 是否自贸区账户
    ,rsrv_02 varchar2(48) -- 备用字段2
    ,rsrv_03 varchar2(96) -- 备用字段3
    ,rsrv_04 varchar2(96) -- 备用字段4
    ,opr_id varchar2(96) -- 开户柜员号
    ,open_tm varchar2(30) -- 开户时间
    ,close_tm varchar2(30) -- 销户时间
    ,card_style varchar2(3) -- 借贷记卡标识
    ,main_acct_id varchar2(96) -- 主账号
    ,acc_type1 varchar2(3) -- 个人账户种类(11：代表i类账户；12：代表ii类账户；13：代表iii类账户；14：代表信用卡账户)
    ,is_merch varchar2(3) -- 银行卡收单账户标识(11：是；12：否)
    ,is_ebank varchar2(3) -- 账户网银标识(11：开通；12：未开通)
    ,mobile_bank_phone varchar2(24) -- 手机银行电话号码
    ,open_chnl varchar2(3) -- 开户渠道
    ,agent_flag varchar2(3) -- 是否代理开户(代理11；本人12；批量开户13)
    ,agent_tel varchar2(90) -- 代理人联系方式
    ,last_occur_dt date -- atm机具所属行行号
    ,oth_agent_cert_type varchar2(192) -- 代办人其他身份证件/证明文件类型件类型编码
    ,oth_card_style varchar2(192) -- 其他银行卡类型
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
grant select on ${iol_schema}.amls_t2a_dpst_acct_i to ${iml_schema};
grant select on ${iol_schema}.amls_t2a_dpst_acct_i to ${icl_schema};
grant select on ${iol_schema}.amls_t2a_dpst_acct_i to ${idl_schema};
grant select on ${iol_schema}.amls_t2a_dpst_acct_i to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2a_dpst_acct_i is 't2a_对私存款账户';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.acct_id is '账户编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.org_id is '开户机构编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.acct_type is '账户类型';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.acct_sts is '账户状态（参见[字典:aml0075]）';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.subject_id is '科目编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.prd_id is '产品编号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.curr_iden is '钞汇标识（参见[字典:aml0077]）';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.curr_cd is '币种';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.open_amt is '定期类存款开户金额';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.bal_amt is '余额';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.last_bal_amt is '昨日余额';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.avl_amt is '可用余额';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.open_dt is '开户日期';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.int_dt is '定期类存款当期起息日';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.mature_dt is '定期类存款当期到期日';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.term_cd is '定期类存款存期代码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.close_dt is '销户日期';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.card_no is '银行卡号码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.agent_name is '代办人姓名';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.agent_nat is '代办人国籍';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.agent_cert_type is '代办人证件种类';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.agent_cert_no is '代办人证件号码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.rsrv_01 is '是否自贸区账户';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.rsrv_02 is '备用字段2';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.rsrv_03 is '备用字段3';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.rsrv_04 is '备用字段4';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.opr_id is '开户柜员号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.open_tm is '开户时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.close_tm is '销户时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.card_style is '借贷记卡标识';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.main_acct_id is '主账号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.acc_type1 is '个人账户种类(11：代表i类账户；12：代表ii类账户；13：代表iii类账户；14：代表信用卡账户)';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.is_merch is '银行卡收单账户标识(11：是；12：否)';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.is_ebank is '账户网银标识(11：开通；12：未开通)';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.mobile_bank_phone is '手机银行电话号码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.open_chnl is '开户渠道';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.agent_flag is '是否代理开户(代理11；本人12；批量开户13)';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.agent_tel is '代理人联系方式';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.last_occur_dt is 'atm机具所属行行号';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.oth_agent_cert_type is '代办人其他身份证件/证明文件类型件类型编码';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.oth_card_style is '其他银行卡类型';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t2a_dpst_acct_i.etl_timestamp is 'ETL处理时间戳';
