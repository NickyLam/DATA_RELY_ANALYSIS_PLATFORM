/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_bkcp_check_acct_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_bkcp_check_acct_basic_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bkcp_check_acct_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bkcp_check_acct_basic_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cust_sub_acct_num varchar2(60) -- 客户账户子户号
    ,brch_id varchar2(60) -- 分行编号
    ,subrch_id varchar2(60) -- 支行编号
    ,org_id varchar2(60) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,acct_name varchar2(500) -- 账户名称
    ,cust_id varchar2(60) -- 客户编号
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,sav_type_cd varchar2(30) -- 储种代码
    ,espec_acct_flg_cd varchar2(30) -- 特殊账户标志代码
    ,curr_cd varchar2(30) -- 币种代码
    ,check_entry_way_cd varchar2(30) -- 对账方式代码
    ,check_entry_ped_cd varchar2(30) -- 对账周期代码
    ,bkcp_open_acct_dt date -- 银企开户日期
    ,last_check_entry_dt date -- 上次对账日期
    ,two_unentry_flg_cd varchar2(10) -- 两期未对账标志代码
    ,seal_acct_id varchar2(60) -- 验印账户编号
    ,seal_way_cd varchar2(30) -- 验印方式代码
    ,rgst_addr varchar2(1000) -- 注册地址
    ,post_addr varchar2(1000) -- 邮寄地址
    ,zip_cd varchar2(30) -- 邮政编码
    ,sign_flg varchar2(10) -- 签约标志
    ,sign_dt date -- 签约日期
    ,sign_org_id varchar2(60) -- 签约机构编号
    ,sign_teller_id varchar2(60) -- 签约柜员编号
    ,sign_cont_id varchar2(100) -- 签约合同编号
    ,cotas_name varchar2(500) -- 联系人名称
    ,phone_num varchar2(100) -- 联系电话号码
    ,resv_phone_num varchar2(100) -- 备用联系电话号码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_bkcp_check_acct_basic_info to ${idl_schema};
grant select on ${icl_schema}.cmm_bkcp_check_acct_basic_info to ${iel_schema};
grant select on ${icl_schema}.cmm_bkcp_check_acct_basic_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_bkcp_check_acct_basic_info is '银企对账账户基本信息';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.cust_sub_acct_num is '客户账户子户号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.brch_id is '分行编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.subrch_id is '支行编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.org_id is '机构编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.org_name is '机构名称';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.sav_type_cd is '储种代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.espec_acct_flg_cd is '特殊账户标志代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.check_entry_way_cd is '对账方式代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.check_entry_ped_cd is '对账周期代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.bkcp_open_acct_dt is '银企开户日期';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.last_check_entry_dt is '上次对账日期';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.two_unentry_flg_cd is '两期未对账标志代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.seal_acct_id is '验印账户编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.seal_way_cd is '验印方式代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.rgst_addr is '注册地址';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.post_addr is '邮寄地址';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.zip_cd is '邮政编码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.sign_flg is '签约标志';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.sign_dt is '签约日期';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.sign_org_id is '签约机构编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.sign_teller_id is '签约柜员编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.sign_cont_id is '签约合同编号';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.cotas_name is '联系人名称';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.phone_num is '联系电话号码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.resv_phone_num is '备用联系电话号码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_bkcp_check_acct_basic_info.etl_timestamp is 'ETL处理时间戳';
