/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_finc_lot_dtl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_finc_lot_dtl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_finc_lot_dtl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_lot_dtl_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,seller_id varchar2(60) -- 销售商编号
    ,prod_id varchar2(60) -- 产品编号
    ,ta_cfm_flow_num varchar2(60) -- TA确认流水号
    ,finc_cust_id varchar2(60) -- 理财客户编号
    ,cust_id varchar2(60) -- 客户编号
    ,ta_tran_acct_id varchar2(60) -- TA交易账户编号
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,ta_cd varchar2(30) -- TA代码
    ,finc_acct_id varchar2(60) -- 理财账户编号
    ,appl_flow_num varchar2(60) -- 申请流水号
    ,cfm_dt date -- 确认日期
    ,lot_src_cd varchar2(30) -- 份额来源代码
    ,lot_tot number(18,6) -- 份额总数
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,init_divd_way_cd varchar2(30) -- 原分红方式代码
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,unpaid_prft number(30,2) -- 未付收益
    ,froz_unpaid_prft number(30,2) -- 冻结未付收益
    ,new_assign_prft number(30,2) -- 新分配收益
    ,init_cfm_amt number(30,2) -- 原确认金额
    ,init_cfm_lot number(18,6) -- 原确认份额
    ,init_corp_nv number(30,8) -- 原单位净值
    ,init_lot_src_cd varchar2(30) -- 原份额来源代码
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,cust_grouping_cd varchar2(30) -- 客户分组代码
    ,bank_acct_id varchar2(100) -- 银行账户编号
    ,tran_med_type_cd varchar2(30) -- 交易介质类型代码
    ,tran_med_id varchar2(100) -- 交易介质编号
    ,cont_id varchar2(100) -- 合约编号
    ,buy_cost number(30,2) -- 买入成本
    ,ped_finc_exp_dt date -- 周期性理财到期日期
    ,ped_finc_flg varchar2(10) -- 周期性理财标志
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
grant select on ${iml_schema}.agt_finc_lot_dtl_h to ${icl_schema};
grant select on ${iml_schema}.agt_finc_lot_dtl_h to ${idl_schema};
grant select on ${iml_schema}.agt_finc_lot_dtl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_finc_lot_dtl_h is '理财份额明细历史';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.seller_id is '销售商编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.ta_cfm_flow_num is 'TA确认流水号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.finc_cust_id is '理财客户编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.ta_cd is 'TA代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.finc_acct_id is '理财账户编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.cfm_dt is '确认日期';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.lot_src_cd is '份额来源代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.lot_tot is '份额总数';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.init_divd_way_cd is '原分红方式代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.unpaid_prft is '未付收益';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.froz_unpaid_prft is '冻结未付收益';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.new_assign_prft is '新分配收益';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.init_cfm_amt is '原确认金额';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.init_cfm_lot is '原确认份额';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.init_corp_nv is '原单位净值';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.init_lot_src_cd is '原份额来源代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.cust_grouping_cd is '客户分组代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.bank_acct_id is '银行账户编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.tran_med_type_cd is '交易介质类型代码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.tran_med_id is '交易介质编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.cont_id is '合约编号';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.buy_cost is '买入成本';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.ped_finc_exp_dt is '周期性理财到期日期';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.ped_finc_flg is '周期性理财标志';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_finc_lot_dtl_h.etl_timestamp is 'ETL处理时间戳';
