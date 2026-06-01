/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_pub_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_pub_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.ref_pub_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_pub_tran_flow(
    seq_num varchar2(60) -- 序号
    ,lp_id varchar2(100) -- 法人编号
    ,chn_tran_flow_num varchar2(100) -- 渠道交易流水号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,sys_flow_num varchar2(100) -- 系统流水号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,bank_org_id varchar2(100) -- 银行机构编号
    ,src_chn_id varchar2(100) -- 源渠道编号
    ,src_module_cd varchar2(30) -- 源模块代码
    ,chn_dt date -- 渠道日期
    ,prod_id varchar2(100) -- 产品编号
    ,acct_curr_cd varchar2(30) -- 账户币种代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,cust_acct_num varchar2(60) -- 客户账号
    ,sub_acct_num varchar2(60) -- 子账号
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,evt_cate varchar2(100) -- 事件类别
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,tran_curr_cd varchar2(30) -- 交易币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_code varchar2(100) -- 交易码
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,bus_tran_dt date -- 业务交易日期
    ,bus_proc_status_cd varchar2(30) -- 业务处理状态代码
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,revs_flow_num varchar2(100) -- 冲正流水号
    ,revs_flg varchar2(10) -- 冲正标志
    ,sign_cntpty_curr_cd varchar2(30) -- 签约对手币种代码
    ,sys_id varchar2(100) -- 系统编号
    ,init_tran_ref_no varchar2(60) -- 原交易参考号
    ,create_entry_flg varchar2(10) -- 生成分录标志
    ,entry_spdst_start_dt date -- 分录试算开始日期
    ,subj_id varchar2(100) -- 科目编号
    ,gl varchar2(100) -- 总账
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
grant select on ${iml_schema}.ref_pub_tran_flow to ${icl_schema};
grant select on ${iml_schema}.ref_pub_tran_flow to ${idl_schema};
grant select on ${iml_schema}.ref_pub_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_pub_tran_flow is '公共交易流水';
comment on column ${iml_schema}.ref_pub_tran_flow.seq_num is '序号';
comment on column ${iml_schema}.ref_pub_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.ref_pub_tran_flow.chn_tran_flow_num is '渠道交易流水号';
comment on column ${iml_schema}.ref_pub_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.ref_pub_tran_flow.sys_flow_num is '系统流水号';
comment on column ${iml_schema}.ref_pub_tran_flow.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.ref_pub_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.ref_pub_tran_flow.bank_org_id is '银行机构编号';
comment on column ${iml_schema}.ref_pub_tran_flow.src_chn_id is '源渠道编号';
comment on column ${iml_schema}.ref_pub_tran_flow.src_module_cd is '源模块代码';
comment on column ${iml_schema}.ref_pub_tran_flow.chn_dt is '渠道日期';
comment on column ${iml_schema}.ref_pub_tran_flow.prod_id is '产品编号';
comment on column ${iml_schema}.ref_pub_tran_flow.acct_curr_cd is '账户币种代码';
comment on column ${iml_schema}.ref_pub_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.ref_pub_tran_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.ref_pub_tran_flow.cust_acct_num is '客户账号';
comment on column ${iml_schema}.ref_pub_tran_flow.sub_acct_num is '子账号';
comment on column ${iml_schema}.ref_pub_tran_flow.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.ref_pub_tran_flow.evt_cate is '事件类别';
comment on column ${iml_schema}.ref_pub_tran_flow.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.ref_pub_tran_flow.tran_curr_cd is '交易币种代码';
comment on column ${iml_schema}.ref_pub_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.ref_pub_tran_flow.tran_code is '交易码';
comment on column ${iml_schema}.ref_pub_tran_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.ref_pub_tran_flow.bus_tran_dt is '业务交易日期';
comment on column ${iml_schema}.ref_pub_tran_flow.bus_proc_status_cd is '业务处理状态代码';
comment on column ${iml_schema}.ref_pub_tran_flow.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.ref_pub_tran_flow.revs_flow_num is '冲正流水号';
comment on column ${iml_schema}.ref_pub_tran_flow.revs_flg is '冲正标志';
comment on column ${iml_schema}.ref_pub_tran_flow.sign_cntpty_curr_cd is '签约对手币种代码';
comment on column ${iml_schema}.ref_pub_tran_flow.sys_id is '系统编号';
comment on column ${iml_schema}.ref_pub_tran_flow.init_tran_ref_no is '原交易参考号';
comment on column ${iml_schema}.ref_pub_tran_flow.create_entry_flg is '生成分录标志';
comment on column ${iml_schema}.ref_pub_tran_flow.entry_spdst_start_dt is '分录试算开始日期';
comment on column ${iml_schema}.ref_pub_tran_flow.subj_id is '科目编号';
comment on column ${iml_schema}.ref_pub_tran_flow.gl is '总账';
comment on column ${iml_schema}.ref_pub_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_pub_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_pub_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.ref_pub_tran_flow.etl_timestamp is 'ETL处理时间戳';
