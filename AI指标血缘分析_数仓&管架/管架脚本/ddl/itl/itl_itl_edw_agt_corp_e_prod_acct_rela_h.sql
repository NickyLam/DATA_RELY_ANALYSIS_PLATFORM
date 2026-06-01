/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_agt_corp_e_prod_acct_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h(
    acct_rela_id varchar2(100) -- 账户关系编号
    ,lp_id varchar2(60) -- 法人编号
    ,agt_id varchar2(60) -- 协议编号
    ,e_acct_id varchar2(60) -- E账户编号
    ,acct_sub_seq_num varchar2(100) -- 账户子序号
    ,prod_acct_id varchar2(60) -- 产品账户编号
    ,cust_id varchar2(60) -- 客户编号
    ,mercht_id varchar2(60) -- 商户编号
    ,acct_id varchar2(60) -- 账户编号
    ,prod_id varchar2(60) -- 产品编号
    ,acct_role_type_cd varchar2(30) -- 账户角色类型代码
    ,effect_tm timestamp -- 生效时间
    ,invalid_tm timestamp -- 失效时间
    ,start_dt date -- 开始日期
    ,end_dt date -- 结束日期
    ,id_mark varchar2(10) -- 删除标识
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h is '公司电子账户与产品账号关系历史';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.acct_rela_id is '账户关系编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.agt_id is '协议编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.e_acct_id is 'E账户编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.acct_sub_seq_num is '账户子序号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.prod_acct_id is '产品账户编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.cust_id is '客户编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.mercht_id is '商户编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.acct_id is '账户编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.prod_id is '产品编号';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.acct_role_type_cd is '账户角色类型代码';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.effect_tm is '生效时间';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.invalid_tm is '失效时间';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.start_dt is '开始日期';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.end_dt is '结束日期';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.id_mark is '删除标识';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_agt_corp_e_prod_acct_rela_h.etl_timestamp is 'ETL处理时间戳';