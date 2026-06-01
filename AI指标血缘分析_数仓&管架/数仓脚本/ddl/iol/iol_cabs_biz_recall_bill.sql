/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cabs_biz_recall_bill
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cabs_biz_recall_bill
whenever sqlerror continue none;
drop table ${iol_schema}.cabs_biz_recall_bill purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cabs_biz_recall_bill(
    id varchar2(72) -- id编号
    ,account varchar2(72) -- 账户
    ,brchno varchar2(15) -- 分行机构号
    ,curr_flag varchar2(3) -- 活期标识 0活期 1非活期
    ,clerk_mobile varchar2(60) -- 企业对账员手机号码
    ,message varchar2(3072) -- 发送信息
    ,no_sign varchar2(3) -- 没有签约
    ,org_code varchar2(15) -- 开户机构
    ,oper_clerk varchar2(15) -- 操作柜员
    ,oper_date date -- 操作日期
    ,oper_rlt varchar2(3) -- 发送结果
    ,bill_no varchar2(72) -- 账单编号
    ,cust_name varchar2(384) -- 客户姓名
    ,cust_address varchar2(1500) -- 客户地址
    ,acc_nanme varchar2(384) -- 账户名称
    ,currency varchar2(5) -- 币种
    ,balance number(21,2) -- 余额
    ,brs_fqcy varchar2(2) -- 对账频率
    ,term_no varchar2(9) -- 账期
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
grant select on ${iol_schema}.cabs_biz_recall_bill to ${iml_schema};
grant select on ${iol_schema}.cabs_biz_recall_bill to ${icl_schema};
grant select on ${iol_schema}.cabs_biz_recall_bill to ${idl_schema};
grant select on ${iol_schema}.cabs_biz_recall_bill to ${iel_schema};

-- comment
comment on table ${iol_schema}.cabs_biz_recall_bill is '账单催收表';
comment on column ${iol_schema}.cabs_biz_recall_bill.id is 'id编号';
comment on column ${iol_schema}.cabs_biz_recall_bill.account is '账户';
comment on column ${iol_schema}.cabs_biz_recall_bill.brchno is '分行机构号';
comment on column ${iol_schema}.cabs_biz_recall_bill.curr_flag is '活期标识 0活期 1非活期';
comment on column ${iol_schema}.cabs_biz_recall_bill.clerk_mobile is '企业对账员手机号码';
comment on column ${iol_schema}.cabs_biz_recall_bill.message is '发送信息';
comment on column ${iol_schema}.cabs_biz_recall_bill.no_sign is '没有签约';
comment on column ${iol_schema}.cabs_biz_recall_bill.org_code is '开户机构';
comment on column ${iol_schema}.cabs_biz_recall_bill.oper_clerk is '操作柜员';
comment on column ${iol_schema}.cabs_biz_recall_bill.oper_date is '操作日期';
comment on column ${iol_schema}.cabs_biz_recall_bill.oper_rlt is '发送结果';
comment on column ${iol_schema}.cabs_biz_recall_bill.bill_no is '账单编号';
comment on column ${iol_schema}.cabs_biz_recall_bill.cust_name is '客户姓名';
comment on column ${iol_schema}.cabs_biz_recall_bill.cust_address is '客户地址';
comment on column ${iol_schema}.cabs_biz_recall_bill.acc_nanme is '账户名称';
comment on column ${iol_schema}.cabs_biz_recall_bill.currency is '币种';
comment on column ${iol_schema}.cabs_biz_recall_bill.balance is '余额';
comment on column ${iol_schema}.cabs_biz_recall_bill.brs_fqcy is '对账频率';
comment on column ${iol_schema}.cabs_biz_recall_bill.term_no is '账期';
comment on column ${iol_schema}.cabs_biz_recall_bill.start_dt is '开始时间';
comment on column ${iol_schema}.cabs_biz_recall_bill.end_dt is '结束时间';
comment on column ${iol_schema}.cabs_biz_recall_bill.id_mark is '增删标志';
comment on column ${iol_schema}.cabs_biz_recall_bill.etl_timestamp is 'ETL处理时间戳';
