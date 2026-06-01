/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ponl_bk_add_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ponl_bk_add_acct_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ponl_bk_add_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ponl_bk_add_acct_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,acct_name varchar2(500) -- 账户名称
    ,curr_cd varchar2(30) -- 币种代码
    ,open_prvlg_flg_comb varchar2(30) -- 开通权限标志组合
    ,acct_in_tm timestamp -- 账户挂入时间
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,open_acct_org_name varchar2(500) -- 开户机构名称
    ,add_org_id varchar2(100) -- 加挂机构编号
    ,add_org_name varchar2(500) -- 加挂机构名称
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,acct_alias varchar2(500) -- 账户别名
    ,sign_way_cd varchar2(30) -- 签约方式代码
    ,sign_chn_cd varchar2(30) -- 签约渠道代码
    ,acct_pause_rs_descb varchar2(500) -- 账户暂停原因描述
    ,co_card_type_cd varchar2(30) -- 合作卡类型代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ponl_bk_add_acct_h to ${icl_schema};
grant select on ${iml_schema}.agt_ponl_bk_add_acct_h to ${idl_schema};
grant select on ${iml_schema}.agt_ponl_bk_add_acct_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ponl_bk_add_acct_h is '个人网银加挂账户历史';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.open_prvlg_flg_comb is '开通权限标志组合';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.acct_in_tm is '账户挂入时间';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.open_acct_org_name is '开户机构名称';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.add_org_id is '加挂机构编号';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.add_org_name is '加挂机构名称';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.acct_alias is '账户别名';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.sign_way_cd is '签约方式代码';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.sign_chn_cd is '签约渠道代码';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.acct_pause_rs_descb is '账户暂停原因描述';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.co_card_type_cd is '合作卡类型代码';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ponl_bk_add_acct_h.etl_timestamp is 'ETL处理时间戳';
