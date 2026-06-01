/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_finc_tran_cfm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_finc_tran_cfm
whenever sqlerror continue none;
drop table ${iml_schema}.evt_finc_tran_cfm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_tran_cfm(
    ta_cd varchar2(30) -- TA代码
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,cfm_dt date -- 确认日期
    ,ta_cfm_flow_num varchar2(60) -- TA确认流水号
    ,init_cfm_flow_num varchar2(100) -- 原确认流水号
    ,intior_cd varchar2(10) -- 发起方代码
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(10) -- 交易时间
    ,clear_day_term date -- 清算日期
    ,flow_num varchar2(60) -- 流水号
    ,tran_cd varchar2(100) -- 交易代码
    ,bus_cd varchar2(10) -- 业务代码
    ,tran_org_id varchar2(60) -- 交易机构编号
    ,tran_open_acct_org_id varchar2(100) -- 交易账户开户机构编号
    ,tran_chn_cd varchar2(10) -- 交易渠道代码
    ,tran_teller_id varchar2(60) -- 交易柜员编号
    ,int_party_acct_id varchar2(60) -- 内当事人户编号
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,bank_cd varchar2(100) -- 银行代码
    ,party_id varchar2(60) -- 当事人编号
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,ta_tran_acct_id varchar2(60) -- TA交易账户编号
    ,tran_med_type_cd varchar2(10) -- 交易介质类型代码
    ,tran_med_id varchar2(60) -- 交易介质编号
    ,ec_flg varchar2(10) -- 钞汇标志
    ,finc_prod_id varchar2(60) -- 理财产品编号
    ,prod_nv number(30,2) -- 产品净值
    ,tran_price number(26,12) -- 交易价格
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(10) -- 币种代码
    ,cfm_amt number(30,2) -- 确认金额
    ,tran_lot number(30,2) -- 交易份额
    ,cfm_lot number(30,2) -- 确认份额
    ,huge_redem_proc_flg varchar2(10) -- 巨额赎回处理标志
    ,force_redem_rs_cd varchar2(10) -- 强行赎回原因代码
    ,cotin_froz_amt number(30,2) -- 继续冻结金额
    ,lot_accu_accum number(30,2) -- 份额累积积数
    ,dtl_flg varchar2(10) -- 明细标志
    ,froz_rs_cd varchar2(10) -- 冻结原因代码
    ,tran_dir_cd varchar2(10) -- 转换方向代码
    ,deflt_divd_way_cd varchar2(10) -- 默认分红方式代码
    ,return_cd varchar2(15) -- 返回代码
    ,remark_info varchar2(1000) -- 备注信息
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,rela_dt date -- 关联日期
    ,rela_flow_num varchar2(60) -- 关联流水号
    ,cont_id varchar2(60) -- 合约编号
    ,host_dt date -- 主机日期
    ,host_flow_num varchar2(60) -- 主机流水号
    ,tran_post_lot number(30,2) -- 交易后份额
    ,rsrv_amt3 number(30,2) -- 预留金额3
    ,resv2 varchar2(375) -- 备用2
    ,resv_region3 varchar2(375) -- 保留域3
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,target_bank_acct_id varchar2(100) -- 目标银行账户编号
    ,tot_cost number(30,2) -- 总费用
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
grant select on ${iml_schema}.evt_finc_tran_cfm to ${icl_schema};
grant select on ${iml_schema}.evt_finc_tran_cfm to ${idl_schema};
grant select on ${iml_schema}.evt_finc_tran_cfm to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_finc_tran_cfm is '理财交易确认事件';
comment on column ${iml_schema}.evt_finc_tran_cfm.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.evt_id is '事件编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.lp_id is '法人编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_finc_tran_cfm.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm.init_cfm_flow_num is '原确认流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm.intior_cd is '发起方代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_finc_tran_cfm.clear_day_term is '清算日期';
comment on column ${iml_schema}.evt_finc_tran_cfm.flow_num is '流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_cd is '交易代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_open_acct_org_id is '交易账户开户机构编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.int_party_acct_id is '内当事人户编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.bank_cd is '银行代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.party_id is '当事人编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_med_id is '交易介质编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.ec_flg is '钞汇标志';
comment on column ${iml_schema}.evt_finc_tran_cfm.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.prod_nv is '产品净值';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_price is '交易价格';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_finc_tran_cfm.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_lot is '交易份额';
comment on column ${iml_schema}.evt_finc_tran_cfm.cfm_lot is '确认份额';
comment on column ${iml_schema}.evt_finc_tran_cfm.huge_redem_proc_flg is '巨额赎回处理标志';
comment on column ${iml_schema}.evt_finc_tran_cfm.force_redem_rs_cd is '强行赎回原因代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.cotin_froz_amt is '继续冻结金额';
comment on column ${iml_schema}.evt_finc_tran_cfm.lot_accu_accum is '份额累积积数';
comment on column ${iml_schema}.evt_finc_tran_cfm.dtl_flg is '明细标志';
comment on column ${iml_schema}.evt_finc_tran_cfm.froz_rs_cd is '冻结原因代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_dir_cd is '转换方向代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.deflt_divd_way_cd is '默认分红方式代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.return_cd is '返回代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.remark_info is '备注信息';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.rela_dt is '关联日期';
comment on column ${iml_schema}.evt_finc_tran_cfm.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm.cont_id is '合约编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.host_dt is '主机日期';
comment on column ${iml_schema}.evt_finc_tran_cfm.host_flow_num is '主机流水号';
comment on column ${iml_schema}.evt_finc_tran_cfm.tran_post_lot is '交易后份额';
comment on column ${iml_schema}.evt_finc_tran_cfm.rsrv_amt3 is '预留金额3';
comment on column ${iml_schema}.evt_finc_tran_cfm.resv2 is '备用2';
comment on column ${iml_schema}.evt_finc_tran_cfm.resv_region3 is '保留域3';
comment on column ${iml_schema}.evt_finc_tran_cfm.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_finc_tran_cfm.target_bank_acct_id is '目标银行账户编号';
comment on column ${iml_schema}.evt_finc_tran_cfm.tot_cost is '总费用';
comment on column ${iml_schema}.evt_finc_tran_cfm.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_finc_tran_cfm.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_finc_tran_cfm.job_cd is '任务编码';
comment on column ${iml_schema}.evt_finc_tran_cfm.etl_timestamp is 'ETL处理时间戳';
