/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_out_acct_ibank_ifin_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,actl_finer_id varchar2(100) -- 实际融资人编号
    ,int_accr_ped_cd varchar2(30) -- 计息周期代码
    ,lpr_ref_way_cd varchar2(30) -- LPR参照方式代码
    ,acct_b_cate_cd varchar2(60) -- 账簿类别代码
    ,open_bank_name_cd varchar2(30) -- 开户行名称代码
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recver_open_bank_name varchar2(500) -- 收款人开户行名称
    ,recver_open_bank_no varchar2(60) -- 收款人开户行行号
    ,distr_acct_name varchar2(500) -- 放款账户名称
    ,distr_acct_open_bank_name varchar2(500) -- 放款账户开户行名称
    ,distr_acct_id varchar2(100) -- 放款账户编号
    ,repay_cnt_type_cd varchar2(30) -- 还款次数类型代码
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
grant select on ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h is '贷款出账同业投融资附属信息历史';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.appl_id is '申请编号';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.actl_finer_id is '实际融资人编号';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.int_accr_ped_cd is '计息周期代码';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.lpr_ref_way_cd is 'LPR参照方式代码';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.acct_b_cate_cd is '账簿类别代码';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.open_bank_name_cd is '开户行名称代码';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.recver_open_bank_name is '收款人开户行名称';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.recver_open_bank_no is '收款人开户行行号';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.distr_acct_name is '放款账户名称';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.distr_acct_open_bank_name is '放款账户开户行名称';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.distr_acct_id is '放款账户编号';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.repay_cnt_type_cd is '还款次数类型代码';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_out_acct_ibank_ifin_attach_info_h.etl_timestamp is 'ETL处理时间戳';
