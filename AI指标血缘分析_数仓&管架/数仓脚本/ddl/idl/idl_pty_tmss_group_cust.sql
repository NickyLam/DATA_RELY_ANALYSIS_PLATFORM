/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl pty_tmss_group_cust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.pty_tmss_group_cust
whenever sqlerror continue none;
drop table ${idl_schema}.pty_tmss_group_cust purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.pty_tmss_group_cust(
    etl_dt date -- 数据日期   
    ,cust_id varchar2(60) -- 客户编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,party_id varchar2(60) -- 当事人编号   
    ,cust_name varchar2(100) -- 客户名称   
    ,cert_cate_cd varchar2(10) -- 证件类别代码   
    ,cert_type_cd varchar2(10) -- 证件类型代码   
    ,cert_no varchar2(100) -- 证件号码   
    ,group_type_cd varchar2(10) -- 集团类型代码   
    ,multi_bank_serv_flg varchar2(10) -- 多银行服务标志   
    ,open_bank_no varchar2(100) -- 开户行行号   
    ,belong_bank_no varchar2(100) -- 归属行行号   
    ,status_cd varchar2(10) -- 状态代码   
    ,operr_id varchar2(60) -- 操作人编号   
    ,create_tm date -- 创建时间   
    ,checker_id varchar2(60) -- 复核人编号   
    ,check_tm date -- 复核时间   
    ,group_id varchar2(60) -- 集团编号   
    ,unify_soci_crdt_id varchar2(100) -- 统一社会信用编号   
    ,adres_name varchar2(100) -- 收件人名称   
    ,adres_addr varchar2(100) -- 收件人地址   
    ,adres_tel varchar2(100) -- 收件人电话   
    ,adres_remark varchar2(100) -- 收件人备注   
    ,dc_rgst_status_cd varchar2(10) -- 软证书注册状态代码   
    ,dc_valid_tm date -- 软证书有效时间   
    ,ukey_uplmi_cnt number(10) -- ukey上限数   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.pty_tmss_group_cust to ${iel_schema};

-- comment
comment on table ${idl_schema}.pty_tmss_group_cust is '现金管理集团客户';
comment on column ${idl_schema}.pty_tmss_group_cust.etl_dt is '数据日期';
comment on column ${idl_schema}.pty_tmss_group_cust.cust_id is '客户编号';
comment on column ${idl_schema}.pty_tmss_group_cust.lp_id is '法人编号';
comment on column ${idl_schema}.pty_tmss_group_cust.party_id is '当事人编号';
comment on column ${idl_schema}.pty_tmss_group_cust.cust_name is '客户名称';
comment on column ${idl_schema}.pty_tmss_group_cust.cert_cate_cd is '证件类别代码';
comment on column ${idl_schema}.pty_tmss_group_cust.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.pty_tmss_group_cust.cert_no is '证件号码';
comment on column ${idl_schema}.pty_tmss_group_cust.group_type_cd is '集团类型代码';
comment on column ${idl_schema}.pty_tmss_group_cust.multi_bank_serv_flg is '多银行服务标志';
comment on column ${idl_schema}.pty_tmss_group_cust.open_bank_no is '开户行行号';
comment on column ${idl_schema}.pty_tmss_group_cust.belong_bank_no is '归属行行号';
comment on column ${idl_schema}.pty_tmss_group_cust.status_cd is '状态代码';
comment on column ${idl_schema}.pty_tmss_group_cust.operr_id is '操作人编号';
comment on column ${idl_schema}.pty_tmss_group_cust.create_tm is '创建时间';
comment on column ${idl_schema}.pty_tmss_group_cust.checker_id is '复核人编号';
comment on column ${idl_schema}.pty_tmss_group_cust.check_tm is '复核时间';
comment on column ${idl_schema}.pty_tmss_group_cust.group_id is '集团编号';
comment on column ${idl_schema}.pty_tmss_group_cust.unify_soci_crdt_id is '统一社会信用编号';
comment on column ${idl_schema}.pty_tmss_group_cust.adres_name is '收件人名称';
comment on column ${idl_schema}.pty_tmss_group_cust.adres_addr is '收件人地址';
comment on column ${idl_schema}.pty_tmss_group_cust.adres_tel is '收件人电话';
comment on column ${idl_schema}.pty_tmss_group_cust.adres_remark is '收件人备注';
comment on column ${idl_schema}.pty_tmss_group_cust.dc_rgst_status_cd is '软证书注册状态代码';
comment on column ${idl_schema}.pty_tmss_group_cust.dc_valid_tm is '软证书有效时间';
comment on column ${idl_schema}.pty_tmss_group_cust.ukey_uplmi_cnt is 'ukey上限数';
comment on column ${idl_schema}.pty_tmss_group_cust.create_dt is '创建日期';
comment on column ${idl_schema}.pty_tmss_group_cust.update_dt is '更新日期';
comment on column ${idl_schema}.pty_tmss_group_cust.id_mark is '删除标识';