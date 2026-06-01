/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_u_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_u_contract
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_u_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_u_contract(
    sgn_no varchar2(55) -- 签约协议号
    ,issr_id varchar2(14) -- 发起方所属机构编号
    ,sgn_date varchar2(8) -- 签约日期:YYYYMMDD
    ,sgn_time varchar2(6) -- 签约时间:HHMMSS
    ,sgn_status varchar2(1) -- 签约状态：0-正常（成功），1-失败，2-已解约，3-过期
    ,rcver_acct_issr_id varchar2(14) -- 签约人银行账户所属机构标识
    ,sgn_acct_tp varchar2(2) -- 签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金
    ,rcver_acct_id varchar2(64) -- 签约账号
    ,rcver_nm varchar2(500) -- 签约账户户名
    ,acct_lvl varchar2(1) -- 签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户
    ,id_tp varchar2(4) -- 证件类型
    ,id_no varchar2(44) -- 证件号码
    ,mob_no varchar2(24) -- 手机号
    ,sder_acct_issr_id varchar2(20) -- 支付账户所属机构标识
    ,expire_date varchar2(8) -- 协议失效日期
    ,insert_time varchar2(14) -- 入库时间
    ,update_time varchar2(14) -- 更新时间
    ,enabled_state varchar2(10) -- ACTIVE
    ,sder_issr_id varchar2(14) -- 签约发起机构标识
    ,biz_tp varchar2(10) -- 原签约的业务bizTp
    ,sgn_typ varchar2(4) -- 类型
    ,sder_acct_id varchar2(34) -- 发起方账户号
    ,sder_acct_issr_nm varchar2(300) -- 发起机构名称
    ,open_org_id varchar2(12) -- 开户机构编号
    ,global_seq_no varchar2(32) -- 全局流水号
    ,tran_teller_no varchar2(10) -- 发起柜员
    ,tran_seq_no varchar2(60) -- 业务流水
    ,trx_id varchar2(40) -- 交易流水
    ,pty_id varchar2(16) -- 客户号
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
grant select on ${iol_schema}.ppps_u_contract to ${iml_schema};
grant select on ${iol_schema}.ppps_u_contract to ${icl_schema};
grant select on ${iol_schema}.ppps_u_contract to ${idl_schema};
grant select on ${iol_schema}.ppps_u_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_u_contract is 'CUP签约表';
comment on column ${iol_schema}.ppps_u_contract.sgn_no is '签约协议号';
comment on column ${iol_schema}.ppps_u_contract.issr_id is '发起方所属机构编号';
comment on column ${iol_schema}.ppps_u_contract.sgn_date is '签约日期:YYYYMMDD';
comment on column ${iol_schema}.ppps_u_contract.sgn_time is '签约时间:HHMMSS';
comment on column ${iol_schema}.ppps_u_contract.sgn_status is '签约状态：0-正常（成功），1-失败，2-已解约，3-过期';
comment on column ${iol_schema}.ppps_u_contract.rcver_acct_issr_id is '签约人银行账户所属机构标识';
comment on column ${iol_schema}.ppps_u_contract.sgn_acct_tp is '签约账户类型:01-个人借记，02-个人贷记，03-个人准待机，05-银行预付费账户，10-个人支付，11-单位支付，20-对公账户，21-备付金';
comment on column ${iol_schema}.ppps_u_contract.rcver_acct_id is '签约账号';
comment on column ${iol_schema}.ppps_u_contract.rcver_nm is '签约账户户名';
comment on column ${iol_schema}.ppps_u_contract.acct_lvl is '签约账户等级:0-缺省，1-I类户，2-II类户，3-III类户';
comment on column ${iol_schema}.ppps_u_contract.id_tp is '证件类型';
comment on column ${iol_schema}.ppps_u_contract.id_no is '证件号码';
comment on column ${iol_schema}.ppps_u_contract.mob_no is '手机号';
comment on column ${iol_schema}.ppps_u_contract.sder_acct_issr_id is '支付账户所属机构标识';
comment on column ${iol_schema}.ppps_u_contract.expire_date is '协议失效日期';
comment on column ${iol_schema}.ppps_u_contract.insert_time is '入库时间';
comment on column ${iol_schema}.ppps_u_contract.update_time is '更新时间';
comment on column ${iol_schema}.ppps_u_contract.enabled_state is 'ACTIVE';
comment on column ${iol_schema}.ppps_u_contract.sder_issr_id is '签约发起机构标识';
comment on column ${iol_schema}.ppps_u_contract.biz_tp is '原签约的业务bizTp';
comment on column ${iol_schema}.ppps_u_contract.sgn_typ is '类型';
comment on column ${iol_schema}.ppps_u_contract.sder_acct_id is '发起方账户号';
comment on column ${iol_schema}.ppps_u_contract.sder_acct_issr_nm is '发起机构名称';
comment on column ${iol_schema}.ppps_u_contract.open_org_id is '开户机构编号';
comment on column ${iol_schema}.ppps_u_contract.global_seq_no is '全局流水号';
comment on column ${iol_schema}.ppps_u_contract.tran_teller_no is '发起柜员';
comment on column ${iol_schema}.ppps_u_contract.tran_seq_no is '业务流水';
comment on column ${iol_schema}.ppps_u_contract.trx_id is '交易流水';
comment on column ${iol_schema}.ppps_u_contract.pty_id is '客户号';
comment on column ${iol_schema}.ppps_u_contract.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_u_contract.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_u_contract.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_u_contract.etl_timestamp is 'ETL处理时间戳';
