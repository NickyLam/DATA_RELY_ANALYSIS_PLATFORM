/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_retl_dubil_renew_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_retl_dubil_renew_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_retl_dubil_renew_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_retl_dubil_renew_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,renew_flow_num varchar2(100) -- 展期流水号
    ,rela_dubil_id varchar2(100) -- 关联借据编号
    ,obj_id varchar2(100) -- 对象编号
    ,obj_type_name varchar2(500) -- 对象类型名称
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,renew_sucs_flg varchar2(10) -- 展期成功标志
    ,renew_cont_id varchar2(100) -- 展期合同编号
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_ped_cd varchar2(30) -- 还款周期代码
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,mon_tenor number(10) -- 月期限
    ,base_int_rat number(18,8) -- 基准利率
    ,int_rat_float_point number(18,8) -- 利率浮动点数
    ,int_rat_float_way_cd varchar2(60) -- 利率浮动方式代码
    ,loan_exec_year_int_rat number(18,8) -- 执行年利率
    ,ovdue_int_rat_float_way_cd varchar2(60) -- 逾期利率浮动方式代码
    ,ovdue_int_rat_fl_rt number(30,2) -- 逾期利率浮动比例
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(100) -- 利率调整周期代码
    ,regroup_loan_flg varchar2(10) -- 重组贷款标志
    ,aldy_call_core_intfc_flg varchar2(10) -- 已调用核心接口标志
    ,precon_id varchar2(100) -- 预约编号
    ,blon_loan_amort_dt date -- 气球贷摊销日期
    ,blon_loan_incrs_amt number(38,8) -- 气球贷递增金额
    ,blon_loan_incrs_ratio number(38,8) -- 气球贷递增比例
    ,remark varchar2(500) -- 备注
    ,init_cont_exp_dt date -- 原合同到期日期
    ,init_repay_way_cd varchar2(30) -- 原还款方式代码
    ,init_repay_ped_cd varchar2(60) -- 原还款周期代码
    ,init_int_rat_float_way_cd varchar2(60) -- 原利率浮动方式代码
    ,init_int_rat_adj_way_cd varchar2(100) -- 原利率调整方式代码
    ,init_int_rat_float_point number(18,8) -- 原利率浮动点数
    ,init_exec_year_int_rat number(18,8) -- 原执行年利率
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
grant select on ${iml_schema}.agt_retl_dubil_renew_appl to ${icl_schema};
grant select on ${iml_schema}.agt_retl_dubil_renew_appl to ${idl_schema};
grant select on ${iml_schema}.agt_retl_dubil_renew_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_retl_dubil_renew_appl is '零售借据展期申请';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.renew_flow_num is '展期流水号';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.rela_dubil_id is '关联借据编号';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.obj_id is '对象编号';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.obj_type_name is '对象类型名称';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.renew_sucs_flg is '展期成功标志';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.renew_cont_id is '展期合同编号';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.repay_ped_cd is '还款周期代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.mon_tenor is '月期限';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.base_int_rat is '基准利率';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.int_rat_float_point is '利率浮动点数';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.loan_exec_year_int_rat is '执行年利率';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.ovdue_int_rat_float_way_cd is '逾期利率浮动方式代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.ovdue_int_rat_fl_rt is '逾期利率浮动比例';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.regroup_loan_flg is '重组贷款标志';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.aldy_call_core_intfc_flg is '已调用核心接口标志';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.precon_id is '预约编号';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.blon_loan_amort_dt is '气球贷摊销日期';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.blon_loan_incrs_amt is '气球贷递增金额';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.blon_loan_incrs_ratio is '气球贷递增比例';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.remark is '备注';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.init_cont_exp_dt is '原合同到期日期';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.init_repay_way_cd is '原还款方式代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.init_repay_ped_cd is '原还款周期代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.init_int_rat_float_way_cd is '原利率浮动方式代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.init_int_rat_adj_way_cd is '原利率调整方式代码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.init_int_rat_float_point is '原利率浮动点数';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.init_exec_year_int_rat is '原执行年利率';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_retl_dubil_renew_appl.etl_timestamp is 'ETL处理时间戳';
