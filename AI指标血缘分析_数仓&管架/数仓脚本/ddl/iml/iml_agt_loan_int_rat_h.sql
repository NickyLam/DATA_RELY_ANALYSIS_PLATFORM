/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_int_rat_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_int_rat_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_int_rat_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_int_rat_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,loan_num varchar2(60) -- 贷款号
    ,int_cls_cd varchar2(30) -- 利息分类代码
    ,cust_id varchar2(100) -- 客户编号
    ,int_set_freq_cd varchar2(30) -- 结息频率代码
    ,next_int_set_dt date -- 下一结息日期
    ,int_set_day number(10) -- 结息日
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,float_int_rat_point number(18,8) -- 浮动利率点数
    ,float_int_rat_ratio number(18,6) -- 浮动利率比例
    ,sub_acct_fix_int_rat number(18,8) -- 分户级固定利率
    ,sub_acct_int_rat_float_point varchar2(50) -- 分户级利率浮动点数
    ,sub_acct_int_rat_float_ratio varchar2(50) -- 分户级利率浮动比例
    ,exec_int_rat number(18,8) -- 执行利率
    ,year_int_accr_base_cd varchar2(30) -- 年计息基准代码
    ,mon_int_accr_base_cd varchar2(30) -- 月计息基准代码
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,int_accr_flg varchar2(10) -- 计息标志
    ,int_rat_start_use_way_cd varchar2(30) -- 利率启用方式代码
    ,int_rat_effect_way_cd varchar2(30) -- 利率生效方式代码
    ,next_int_rat_modif_dt date -- 下一利率变更日期
    ,int_rat_modif_ped_cd varchar2(30) -- 利率变更周期代码
    ,int_rat_modif_day number(10) -- 利率变更日
    ,int_accr_begin_dt date -- 计息起始日期
    ,int_accr_exp_dt date -- 计息到期日期
    ,lowt_exec_int_rat number(18,8) -- 最低执行利率
    ,higt_exec_int_rat number(18,8) -- 最高执行利率
    ,cap_flg varchar2(10) -- 资本化标志
    ,pnlt_int_rat_use_way_cd varchar2(30) -- 罚息利率使用方式代码
    ,accrd_nomal_int_rat_float_flg varchar2(10) -- 按正常利率浮动标志
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,final_modif_dt date -- 最后修改日期
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
grant select on ${iml_schema}.agt_loan_int_rat_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_int_rat_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_int_rat_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_int_rat_h is '贷款利率历史';
comment on column ${iml_schema}.agt_loan_int_rat_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_int_rat_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_int_rat_h.loan_num is '贷款号';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_cls_cd is '利息分类代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_set_freq_cd is '结息频率代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_set_day is '结息日';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_loan_int_rat_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_loan_int_rat_h.float_int_rat_point is '浮动利率点数';
comment on column ${iml_schema}.agt_loan_int_rat_h.float_int_rat_ratio is '浮动利率比例';
comment on column ${iml_schema}.agt_loan_int_rat_h.sub_acct_fix_int_rat is '分户级固定利率';
comment on column ${iml_schema}.agt_loan_int_rat_h.sub_acct_int_rat_float_point is '分户级利率浮动点数';
comment on column ${iml_schema}.agt_loan_int_rat_h.sub_acct_int_rat_float_ratio is '分户级利率浮动比例';
comment on column ${iml_schema}.agt_loan_int_rat_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_loan_int_rat_h.year_int_accr_base_cd is '年计息基准代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.mon_int_accr_base_cd is '月计息基准代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_accr_base_cd is '计息基准代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_accr_flg is '计息标志';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_rat_start_use_way_cd is '利率启用方式代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_rat_effect_way_cd is '利率生效方式代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.next_int_rat_modif_dt is '下一利率变更日期';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_rat_modif_ped_cd is '利率变更周期代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_rat_modif_day is '利率变更日';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_accr_begin_dt is '计息起始日期';
comment on column ${iml_schema}.agt_loan_int_rat_h.int_accr_exp_dt is '计息到期日期';
comment on column ${iml_schema}.agt_loan_int_rat_h.lowt_exec_int_rat is '最低执行利率';
comment on column ${iml_schema}.agt_loan_int_rat_h.higt_exec_int_rat is '最高执行利率';
comment on column ${iml_schema}.agt_loan_int_rat_h.cap_flg is '资本化标志';
comment on column ${iml_schema}.agt_loan_int_rat_h.pnlt_int_rat_use_way_cd is '罚息利率使用方式代码';
comment on column ${iml_schema}.agt_loan_int_rat_h.accrd_nomal_int_rat_float_flg is '按正常利率浮动标志';
comment on column ${iml_schema}.agt_loan_int_rat_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_loan_int_rat_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_loan_int_rat_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_int_rat_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_int_rat_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_int_rat_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_int_rat_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_int_rat_h.etl_timestamp is 'ETL处理时间戳';
