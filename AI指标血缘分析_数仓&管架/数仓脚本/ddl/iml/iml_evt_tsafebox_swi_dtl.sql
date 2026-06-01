/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tsafebox_swi_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tsafebox_swi_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tsafebox_swi_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tsafebox_swi_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,doc_name varchar2(500) -- 文件名称
    ,insure_id varchar2(100) -- 保险箱编号
    ,rgst_dt date -- 登记日期
    ,oper_dt date -- 操作日期
    ,operr_name varchar2(500) -- 操作人名称
    ,open_box_way_cd varchar2(60) -- 开箱方式代码
    ,open_box_dt date -- 开箱日期
    ,unpacker_pub_priv_idf_cd varchar2(30) -- 开箱人公私标识代码
    ,unpacker_name varchar2(500) -- 开箱人姓名
    ,unpacker_id_card_proof varchar2(30) -- 开箱人身份证明文件
    ,unpacker_cert_no varchar2(250) -- 开箱人证件号码
    ,unpacker_cert_valid_dt date -- 开箱人证件有效日期
    ,unpacker_idti_type_cd varchar2(500) -- 开箱人身份类型代码
    ,brac_org_id varchar2(100) -- 网点机构编号
    ,actl_user_pub_priv_idf_cd varchar2(30) -- 实际使用人公私标识代码
    ,actl_user_name varchar2(500) -- 实际使用人姓名
    ,actl_user_id_card_proof varchar2(30) -- 实际使用人身份证明文件
    ,actl_user_cert_id varchar2(250) -- 实际使用人证件编号
    ,actl_user_cert_valid_dt date -- 实际使用人证件有效日期
    ,actl_use_cust_id varchar2(100) -- 实际使用客户编号
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.evt_tsafebox_swi_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_tsafebox_swi_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_tsafebox_swi_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tsafebox_swi_dtl is '保险箱开关箱明细';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.doc_name is '文件名称';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.insure_id is '保险箱编号';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.rgst_dt is '登记日期';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.oper_dt is '操作日期';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.operr_name is '操作人名称';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.open_box_way_cd is '开箱方式代码';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.open_box_dt is '开箱日期';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.unpacker_pub_priv_idf_cd is '开箱人公私标识代码';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.unpacker_name is '开箱人姓名';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.unpacker_id_card_proof is '开箱人身份证明文件';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.unpacker_cert_no is '开箱人证件号码';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.unpacker_cert_valid_dt is '开箱人证件有效日期';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.unpacker_idti_type_cd is '开箱人身份类型代码';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.brac_org_id is '网点机构编号';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.actl_user_pub_priv_idf_cd is '实际使用人公私标识代码';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.actl_user_name is '实际使用人姓名';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.actl_user_id_card_proof is '实际使用人身份证明文件';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.actl_user_cert_id is '实际使用人证件编号';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.actl_user_cert_valid_dt is '实际使用人证件有效日期';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.actl_use_cust_id is '实际使用客户编号';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tsafebox_swi_dtl.etl_timestamp is 'ETL处理时间戳';
