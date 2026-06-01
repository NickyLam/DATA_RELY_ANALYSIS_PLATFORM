/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cust_prefr_exch_rat_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cust_prefr_exch_rat_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cust_prefr_exch_rat_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cust_prefr_exch_rat_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,int_rat_apv_form_id varchar2(100) -- 利率审批单编号
    ,prefr_exch_rat_type_cd varchar2(30) -- 优惠汇率类型代码
    ,cust_id varchar2(100) -- 客户编号
    ,appl_org_id varchar2(100) -- 申请机构编号
    ,curr_cd varchar2(30) -- 币种代码
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_dt date -- 交易日期
    ,offset_prefr_val number(10) -- 平盘优惠值
    ,prefr_begin_dt date -- 优惠起始日期
    ,prefr_exp_dt date -- 优惠到期日期
    ,prefr_days number(10) -- 优惠天数
    ,prefr_status_cd varchar2(30) -- 优惠状态代码
    ,exch_rat_prefr_way_cd varchar2(30) -- 汇率优惠方式代码
    ,single_acct_prefr_val number(10) -- 单户优惠值
    ,wrt_guat_type_cd varchar2(30) -- 结售汇类型代码
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
grant select on ${iml_schema}.agt_cust_prefr_exch_rat_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_cust_prefr_exch_rat_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_cust_prefr_exch_rat_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cust_prefr_exch_rat_info_h is '客户优惠汇率信息历史';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.int_rat_apv_form_id is '利率审批单编号';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.prefr_exch_rat_type_cd is '优惠汇率类型代码';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.appl_org_id is '申请机构编号';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.offset_prefr_val is '平盘优惠值';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.prefr_begin_dt is '优惠起始日期';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.prefr_exp_dt is '优惠到期日期';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.prefr_days is '优惠天数';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.prefr_status_cd is '优惠状态代码';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.exch_rat_prefr_way_cd is '汇率优惠方式代码';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.single_acct_prefr_val is '单户优惠值';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.wrt_guat_type_cd is '结售汇类型代码';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cust_prefr_exch_rat_info_h.etl_timestamp is 'ETL处理时间戳';
