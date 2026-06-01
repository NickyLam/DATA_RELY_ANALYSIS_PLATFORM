/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_tran_bank_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_tran_bank_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_tran_bank_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tran_bank_acct(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,operr_id varchar2(100) -- 操作员编号
    ,operr_name varchar2(500) -- 操作员名称
    ,acct_cate_cd varchar2(30) -- 账户类别代码
    ,acct_name varchar2(500) -- 账户名称
    ,ec_idf_cd varchar2(30) -- 钞汇标识代码
    ,curr_cd varchar2(30) -- 币种代码
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,sign_flg varchar2(10) -- 签约标志
    ,sign_chn_cd varchar2(30) -- 签约渠道代码
    ,hide_flg varchar2(10) -- 隐藏标志
    ,prvlg_open_flg varchar2(10) -- 权限开通标志
    ,src_sys_cd varchar2(30) -- 来源系统代码
    ,fir_bind_tm date -- 首次绑定时间
    ,rels_dt date -- 解约日期
    ,core_open_tm date -- 核心开户时间
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_tran_bank_acct to ${icl_schema};
grant select on ${iml_schema}.agt_tran_bank_acct to ${idl_schema};
grant select on ${iml_schema}.agt_tran_bank_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_tran_bank_acct is '交易银行账户';
comment on column ${iml_schema}.agt_tran_bank_acct.agt_id is '协议编号';
comment on column ${iml_schema}.agt_tran_bank_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_tran_bank_acct.acct_id is '账户编号';
comment on column ${iml_schema}.agt_tran_bank_acct.cust_id is '客户编号';
comment on column ${iml_schema}.agt_tran_bank_acct.operr_id is '操作员编号';
comment on column ${iml_schema}.agt_tran_bank_acct.operr_name is '操作员名称';
comment on column ${iml_schema}.agt_tran_bank_acct.acct_cate_cd is '账户类别代码';
comment on column ${iml_schema}.agt_tran_bank_acct.acct_name is '账户名称';
comment on column ${iml_schema}.agt_tran_bank_acct.ec_idf_cd is '钞汇标识代码';
comment on column ${iml_schema}.agt_tran_bank_acct.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_tran_bank_acct.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_tran_bank_acct.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_tran_bank_acct.sign_flg is '签约标志';
comment on column ${iml_schema}.agt_tran_bank_acct.sign_chn_cd is '签约渠道代码';
comment on column ${iml_schema}.agt_tran_bank_acct.hide_flg is '隐藏标志';
comment on column ${iml_schema}.agt_tran_bank_acct.prvlg_open_flg is '权限开通标志';
comment on column ${iml_schema}.agt_tran_bank_acct.src_sys_cd is '来源系统代码';
comment on column ${iml_schema}.agt_tran_bank_acct.fir_bind_tm is '首次绑定时间';
comment on column ${iml_schema}.agt_tran_bank_acct.rels_dt is '解约日期';
comment on column ${iml_schema}.agt_tran_bank_acct.core_open_tm is '核心开户时间';
comment on column ${iml_schema}.agt_tran_bank_acct.create_dt is '创建日期';
comment on column ${iml_schema}.agt_tran_bank_acct.update_dt is '更新日期';
comment on column ${iml_schema}.agt_tran_bank_acct.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_tran_bank_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_tran_bank_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_tran_bank_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_tran_bank_acct.etl_timestamp is 'ETL处理时间戳';
