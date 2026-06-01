/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_inter_bus_inco_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_inter_bus_inco_dtl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_inter_bus_inco_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_inter_bus_inco_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_bill_flow_num varchar2(60) -- 账单流水号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,tran_dt date -- 交易日期
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,charge_doc_num varchar2(100) -- 收费单据号
    ,charge_flow_num varchar2(100) -- 收费流水号
    ,acct_dt date -- 账务日期
    ,amort_flow_num varchar2(60) -- 摊销流水号
    ,amort_start_dt date -- 摊销开始日期
    ,amort_end_dt date -- 摊销结束日期
    ,charge_dt date -- 收费日期
    ,subj_id varchar2(60) -- 科目编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(250) -- 客户名称
    ,bus_acct_id varchar2(60) -- 业务账户编号
    ,intnal_acct_id varchar2(60) -- 内部账户编号
    ,intnal_acct_name varchar2(100) -- 内部账户名称
    ,intnal_main_acct_id varchar2(60) -- 内部主账户编号
    ,tran_acct_id varchar2(60) -- 交易账户编号
    ,tran_main_acct_id varchar2(60) -- 交易主账户编号
    ,tran_sub_acct_id varchar2(60) -- 交易子账户编号
    ,tran_chn_cd varchar2(10) -- 交易渠道编号
    ,bal_dir_cd varchar2(10) -- 余额方向代码
    ,sorc_sys_cd varchar2(30) -- 来源系统编号
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,charge_cd varchar2(60) -- 收费代码
    ,charge_name varchar2(100) -- 收费名称
    ,charge_cate_cd varchar2(10) -- 收费类别代码
    ,charge_way_cd varchar2(10) -- 收费方式代码
    ,tran_type_cd varchar2(10) -- 交易类型代码
    ,amort_flg varchar2(10) -- 摊销标志
    ,debit_crdt_flg varchar2(10) -- 借贷标志
    ,erase_acct_flg varchar2(10) -- 抹账标志
    ,revs_flg varchar2(10) -- 冲正标志
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,curr_cd varchar2(10) -- 币种代码
    ,acm_amort_amt number(30,2) -- 累计摊销金额
    ,amorted_tot_amt number(30,2) -- 待摊总金额
    ,tran_amt number(30,2) -- 交易金额
    ,recvbl_comm_fee_amt number(18,2) -- 应收手续费金额
    ,tax_amt number(18,2) -- 税额
    ,at_amt number(18,2) -- 税后金额
    ,tran_remark_info varchar2(100) -- 交易备注信息
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
grant select on ${icl_schema}.cmm_inter_bus_inco_dtl to ${idl_schema};
grant select on ${icl_schema}.cmm_inter_bus_inco_dtl to ${iel_schema};
grant select on ${icl_schema}.cmm_inter_bus_inco_dtl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_inter_bus_inco_dtl is '中间业务收入明细';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.acct_bill_flow_num is '账单流水号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_flow_num is '交易流水号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.ova_flow_num is '全局流水号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.bus_flow_num is '业务流水号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.charge_doc_num is '收费单据号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.charge_flow_num is '收费流水号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.acct_dt is '账务日期';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.amort_flow_num is '摊销流水号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.amort_start_dt is '摊销开始日期';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.amort_end_dt is '摊销结束日期';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.charge_dt is '收费日期';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.cust_name is '客户名称';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.bus_acct_id is '业务账户编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.intnal_acct_id is '内部账户编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.intnal_acct_name is '内部账户名称';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.intnal_main_acct_id is '内部主账户编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_acct_id is '交易账户编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_main_acct_id is '交易主账户编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_sub_acct_id is '交易子账户编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_chn_cd is '交易渠道编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.bal_dir_cd is '余额方向代码';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.sorc_sys_cd is '来源系统编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.charge_cd is '收费代码';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.charge_name is '收费名称';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.charge_cate_cd is '收费类别代码';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.charge_way_cd is '收费方式代码';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_type_cd is '交易类型代码';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.amort_flg is '摊销标志';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.debit_crdt_flg is '借贷标志';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.erase_acct_flg is '抹账标志';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.revs_flg is '冲正标志';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_org_id is '交易机构编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.acm_amort_amt is '累计摊销金额';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.amorted_tot_amt is '待摊总金额';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.recvbl_comm_fee_amt is '应收手续费金额';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tax_amt is '税额';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.at_amt is '税后金额';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.tran_remark_info is '交易备注信息';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_inter_bus_inco_dtl.etl_timestamp is 'ETL处理时间戳';
