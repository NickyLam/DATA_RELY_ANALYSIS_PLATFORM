/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_reg_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_reg_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_reg_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_reg_tran_flow(
    acct_id varchar2(100) -- 账户编号
    ,evt_id varchar2(250) -- 事件编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,lp_id varchar2(100) -- 法人编号
    ,time_dep_rcpt_num varchar2(60) -- 定期存单号
    ,revs_tran_seq_num varchar2(60) -- 冲正交易序号
    ,tran_seq_num varchar2(60) -- 交易序号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_base_int_rat number(18,8) -- 账户基础利率
    ,acct_open_acct_dt date -- 账户开户日期
    ,tran_dt date -- 交易日期
    ,acct_exp_dt date -- 账户到期日期
    ,vouch_type_cd varchar2(30) -- 凭证类型代码
    ,loss_id varchar2(100) -- 挂失编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,redt_seq_num varchar2(60) -- 转存序号
    ,tax number(30,2) -- 税金
    ,wdraw_amt number(30,2) -- 支取金额
    ,tran_happ_pric number(30,2) -- 交易发生本金
    ,actl_pric_amt number(30,2) -- 实际本金金额
    ,tot_int_amt number(30,2) -- 总利息金额
    ,int_adj_add_amt number(30,2) -- 利息调增金额
    ,provi_day_int_adj number(30,2) -- 计提日利息调整
    ,net_int number(30,2) -- 净利息
    ,float_point number(18,8) -- 浮动点数
    ,wdraw_int_rat number(18,8) -- 支取利率
    ,tenor_type_cd varchar2(30) -- 期限类型代码
    ,exp_advise_flg varchar2(10) -- 到期通知标志
    ,advise_dep_tenor number(10) -- 通知存款期限
    ,pric_int_redt_cnt number(10) -- 本息转存次数
    ,deduct_type_cd varchar2(30) -- 扣划类型代码
    ,tran_scene_descb varchar2(500) -- 交易场景描述
    ,conti_dep_term_cnt number(10) -- 续存期数
    ,allow_add_pric_flg varchar2(10) -- 允许增加本金标志
    ,redt_way_type_cd varchar2(30) -- 转存方式类型代码
    ,dep_term_tenor number(10) -- 存期期限
    ,redt_type_cd varchar2(30) -- 转存类型代码
    ,part_pric_redt_flg varchar2(10) -- 部分本金转存标志
    ,pric_redt_cnt number(10) -- 本金转存次数
    ,tran_valid_flg varchar2(10) -- 交易有效标志
    ,tran_tm timestamp -- 交易时间
    ,tran_teller_id varchar2(100) -- 交易柜员编号
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
grant select on ${iml_schema}.evt_reg_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_reg_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_reg_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_reg_tran_flow is '定期交易流水';
comment on column ${iml_schema}.evt_reg_tran_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_reg_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_reg_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_reg_tran_flow.time_dep_rcpt_num is '定期存单号';
comment on column ${iml_schema}.evt_reg_tran_flow.revs_tran_seq_num is '冲正交易序号';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_seq_num is '交易序号';
comment on column ${iml_schema}.evt_reg_tran_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_reg_tran_flow.acct_base_int_rat is '账户基础利率';
comment on column ${iml_schema}.evt_reg_tran_flow.acct_open_acct_dt is '账户开户日期';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_reg_tran_flow.acct_exp_dt is '账户到期日期';
comment on column ${iml_schema}.evt_reg_tran_flow.vouch_type_cd is '凭证类型代码';
comment on column ${iml_schema}.evt_reg_tran_flow.loss_id is '挂失编号';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_reg_tran_flow.redt_seq_num is '转存序号';
comment on column ${iml_schema}.evt_reg_tran_flow.tax is '税金';
comment on column ${iml_schema}.evt_reg_tran_flow.wdraw_amt is '支取金额';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_happ_pric is '交易发生本金';
comment on column ${iml_schema}.evt_reg_tran_flow.actl_pric_amt is '实际本金金额';
comment on column ${iml_schema}.evt_reg_tran_flow.tot_int_amt is '总利息金额';
comment on column ${iml_schema}.evt_reg_tran_flow.int_adj_add_amt is '利息调增金额';
comment on column ${iml_schema}.evt_reg_tran_flow.provi_day_int_adj is '计提日利息调整';
comment on column ${iml_schema}.evt_reg_tran_flow.net_int is '净利息';
comment on column ${iml_schema}.evt_reg_tran_flow.float_point is '浮动点数';
comment on column ${iml_schema}.evt_reg_tran_flow.wdraw_int_rat is '支取利率';
comment on column ${iml_schema}.evt_reg_tran_flow.tenor_type_cd is '期限类型代码';
comment on column ${iml_schema}.evt_reg_tran_flow.exp_advise_flg is '到期通知标志';
comment on column ${iml_schema}.evt_reg_tran_flow.advise_dep_tenor is '通知存款期限';
comment on column ${iml_schema}.evt_reg_tran_flow.pric_int_redt_cnt is '本息转存次数';
comment on column ${iml_schema}.evt_reg_tran_flow.deduct_type_cd is '扣划类型代码';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_scene_descb is '交易场景描述';
comment on column ${iml_schema}.evt_reg_tran_flow.conti_dep_term_cnt is '续存期数';
comment on column ${iml_schema}.evt_reg_tran_flow.allow_add_pric_flg is '允许增加本金标志';
comment on column ${iml_schema}.evt_reg_tran_flow.redt_way_type_cd is '转存方式类型代码';
comment on column ${iml_schema}.evt_reg_tran_flow.dep_term_tenor is '存期期限';
comment on column ${iml_schema}.evt_reg_tran_flow.redt_type_cd is '转存类型代码';
comment on column ${iml_schema}.evt_reg_tran_flow.part_pric_redt_flg is '部分本金转存标志';
comment on column ${iml_schema}.evt_reg_tran_flow.pric_redt_cnt is '本金转存次数';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_valid_flg is '交易有效标志';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_reg_tran_flow.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_reg_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_reg_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_reg_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_reg_tran_flow.etl_timestamp is 'ETL处理时间戳';
