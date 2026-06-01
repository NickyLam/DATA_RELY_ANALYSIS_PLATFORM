/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_dep_froz_stop_pay_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_dep_froz_stop_pay_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_dep_froz_stop_pay_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_froz_stop_pay_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,froz_stop_pay_dt date -- 冻结止付日期
    ,froz_stop_pay_timestamp timestamp(6) -- 冻结止付时间戳
    ,froz_stop_pay_flow_num varchar2(60) -- 冻结止付流水号
    ,seq_num varchar2(50) -- 顺序号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,acct_id varchar2(60) -- 账户编号
    ,sub_acct_id varchar2(60) -- 子户编号
    ,dep_sub_acct_id varchar2(60) -- 存款分户编号
    ,old_sub_acct_id varchar2(10) -- 旧子户编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cert_id varchar2(250) -- 证明书编号
    ,proof_cate_cd varchar2(10) -- 证明类别代码
    ,status_cd varchar2(10) -- 状态代码
    ,chn_cd varchar2(10) -- 渠道编号
    ,froz_stop_pay_bus_way_cd varchar2(10) -- 冻结止付业务方式代码
    ,froz_stop_pay_cate_cd varchar2(10) -- 冻结止付类别代码
    ,operr_id varchar2(60) -- 操作员编号
    ,apv_teller_id varchar2(60) -- 审批柜员编号
    ,auth_teller_id varchar2(60) -- 授权柜员编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,appl_froz_amt number(30,2) -- 申请冻结金额
    ,surp_froz_amt number(30,2) -- 剩余冻结金额
    ,froz_end_dt date -- 冻结截至日期
    ,froz_rs varchar2(500) -- 冻结原因
    ,exec_org_name varchar2(500) -- 执行机关名称
    ,exec_cert_cd_1 varchar2(10) -- 执行证件代码1
    ,exec_id_1 varchar2(250) -- 执行编号1
    ,exec_cert_cd_2 varchar2(10) -- 执行证件代码2
    ,exec_id_2 varchar2(60) -- 执行编号2
    ,exec_ps_name_1 varchar2(250) -- 执行人名称1
    ,exec_ps_name_2 varchar2(250) -- 执行人名称2
    ,jut_froz_stop_pay_flg varchar2(10) -- 司法冻结止付标志
    ,jut_froz_stop_pay_type_cd varchar2(10) -- 司法冻结止付类型代码
    ,inv_ctrl_sys_id varchar2(60) -- 查控系统编号
    ,inv_ctrl_sys_name varchar2(100) -- 查控系统名称
    ,inv_ctrl_char varchar2(100) -- 查控性质
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_dep_froz_stop_pay_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_dep_froz_stop_pay_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_dep_froz_stop_pay_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_dep_froz_stop_pay_dtl is '存款账户冻结止付明细';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.froz_stop_pay_dt is '冻结止付日期';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.froz_stop_pay_timestamp is '冻结止付时间戳';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.froz_stop_pay_flow_num is '冻结止付流水号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.seq_num is '顺序号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.tran_flow_num is '交易流水号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.sub_acct_id is '子户编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.dep_sub_acct_id is '存款分户编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.old_sub_acct_id is '旧子户编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.cust_name is '客户名称';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.cert_id is '证明书编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.proof_cate_cd is '证明类别代码';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.status_cd is '状态代码';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.chn_cd is '渠道编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.froz_stop_pay_bus_way_cd is '冻结止付业务方式代码';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.froz_stop_pay_cate_cd is '冻结止付类别代码';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.operr_id is '操作员编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.apv_teller_id is '审批柜员编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.auth_teller_id is '授权柜员编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.appl_froz_amt is '申请冻结金额';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.surp_froz_amt is '剩余冻结金额';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.froz_end_dt is '冻结截至日期';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.froz_rs is '冻结原因';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.exec_org_name is '执行机关名称';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.exec_cert_cd_1 is '执行证件代码1';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.exec_id_1 is '执行编号1';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.exec_cert_cd_2 is '执行证件代码2';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.exec_id_2 is '执行编号2';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.exec_ps_name_1 is '执行人名称1';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.exec_ps_name_2 is '执行人名称2';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.jut_froz_stop_pay_flg is '司法冻结止付标志';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.jut_froz_stop_pay_type_cd is '司法冻结止付类型代码';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.inv_ctrl_sys_id is '查控系统编号';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.inv_ctrl_sys_name is '查控系统名称';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.inv_ctrl_char is '查控性质';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_dep_froz_stop_pay_dtl.etl_timestamp is 'ETL处理时间戳';
