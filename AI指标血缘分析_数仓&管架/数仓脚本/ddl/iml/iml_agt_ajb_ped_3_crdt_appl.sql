/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ajb_ped_3_crdt_appl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ajb_ped_3_crdt_appl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ajb_ped_3_crdt_appl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ajb_ped_3_crdt_appl(
    appl_id varchar2(60) -- 申请编号
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(60) -- 产品编号
    ,prod_name varchar2(250) -- 产品名称
    ,appl_dt date -- 申请日期
    ,appl_flow_num varchar2(100) -- 申请流水号
    ,crdt_appl_id varchar2(100) -- 授信申请编号
    ,crdt_appl_type_cd varchar2(60) -- 授信申请类型代码
    ,appl_src_cd varchar2(60) -- 申请来源代码
    ,cust_id varchar2(60) -- 客户编号
    ,appl_exp_tm timestamp -- 申请过期时间
    ,crdt_lmt number(30,2) -- 授信额度
    ,open_acct_sucs_flg varchar2(10) -- 开户成功标志
    ,final_jud_advise_sucs_flg varchar2(10) -- 终审通知成功标志
    ,apv_start_tm timestamp -- 审批开始时间
    ,apv_end_tm timestamp -- 审批结束时间
    ,check_anti_fraud_flg varchar2(10) -- 验证反欺诈标志
    ,remark varchar2(2000) -- 备注
    ,rgstrat_id varchar2(60) -- 登记人编号
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,apv_rest_code varchar2(100) -- 审批结果码
    ,apv_rest_descb varchar2(1000) -- 审批结果描述
    ,apved_flg varchar2(10) -- 审批通过标志
    ,crdt_valid_dt date -- 授信有效日期
    ,crdtc_acqt_sucs_flg varchar2(10) -- 征信采集成功标志
    ,crdtc_check_sucs_flg varchar2(10) -- 征信校验成功标志
    ,score_val varchar2(10) -- 评分分值
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ajb_ped_3_crdt_appl to ${icl_schema};
grant select on ${iml_schema}.agt_ajb_ped_3_crdt_appl to ${idl_schema};
grant select on ${iml_schema}.agt_ajb_ped_3_crdt_appl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ajb_ped_3_crdt_appl is '借呗三期授信申请';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.appl_id is '申请编号';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.prod_name is '产品名称';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.appl_dt is '申请日期';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.appl_flow_num is '申请流水号';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.crdt_appl_id is '授信申请编号';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.crdt_appl_type_cd is '授信申请类型代码';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.appl_src_cd is '申请来源代码';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.appl_exp_tm is '申请过期时间';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.crdt_lmt is '授信额度';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.open_acct_sucs_flg is '开户成功标志';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.final_jud_advise_sucs_flg is '终审通知成功标志';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.apv_start_tm is '审批开始时间';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.apv_end_tm is '审批结束时间';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.check_anti_fraud_flg is '验证反欺诈标志';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.remark is '备注';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.rgstrat_id is '登记人编号';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.apv_rest_code is '审批结果码';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.apv_rest_descb is '审批结果描述';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.apved_flg is '审批通过标志';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.crdt_valid_dt is '授信有效日期';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.crdtc_acqt_sucs_flg is '征信采集成功标志';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.crdtc_check_sucs_flg is '征信校验成功标志';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.score_val is '评分分值';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.create_dt is '创建日期';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.update_dt is '更新日期';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ajb_ped_3_crdt_appl.etl_timestamp is 'ETL处理时间戳';
