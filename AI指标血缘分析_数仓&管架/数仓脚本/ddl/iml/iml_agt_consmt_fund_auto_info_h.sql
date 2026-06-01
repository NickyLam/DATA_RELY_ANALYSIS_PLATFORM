/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_consmt_fund_auto_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_consmt_fund_auto_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_consmt_fund_auto_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_consmt_fund_auto_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,auto_finc_id varchar2(100) -- 自动理财编号
    ,finc_tran_cd varchar2(30) -- 理财交易代码
    ,appl_dt date -- 申请日期
    ,finc_cust_id varchar2(100) -- 理财客户编号
    ,bank_id varchar2(100) -- 银行编号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,cust_grouping_cd varchar2(30) -- 客户分组代码
    ,open_chn_cd varchar2(30) -- 开通渠道代码
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,prod_id varchar2(100) -- 产品编号
    ,ta_cd varchar2(30) -- TA代码
    ,invest_amt number(30,8) -- 投资金额
    ,invest_lot number(30,8) -- 投资份额
    ,huge_redem_proc_flg_cd varchar2(30) -- 巨额赎回处理标志代码
    ,lowt_invest_amt number(30,8) -- 最低投资金额
    ,higt_invest_amt number(30,8) -- 最高投资金额
    ,resv_amt number(30,8) -- 保留金额
    ,tran_discnt_rat number(18,6) -- 交易折扣率
    ,termnt_mode_cd varchar2(30) -- 终止模式代码
    ,invest_day number(10) -- 投资日
    ,invest_perds number(30,2) -- 投资期数
    ,surp_invest_perds number(10) -- 剩余投资期数
    ,sucs_invest_perds number(10) -- 成功投资期数
    ,conti_fail_perds number(10) -- 连续失败期数
    ,invest_ped_cd varchar2(45) -- 期限单位
    ,invest_intrv number(10) -- 投资间隔
    ,next_invest_dt date -- 下一投资日期
    ,last_invest_dt date -- 上一投资日期
    ,latest_tran_comnt varchar2(500) -- 最新交易说明
    ,end_flg_cd varchar2(30) -- 结束标志代码
    ,start_invest_dt date -- 开始投资日期
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_consmt_fund_auto_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_consmt_fund_auto_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_consmt_fund_auto_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_consmt_fund_auto_info_h is '代销基金自动投资信息历史';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.auto_finc_id is '自动理财编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.finc_tran_cd is '理财交易代码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.bank_id is '银行编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.cust_grouping_cd is '客户分组代码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.open_chn_cd is '开通渠道代码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.invest_amt is '投资金额';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.invest_lot is '投资份额';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.huge_redem_proc_flg_cd is '巨额赎回处理标志代码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.lowt_invest_amt is '最低投资金额';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.higt_invest_amt is '最高投资金额';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.resv_amt is '保留金额';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.tran_discnt_rat is '交易折扣率';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.termnt_mode_cd is '终止模式代码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.invest_day is '投资日';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.invest_perds is '投资期数';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.surp_invest_perds is '剩余投资期数';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.sucs_invest_perds is '成功投资期数';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.conti_fail_perds is '连续失败期数';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.invest_ped_cd is '期限单位';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.invest_intrv is '投资间隔';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.next_invest_dt is '下一投资日期';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.last_invest_dt is '上一投资日期';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.latest_tran_comnt is '最新交易说明';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.end_flg_cd is '结束标志代码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.start_invest_dt is '开始投资日期';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_consmt_fund_auto_info_h.etl_timestamp is 'ETL处理时间戳';
