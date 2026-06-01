/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ifs_froz_stop_pay_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,froz_dt date -- 冻结日期
    ,froz_tm varchar2(20) -- 冻结时间
    ,seq_num varchar2(60) -- 顺序号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,rec_cate_cd varchar2(10) -- 记录类别代码
    ,bus_way_cd varchar2(10) -- 业务方式代码
    ,status_cd varchar2(10) -- 状态代码
    ,acct_num varchar2(60) -- 账号
    ,sub_acct_num varchar2(60) -- 子户号
    ,cust_name varchar2(500) -- 客户名称
    ,appl_froz_amt number(30,2) -- 申请冻结金额
    ,surp_froz_amt number(30,2) -- 剩余冻结金额
    ,froz_end_dt date -- 冻结截至日期
    ,proof_cate_cd varchar2(10) -- 证明类别代码
    ,cert_num varchar2(250) -- 证明书号
    ,froz_rs varchar2(375) -- 冻结原因
    ,exec_org varchar2(90) -- 执行机关
    ,exec_cert_type_cd_1 varchar2(10) -- 执行证件类型代码1
    ,exec_num_1 varchar2(48) -- 执行号码1
    ,exec_cert_type_cd_2 varchar2(10) -- 执行证件类型代码2
    ,exec_num_2 varchar2(60) -- 执行号码2
    ,exec_ps_1 varchar2(45) -- 执行人1
    ,exec_ps_2 varchar2(45) -- 执行人2
    ,operr_id varchar2(60) -- 操作员编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,chn_id varchar2(60) -- 渠道编号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b to ${icl_schema};
grant select on ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b to ${idl_schema};
grant select on ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b is '联合存款冻结止付登记簿';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.froz_dt is '冻结日期';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.froz_tm is '冻结时间';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.seq_num is '顺序号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.rec_cate_cd is '记录类别代码';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.bus_way_cd is '业务方式代码';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.status_cd is '状态代码';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.acct_num is '账号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.sub_acct_num is '子户号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.cust_name is '客户名称';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.appl_froz_amt is '申请冻结金额';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.surp_froz_amt is '剩余冻结金额';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.froz_end_dt is '冻结截至日期';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.proof_cate_cd is '证明类别代码';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.cert_num is '证明书号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.froz_rs is '冻结原因';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.exec_org is '执行机关';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.exec_cert_type_cd_1 is '执行证件类型代码1';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.exec_num_1 is '执行号码1';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.exec_cert_type_cd_2 is '执行证件类型代码2';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.exec_num_2 is '执行号码2';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.exec_ps_1 is '执行人1';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.exec_ps_2 is '执行人2';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.operr_id is '操作员编号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ifs_froz_stop_pay_rgst_b.etl_timestamp is 'ETL处理时间戳';
