/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wld_dubil_wrt_off
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wld_dubil_wrt_off
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wld_dubil_wrt_off purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_dubil_wrt_off(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,ser_num varchar2(60) -- 序列号
    ,batch_doc_name varchar2(150) -- 批量文件名称
    ,wrt_off_dt date -- 核销日期
    ,cust_id varchar2(60) -- 交易客户编号
    ,cust_name varchar2(750) -- 客户名称
    ,wrt_off_pric number(30,2) -- 核销本金
    ,wrt_off_int number(30,8) -- 核销利息
    ,bank_contri_ratio number(18,6) -- 银行出资比例
    ,bank_id varchar2(60) -- 银行编号
    ,syn_id varchar2(60) -- 银团编号
    ,loan_prod_id varchar2(60) -- 贷款产品编号
    ,card_no varchar2(60) -- 卡号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,wrt_off_status_cd varchar2(30) -- 核销状态代码
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
grant select on ${iml_schema}.evt_wld_dubil_wrt_off to ${icl_schema};
grant select on ${iml_schema}.evt_wld_dubil_wrt_off to ${idl_schema};
grant select on ${iml_schema}.evt_wld_dubil_wrt_off to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wld_dubil_wrt_off is '微粒贷借据核销事件';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.ser_num is '序列号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.cust_name is '客户名称';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.wrt_off_pric is '核销本金';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.wrt_off_int is '核销利息';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.bank_contri_ratio is '银行出资比例';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.bank_id is '银行编号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.syn_id is '银团编号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.loan_prod_id is '贷款产品编号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.card_no is '卡号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.wrt_off_status_cd is '核销状态代码';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wld_dubil_wrt_off.etl_timestamp is 'ETL处理时间戳';
