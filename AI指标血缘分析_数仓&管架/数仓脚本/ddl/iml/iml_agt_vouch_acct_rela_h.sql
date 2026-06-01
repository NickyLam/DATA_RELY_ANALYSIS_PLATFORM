/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_vouch_acct_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_vouch_acct_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_vouch_acct_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_vouch_acct_rela_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,dep_vouch_cate_cd varchar2(30) -- 存款凭证类别代码
    ,vouch_no varchar2(60) -- 凭证号码
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,card_no varchar2(60) -- 卡号
    ,vouch_kind_cd varchar2(30) -- 凭证种类代码
    ,vouch_status_cd varchar2(30) -- 凭证状态代码
    ,vouch_orig_status_cd varchar2(30) -- 凭证原状态代码
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,pm_flg varchar2(10) -- 抵质押标志
    ,pm_id varchar2(100) -- 抵质押编号
    ,cust_id varchar2(100) -- 客户编号
    ,tran_memo_descb varchar2(500) -- 交易摘要描述
    ,tran_dt date -- 交易日期
    ,tran_timestamp date -- 交易时间
    ,cancel_rs_cd varchar2(30) -- 作废原因代码
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
grant select on ${iml_schema}.agt_vouch_acct_rela_h to ${icl_schema};
grant select on ${iml_schema}.agt_vouch_acct_rela_h to ${idl_schema};
grant select on ${iml_schema}.agt_vouch_acct_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_vouch_acct_rela_h is '凭证账户关系历史';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.vouch_no is '凭证号码';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.card_no is '卡号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.vouch_kind_cd is '凭证种类代码';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.vouch_status_cd is '凭证状态代码';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.vouch_orig_status_cd is '凭证原状态代码';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.pm_flg is '抵质押标志';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.pm_id is '抵质押编号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.tran_memo_descb is '交易摘要描述';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.tran_timestamp is '交易时间';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.cancel_rs_cd is '作废原因代码';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_vouch_acct_rela_h.etl_timestamp is 'ETL处理时间戳';
