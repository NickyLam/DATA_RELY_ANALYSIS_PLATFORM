/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_pos_mercht_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_pos_mercht_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_pos_mercht_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_pos_mercht_info_h(
    mercht_seq_num varchar2(60) -- 商户序号
    ,lp_id varchar2(60) -- 法人编号
    ,mercht_id varchar2(60) -- 商户编号
    ,mercht_cn_abbr varchar2(150) -- 商户中文简称
    ,mercht_cn_name varchar2(150) -- 商户中文名称
    ,mercht_addr varchar2(150) -- 商户地址
    ,mercht_local_rg_cd varchar2(30) -- 商户地区代码
    ,mercht_sign_dt date -- 商户签约日期
    ,stl_acct_type_cd varchar2(30) -- 结算账户类型代码
    ,mercht_revo_dt date -- 商户撤销日期
    ,co_status_cd varchar2(30) -- 合作状态代码
    ,acquiri_bank_num varchar2(60) -- 收单行号
    ,open_bank_name varchar2(150) -- 开户行名称
    ,acct_id varchar2(60) -- 账户编号
    ,cotas_name varchar2(150) -- 联系人名称
    ,cotas_cert_no varchar2(60) -- 联系人证件号码
    ,cotas_tel_num varchar2(60) -- 联系人电话号码
    ,fax_num varchar2(60) -- 传真号码
    ,agency_name varchar2(150) -- 代理商名称
    ,acct_name varchar2(150) -- 账户名称
    ,open_bank_no varchar2(60) -- 开户行行号
    ,check_status_cd varchar2(10) -- 审核状态代码
    ,recv_org_id varchar2(60) -- 收单机构编号
    ,mcc_code varchar2(15) -- MCC码
    ,unify_soci_crdt_cd varchar2(60) -- 统一社会信用代码
    ,cust_mgr_name varchar2(150) -- 客户经理姓名
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,acvmnt_assign_ratio varchar2(30) -- 业绩分配比例
    ,zip_cd varchar2(30) -- 邮政编码
    ,start_use_dt date -- 启用日期
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
grant select on ${iml_schema}.pty_pos_mercht_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_pos_mercht_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_pos_mercht_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_pos_mercht_info_h is 'POS商户信息历史';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mercht_seq_num is '商户序号';
comment on column ${iml_schema}.pty_pos_mercht_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mercht_id is '商户编号';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mercht_cn_abbr is '商户中文简称';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mercht_cn_name is '商户中文名称';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mercht_addr is '商户地址';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mercht_local_rg_cd is '商户地区代码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mercht_sign_dt is '商户签约日期';
comment on column ${iml_schema}.pty_pos_mercht_info_h.stl_acct_type_cd is '结算账户类型代码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mercht_revo_dt is '商户撤销日期';
comment on column ${iml_schema}.pty_pos_mercht_info_h.co_status_cd is '合作状态代码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.acquiri_bank_num is '收单行号';
comment on column ${iml_schema}.pty_pos_mercht_info_h.open_bank_name is '开户行名称';
comment on column ${iml_schema}.pty_pos_mercht_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.pty_pos_mercht_info_h.cotas_name is '联系人名称';
comment on column ${iml_schema}.pty_pos_mercht_info_h.cotas_cert_no is '联系人证件号码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.cotas_tel_num is '联系人电话号码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.fax_num is '传真号码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.agency_name is '代理商名称';
comment on column ${iml_schema}.pty_pos_mercht_info_h.acct_name is '账户名称';
comment on column ${iml_schema}.pty_pos_mercht_info_h.open_bank_no is '开户行行号';
comment on column ${iml_schema}.pty_pos_mercht_info_h.check_status_cd is '审核状态代码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.recv_org_id is '收单机构编号';
comment on column ${iml_schema}.pty_pos_mercht_info_h.mcc_code is 'MCC码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.unify_soci_crdt_cd is '统一社会信用代码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.cust_mgr_name is '客户经理姓名';
comment on column ${iml_schema}.pty_pos_mercht_info_h.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.pty_pos_mercht_info_h.acvmnt_assign_ratio is '业绩分配比例';
comment on column ${iml_schema}.pty_pos_mercht_info_h.zip_cd is '邮政编码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.start_use_dt is '启用日期';
comment on column ${iml_schema}.pty_pos_mercht_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_pos_mercht_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_pos_mercht_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_pos_mercht_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_pos_mercht_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_pos_mercht_info_h.etl_timestamp is 'ETL处理时间戳';
