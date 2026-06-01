/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_fx_ib_lend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_fx_ib_lend
whenever sqlerror continue none;
drop table ${iml_schema}.agt_fx_ib_lend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fx_ib_lend(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,org_id varchar2(60) -- 机构编号
    ,input_dt date -- 录入日期
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,fir_pay_int_dt date -- 首次付息日期
    ,curr_cd varchar2(10) -- 币种代码
    ,ib_lend_int_rat number(18,8) -- 拆借利率
    ,ib_lend_amt number(30,2) -- 拆借金额
    ,convt_usd_curr_amt number(30,2) -- 折美元货币金额
    ,term_end_stl_amt number(30,2) -- 期末结算金额
    ,ib_lend_days number(18,0) -- 拆借天数
    ,daily_int_amt number(18,8) -- 每日利息金额
    ,acru_int_tot number(18,8) -- 应计利息总额
    ,tran_aim_cd varchar2(10) -- 交易目的代码
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,bag_id varchar2(60) -- 成交编号
    ,tran_mode_cd varchar2(10) -- 交易模式代码
    ,tran_src_cd varchar2(10) -- 交易来源代码
    ,tran_site_cd varchar2(10) -- 交易场所代码
    ,clear_way_cd varchar2(10) -- 清算方式代码
    ,rela_tran_id varchar2(60) -- 关联交易编号
    ,portf_tran_id varchar2(60) -- 投组交易编号
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(750) -- 投组名称
    ,portf_type_name varchar2(150) -- 投组类型名称
    ,portf_status_cd varchar2(10) -- 投组状态代码
    ,portf_rela_tran_id varchar2(60) -- 投组关联交易编号
    ,ib_lend_type_cd varchar2(10) -- 拆借类型代码
    ,clear_org_cd varchar2(10) -- 清算机构代码
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,int_rat_tenor_cd varchar2(30) -- 利率期限代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,int_rat_float_point number(38,8) -- 利率浮动点数
    ,pay_int_freq varchar2(60) -- 付息频率
    ,pay_stub_proc_way_cd varchar2(10) -- 付息残段处理方式代码
    ,curr_bal number(30,2) -- 当前余额
    ,inpwn_way_descb varchar2(45) -- 质押方式描述
    ,bond_curr_cd varchar2(30) -- 债券币种代码
    ,convt_ratio number(18,2) -- 折算比例
    ,bond_id varchar2(100) -- 债券编号
    ,fac_val number(30,8) -- 面值
    ,cert_face_tot number(30,8) -- 券面总额
    ,convt_amt varchar2(750) -- 折算金额1
    ,dealer_id varchar2(100) -- 交易员编号
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_fx_ib_lend to ${icl_schema};
grant select on ${iml_schema}.agt_fx_ib_lend to ${idl_schema};
grant select on ${iml_schema}.agt_fx_ib_lend to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_fx_ib_lend is '外汇同业拆借';
comment on column ${iml_schema}.agt_fx_ib_lend.agt_id is '协议编号';
comment on column ${iml_schema}.agt_fx_ib_lend.lp_id is '法人编号';
comment on column ${iml_schema}.agt_fx_ib_lend.bus_id is '业务编号';
comment on column ${iml_schema}.agt_fx_ib_lend.org_id is '机构编号';
comment on column ${iml_schema}.agt_fx_ib_lend.input_dt is '录入日期';
comment on column ${iml_schema}.agt_fx_ib_lend.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_fx_ib_lend.value_dt is '起息日期';
comment on column ${iml_schema}.agt_fx_ib_lend.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_fx_ib_lend.fir_pay_int_dt is '首次付息日期';
comment on column ${iml_schema}.agt_fx_ib_lend.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_fx_ib_lend.ib_lend_int_rat is '拆借利率';
comment on column ${iml_schema}.agt_fx_ib_lend.ib_lend_amt is '拆借金额';
comment on column ${iml_schema}.agt_fx_ib_lend.convt_usd_curr_amt is '折美元货币金额';
comment on column ${iml_schema}.agt_fx_ib_lend.term_end_stl_amt is '期末结算金额';
comment on column ${iml_schema}.agt_fx_ib_lend.ib_lend_days is '拆借天数';
comment on column ${iml_schema}.agt_fx_ib_lend.daily_int_amt is '每日利息金额';
comment on column ${iml_schema}.agt_fx_ib_lend.acru_int_tot is '应计利息总额';
comment on column ${iml_schema}.agt_fx_ib_lend.tran_aim_cd is '交易目的代码';
comment on column ${iml_schema}.agt_fx_ib_lend.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.agt_fx_ib_lend.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_fx_ib_lend.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_fx_ib_lend.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_fx_ib_lend.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.agt_fx_ib_lend.bag_id is '成交编号';
comment on column ${iml_schema}.agt_fx_ib_lend.tran_mode_cd is '交易模式代码';
comment on column ${iml_schema}.agt_fx_ib_lend.tran_src_cd is '交易来源代码';
comment on column ${iml_schema}.agt_fx_ib_lend.tran_site_cd is '交易场所代码';
comment on column ${iml_schema}.agt_fx_ib_lend.clear_way_cd is '清算方式代码';
comment on column ${iml_schema}.agt_fx_ib_lend.rela_tran_id is '关联交易编号';
comment on column ${iml_schema}.agt_fx_ib_lend.portf_tran_id is '投组交易编号';
comment on column ${iml_schema}.agt_fx_ib_lend.portf_id is '投组编号';
comment on column ${iml_schema}.agt_fx_ib_lend.portf_name is '投组名称';
comment on column ${iml_schema}.agt_fx_ib_lend.portf_type_name is '投组类型名称';
comment on column ${iml_schema}.agt_fx_ib_lend.portf_status_cd is '投组状态代码';
comment on column ${iml_schema}.agt_fx_ib_lend.portf_rela_tran_id is '投组关联交易编号';
comment on column ${iml_schema}.agt_fx_ib_lend.ib_lend_type_cd is '拆借类型代码';
comment on column ${iml_schema}.agt_fx_ib_lend.clear_org_cd is '清算机构代码';
comment on column ${iml_schema}.agt_fx_ib_lend.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_fx_ib_lend.int_rat_tenor_cd is '利率期限代码';
comment on column ${iml_schema}.agt_fx_ib_lend.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_fx_ib_lend.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${iml_schema}.agt_fx_ib_lend.int_rat_float_point is '利率浮动点数';
comment on column ${iml_schema}.agt_fx_ib_lend.pay_int_freq is '付息频率';
comment on column ${iml_schema}.agt_fx_ib_lend.pay_stub_proc_way_cd is '付息残段处理方式代码';
comment on column ${iml_schema}.agt_fx_ib_lend.curr_bal is '当前余额';
comment on column ${iml_schema}.agt_fx_ib_lend.inpwn_way_descb is '质押方式描述';
comment on column ${iml_schema}.agt_fx_ib_lend.bond_curr_cd is '债券币种代码';
comment on column ${iml_schema}.agt_fx_ib_lend.convt_ratio is '折算比例';
comment on column ${iml_schema}.agt_fx_ib_lend.bond_id is '债券编号';
comment on column ${iml_schema}.agt_fx_ib_lend.fac_val is '面值';
comment on column ${iml_schema}.agt_fx_ib_lend.cert_face_tot is '券面总额';
comment on column ${iml_schema}.agt_fx_ib_lend.convt_amt is '折算金额1';
comment on column ${iml_schema}.agt_fx_ib_lend.dealer_id is '交易员编号';
comment on column ${iml_schema}.agt_fx_ib_lend.create_dt is '创建日期';
comment on column ${iml_schema}.agt_fx_ib_lend.update_dt is '更新日期';
comment on column ${iml_schema}.agt_fx_ib_lend.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_fx_ib_lend.id_mark is '增删标志';
comment on column ${iml_schema}.agt_fx_ib_lend.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_fx_ib_lend.job_cd is '任务编码';
comment on column ${iml_schema}.agt_fx_ib_lend.etl_timestamp is 'ETL处理时间戳';
