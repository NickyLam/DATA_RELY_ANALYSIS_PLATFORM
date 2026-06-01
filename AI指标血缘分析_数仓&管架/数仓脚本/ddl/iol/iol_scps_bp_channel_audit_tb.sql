/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_channel_audit_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_channel_audit_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_channel_audit_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_channel_audit_tb(
    task_id varchar2(36) -- 任务号
    ,seq_num varchar2(60) -- 流水号
    ,chn_id varchar2(6) -- 源发起渠道编号
    ,user_no varchar2(10) -- 用户号
    ,cust_na varchar2(200) -- 姓名
    ,ocr_cust_na varchar2(200) -- OCR姓名
    ,access_token varchar2(64) -- 用户信息唯一标志
    ,idtf_tp varchar2(20) -- 证件类型
    ,idtf_no varchar2(40) -- 证件号码
    ,idtd_dt date -- 证件生效日期
    ,ocr_idt_dt date -- 证件生效日期
    ,idt_address varchar2(400) -- 证件地址
    ,ocr_idt_address varchar2(400) -- ocr识别地址
    ,bound_accno varchar2(28) -- 绑定账号
    ,bound_bank varchar2(80) -- 绑定账号开户行
    ,mobile varchar2(30) -- 预留手机号
    ,idcheck_result varchar2(20) -- 身份证联网核查结果
    ,check_case varchar2(200) -- 落地审核原因
    ,rego_result varchar2(10) -- 识别结果
    ,sim_larity varchar2(10) -- 认证相似度
    ,biz_code varchar2(10) -- 业务类型
    ,doc_id varchar2(50) -- 影像批次号
    ,trans_id varchar2(10) -- 业务种类
    ,channel varchar2(6) -- 渠道编号
    ,vouch_group varchar2(20) -- 凭证种类
    ,creation_time varchar2(20) -- 发起时间
    ,audit_result varchar2(2) -- 审核结果(0审核通过 1审核不通过)
    ,audit_status varchar2(2) -- 审核状态（0 未审核 1 审核中 2 审核完成）
    ,bank_no varchar2(10) -- 银行标识
    ,system_no varchar2(10) -- 系统标识
    ,scene_code varchar2(20) -- 业务场景号
    ,organ_no varchar2(10) -- 机构号
    ,receive_no varchar2(60) -- 受理号
    ,id varchar2(30) -- 主键
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
grant select on ${iol_schema}.scps_bp_channel_audit_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_channel_audit_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_channel_audit_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_channel_audit_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_channel_audit_tb is '渠道审核登记簿';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.seq_num is '流水号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.chn_id is '源发起渠道编号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.user_no is '用户号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.cust_na is '姓名';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.ocr_cust_na is 'OCR姓名';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.access_token is '用户信息唯一标志';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.idtf_tp is '证件类型';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.idtf_no is '证件号码';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.idtd_dt is '证件生效日期';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.ocr_idt_dt is '证件生效日期';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.idt_address is '证件地址';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.ocr_idt_address is 'ocr识别地址';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.bound_accno is '绑定账号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.bound_bank is '绑定账号开户行';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.mobile is '预留手机号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.idcheck_result is '身份证联网核查结果';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.check_case is '落地审核原因';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.rego_result is '识别结果';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.sim_larity is '认证相似度';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.biz_code is '业务类型';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.doc_id is '影像批次号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.trans_id is '业务种类';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.channel is '渠道编号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.vouch_group is '凭证种类';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.creation_time is '发起时间';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.audit_result is '审核结果(0审核通过 1审核不通过)';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.audit_status is '审核状态（0 未审核 1 审核中 2 审核完成）';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.bank_no is '银行标识';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.system_no is '系统标识';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.scene_code is '业务场景号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.organ_no is '机构号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.receive_no is '受理号';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.id is '主键';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_channel_audit_tb.etl_timestamp is 'ETL处理时间戳';
