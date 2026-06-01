/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_inter_income_bus_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_inter_income_bus_tran_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_inter_income_bus_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_inter_income_bus_tran_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,sob_id varchar2(100) -- 账套编号
    ,bus_sys_id varchar2(100) -- 业务系统编号
    ,fin_dt date -- 财务日期
    ,doc_id varchar2(100) -- 单据编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,new_tran_flow_num varchar2(100) -- 新交易流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_tm timestamp -- 交易时间
    ,proc_status_cd varchar2(30) -- 处理状态代码
    ,fee_cd varchar2(100) -- 费用代码
    ,prod_id varchar2(100) -- 产品编号
    ,fin_org_id varchar2(100) -- 财务机构编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_chn_id varchar2(250) -- 交易渠道编号
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_code varchar2(30) -- 交易码
    ,amort_start_dt date -- 摊销开始日期
    ,amort_end_dt date -- 摊销结束日期
    ,amorted_tot_amt number(30,2) -- 待摊总金额
    ,ths_tm_amort_amt number(30,2) -- 本次摊销金额
    ,batch_no varchar2(60) -- 批次号
    ,seq_num varchar2(60) -- 序号
    ,bus_type_cd varchar2(60) -- 业务类型代码
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,update_bus_flow_num varchar2(250) -- 更新业务流水号
    ,sellbl_prod_id varchar2(250) -- 可售产品编号
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
grant select on ${iml_schema}.evt_inter_income_bus_tran_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_inter_income_bus_tran_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_inter_income_bus_tran_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_inter_income_bus_tran_dtl is '中收业务交易明细';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.sob_id is '账套编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.bus_sys_id is '业务系统编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.fin_dt is '财务日期';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.doc_id is '单据编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.new_tran_flow_num is '新交易流水号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.proc_status_cd is '处理状态代码';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.fee_cd is '费用代码';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.fin_org_id is '财务机构编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.tran_chn_id is '交易渠道编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.tran_code is '交易码';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.amort_start_dt is '摊销开始日期';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.amort_end_dt is '摊销结束日期';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.amorted_tot_amt is '待摊总金额';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.ths_tm_amort_amt is '本次摊销金额';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.batch_no is '批次号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.seq_num is '序号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.update_bus_flow_num is '更新业务流水号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.sellbl_prod_id is '可售产品编号';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_inter_income_bus_tran_dtl.etl_timestamp is 'ETL处理时间戳';
