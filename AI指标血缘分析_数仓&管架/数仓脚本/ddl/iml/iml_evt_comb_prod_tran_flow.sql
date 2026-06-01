/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_comb_prod_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_comb_prod_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_comb_prod_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_comb_prod_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,cont_id varchar2(100) -- 合约编号
    ,comb_prod_id varchar2(100) -- 组合产品编号
    ,tran_cd varchar2(60) -- 交易代码
    ,tran_dt date -- 交易日期
    ,tran_tm timestamp -- 交易时间
    ,sys_tran_dt date -- 系统交易日期
    ,vtual_bank_acct_id varchar2(100) -- 虚拟银行账户编号
    ,ctrl_flg_comb varchar2(1500) -- 控制标志组合
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,intnal_cust_id varchar2(100) -- 内部客户编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(750) -- 客户名称
    ,cap_acct_id varchar2(100) -- 银行账户编号
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,tran_med_type_cd varchar2(30) -- 交易介质类型代码
    ,tran_acct_id varchar2(100) -- 交易账户编号
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,init_tran_flow_num varchar2(100) -- 原交易流水号
    ,init_tran_dt date -- 原交易日期
    ,tran_amt number(30,2) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,init_tran_chn_cd varchar2(30) -- 原交易渠道代码
    ,init_tran_org_id varchar2(100) -- 原交易机构编号
    ,init_tran_host_check_entry_dt date -- 原交易主机对账日期
    ,send_finc_plat_flow_num varchar2(100) -- 发送理财平台流水号
    ,finc_plat_check_entry_dt date -- 理财平台对账日期
    ,finc_plat_flow_num varchar2(100) -- 理财平台流水号
    ,finc_plat_tran_code varchar2(45) -- 理财平台交易码
    ,finc_plat_dt date -- 理财平台日期
    ,send_host_flow_num varchar2(100) -- 发送主机流水号
    ,host_check_entry_dt date -- 主机对账日期
    ,host_flow_num varchar2(100) -- 主机流水号
    ,host_tran_code varchar2(45) -- 主机交易码
    ,host_dt date -- 主机日期
    ,fin_status_cd varchar2(30) -- 财务状态代码
    ,target_bank_acct_id varchar2(100) -- 目标银行账户编号
    ,sp_acct_id varchar2(100) -- 认申购账户编号
    ,huge_redem_flg varchar2(10) -- 巨额赎回标志
    ,redem_acct_id varchar2(100) -- 赎回账户编号
    ,comb_redem_coll_acct_id varchar2(100) -- 组合赎回归集账户编号
    ,cfm_amt number(30,2) -- 确认金额
    ,cfm_dt date -- 确认日期
    ,err_cd varchar2(45) -- 错误码
    ,err_info_desc varchar2(1500) -- 错误信息描述
    ,memo_comnt varchar2(750) -- 摘要说明
    ,brch_org_id varchar2(100) -- 分行机构编号
    ,open_acct_belong_org_id varchar2(100) -- 所属机构编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,oper_teller_id varchar2(100) -- 操作柜员编号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
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
grant select on ${iml_schema}.evt_comb_prod_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_comb_prod_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_comb_prod_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_comb_prod_tran_flow is '组合产品交易流水';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.cont_id is '合约编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.comb_prod_id is '组合产品编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.sys_tran_dt is '系统交易日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.vtual_bank_acct_id is '虚拟银行账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.ctrl_flg_comb is '控制标志组合';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.cap_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.tran_acct_id is '交易账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.init_tran_flow_num is '原交易流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.init_tran_dt is '原交易日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.init_tran_chn_cd is '原交易渠道代码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.init_tran_org_id is '原交易机构编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.init_tran_host_check_entry_dt is '原交易主机对账日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.send_finc_plat_flow_num is '发送理财平台流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.finc_plat_check_entry_dt is '理财平台对账日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.finc_plat_flow_num is '理财平台流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.finc_plat_tran_code is '理财平台交易码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.finc_plat_dt is '理财平台日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.send_host_flow_num is '发送主机流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.host_check_entry_dt is '主机对账日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.host_dt is '主机日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.fin_status_cd is '财务状态代码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.target_bank_acct_id is '目标银行账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.sp_acct_id is '认申购账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.huge_redem_flg is '巨额赎回标志';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.redem_acct_id is '赎回账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.comb_redem_coll_acct_id is '组合赎回归集账户编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.err_cd is '错误码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.memo_comnt is '摘要说明';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.brch_org_id is '分行机构编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.open_acct_belong_org_id is '所属机构编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_comb_prod_tran_flow.etl_timestamp is 'ETL处理时间戳';
