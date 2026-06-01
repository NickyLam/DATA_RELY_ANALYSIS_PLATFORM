/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ibank_cntpty_acct_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ibank_cntpty_acct_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ibank_cntpty_acct_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_cntpty_acct_info_h(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_agt_id varchar2(60) -- 源协议编号
    ,org_id varchar2(60) -- 机构编号
    ,bank_acct_id varchar2(250) -- 银行账户编号
    ,bank_acct_name varchar2(750) -- 银行账户名称
    ,curr_cd varchar2(30) -- 币种代码
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,mdl_bank_acct_id varchar2(100) -- 中间行账户编号
    ,mdl_bank_name varchar2(750) -- 中间行名称
    ,mdl_bank_swift_cd varchar2(100) -- 中间行SWIFT代码
    ,open_bank_acct_id varchar2(100) -- 开户行账户编号
    ,open_bank_name varchar2(300) -- 开户行名称
    ,open_bank_swift_cd varchar2(100) -- 开户行SWIFT代码
    ,ghb_recv_bank_acct_name varchar2(750) -- 本方收款行账户名称
    ,ghb_recv_bank_acct_swift_cd varchar2(100) -- 本方收款行SWIFT代码
    ,pay_type_cd varchar2(30) -- 支付类型代码
    ,dlvy_msg_cd varchar2(30) -- 交割报文代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ibank_cntpty_acct_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_ibank_cntpty_acct_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_ibank_cntpty_acct_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ibank_cntpty_acct_info_h is '同业交易对手账户信息历史';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.bank_acct_name is '银行账户名称';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.mdl_bank_acct_id is '中间行账户编号';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.mdl_bank_name is '中间行名称';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.mdl_bank_swift_cd is '中间行SWIFT代码';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.open_bank_acct_id is '开户行账户编号';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.open_bank_name is '开户行名称';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.open_bank_swift_cd is '开户行SWIFT代码';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.ghb_recv_bank_acct_name is '本方收款行账户名称';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.ghb_recv_bank_acct_swift_cd is '本方收款行SWIFT代码';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.pay_type_cd is '支付类型代码';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.dlvy_msg_cd is '交割报文代码';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ibank_cntpty_acct_info_h.etl_timestamp is 'ETL处理时间戳';
