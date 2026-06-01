/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_seal_acct_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_seal_acct_basic_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_seal_acct_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_seal_acct_basic_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,acct_name varchar2(1500) -- 账户名称
    ,open_acct_dt date -- 开户日期
    ,acct_start_use_dt date -- 账户启用日期
    ,acct_wrtoff_dt date -- 账户注销日期
    ,seal_kind_cd varchar2(30) -- 验印种类代码
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,warn_flg_cd varchar2(30) -- 预警标志代码
    ,pt_type_cd varchar2(30) -- 支付工具类型代码
    ,acct_kind_cd varchar2(30) -- 账户种类代码
    ,tran_kind_cd varchar2(30) -- 交易种类代码
    ,curr_cd varchar2(30) -- 币种代码
    ,unite_acct_flg varchar2(10) -- 联合账户标志
    ,sleep_acct_flg varchar2(10) -- 睡眠户标志
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,oper_teller_id varchar2(60) -- 操作柜员编号
    ,check_teller_id varchar2(60) -- 复核柜员编号
    ,cotas_name varchar2(750) -- 联系人名称
    ,cont_addr varchar2(1500) -- 联系地址
    ,phone_num varchar2(250) -- 联系电话号码
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
grant select on ${icl_schema}.cmm_seal_acct_basic_info to ${idl_schema};
grant select on ${icl_schema}.cmm_seal_acct_basic_info to ${iel_schema};
grant select on ${icl_schema}.cmm_seal_acct_basic_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_seal_acct_basic_info is '验印账户基本信息';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.open_acct_dt is '开户日期';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.acct_start_use_dt is '账户启用日期';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.acct_wrtoff_dt is '账户注销日期';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.seal_kind_cd is '验印种类代码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.warn_flg_cd is '预警标志代码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.pt_type_cd is '支付工具类型代码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.acct_kind_cd is '账户种类代码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.tran_kind_cd is '交易种类代码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.unite_acct_flg is '联合账户标志';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.sleep_acct_flg is '睡眠户标志';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.oper_teller_id is '操作柜员编号';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.check_teller_id is '复核柜员编号';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.cotas_name is '联系人名称';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.cont_addr is '联系地址';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.phone_num is '联系电话号码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_seal_acct_basic_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_seal_acct_basic_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_seal_acct_basic_info.etl_timestamp is 'ETL处理时间戳';
