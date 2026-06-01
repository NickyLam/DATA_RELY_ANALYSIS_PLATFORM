/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_billsys_business_transaction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_billsys_business_transaction
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_billsys_business_transaction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_billsys_business_transaction(
    id number(22) -- 
    ,business_type varchar2(3) -- 业务类型 1-代保管申请 2-代保管出库 4-代保管转质押 5-质押转代保管
    ,app_status varchar2(2) -- 申请状态 1-申请中  2-驳回   3-审批中   4-审批完成
    ,draft_id number(22) -- 票据信息表id
    ,draft_number varchar2(45) -- 票号
    ,draft_attr varchar2(2) -- 票据属性  1-纸票   2-电票
    ,draft_type varchar2(2) -- 票据类型   1-银票 2-商票
    ,remit_date varchar2(12) -- 出票日期
    ,maturity_date varchar2(12) -- 票面到期日
    ,remitter_cmonid varchar2(15) -- 出票人组织机构代码
    ,remitter_name varchar2(270) -- 出票人名称
    ,remitter_bank_no varchar2(30) -- 出票人开户行号
    ,remitter_bank_name varchar2(270) -- 出票人开户行名称
    ,remitter_account varchar2(60) -- 出票人账号
    ,acceptor varchar2(270) -- 承兑人
    ,acceptor_bank_no varchar2(30) -- 承兑人开户行号
    ,acceptor_actno varchar2(60) -- 承兑人账号
    ,acceptor_bank_name varchar2(270) -- 承兑人开户行名称
    ,payee_name varchar2(270) -- 票面收款人名称
    ,payee_account varchar2(60) -- 票面收款人账号
    ,payee_bank_no varchar2(30) -- 票面收款人开户行号
    ,payee_bank_name varchar2(270) -- 票面收款人开户行
    ,face_amount number(18,2) -- 票面金额
    ,end_or_sement_mk varchar2(6) -- 人行可转让标志  em00可再转让  em01不得转让
    ,pledge_seq_no varchar2(75) -- 质押流水号
    ,reason varchar2(384) -- 驳回理由
    ,cust_no varchar2(30) -- 客户号
    ,branch_id number(22) -- 所属机构
    ,last_upd_oper_id number(22) -- 最后修改操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,applock varchar2(3) -- 任务锁  01-办理加锁 00-办理未加锁 (00为可挑选）
    ,int_tm timestamp -- 插入时间    初始插入时间戳   yyyy-mm-dd hh:mm:ss.0
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
grant select on ${iol_schema}.bdps_billsys_business_transaction to ${iml_schema};
grant select on ${iol_schema}.bdps_billsys_business_transaction to ${icl_schema};
grant select on ${iol_schema}.bdps_billsys_business_transaction to ${idl_schema};
grant select on ${iol_schema}.bdps_billsys_business_transaction to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_billsys_business_transaction is '票据系统业务交易信息表';
comment on column ${iol_schema}.bdps_billsys_business_transaction.id is '';
comment on column ${iol_schema}.bdps_billsys_business_transaction.business_type is '业务类型 1-代保管申请 2-代保管出库 4-代保管转质押 5-质押转代保管';
comment on column ${iol_schema}.bdps_billsys_business_transaction.app_status is '申请状态 1-申请中  2-驳回   3-审批中   4-审批完成';
comment on column ${iol_schema}.bdps_billsys_business_transaction.draft_id is '票据信息表id';
comment on column ${iol_schema}.bdps_billsys_business_transaction.draft_number is '票号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.draft_attr is '票据属性  1-纸票   2-电票';
comment on column ${iol_schema}.bdps_billsys_business_transaction.draft_type is '票据类型   1-银票 2-商票';
comment on column ${iol_schema}.bdps_billsys_business_transaction.remit_date is '出票日期';
comment on column ${iol_schema}.bdps_billsys_business_transaction.maturity_date is '票面到期日';
comment on column ${iol_schema}.bdps_billsys_business_transaction.remitter_cmonid is '出票人组织机构代码';
comment on column ${iol_schema}.bdps_billsys_business_transaction.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdps_billsys_business_transaction.remitter_bank_no is '出票人开户行号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.remitter_bank_name is '出票人开户行名称';
comment on column ${iol_schema}.bdps_billsys_business_transaction.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.acceptor is '承兑人';
comment on column ${iol_schema}.bdps_billsys_business_transaction.acceptor_bank_no is '承兑人开户行号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.acceptor_actno is '承兑人账号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.acceptor_bank_name is '承兑人开户行名称';
comment on column ${iol_schema}.bdps_billsys_business_transaction.payee_name is '票面收款人名称';
comment on column ${iol_schema}.bdps_billsys_business_transaction.payee_account is '票面收款人账号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.payee_bank_no is '票面收款人开户行号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.payee_bank_name is '票面收款人开户行';
comment on column ${iol_schema}.bdps_billsys_business_transaction.face_amount is '票面金额';
comment on column ${iol_schema}.bdps_billsys_business_transaction.end_or_sement_mk is '人行可转让标志  em00可再转让  em01不得转让';
comment on column ${iol_schema}.bdps_billsys_business_transaction.pledge_seq_no is '质押流水号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.reason is '驳回理由';
comment on column ${iol_schema}.bdps_billsys_business_transaction.cust_no is '客户号';
comment on column ${iol_schema}.bdps_billsys_business_transaction.branch_id is '所属机构';
comment on column ${iol_schema}.bdps_billsys_business_transaction.last_upd_oper_id is '最后修改操作员';
comment on column ${iol_schema}.bdps_billsys_business_transaction.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdps_billsys_business_transaction.applock is '任务锁  01-办理加锁 00-办理未加锁 (00为可挑选）';
comment on column ${iol_schema}.bdps_billsys_business_transaction.int_tm is '插入时间    初始插入时间戳   yyyy-mm-dd hh:mm:ss.0';
comment on column ${iol_schema}.bdps_billsys_business_transaction.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_billsys_business_transaction.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_billsys_business_transaction.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_billsys_business_transaction.etl_timestamp is 'ETL处理时间戳';
