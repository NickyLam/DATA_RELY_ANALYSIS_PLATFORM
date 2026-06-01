/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_close_dep_acct_int_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_close_dep_acct_int_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_close_dep_acct_int_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_close_dep_acct_int_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,provi_day number(10) -- 计提日
    ,int_provi_ped varchar2(10) -- 利息计提周期
    ,next_provi_dt date -- 下一计提日期
    ,last_provi_dt date -- 上一计提日期
    ,int_set_flg varchar2(10) -- 结息标志
    ,int_set_freq_cd varchar2(30) -- 结息频率代码
    ,int_set_day number(10) -- 结息日
    ,int_set_amt number(30,2) -- 结息金额
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,next_int_set_dt date -- 下一结息日期
    ,last_int_set_dt date -- 上一结息日期
    ,last_real_int_set_dt date -- 上一真实结息日期
    ,day_bf_last_int_set_dt date -- 日切前上一结息日期
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,int_rat_effect_way_cd varchar2(30) -- 利率生效方式代码
    ,acm_provi_int number(30,2) -- 累计计提利息
    ,acm_int_adj_amt number(30,2) -- 累计利息调整
    ,ld_acm_provi_int number(30,2) -- 上日累计计提利息
    ,ld_acm_int_adj_amt number(30,2) -- 上日累计利息调整
    ,ld_acm_adj_dt date -- 上日累计调整日期
    ,ld_acm_paid_dt date -- 上日累计已付日期
    ,up_ld_acm_int_adj_amt number(30,2) -- 上上日累计利息调整
    ,up_ld_acm_provi_int number(30,2) -- 上上日累计计提利息
    ,up_ld_bf_pay_int number(30,2) -- 上上日前付息
    ,curr_mon_daily_end_day_bal_sum number(30,2) -- 当月累计日终余额
    ,last_mon_daily_end_day_bal_sum number(30,2) -- 上月累计日终余额
    ,cap_flg varchar2(10) -- 资本化标志
    ,cust_id varchar2(100) -- 客户编号
    ,tran_dt date -- 交易日期
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
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
grant select on ${iml_schema}.agt_close_dep_acct_int_h to ${icl_schema};
grant select on ${iml_schema}.agt_close_dep_acct_int_h to ${idl_schema};
grant select on ${iml_schema}.agt_close_dep_acct_int_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_close_dep_acct_int_h is '已销户存款账户利息调整历史';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.provi_day is '计提日';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.int_provi_ped is '利息计提周期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.next_provi_dt is '下一计提日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.last_provi_dt is '上一计提日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.int_set_flg is '结息标志';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.int_set_freq_cd is '结息频率代码';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.int_set_day is '结息日';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.int_set_amt is '结息金额';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.last_int_set_dt is '上一结息日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.last_real_int_set_dt is '上一真实结息日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.day_bf_last_int_set_dt is '日切前上一结息日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.int_rat_effect_way_cd is '利率生效方式代码';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.acm_provi_int is '累计计提利息';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.acm_int_adj_amt is '累计利息调整';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.ld_acm_provi_int is '上日累计计提利息';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.ld_acm_int_adj_amt is '上日累计利息调整';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.ld_acm_adj_dt is '上日累计调整日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.ld_acm_paid_dt is '上日累计已付日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.up_ld_acm_int_adj_amt is '上上日累计利息调整';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.up_ld_acm_provi_int is '上上日累计计提利息';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.up_ld_bf_pay_int is '上上日前付息';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.curr_mon_daily_end_day_bal_sum is '当月累计日终余额';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.last_mon_daily_end_day_bal_sum is '上月累计日终余额';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.cap_flg is '资本化标志';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_close_dep_acct_int_h.etl_timestamp is 'ETL处理时间戳';
