/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_entry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_entry
whenever sqlerror continue none;
drop table ${iml_schema}.evt_entry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_entry(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,entry_id varchar2(60) -- 记账分录编号
    ,belong_hq_bank_no varchar2(60) -- 所属总行行号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,entry_tran_id varchar2(60) -- 记账交易编号
    ,tran_attr_string varchar2(150) -- 交易属性字符串
    ,prod_id varchar2(60) -- 产品编号
    ,batch_id varchar2(60) -- 批次编号
    ,cont_id varchar2(60) -- 合同编号
    ,dtl_id varchar2(100) -- 明细编号
    ,bill_id varchar2(60) -- 票据编号
    ,bill_num varchar2(60) -- 票据号码
    ,fac_val_amt number(30,2) -- 票面金额
    ,entry_seq_num number(10) -- 分录顺序号
    ,get_val_field varchar2(90) -- 取值字段
    ,debit_crdt_dir_cd varchar2(10) -- 借贷方向代码
    ,prtcptr_role_cd varchar2(60) -- 参与方角色代码
    ,prtcptr_amt number(30,2) -- 参与方金额
    ,entry_flg varchar2(10) -- 分录标志
    ,subj_id varchar2(60) -- 科目编号
    ,subj_name varchar2(150) -- 科目名称
    ,cust_id varchar2(100) -- 客户编号
    ,target_acct_num varchar2(100) -- 目标账户号
    ,prtcptr_acct_type_cd varchar2(60) -- 参与方账户类型代码
    ,org_id varchar2(60) -- 机构编号
    ,prtcptr_type_cd varchar2(30) -- 参与方类型代码
    ,prtcptr_ext varchar2(375) -- 参与方扩展
    ,ext_amt_1 number(30,2) -- 扩展金额1
    ,ext_amt_2 number(30,2) -- 扩展金额2
    ,ext_amt_3 number(30,2) -- 扩展金额3
    ,batch_entry_flg varchar2(10) -- 批次记账标志
    ,dtl_status_flg varchar2(10) -- 明细状态标志
    ,create_tm timestamp -- 创建时间
    ,update_tm timestamp -- 更新时间
    ,final_modif_operr_id varchar2(60) -- 最后修改操作员编号
    ,sys_id varchar2(150) -- 系统编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,init_bill_sys_rgst_cter_id varchar2(60) -- 原票据系统登记中心编号
    ,h_data_flg varchar2(100) -- 历史数据标志
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
grant select on ${iml_schema}.evt_entry to ${icl_schema};
grant select on ${iml_schema}.evt_entry to ${idl_schema};
grant select on ${iml_schema}.evt_entry to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_entry is '记账分录事件';
comment on column ${iml_schema}.evt_entry.evt_id is '事件编号';
comment on column ${iml_schema}.evt_entry.lp_id is '法人编号';
comment on column ${iml_schema}.evt_entry.entry_id is '记账分录编号';
comment on column ${iml_schema}.evt_entry.belong_hq_bank_no is '所属总行行号';
comment on column ${iml_schema}.evt_entry.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_entry.entry_tran_id is '记账交易编号';
comment on column ${iml_schema}.evt_entry.tran_attr_string is '交易属性字符串';
comment on column ${iml_schema}.evt_entry.prod_id is '产品编号';
comment on column ${iml_schema}.evt_entry.batch_id is '批次编号';
comment on column ${iml_schema}.evt_entry.cont_id is '合同编号';
comment on column ${iml_schema}.evt_entry.dtl_id is '明细编号';
comment on column ${iml_schema}.evt_entry.bill_id is '票据编号';
comment on column ${iml_schema}.evt_entry.bill_num is '票据号码';
comment on column ${iml_schema}.evt_entry.fac_val_amt is '票面金额';
comment on column ${iml_schema}.evt_entry.entry_seq_num is '分录顺序号';
comment on column ${iml_schema}.evt_entry.get_val_field is '取值字段';
comment on column ${iml_schema}.evt_entry.debit_crdt_dir_cd is '借贷方向代码';
comment on column ${iml_schema}.evt_entry.prtcptr_role_cd is '参与方角色代码';
comment on column ${iml_schema}.evt_entry.prtcptr_amt is '参与方金额';
comment on column ${iml_schema}.evt_entry.entry_flg is '分录标志';
comment on column ${iml_schema}.evt_entry.subj_id is '科目编号';
comment on column ${iml_schema}.evt_entry.subj_name is '科目名称';
comment on column ${iml_schema}.evt_entry.cust_id is '客户编号';
comment on column ${iml_schema}.evt_entry.target_acct_num is '目标账户号';
comment on column ${iml_schema}.evt_entry.prtcptr_acct_type_cd is '参与方账户类型代码';
comment on column ${iml_schema}.evt_entry.org_id is '机构编号';
comment on column ${iml_schema}.evt_entry.prtcptr_type_cd is '参与方类型代码';
comment on column ${iml_schema}.evt_entry.prtcptr_ext is '参与方扩展';
comment on column ${iml_schema}.evt_entry.ext_amt_1 is '扩展金额1';
comment on column ${iml_schema}.evt_entry.ext_amt_2 is '扩展金额2';
comment on column ${iml_schema}.evt_entry.ext_amt_3 is '扩展金额3';
comment on column ${iml_schema}.evt_entry.batch_entry_flg is '批次记账标志';
comment on column ${iml_schema}.evt_entry.dtl_status_flg is '明细状态标志';
comment on column ${iml_schema}.evt_entry.create_tm is '创建时间';
comment on column ${iml_schema}.evt_entry.update_tm is '更新时间';
comment on column ${iml_schema}.evt_entry.final_modif_operr_id is '最后修改操作员编号';
comment on column ${iml_schema}.evt_entry.sys_id is '系统编号';
comment on column ${iml_schema}.evt_entry.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.evt_entry.init_bill_sys_rgst_cter_id is '原票据系统登记中心编号';
comment on column ${iml_schema}.evt_entry.h_data_flg is '历史数据标志';
comment on column ${iml_schema}.evt_entry.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_entry.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_entry.job_cd is '任务编码';
comment on column ${iml_schema}.evt_entry.etl_timestamp is 'ETL处理时间戳';
