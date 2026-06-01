/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl dmm_loan_syn_crdt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dmm_loan_syn_crdt_info
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_loan_syn_crdt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_loan_syn_crdt_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,sys_src_idf varchar2(30) -- 系统来源标识
    ,crdt_id varchar2(4000) -- 授信编号
    ,cust_id varchar2(4000) -- 客户编号
    ,cust_name varchar2(4000) -- 客户名称
    ,lmt_bus_flg varchar2(10) -- 额度业务标志
    ,loan_distr_type_cd varchar2(4000) -- 贷款发放类型代码
    ,happ_dt date -- 发生日期
    ,lmt_bus_curr_cd varchar2(10) -- 额度业务币种代码
    ,crdt_lmt number(38,8) -- 授信额度
    ,prod_id varchar2(4000) -- 产品编号
    ,sub_prod_name varchar2(10) -- 子产品名称
    ,tenor_mon number(22) -- 期限(月)
    ,lmt_bus_begin_day date -- 额度业务起始日
    ,lmt_bus_exp_day date -- 额度业务到期日
    ,is_circl_lmt varchar2(4000) -- 是否循环(额度)
    ,risk_type_lmt varchar2(4000) -- 风险类型(额度)
    ,loan_dir_indus varchar2(60) -- 贷款投向行业
    ,usage varchar2(4000) -- 用途
    ,main_guar_way varchar2(10) -- 主担保方式
    ,apv_status varchar2(4000) -- 审批状态
    ,oper_org varchar2(4000) -- 经办机构
    ,oper_dt date -- 经办日期
    ,rgstrat varchar2(4000) -- 登记人
    ,rgst_org varchar2(250) -- 登记机构
    ,rgst_dt date -- 登记日期
    ,updater varchar2(4000) -- 更新人
    ,update_org varchar2(100) -- 更新机构
    ,update_dt date -- 更新日期
    ,belong_strip_line varchar2(60) -- 所属条线
    ,loan_usage varchar2(4000) -- 贷款用途
    ,lmt_open_amt number(24,6) -- 额度敞口金额
    ,guar_lon_flg varchar2(10) -- 担保贷标志
    ,prod_type varchar2(30) -- 产品类型
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.dmm_loan_syn_crdt_info to ${idl_schema};
grant select on ${idl_schema}.dmm_loan_syn_crdt_info to ${iel_schema};
grant select on ${idl_schema}.dmm_loan_syn_crdt_info to ${dqc_schema};
-- comment
comment on table ${idl_schema}.dmm_loan_syn_crdt_info is '贷款综合授信信息';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.etl_dt is '数据日期';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.lp_id is '法人编号';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.sys_src_idf is '系统来源标识';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.crdt_id is '授信编号';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.cust_id is '客户编号';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.cust_name is '客户名称';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.lmt_bus_flg is '额度业务标志';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.loan_distr_type_cd is '贷款发放类型代码';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.happ_dt is '发生日期';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.lmt_bus_curr_cd is '额度业务币种代码';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.crdt_lmt is '授信额度';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.prod_id is '产品编号';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.sub_prod_name is '子产品名称';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.tenor_mon is '期限(月)';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.lmt_bus_begin_day is '额度业务起始日';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.lmt_bus_exp_day is '额度业务到期日';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.is_circl_lmt is '是否循环(额度)';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.risk_type_lmt is '风险类型(额度)';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.loan_dir_indus is '贷款投向行业';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.usage is '用途';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.main_guar_way is '主担保方式';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.apv_status is '审批状态';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.oper_org is '经办机构';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.oper_dt is '经办日期';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.rgstrat is '登记人';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.rgst_org is '登记机构';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.rgst_dt is '登记日期';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.updater is '更新人';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.update_org is '更新机构';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.update_dt is '更新日期';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.belong_strip_line is '所属条线';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.loan_usage is '贷款用途';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.lmt_open_amt is '额度敞口金额';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.guar_lon_flg is '担保贷标志';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.prod_type is '产品类型';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.job_cd is '任务代码';
comment on column ${idl_schema}.dmm_loan_syn_crdt_info.etl_timestamp is '数据处理时间';
--comment on column ${idl_schema}.dmm_loan_syn_crdt_info.etl_dt is 'ETL处理日期';
--comment on column ${idl_schema}.dmm_loan_syn_crdt_info.etl_timestamp is 'ETL处理时间戳';
