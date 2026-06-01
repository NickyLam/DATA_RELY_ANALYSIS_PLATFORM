/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_froz_stop_pay_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_froz_stop_pay_rgst_b
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_froz_stop_pay_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_froz_stop_pay_rgst_b(
    froz_dt varchar2(12) -- 冻结日期
    ,froz_flow_num varchar2(90) -- 冻结流水
    ,seq_num number(22) -- 顺序号
    ,tran_flow_num varchar2(90) -- 交易流水
    ,rec_type varchar2(2) -- 记录类别
    ,bus_type varchar2(2) -- 业务方式
    ,status_cd varchar2(2) -- 状态
    ,acct_id varchar2(90) -- 账号
    ,dep_prod_sub_acct_id varchar2(90) -- 子户号
    ,acct_name varchar2(384) -- 客户名
    ,appl_froz_amt number(18,2) -- 申请冻结金额
    ,surp_froz_amt number(18,2) -- 剩余冻结金额
    ,froz_end_dt varchar2(12) -- 冻结截至日
    ,proof_type varchar2(2) -- 证明类别
    ,proof_id varchar2(300) -- 证明书号
    ,froz_rs varchar2(150) -- 冻结原因
    ,exec_org_cd varchar2(768) -- 执行机关
    ,exec_cert_type_01 varchar2(6) -- 执行证件一
    ,exec_cert_no_01 varchar2(72) -- 执行号码一
    ,exec_cert_type_02 varchar2(6) -- 执行证件二
    ,exec_cert_no_02 varchar2(72) -- 执行号码二
    ,exec_ps_01 varchar2(30) -- 执行人一
    ,exec_ps_02 varchar2(30) -- 执行人二
    ,operr_no varchar2(15) -- 操作员
    ,tran_org varchar2(15) -- 交易机构
    ,chn_cd varchar2(9) -- 渠道码
    ,froz_tm varchar2(32) -- 冻结时间
    ,ori_tran_flow varchar2(90) -- 平台上送交易流水
    ,law_enforce_type varchar2(75) -- 执法部门类型
    ,law_enforce_name varchar2(768) -- 执法部门名称
    ,deduct_doc_type varchar2(45) -- 划扣通知书类型
    ,deduct_doc_code varchar2(300) -- 划扣通知书编号
    ,blacklist_type varchar2(2) -- 黑名单类型
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifcs_froz_stop_pay_rgst_b to ${iml_schema};
grant select on ${iol_schema}.ifcs_froz_stop_pay_rgst_b to ${icl_schema};
grant select on ${iol_schema}.ifcs_froz_stop_pay_rgst_b to ${idl_schema};
grant select on ${iol_schema}.ifcs_froz_stop_pay_rgst_b to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_froz_stop_pay_rgst_b is '冻结止付登记簿';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.froz_dt is '冻结日期';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.froz_flow_num is '冻结流水';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.seq_num is '顺序号';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.tran_flow_num is '交易流水';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.rec_type is '记录类别';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.bus_type is '业务方式';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.status_cd is '状态';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.acct_id is '账号';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.dep_prod_sub_acct_id is '子户号';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.acct_name is '客户名';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.appl_froz_amt is '申请冻结金额';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.surp_froz_amt is '剩余冻结金额';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.froz_end_dt is '冻结截至日';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.proof_type is '证明类别';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.proof_id is '证明书号';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.froz_rs is '冻结原因';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.exec_org_cd is '执行机关';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.exec_cert_type_01 is '执行证件一';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.exec_cert_no_01 is '执行号码一';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.exec_cert_type_02 is '执行证件二';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.exec_cert_no_02 is '执行号码二';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.exec_ps_01 is '执行人一';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.exec_ps_02 is '执行人二';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.operr_no is '操作员';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.tran_org is '交易机构';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.chn_cd is '渠道码';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.froz_tm is '冻结时间';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.ori_tran_flow is '平台上送交易流水';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.law_enforce_type is '执法部门类型';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.law_enforce_name is '执法部门名称';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.deduct_doc_type is '划扣通知书类型';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.deduct_doc_code is '划扣通知书编号';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.blacklist_type is '黑名单类型';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_froz_stop_pay_rgst_b.etl_timestamp is 'ETL处理时间戳';
