/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_am_fin_prod_tran_attach_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_am_fin_prod_tran_attach_h
whenever sqlerror continue none;
drop table ${iml_schema}.evt_am_fin_prod_tran_attach_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_am_fin_prod_tran_attach_h(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_id varchar2(100) -- 交易编号
    ,pnlt_amt number(30,2) -- 罚息金额
    ,custm_cashflow_type_cd varchar2(60) -- 自定义现金流类型代码
    ,expect_purch_cfm_day date -- 预计申购确认日
    ,expect_redem_arriv_dt date -- 预计赎回到账日
    ,eqty_rgst_day date -- 权益登记日
    ,expect_divd_day date -- 预计分红日
    ,creator_name varchar2(20) -- 创建人名称
    ,create_dept varchar2(60) -- 创建部门
    ,create_tm timestamp -- 创建时间
    ,updater_name varchar2(20) -- 更新人名称
    ,update_tm timestamp -- 更新时间
    ,redem_prft number(30,2) -- 赎回收益
    ,redem_cost number(30,2) -- 赎回成本
    ,eqty_rgst_day_amt number(30,2) -- 权益登记日金额
    ,fin_prod_id varchar2(100) -- 金融产品编号
    ,brch_seq_num varchar2(100) -- 分支序号
    ,asset_refer_id varchar2(100) -- 资产推荐方编号
    ,expect_turn_stock_val number(30,2) -- 预计转股价值
    ,margin_amt number(30,2) -- 保证金余额
    ,adv_termnt_int_rat number(30,2) -- 提前终止利率
    ,inv_port_id varchar2(100) -- 投资组合编号
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
grant select on ${iml_schema}.evt_am_fin_prod_tran_attach_h to ${icl_schema};
grant select on ${iml_schema}.evt_am_fin_prod_tran_attach_h to ${idl_schema};
grant select on ${iml_schema}.evt_am_fin_prod_tran_attach_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_am_fin_prod_tran_attach_h is '资管金融产品交易附属历史';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.evt_id is '事件编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.lp_id is '法人编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.tran_id is '交易编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.pnlt_amt is '罚息金额';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.custm_cashflow_type_cd is '自定义现金流类型代码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.expect_purch_cfm_day is '预计申购确认日';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.expect_redem_arriv_dt is '预计赎回到账日';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.eqty_rgst_day is '权益登记日';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.expect_divd_day is '预计分红日';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.creator_name is '创建人名称';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.create_dept is '创建部门';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.create_tm is '创建时间';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.updater_name is '更新人名称';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.update_tm is '更新时间';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.redem_prft is '赎回收益';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.redem_cost is '赎回成本';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.eqty_rgst_day_amt is '权益登记日金额';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.brch_seq_num is '分支序号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.asset_refer_id is '资产推荐方编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.expect_turn_stock_val is '预计转股价值';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.margin_amt is '保证金余额';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.adv_termnt_int_rat is '提前终止利率';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.inv_port_id is '投资组合编号';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.start_dt is '开始时间';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.end_dt is '结束时间';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.id_mark is '增删标志';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.job_cd is '任务编码';
comment on column ${iml_schema}.evt_am_fin_prod_tran_attach_h.etl_timestamp is 'ETL处理时间戳';
