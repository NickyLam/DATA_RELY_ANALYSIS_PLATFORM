/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_pty_corp_cust_group_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_pty_corp_cust_group_info_h
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_pty_corp_cust_group_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_pty_corp_cust_group_info_h(
    etl_dt date -- 数据日期
    ,party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,belong_group_id varchar2(60) -- 所属集团编号
    ,data_src_cd varchar2(10) -- 数据来源代码
    ,belong_group_name varchar2(100) -- 所属集团名称
    ,belong_group_orgnz_cd varchar2(60) -- 所属集团组织机构代码
    ,belong_group_loan_card_no varchar2(60) -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd varchar2(10) -- 所属集团注册国家地区代码
    ,belong_group_site_cd varchar2(10) -- 所属集团所在地代码
    ,belong_group_rgst_addr varchar2(500) -- 所属集团注册地址
    ,group_core_mem_flg varchar2(10) -- 集团核心成员标志
    ,belong_group_dom_work_addr varchar2(500) -- 所属集团国内办公地址
    ,mem_type_cd varchar2(10) -- 成员类型代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_pty_corp_cust_group_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_pty_corp_cust_group_info_h is '对公客户集团信息历史';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.party_id is '当事人编号';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.belong_group_id is '所属集团编号';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.data_src_cd is '数据来源代码';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.belong_group_name is '所属集团名称';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.belong_group_orgnz_cd is '所属集团组织机构代码';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.belong_group_loan_card_no is '所属集团贷款卡号';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.belong_group_rgst_cty_rg_cd is '所属集团注册国家地区代码';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.belong_group_site_cd is '所属集团所在地代码';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.belong_group_rgst_addr is '所属集团注册地址';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.group_core_mem_flg is '集团核心成员标志';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.belong_group_dom_work_addr is '所属集团国内办公地址';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.mem_type_cd is '成员类型代码';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_pty_corp_cust_group_info_h.etl_timestamp is '数据处理时间';
