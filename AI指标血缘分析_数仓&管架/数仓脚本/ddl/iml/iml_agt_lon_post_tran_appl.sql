/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lon_post_tran_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lon_post_tran_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lon_post_tran_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lon_post_tran_appl(
    appl_id varchar2(100) -- 申请编号
    ,lp_id varchar2(100) -- 法人编号
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,rela_tran_flow_num varchar2(100) -- 关联交易流水号
    ,tran_cd varchar2(30) -- 交易代码
    ,tran_dt date -- 交易日期
    ,tran_amt number(30,8) -- 交易金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,realtm_tran_flg varchar2(10) -- 实时交易标志
    ,rolbk_flow_num varchar2(100) -- 回退流水号
    ,core_tran_ref_no varchar2(100) -- 核心交易参考号
    ,core_entry_flow_num varchar2(100) -- 核心记账流水号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,fft_tran_type_cd varchar2(30) -- 福费廷转让类型代码
    ,grace_int_flg varchar2(10) -- 宽限利息标志
    ,grace_pric_flg varchar2(10) -- 宽限本金标志
    ,adv_repay_rs_cd varchar2(30) -- 提前还款原因代码
    ,adv_repay_comnt varchar2(500) -- 提前还款说明
    ,adv_repay_cap_src_comnt varchar2(500) -- 提前还款资金来源说明
    ,regroup_loan_flg varchar2(10) -- 重组贷款标志
    ,rela_obj_name varchar2(500) -- 关联对象名称
    ,obj_id varchar2(100) -- 对象编号
    ,doc_type_name varchar2(500) -- 单据类型名称
    ,doc_flow_num varchar2(100) -- 单据流水号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,remark varchar2(4000) -- 备注
    ,other_comnt varchar2(4000) -- 其他说明
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
grant select on ${iml_schema}.agt_lon_post_tran_appl to ${icl_schema};
grant select on ${iml_schema}.agt_lon_post_tran_appl to ${idl_schema};
grant select on ${iml_schema}.agt_lon_post_tran_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lon_post_tran_appl is '贷后交易申请';
comment on column ${iml_schema}.agt_lon_post_tran_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.rela_tran_flow_num is '关联交易流水号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.tran_cd is '交易代码';
comment on column ${iml_schema}.agt_lon_post_tran_appl.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_lon_post_tran_appl.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_lon_post_tran_appl.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_lon_post_tran_appl.realtm_tran_flg is '实时交易标志';
comment on column ${iml_schema}.agt_lon_post_tran_appl.rolbk_flow_num is '回退流水号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.core_tran_ref_no is '核心交易参考号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.core_entry_flow_num is '核心记账流水号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.fft_tran_type_cd is '福费廷转让类型代码';
comment on column ${iml_schema}.agt_lon_post_tran_appl.grace_int_flg is '宽限利息标志';
comment on column ${iml_schema}.agt_lon_post_tran_appl.grace_pric_flg is '宽限本金标志';
comment on column ${iml_schema}.agt_lon_post_tran_appl.adv_repay_rs_cd is '提前还款原因代码';
comment on column ${iml_schema}.agt_lon_post_tran_appl.adv_repay_comnt is '提前还款说明';
comment on column ${iml_schema}.agt_lon_post_tran_appl.adv_repay_cap_src_comnt is '提前还款资金来源说明';
comment on column ${iml_schema}.agt_lon_post_tran_appl.regroup_loan_flg is '重组贷款标志';
comment on column ${iml_schema}.agt_lon_post_tran_appl.rela_obj_name is '关联对象名称';
comment on column ${iml_schema}.agt_lon_post_tran_appl.obj_id is '对象编号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.doc_type_name is '单据类型名称';
comment on column ${iml_schema}.agt_lon_post_tran_appl.doc_flow_num is '单据流水号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_lon_post_tran_appl.remark is '备注';
comment on column ${iml_schema}.agt_lon_post_tran_appl.other_comnt is '其他说明';
comment on column ${iml_schema}.agt_lon_post_tran_appl.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lon_post_tran_appl.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lon_post_tran_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lon_post_tran_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lon_post_tran_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lon_post_tran_appl.etl_timestamp is 'ETL处理时间戳';
