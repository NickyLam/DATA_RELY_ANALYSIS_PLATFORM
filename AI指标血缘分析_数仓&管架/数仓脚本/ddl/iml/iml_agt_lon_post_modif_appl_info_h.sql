/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lon_post_modif_appl_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lon_post_modif_appl_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lon_post_modif_appl_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lon_post_modif_appl_info_h(
    agt_id varchar2(250) -- 协议编号
    ,modif_flow_num varchar2(100) -- 变更流水号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,rela_obj_flow_num varchar2(100) -- 关联对象流水号
    ,rela_obj_type_name varchar2(500) -- 关联对象类型名称
    ,rela_dubil_id varchar2(100) -- 关联借据编号
    ,appl_status_cd varchar2(30) -- 申请状态代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,init_loan_exp_dt date -- 原贷款到期日期
    ,new_loan_exp_dt date -- 新贷款到期日期
    ,int_rat_modif_flg varchar2(10) -- 利率变更标志
    ,int_rat_mode_cd varchar2(30) -- 利率模式代码
    ,int_rat_corp_cd varchar2(30) -- 利率单位代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,base_rat_type_cd varchar2(30) -- 基准利率类型代码
    ,int_rat_float_type_cd varchar2(30) -- 利率浮动类型代码
    ,int_rat_flo_val number(18,6) -- 利率浮动值
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,int_rat_mode_cd_two varchar2(30) -- 利率模式代码二
    ,int_rat_corp_cd_two varchar2(30) -- 利率单位代码二
    ,int_rat_adj_way_cd_two varchar2(30) -- 利率调整方式代码二
    ,base_rat_type_cd_two varchar2(30) -- 基准利率类型代码二
    ,int_rat_float_type_cd_two varchar2(30) -- 利率浮动类型代码二
    ,int_rat_flo_val_two number(18,6) -- 利率浮动值二
    ,base_rat_two number(18,8) -- 基准利率二
    ,exec_int_rat_two number(18,8) -- 执行利率二
    ,distr_acct_id varchar2(100) -- 放款账户编号
    ,repay_num varchar2(100) -- 还款账号
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,repay_ped_type_cd varchar2(30) -- 还款周期类型代码
    ,deflt_repay_day varchar2(10) -- 默认还款日
    ,spec_ped_cd varchar2(30) -- 指定周期代码
    ,bal_pay_amt number(30,2) -- 尾款金额
    ,enter_acct_org_id varchar2(100) -- 入账机构编号
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_dt date -- 交易日期
    ,effect_dt date -- 生效日期
    ,remark varchar2(500) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,modif_dt date -- 变更日期
    ,cmplt_flg varchar2(10) -- 完成标志
    ,belong_strip_line_cd varchar2(30) -- 所属条线代码
    ,lp_id varchar2(100) -- 法人编号
    ,init_repay_way_cd varchar2(30) -- 原还款方式代码
    ,init_repay_day varchar2(10) -- 原还款日
    ,repay_acct_name varchar2(500) -- 还款账户名称
    ,init_repay_num_id varchar2(100) -- 原还款账户编号
    ,init_repay_num_name varchar2(500) -- 原还款账户名称
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
grant select on ${iml_schema}.agt_lon_post_modif_appl_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_lon_post_modif_appl_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_lon_post_modif_appl_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lon_post_modif_appl_info_h is '贷后变更申请信息历史';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.modif_flow_num is '变更流水号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.rela_obj_flow_num is '关联对象流水号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.rela_obj_type_name is '关联对象类型名称';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.rela_dubil_id is '关联借据编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.appl_status_cd is '申请状态代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.init_loan_exp_dt is '原贷款到期日期';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.new_loan_exp_dt is '新贷款到期日期';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_modif_flg is '利率变更标志';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_mode_cd is '利率模式代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_corp_cd is '利率单位代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.base_rat_type_cd is '基准利率类型代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_float_type_cd is '利率浮动类型代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_flo_val is '利率浮动值';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_mode_cd_two is '利率模式代码二';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_corp_cd_two is '利率单位代码二';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_adj_way_cd_two is '利率调整方式代码二';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.base_rat_type_cd_two is '基准利率类型代码二';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_float_type_cd_two is '利率浮动类型代码二';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.int_rat_flo_val_two is '利率浮动值二';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.base_rat_two is '基准利率二';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.exec_int_rat_two is '执行利率二';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.distr_acct_id is '放款账户编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.repay_num is '还款账号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.repay_ped_type_cd is '还款周期类型代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.deflt_repay_day is '默认还款日';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.spec_ped_cd is '指定周期代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.bal_pay_amt is '尾款金额';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.enter_acct_org_id is '入账机构编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.remark is '备注';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.modif_dt is '变更日期';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.cmplt_flg is '完成标志';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.belong_strip_line_cd is '所属条线代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.init_repay_way_cd is '原还款方式代码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.init_repay_day is '原还款日';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.repay_acct_name is '还款账户名称';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.init_repay_num_id is '原还款账户编号';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.init_repay_num_name is '原还款账户名称';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lon_post_modif_appl_info_h.etl_timestamp is 'ETL处理时间戳';
