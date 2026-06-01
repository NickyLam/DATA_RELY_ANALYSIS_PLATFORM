/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_renew_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_renew_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_renew_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_renew_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,renew_flow_num varchar2(100) -- 展期流水号
    ,precon_id varchar2(100) -- 预约编号
    ,rela_dubil_id varchar2(100) -- 关联借据编号
    ,out_acct_flow_num varchar2(100) -- 出账流水号
    ,renew_status_cd varchar2(30) -- 展期状态代码
    ,happ_dt date -- 发生日期
    ,init_int_rat number(18,8) -- 原利率
    ,init_exp_dt date -- 原到期日期
    ,renew_amt number(30,2) -- 展期金额
    ,b_renew_amt number(30,2) -- 展期前金额
    ,renew_year_tenor number(10) -- 展期年期限
    ,renew_mon_tenor number(10) -- 展期月期限
    ,renew_day_tenor number(10) -- 展期日期限
    ,a_renew_int_rat number(18,8) -- 展期后利率
    ,a_renew_exp_dt date -- 展期后到期日期
    ,entr_pay_dt date -- 受托支付日期
    ,org_id varchar2(100) -- 机构编号
    ,oper_teller_id varchar2(100) -- 操作柜员编号
    ,update_flg varchar2(10) -- 更新标志
    ,remark varchar2(2000) -- 备注
    ,renew_cont_id varchar2(100) -- 展期合同编号
    ,a_renew_repay_plan_effect_dt date -- 展期后还款计划生效日期
    ,a_renew_int_rat_effect_dt date -- 展期后利率的生效日期
    ,renew_effect_dt date -- 展期生效日期
    ,new_repay_way_cd varchar2(30) -- 新还款方式代码
    ,repay_ped_cd varchar2(60) -- 还款周期代码
    ,base_rat number(30,8) -- 基准利率
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_rat_adj_ped_cd varchar2(30) -- 利率调整周期代码
    ,int_rat_reval_way_cd varchar2(30) -- 利率重定价方式代码
    ,OVDUE_LOAN_INT_RAT_FLOAT_RATIO number(30,2) -- 逾期贷款利率浮动比例
    ,ovdue_loan_exec_int_rat number(18,8) -- 逾期贷款执行利率
    ,next_int_set_dt date -- 下一结息日期
    ,mortg_repay_day date -- 按揭还款日
    ,late_merge_flg varchar2(10) -- 末期合并标志
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
grant select on ${iml_schema}.agt_loan_renew_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_renew_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_renew_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_renew_info_h is '贷款展期信息历史';
comment on column ${iml_schema}.agt_loan_renew_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_renew_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_renew_info_h.renew_flow_num is '展期流水号';
comment on column ${iml_schema}.agt_loan_renew_info_h.precon_id is '预约编号';
comment on column ${iml_schema}.agt_loan_renew_info_h.rela_dubil_id is '关联借据编号';
comment on column ${iml_schema}.agt_loan_renew_info_h.out_acct_flow_num is '出账流水号';
comment on column ${iml_schema}.agt_loan_renew_info_h.renew_status_cd is '展期状态代码';
comment on column ${iml_schema}.agt_loan_renew_info_h.happ_dt is '发生日期';
comment on column ${iml_schema}.agt_loan_renew_info_h.init_int_rat is '原利率';
comment on column ${iml_schema}.agt_loan_renew_info_h.init_exp_dt is '原到期日期';
comment on column ${iml_schema}.agt_loan_renew_info_h.renew_amt is '展期金额';
comment on column ${iml_schema}.agt_loan_renew_info_h.b_renew_amt is '展期前金额';
comment on column ${iml_schema}.agt_loan_renew_info_h.renew_year_tenor is '展期年期限';
comment on column ${iml_schema}.agt_loan_renew_info_h.renew_mon_tenor is '展期月期限';
comment on column ${iml_schema}.agt_loan_renew_info_h.renew_day_tenor is '展期日期限';
comment on column ${iml_schema}.agt_loan_renew_info_h.a_renew_int_rat is '展期后利率';
comment on column ${iml_schema}.agt_loan_renew_info_h.a_renew_exp_dt is '展期后到期日期';
comment on column ${iml_schema}.agt_loan_renew_info_h.entr_pay_dt is '受托支付日期';
comment on column ${iml_schema}.agt_loan_renew_info_h.org_id is '机构编号';
comment on column ${iml_schema}.agt_loan_renew_info_h.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.agt_loan_renew_info_h.update_flg is '更新标志';
comment on column ${iml_schema}.agt_loan_renew_info_h.remark is '备注';
comment on column ${iml_schema}.agt_loan_renew_info_h.renew_cont_id is '展期合同编号';
comment on column ${iml_schema}.agt_loan_renew_info_h.a_renew_repay_plan_effect_dt is '展期后还款计划生效日期';
comment on column ${iml_schema}.agt_loan_renew_info_h.a_renew_int_rat_effect_dt is '展期后利率的生效日期';
comment on column ${iml_schema}.agt_loan_renew_info_h.renew_effect_dt is '展期生效日期';
comment on column ${iml_schema}.agt_loan_renew_info_h.new_repay_way_cd is '新还款方式代码';
comment on column ${iml_schema}.agt_loan_renew_info_h.repay_ped_cd is '还款周期代码';
comment on column ${iml_schema}.agt_loan_renew_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_loan_renew_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_loan_renew_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_loan_renew_info_h.int_rat_adj_ped_cd is '利率调整周期代码';
comment on column ${iml_schema}.agt_loan_renew_info_h.int_rat_reval_way_cd is '利率重定价方式代码';
comment on column ${iml_schema}.agt_loan_renew_info_h.OVDUE_LOAN_INT_RAT_FLOAT_RATIO is '逾期贷款利率浮动比例';
comment on column ${iml_schema}.agt_loan_renew_info_h.ovdue_loan_exec_int_rat is '逾期贷款执行利率';
comment on column ${iml_schema}.agt_loan_renew_info_h.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_loan_renew_info_h.mortg_repay_day is '按揭还款日';
comment on column ${iml_schema}.agt_loan_renew_info_h.late_merge_flg is '末期合并标志';
comment on column ${iml_schema}.agt_loan_renew_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_renew_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_renew_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_renew_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_renew_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_renew_info_h.etl_timestamp is 'ETL处理时间戳';
