/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_ap_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_ap_apply
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_ap_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_ap_apply(
    id number(22,0) -- 物理主键
    ,appl_no varchar2(4000) -- 申请号
    ,user_no varchar2(4000) -- 用户号
    ,id_no_encryptx varchar2(4000) -- 身份证号号密文
    ,id_no_md5x varchar2(4000) -- 身份证号MD5
    ,id_type varchar2(4000) -- 证件类型
    ,cust_name_encryptx varchar2(4000) -- 姓名密文
    ,cust_name_md5x varchar2(4000) -- 姓名MD5
    ,mobile_no_encryptx varchar2(4000) -- 手机号密文
    ,mobile_no_md5x varchar2(4000) -- 手机号MD5
    ,purpose_no varchar2(4000) -- 贷款用途
    ,product_code varchar2(4000) -- 产品代码
    ,product_type varchar2(4000) -- 产品类型：消费贷，经营贷
    ,ref_appl_no varchar2(4000) -- 关联业务申请号（第三方）
    ,org_no varchar2(4000) -- 所属机构编号
    ,sub_org_no varchar2(4000) -- 子机构编码
    ,regist_channel varchar2(4000) -- 注册渠道
    ,apply_channel varchar2(4000) -- 申请渠道
    ,sub_channel varchar2(4000) -- 子渠道
    ,state varchar2(4000) -- 申请状态 审批中/通过/拒绝
    ,reject_code varchar2(4000) -- 拒绝代码
    ,reject_msg varchar2(4000) -- 拒绝原因
    ,date_finished date -- 申请结束时间
    ,approval_user varchar2(4000) -- 审批通过用户
    ,appr_auto_amt number(38,8) -- 自动审批通过金额
    ,appr_manual_amt number(38,8) -- 人工审批通过金额
    ,appr_final_amt number(38,8) -- 人工最终审批金额
    ,contract_no varchar2(4000) -- 额度合同号
    ,manual_flag varchar2(4000) -- 是否走人工审批（Y 表示走人工审批流程）
    ,user_type varchar2(4000) -- 授信人类型 MASTER=主借人 COBO=共借人 COOWNER=共有人 GURANTEE=担保人
    ,date_created timestamp -- 创建时间
    ,created_by varchar2(4000) -- 创建人
    ,date_updated timestamp -- 修改时间
    ,updated_by varchar2(4000) -- 修改人
    ,scene_value varchar2(4000) -- scene_value
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pcls_ap_apply to ${iml_schema};
grant select on ${iol_schema}.pcls_ap_apply to ${icl_schema};
grant select on ${iol_schema}.pcls_ap_apply to ${idl_schema};
grant select on ${iol_schema}.pcls_ap_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_ap_apply is '授信申请表';
comment on column ${iol_schema}.pcls_ap_apply.id is '物理主键';
comment on column ${iol_schema}.pcls_ap_apply.appl_no is '申请号';
comment on column ${iol_schema}.pcls_ap_apply.user_no is '用户号';
comment on column ${iol_schema}.pcls_ap_apply.id_no_encryptx is '身份证号号密文';
comment on column ${iol_schema}.pcls_ap_apply.id_no_md5x is '身份证号MD5';
comment on column ${iol_schema}.pcls_ap_apply.id_type is '证件类型';
comment on column ${iol_schema}.pcls_ap_apply.cust_name_encryptx is '姓名密文';
comment on column ${iol_schema}.pcls_ap_apply.cust_name_md5x is '姓名MD5';
comment on column ${iol_schema}.pcls_ap_apply.mobile_no_encryptx is '手机号密文';
comment on column ${iol_schema}.pcls_ap_apply.mobile_no_md5x is '手机号MD5';
comment on column ${iol_schema}.pcls_ap_apply.purpose_no is '贷款用途';
comment on column ${iol_schema}.pcls_ap_apply.product_code is '产品代码';
comment on column ${iol_schema}.pcls_ap_apply.product_type is '产品类型：消费贷，经营贷';
comment on column ${iol_schema}.pcls_ap_apply.ref_appl_no is '关联业务申请号（第三方）';
comment on column ${iol_schema}.pcls_ap_apply.org_no is '所属机构编号';
comment on column ${iol_schema}.pcls_ap_apply.sub_org_no is '子机构编码';
comment on column ${iol_schema}.pcls_ap_apply.regist_channel is '注册渠道';
comment on column ${iol_schema}.pcls_ap_apply.apply_channel is '申请渠道';
comment on column ${iol_schema}.pcls_ap_apply.sub_channel is '子渠道';
comment on column ${iol_schema}.pcls_ap_apply.state is '申请状态 审批中/通过/拒绝';
comment on column ${iol_schema}.pcls_ap_apply.reject_code is '拒绝代码';
comment on column ${iol_schema}.pcls_ap_apply.reject_msg is '拒绝原因';
comment on column ${iol_schema}.pcls_ap_apply.date_finished is '申请结束时间';
comment on column ${iol_schema}.pcls_ap_apply.approval_user is '审批通过用户';
comment on column ${iol_schema}.pcls_ap_apply.appr_auto_amt is '自动审批通过金额';
comment on column ${iol_schema}.pcls_ap_apply.appr_manual_amt is '人工审批通过金额';
comment on column ${iol_schema}.pcls_ap_apply.appr_final_amt is '人工最终审批金额';
comment on column ${iol_schema}.pcls_ap_apply.contract_no is '额度合同号';
comment on column ${iol_schema}.pcls_ap_apply.manual_flag is '是否走人工审批（Y 表示走人工审批流程）';
comment on column ${iol_schema}.pcls_ap_apply.user_type is '授信人类型 MASTER=主借人 COBO=共借人 COOWNER=共有人 GURANTEE=担保人';
comment on column ${iol_schema}.pcls_ap_apply.date_created is '创建时间';
comment on column ${iol_schema}.pcls_ap_apply.created_by is '创建人';
comment on column ${iol_schema}.pcls_ap_apply.date_updated is '修改时间';
comment on column ${iol_schema}.pcls_ap_apply.updated_by is '修改人';
comment on column ${iol_schema}.pcls_ap_apply.scene_value is 'scene_value';
comment on column ${iol_schema}.pcls_ap_apply.start_dt is '开始时间';
comment on column ${iol_schema}.pcls_ap_apply.end_dt is '结束时间';
comment on column ${iol_schema}.pcls_ap_apply.id_mark is '增删标志';
comment on column ${iol_schema}.pcls_ap_apply.etl_timestamp is 'ETL处理时间戳';
