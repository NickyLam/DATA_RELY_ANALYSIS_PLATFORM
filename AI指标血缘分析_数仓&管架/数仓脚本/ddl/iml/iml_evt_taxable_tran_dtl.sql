/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_taxable_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_taxable_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_taxable_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_taxable_tran_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,taxable_flow_num varchar2(100) -- 应税流水号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,sob_id varchar2(100) -- 账套编号
    ,bus_sys_id varchar2(100) -- 来源系统编号
    ,tran_dt date -- 交易日期
    ,sumos_seq_num varchar2(60) -- 传票序号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,cust_id varchar2(100) -- 客户编号
    ,bus_cate_cd varchar2(30) -- 业务类别代码
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tax_inc_tran_amt number(30,2) -- 含税交易金额
    ,tax_rat number(30,8) -- 税率
    ,tax_amt number(30,2) -- 税额
    ,exclude_tax_tran_amt number(30,2) -- 不含税交易金额
    ,remark varchar2(500) -- 备注
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tax_way_cd varchar2(30) -- 计税方式代码
    ,taxable_idf_cd varchar2(30) -- 应税标识代码
    ,tax_item_id varchar2(100) -- 税目编号
    ,open_invoice_curr_cd varchar2(30) -- 开票币种代码
    ,convt_exch_rat number(18,8) -- 折算汇率
    ,net_price_convt_amt number(30,2) -- 净价折算金额
    ,subj_id varchar2(100) -- 科目编号
    ,subj_name varchar2(500) -- 科目名称
    ,tax_lmt_convt_amt number(30,2) -- 税额折算金额
    ,net_price_subj_id varchar2(100) -- 净价科目编号
    ,tax_lmt_subj_id varchar2(100) -- 税额科目编号
    ,intnal_prod_id varchar2(100) -- 内部产品编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,prod_taxable_type_cd varchar2(30) -- 产品应税类型代码
    ,loan_tis_tax_cd varchar2(30) -- 贷款涉票涉税代码
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
grant select on ${iml_schema}.evt_taxable_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_taxable_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_taxable_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_taxable_tran_dtl is '应税交易明细';
comment on column ${iml_schema}.evt_taxable_tran_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.taxable_flow_num is '应税流水号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.sob_id is '账套编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.bus_sys_id is '来源系统编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_taxable_tran_dtl.sumos_seq_num is '传票序号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.bus_cate_cd is '业务类别代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tax_inc_tran_amt is '含税交易金额';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tax_rat is '税率';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tax_amt is '税额';
comment on column ${iml_schema}.evt_taxable_tran_dtl.exclude_tax_tran_amt is '不含税交易金额';
comment on column ${iml_schema}.evt_taxable_tran_dtl.remark is '备注';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tax_way_cd is '计税方式代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.taxable_idf_cd is '应税标识代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tax_item_id is '税目编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.open_invoice_curr_cd is '开票币种代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.convt_exch_rat is '折算汇率';
comment on column ${iml_schema}.evt_taxable_tran_dtl.net_price_convt_amt is '净价折算金额';
comment on column ${iml_schema}.evt_taxable_tran_dtl.subj_id is '科目编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.subj_name is '科目名称';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tax_lmt_convt_amt is '税额折算金额';
comment on column ${iml_schema}.evt_taxable_tran_dtl.net_price_subj_id is '净价科目编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.tax_lmt_subj_id is '税额科目编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.intnal_prod_id is '内部产品编号';
comment on column ${iml_schema}.evt_taxable_tran_dtl.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.prod_taxable_type_cd is '产品应税类型代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.loan_tis_tax_cd is '贷款涉票涉税代码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_taxable_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_taxable_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_taxable_tran_dtl.etl_timestamp is 'ETL处理时间戳';
