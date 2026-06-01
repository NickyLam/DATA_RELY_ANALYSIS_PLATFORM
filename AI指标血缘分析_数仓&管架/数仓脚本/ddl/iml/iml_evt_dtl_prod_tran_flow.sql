/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_dtl_prod_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_dtl_prod_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_dtl_prod_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_dtl_prod_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,ext_flow_num varchar2(100) -- 外部流水号
    ,dtl_prod_id varchar2(100) -- 明细产品编号
    ,comb_prod_id varchar2(100) -- 组合产品编号
    ,intnal_cust_id varchar2(100) -- 内部客户编号
    ,tran_cd varchar2(60) -- 交易代码
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,sub_flow_num varchar2(100) -- 子流水号
    ,sub_tran_cd varchar2(60) -- 子交易代码
    ,sub_tran_status_cd varchar2(30) -- 子交易状态代码
    ,fin_status_cd varchar2(30) -- 财务状态代码
    ,amt number(30,2) -- 金额
    ,lot number(30,8) -- 份额
    ,comm_fee number(30,2) -- 手续费
    ,cfm_amt number(30,2) -- 确认金额
    ,cfm_lot number(30,8) -- 确认份额
    ,cfm_nv number(18,8) -- 确认净值
    ,cfm_comm_fee number(30,2) -- 确认手续费
    ,cfm_dt date -- 确认日期
    ,revo_amt number(30,2) -- 撤单金额
    ,revo_dt date -- 撤单日期
    ,revo_tm timestamp -- 撤单时间
    ,discnt_rat number(18,6) -- 折扣率
    ,clear_dt date -- 清算日期
    ,check_entry_dt date -- 对账日期
    ,init_tran_host_check_entry_dt date -- 原交易主机对账日期
    ,host_flow_num varchar2(100) -- 主机流水号
    ,send_host_flow_num varchar2(100) -- 发送主机流水号
    ,host_tran_code varchar2(45) -- 主机交易码
    ,host_dt date -- 主机日期
    ,init_tran_flow_num varchar2(100) -- 原交易流水号
    ,err_cd varchar2(45) -- 错误码
    ,err_info_desc varchar2(1500) -- 错误信息描述
    ,memo_comnt varchar2(750) -- 摘要说明
    ,cust_mgr_id varchar2(100) -- 客户经理编号
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
grant select on ${iml_schema}.evt_dtl_prod_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_dtl_prod_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_dtl_prod_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_dtl_prod_tran_flow is '明细产品交易流水';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.ext_flow_num is '外部流水号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.dtl_prod_id is '明细产品编号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.comb_prod_id is '组合产品编号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.sub_flow_num is '子流水号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.sub_tran_cd is '子交易代码';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.sub_tran_status_cd is '子交易状态代码';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.fin_status_cd is '财务状态代码';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.amt is '金额';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.lot is '份额';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.comm_fee is '手续费';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.cfm_nv is '确认净值';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.cfm_comm_fee is '确认手续费';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.revo_amt is '撤单金额';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.revo_dt is '撤单日期';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.revo_tm is '撤单时间';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.discnt_rat is '折扣率';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.check_entry_dt is '对账日期';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.init_tran_host_check_entry_dt is '原交易主机对账日期';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.send_host_flow_num is '发送主机流水号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.host_dt is '主机日期';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.init_tran_flow_num is '原交易流水号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.err_cd is '错误码';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.memo_comnt is '摘要说明';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_dtl_prod_tran_flow.etl_timestamp is 'ETL处理时间戳';
