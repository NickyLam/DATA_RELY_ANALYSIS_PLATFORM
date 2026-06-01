/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_finc_cap_clear
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_finc_cap_clear
whenever sqlerror continue none;
drop table ${iml_schema}.evt_finc_cap_clear purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_cap_clear(
    evt_id varchar2(100) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,clear_flow_num varchar2(60) -- 清算流水号
    ,clear_seq_num varchar2(60) -- 清算顺序号
    ,tran_dt date -- 交易日期
    ,clear_dt date -- 清算日期
    ,actl_enter_acct_dt date -- 实际入帐日期
    ,chg_bf_clear_dt date -- 变动前清算日期
    ,flow_num varchar2(60) -- 流水号
    ,rela_flow_num varchar2(60) -- 关联流水号
    ,intior_cd varchar2(10) -- 发起方代码
    ,tran_cd varchar2(100) -- 交易代码
    ,bus_cd varchar2(10) -- 业务代码
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,intnal_cust_id varchar2(60) -- 内部客户编号
    ,bank_id varchar2(60) -- 银行编号
    ,cust_id varchar2(60) -- 交易客户编号
    ,bank_acct_num varchar2(100) -- 银行账号
    ,bank_acct_type_cd varchar2(10) -- 银行帐户类型代码
    ,tran_chn_cd varchar2(10) -- 交易渠道代码
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,termn_id varchar2(60) -- 交易终端编号
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,tran_belong_org_id varchar2(100) -- 交易所属机构编号
    ,ta_cd varchar2(30) -- TA代码
    ,prod_id varchar2(60) -- 产品编号
    ,acct_dir_cd varchar2(10) -- 账务方向代码
    ,clear_amt number(30,2) -- 清算金额
    ,curr_cd varchar2(10) -- 币种代码
    ,ec_idf_cd varchar2(10) -- 钞汇标识代码
    ,unfrz_amt number(30,2) -- 解冻金额
    ,host_tran_code varchar2(15) -- 主机交易码
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(60) -- 主机流水号
    ,froz_amt number(30,2) -- 冻结金额
    ,bal_chk_cfm_cd varchar2(10) -- 勾对确认代码
    ,acct_amt_src_type_cd varchar2(10) -- 上帐金额来源类型代码
    ,cap_cate_cd varchar2(60) -- 资金类别代码
    ,pric_prft_cd varchar2(10) -- 本金收益代码
    ,cfm_lot number(18,3) -- 确认份额
    ,pric_amt number(30,2) -- 本金金额
    ,cfm_prft_amt number(30,2) -- 确认收益金额
    ,lot_accu_accum number(18,3) -- 份额累积积数
    ,prod_acct_num varchar2(60) -- 产品账号
    ,prod_acct_type_cd varchar2(10) -- 产品账户类型代码
    ,memo_comnt varchar2(750) -- 摘要说明
    ,cap_clear_status_cd varchar2(10) -- 资金清算状态代码
    ,init_clear_flow_num varchar2(60) -- 原清算流水号
    ,return_code varchar2(15) -- 返回码
    ,err_info_desc varchar2(750) -- 错误信息描述
    ,intfc_proc_flg varchar2(10) -- 接口处理标志
    ,remark_info_1 varchar2(750) -- 备注信息1
    ,remark_info_2 varchar2(750) -- 备注信息2
    ,remark_info_3 varchar2(750) -- 备注信息3
    ,remark_info_4 varchar2(750) -- 备注信息4
    ,remark_info_5 varchar2(750) -- 备注信息5
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
grant select on ${iml_schema}.evt_finc_cap_clear to ${icl_schema};
grant select on ${iml_schema}.evt_finc_cap_clear to ${idl_schema};
grant select on ${iml_schema}.evt_finc_cap_clear to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_finc_cap_clear is '理财资金清算';
comment on column ${iml_schema}.evt_finc_cap_clear.evt_id is '事件编号';
comment on column ${iml_schema}.evt_finc_cap_clear.lp_id is '法人编号';
comment on column ${iml_schema}.evt_finc_cap_clear.clear_flow_num is '清算流水号';
comment on column ${iml_schema}.evt_finc_cap_clear.clear_seq_num is '清算顺序号';
comment on column ${iml_schema}.evt_finc_cap_clear.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_finc_cap_clear.clear_dt is '清算日期';
comment on column ${iml_schema}.evt_finc_cap_clear.actl_enter_acct_dt is '实际入帐日期';
comment on column ${iml_schema}.evt_finc_cap_clear.chg_bf_clear_dt is '变动前清算日期';
comment on column ${iml_schema}.evt_finc_cap_clear.flow_num is '流水号';
comment on column ${iml_schema}.evt_finc_cap_clear.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.evt_finc_cap_clear.intior_cd is '发起方代码';
comment on column ${iml_schema}.evt_finc_cap_clear.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_finc_cap_clear.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_finc_cap_clear.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_finc_cap_clear.intnal_cust_id is '内部客户编号';
comment on column ${iml_schema}.evt_finc_cap_clear.bank_id is '银行编号';
comment on column ${iml_schema}.evt_finc_cap_clear.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_finc_cap_clear.bank_acct_num is '银行账号';
comment on column ${iml_schema}.evt_finc_cap_clear.bank_acct_type_cd is '银行帐户类型代码';
comment on column ${iml_schema}.evt_finc_cap_clear.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_finc_cap_clear.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_finc_cap_clear.termn_id is '交易终端编号';
comment on column ${iml_schema}.evt_finc_cap_clear.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_finc_cap_clear.tran_belong_org_id is '交易所属机构编号';
comment on column ${iml_schema}.evt_finc_cap_clear.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_finc_cap_clear.prod_id is '产品编号';
comment on column ${iml_schema}.evt_finc_cap_clear.acct_dir_cd is '账务方向代码';
comment on column ${iml_schema}.evt_finc_cap_clear.clear_amt is '清算金额';
comment on column ${iml_schema}.evt_finc_cap_clear.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_finc_cap_clear.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.evt_finc_cap_clear.unfrz_amt is '解冻金额';
comment on column ${iml_schema}.evt_finc_cap_clear.host_tran_code is '主机交易码';
comment on column ${iml_schema}.evt_finc_cap_clear.host_dt is '主机日期';
comment on column ${iml_schema}.evt_finc_cap_clear.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_finc_cap_clear.froz_amt is '冻结金额';
comment on column ${iml_schema}.evt_finc_cap_clear.bal_chk_cfm_cd is '勾对确认代码';
comment on column ${iml_schema}.evt_finc_cap_clear.acct_amt_src_type_cd is '上帐金额来源类型代码';
comment on column ${iml_schema}.evt_finc_cap_clear.cap_cate_cd is '资金类别代码';
comment on column ${iml_schema}.evt_finc_cap_clear.pric_prft_cd is '本金收益代码';
comment on column ${iml_schema}.evt_finc_cap_clear.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_finc_cap_clear.pric_amt is '本金金额';
comment on column ${iml_schema}.evt_finc_cap_clear.cfm_prft_amt is '确认收益金额';
comment on column ${iml_schema}.evt_finc_cap_clear.lot_accu_accum is '份额累积积数';
comment on column ${iml_schema}.evt_finc_cap_clear.prod_acct_num is '产品账号';
comment on column ${iml_schema}.evt_finc_cap_clear.prod_acct_type_cd is '产品账户类型代码';
comment on column ${iml_schema}.evt_finc_cap_clear.memo_comnt is '摘要说明';
comment on column ${iml_schema}.evt_finc_cap_clear.cap_clear_status_cd is '资金清算状态代码';
comment on column ${iml_schema}.evt_finc_cap_clear.init_clear_flow_num is '原清算流水号';
comment on column ${iml_schema}.evt_finc_cap_clear.return_code is '返回码';
comment on column ${iml_schema}.evt_finc_cap_clear.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_finc_cap_clear.intfc_proc_flg is '接口处理标志';
comment on column ${iml_schema}.evt_finc_cap_clear.remark_info_1 is '备注信息1';
comment on column ${iml_schema}.evt_finc_cap_clear.remark_info_2 is '备注信息2';
comment on column ${iml_schema}.evt_finc_cap_clear.remark_info_3 is '备注信息3';
comment on column ${iml_schema}.evt_finc_cap_clear.remark_info_4 is '备注信息4';
comment on column ${iml_schema}.evt_finc_cap_clear.remark_info_5 is '备注信息5';
comment on column ${iml_schema}.evt_finc_cap_clear.start_dt is '开始时间';
comment on column ${iml_schema}.evt_finc_cap_clear.end_dt is '结束时间';
comment on column ${iml_schema}.evt_finc_cap_clear.id_mark is '增删标志';
comment on column ${iml_schema}.evt_finc_cap_clear.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_finc_cap_clear.job_cd is '任务编码';
comment on column ${iml_schema}.evt_finc_cap_clear.etl_timestamp is 'ETL处理时间戳';
