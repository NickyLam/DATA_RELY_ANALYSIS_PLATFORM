/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_int_rat_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_int_rat_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_int_rat_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_int_rat_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,int_rat_apv_form_id varchar2(100) -- 利率审批单编号
    ,init_apv_form_id varchar2(100) -- 原审批单编号
    ,add_agt_flg_cd varchar2(30) -- 新增协议标志代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,curr_cd varchar2(30) -- 币种代码
    ,int_rat_apv_appl_cate_cd varchar2(30) -- 利率审批申请类别代码
    ,int_rat_agt_status_cd varchar2(30) -- 利率协议状态代码
    ,int_rat_apv_form_dep_breed_cd varchar2(30) -- 利率审批单存款品种代码
    ,new_acct_num_flg varchar2(10) -- 新账号标志
    ,int_rat_agt_tenor number(10) -- 利率协议期限
    ,int_rat_agt_tenor_corp_cd varchar2(30) -- 利率协议期限单位代码
    ,dep_tenor number(10) -- 存款期限
    ,dep_tenor_corp_cd varchar2(30) -- 存款期限单位代码
    ,base_rat number(18,8) -- 基准利率
    ,float_ratio number(18,8) -- 浮动比例
    ,exec_int_rat number(18,8) -- 执行利率
    ,rs_descb varchar2(500) -- 原因描述
    ,agt_effect_dt date -- 协议生效日期
    ,agt_invalid_dt date -- 协议失效日期
    ,hxb_crdt_cust_flg varchar2(10) -- 我行授信客户标志
    ,appl_pric_amt_uplmi number(30,2) -- 申请本金金额上限
    ,int_rat_prefr_effect_dt date -- 利率优惠生效日期
    ,int_rat_prefr_invalid_dt date -- 利率优惠失效日期
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
grant select on ${iml_schema}.agt_dep_int_rat_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_int_rat_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_int_rat_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_int_rat_info_h is '存款利率信息历史';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.int_rat_apv_form_id is '利率审批单编号';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.init_apv_form_id is '原审批单编号';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.add_agt_flg_cd is '新增协议标志代码';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.int_rat_apv_appl_cate_cd is '利率审批申请类别代码';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.int_rat_agt_status_cd is '利率协议状态代码';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.int_rat_apv_form_dep_breed_cd is '利率审批单存款品种代码';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.new_acct_num_flg is '新账号标志';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.int_rat_agt_tenor is '利率协议期限';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.int_rat_agt_tenor_corp_cd is '利率协议期限单位代码';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.dep_tenor is '存款期限';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.dep_tenor_corp_cd is '存款期限单位代码';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.base_rat is '基准利率';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.float_ratio is '浮动比例';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.rs_descb is '原因描述';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.agt_effect_dt is '协议生效日期';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.agt_invalid_dt is '协议失效日期';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.hxb_crdt_cust_flg is '我行授信客户标志';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.appl_pric_amt_uplmi is '申请本金金额上限';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.int_rat_prefr_effect_dt is '利率优惠生效日期';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.int_rat_prefr_invalid_dt is '利率优惠失效日期';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_int_rat_info_h.etl_timestamp is 'ETL处理时间戳';
