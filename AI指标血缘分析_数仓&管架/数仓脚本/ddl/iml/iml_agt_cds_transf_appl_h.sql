/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cds_transf_appl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cds_transf_appl_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cds_transf_appl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_transf_appl_h(
    evt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,transf_id varchar2(100) -- 转让编号
    ,tran_ref_no varchar2(100) -- 交易参考号
    ,sub_acct_num varchar2(60) -- 子账号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,core_teller_id varchar2(100) -- 核心柜员编号
    ,lmt_id varchar2(100) -- 限制编号
    ,pd_cd varchar2(30) -- 期次编号
    ,tran_tm timestamp -- 交易时间
    ,dep_days number(10) -- 存款天数
    ,int_accr_surp_days number(10) -- 计息剩余天数
    ,transf_tot_cosdetn number(30,2) -- 转让总对价
    ,transf_exp_dt date -- 转让到期日期
    ,dir_transf_flg varchar2(10) -- 定向转让标志
    ,order_begin_dt date -- 挂单起始日期
    ,tran_in_fee number(30,2) -- 转入费用
    ,order_end_dt date -- 挂单结束日期
    ,transf_pric number(30,2) -- 转让本金
    ,transf_int_rat number(18,8) -- 转让利率
    ,cds_transf_type_cd varchar2(30) -- 大额存单转让类型代码
    ,transf_status_cd varchar2(30) -- 转让状态代码
    ,benefc_cust_id varchar2(100) -- 受益人客户编号
    ,transf_dt date -- 转让日期
    ,asign_yld_rat number(18,8) -- 受让人收益率
    ,tran_out_fee number(30,2) -- 转出费用
    ,final_modif_dt date -- 最后修改日期
    ,tran_in_cust_acct_num varchar2(100) -- 转入客户账号
    ,stl_acct_sub_acct_num varchar2(60) -- 结算账户子账号
    ,stl_cust_acct_num varchar2(60) -- 结算客户账号
    ,tran_dt date -- 交易日期
    ,prod_id varchar2(60) -- 产品编号
    ,appl_dt date -- 申请日期
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
grant select on ${iml_schema}.agt_cds_transf_appl_h to ${icl_schema};
grant select on ${iml_schema}.agt_cds_transf_appl_h to ${idl_schema};
grant select on ${iml_schema}.agt_cds_transf_appl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cds_transf_appl_h is '大额存单转让申请历史';
comment on column ${iml_schema}.agt_cds_transf_appl_h.evt_id is '协议编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.transf_id is '转让编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.cust_name is '客户名称';
comment on column ${iml_schema}.agt_cds_transf_appl_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.core_teller_id is '核心柜员编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.lmt_id is '限制编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.pd_cd is '期次编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_cds_transf_appl_h.dep_days is '存款天数';
comment on column ${iml_schema}.agt_cds_transf_appl_h.int_accr_surp_days is '计息剩余天数';
comment on column ${iml_schema}.agt_cds_transf_appl_h.transf_tot_cosdetn is '转让总对价';
comment on column ${iml_schema}.agt_cds_transf_appl_h.transf_exp_dt is '转让到期日期';
comment on column ${iml_schema}.agt_cds_transf_appl_h.dir_transf_flg is '定向转让标志';
comment on column ${iml_schema}.agt_cds_transf_appl_h.order_begin_dt is '挂单起始日期';
comment on column ${iml_schema}.agt_cds_transf_appl_h.tran_in_fee is '转入费用';
comment on column ${iml_schema}.agt_cds_transf_appl_h.order_end_dt is '挂单结束日期';
comment on column ${iml_schema}.agt_cds_transf_appl_h.transf_pric is '转让本金';
comment on column ${iml_schema}.agt_cds_transf_appl_h.transf_int_rat is '转让利率';
comment on column ${iml_schema}.agt_cds_transf_appl_h.cds_transf_type_cd is '大额存单转让类型代码';
comment on column ${iml_schema}.agt_cds_transf_appl_h.transf_status_cd is '转让状态代码';
comment on column ${iml_schema}.agt_cds_transf_appl_h.benefc_cust_id is '受益人客户编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.transf_dt is '转让日期';
comment on column ${iml_schema}.agt_cds_transf_appl_h.asign_yld_rat is '受让人收益率';
comment on column ${iml_schema}.agt_cds_transf_appl_h.tran_out_fee is '转出费用';
comment on column ${iml_schema}.agt_cds_transf_appl_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_cds_transf_appl_h.tran_in_cust_acct_num is '转入客户账号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.stl_acct_sub_acct_num is '结算账户子账号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.stl_cust_acct_num is '结算客户账号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_cds_transf_appl_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_cds_transf_appl_h.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_cds_transf_appl_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cds_transf_appl_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cds_transf_appl_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cds_transf_appl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cds_transf_appl_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cds_transf_appl_h.etl_timestamp is 'ETL处理时间戳';
