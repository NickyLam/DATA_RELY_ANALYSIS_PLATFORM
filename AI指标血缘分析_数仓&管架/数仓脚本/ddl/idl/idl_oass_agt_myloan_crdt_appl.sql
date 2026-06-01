/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_myloan_crdt_appl
CreateDate: 20250211
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_myloan_crdt_appl purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_myloan_crdt_appl(
etl_dt date --ETL处理日期
,crdt_appl_id varchar2(100) --授信申请编号
,appl_flow_num varchar2(250) --申请流水号
,prod_id varchar2(100) --产品编号
,appl_dt date --申请日期
,cust_name varchar2(750) --客户名称
,cust_id varchar2(100) --客户编号
,crdt_lmt number(30,8) --授信额度
,apv_start_tm timestamp(6) --审批开始时间
,apv_end_tm timestamp(6) --审批结束时间
,apv_status_cd varchar2(60) --审批状态代码
,final_jud_advise_sucs_flg varchar2(10) --终审通知成功标志
,final_jud_advise_tm timestamp(6) --终审通知时间
,cust_mgr_id varchar2(60) --客户经理编号
,rgst_org_id varchar2(60) --登记机构编号
,farm_flg varchar2(10) --农户标志
,refuse_rs varchar2(3000) --拒绝原因
,mobile_no varchar2(60) --手机号码
,crdt_sugst_lmt number(30,2) --授信建议额度
,netw_vrfction_status_cd varchar2(30) --联网核查状态代码
,prod_name varchar2(750) --产品名称
,apv_rest_cd varchar2(30) --审批结果代码
,bus_scene_cd varchar2(30) --业务场景代码
,lmt_status_cd varchar2(30) --额度状态代码
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,bank_supv_custs_mang_lab varchar2(96) --银监客群经营标签
,pbc_custs_mang_lab varchar2(96) --人行客群经营标签
,appl_id varchar2(100) --申请编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_myloan_crdt_appl to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_myloan_crdt_appl is '网商贷授信申请';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.crdt_appl_id is '授信申请编号';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.appl_flow_num is '申请流水号';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.prod_id is '产品编号';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.appl_dt is '申请日期';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.cust_name is '客户名称';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.crdt_lmt is '授信额度';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.apv_start_tm is '审批开始时间';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.apv_end_tm is '审批结束时间';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.apv_status_cd is '审批状态代码';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.final_jud_advise_sucs_flg is '终审通知成功标志';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.final_jud_advise_tm is '终审通知时间';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.farm_flg is '农户标志';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.refuse_rs is '拒绝原因';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.mobile_no is '手机号码';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.crdt_sugst_lmt is '授信建议额度';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.netw_vrfction_status_cd is '联网核查状态代码';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.prod_name is '产品名称';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.apv_rest_cd is '审批结果代码';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.bus_scene_cd is '业务场景代码';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.lmt_status_cd is '额度状态代码';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.bank_supv_custs_mang_lab is '银监客群经营标签';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.pbc_custs_mang_lab is '人行客群经营标签';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.appl_id is '申请编号';
comment on column ${idl_schema}.oass_agt_myloan_crdt_appl.lp_id is '法人编号';

