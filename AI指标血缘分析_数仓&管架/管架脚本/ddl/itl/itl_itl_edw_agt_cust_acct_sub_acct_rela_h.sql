/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_agt_cust_acct_sub_acct_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,agt_rela_type_cd varchar2(10) -- 协议关系类型代码
    ,seq_num varchar2(60) -- 序号
    ,rela_agt_id varchar2(60) -- 关联协议编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_sub_acct_id varchar2(60) -- 账户分户编号
    ,stand_b_type_cd varchar2(10) -- 台账类型代码
    ,dep_basic_acct_flg varchar2(10) -- 存款基本户标志
    ,curr_cd varchar2(10) -- 币种代码
    ,ec_flg varchar2(10) -- 钞汇标志
    ,ext_prod_id varchar2(60) -- 外部产品编号
    ,intnal_prod_id varchar2(60) -- 内部产品编号
    ,start_dt date -- 开始日期
    ,end_dt date -- 结束日期
    ,id_mark varchar2(10) -- 删除标识
    ,etl_timestamp timestamp -- ETL处理时间戳
    ,JOB_CD  VARCHAR2(10)

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h is '客户账户与子户关系历史';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.agt_id is '协议编号';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.agt_rela_type_cd is '协议关系类型代码';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.seq_num is '序号';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.rela_agt_id is '关联协议编号';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.acct_id is '账户编号';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.acct_sub_acct_id is '账户分户编号';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.stand_b_type_cd is '台账类型代码';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.dep_basic_acct_flg is '存款基本户标志';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.curr_cd is '币种代码';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.ec_flg is '钞汇标志';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.ext_prod_id is '外部产品编号';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.intnal_prod_id is '内部产品编号';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.start_dt is '开始日期';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.end_dt is '结束日期';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.id_mark is '删除标识';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.etl_timestamp is 'ETL处理时间戳';
comment on column ${itl_schema}.itl_edw_agt_cust_acct_sub_acct_rela_h.JOB_CD is '任务编码';