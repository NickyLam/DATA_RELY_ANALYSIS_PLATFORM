/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_distr_finc_tran_req_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_distr_finc_tran_req_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_distr_finc_tran_req_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_distr_finc_tran_req_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_cd varchar2(30) -- 业务代码
    ,ta_cd varchar2(30) -- TA代码
    ,appl_dt date -- 申请日期
    ,appl_tm date -- 申请时间
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,seller_id varchar2(100) -- 销售商编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,finc_acct_id varchar2(100) -- 理财账户编号
    ,ta_tran_acct_id varchar2(100) -- TA交易账户编号
    ,prod_id varchar2(100) -- 产品编号
    ,finc_prod_id varchar2(100) -- 理财产品编号
    ,lot_cate_cd varchar2(30) -- 份额类别代码
    ,appl_amt number(30,2) -- 申请金额
    ,appl_shares number(30,2) -- 申请份数
    ,init_appl_flow_num varchar2(100) -- 原申请流水号
    ,init_cfm_flow_num varchar2(100) -- 原确认流水号
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,ta_init_flg varchar2(10) -- TA发起标志
    ,ext_bus_cd varchar2(30) -- 外部业务代码
    ,ta_manu_check_flg varchar2(10) -- TA人工审核标志
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,finc_cust_id varchar2(100) -- 理财客户编号
    ,cfm_dt date -- 确认日期
    ,status_cd varchar2(30) -- 状态代码
    ,cfm_amt number(30,2) -- 确认金额
    ,tran_chn_cd varchar2(30) -- 交易渠道编号
    ,bank_id varchar2(100) -- 银行编号
    ,redem_mode_cd varchar2(30) -- 赎回模式代码
    ,return_info varchar2(150) -- 返回信息
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
grant select on ${iml_schema}.evt_distr_finc_tran_req_h to ${icl_schema};
grant select on ${iml_schema}.evt_distr_finc_tran_req_h to ${idl_schema};
grant select on ${iml_schema}.evt_distr_finc_tran_req_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_distr_finc_tran_req_h is '分销理财交易请求历史';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.bus_cd is '业务代码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.appl_dt is '申请日期';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.appl_tm is '申请时间';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.seller_id is '销售商编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.prod_id is '产品编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.lot_cate_cd is '份额类别代码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.appl_amt is '申请金额';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.appl_shares is '申请份数';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.init_appl_flow_num is '原申请流水号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.init_cfm_flow_num is '原确认流水号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.ta_init_flg is 'TA发起标志';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.ext_bus_cd is '外部业务代码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.ta_manu_check_flg is 'TA人工审核标志';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.status_cd is '状态代码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.cfm_amt is '确认金额';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.tran_chn_cd is '交易渠道编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.bank_id is '银行编号';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.redem_mode_cd is '赎回模式代码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.return_info is '返回信息';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_distr_finc_tran_req_h.etl_timestamp is 'ETL处理时间戳';
