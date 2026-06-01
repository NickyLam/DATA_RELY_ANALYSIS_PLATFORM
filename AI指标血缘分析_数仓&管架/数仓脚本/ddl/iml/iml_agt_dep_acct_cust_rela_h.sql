/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_cust_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_cust_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_cust_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_cust_rela_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,actl_acct_num varchar2(60) -- 实际账号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_name varchar2(500) -- 账户名称
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,priv_flg varchar2(10) -- 对私标志
    ,chn_id varchar2(100) -- 渠道编号
    ,card_flg varchar2(10) -- 卡标志
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,acct_kind_cd varchar2(30) -- 账户种类代码
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,acct_attr_cd varchar2(30) -- 账户属性代码
    ,vtual_acct_flg varchar2(10) -- 虚户标志
    ,deflt_stl_acct_num_flg varchar2(10) -- 默认结算账号标志
    ,main_acct_flg varchar2(10) -- 主账户标志
    ,super_acct_id varchar2(100) -- 上级账户编号
    ,acct_usage_cd varchar2(30) -- 账户用途代码
    ,supp_card_flg varchar2(10) -- 附属卡标志
    ,corp_stl_card_flg varchar2(10) -- 单位结算卡标志
    ,tran_dt date -- 交易日期
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
grant select on ${iml_schema}.agt_dep_acct_cust_rela_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_cust_rela_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_cust_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_cust_rela_h is '存款账户客户关系历史';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.actl_acct_num is '实际账号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.cert_no is '证件号码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.priv_flg is '对私标志';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.card_flg is '卡标志';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.acct_kind_cd is '账户种类代码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.acct_attr_cd is '账户属性代码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.vtual_acct_flg is '虚户标志';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.deflt_stl_acct_num_flg is '默认结算账号标志';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.main_acct_flg is '主账户标志';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.super_acct_id is '上级账户编号';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.acct_usage_cd is '账户用途代码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.supp_card_flg is '附属卡标志';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.corp_stl_card_flg is '单位结算卡标志';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_cust_rela_h.etl_timestamp is 'ETL处理时间戳';
