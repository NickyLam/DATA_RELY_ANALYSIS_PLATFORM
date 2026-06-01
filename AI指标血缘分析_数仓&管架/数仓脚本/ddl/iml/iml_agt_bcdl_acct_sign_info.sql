/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_bcdl_acct_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_bcdl_acct_sign_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_bcdl_acct_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bcdl_acct_sign_info(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,sign_id varchar2(100) -- 签约编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(750) -- 账户名称
    ,cust_id varchar2(100) -- 客户编号
    ,acct_prvlg_cd varchar2(30) -- 账户权限代码
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,acct_sign_status_cd varchar2(30) -- 账户签约状态代码
    ,sign_dt date -- 签约日期
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
grant select on ${iml_schema}.agt_bcdl_acct_sign_info to ${icl_schema};
grant select on ${iml_schema}.agt_bcdl_acct_sign_info to ${idl_schema};
grant select on ${iml_schema}.agt_bcdl_acct_sign_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_bcdl_acct_sign_info is '银企直联账户签约信息';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.sign_id is '签约编号';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.acct_id is '账户编号';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.acct_name is '账户名称';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.cust_id is '客户编号';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.acct_prvlg_cd is '账户权限代码';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.acct_sign_status_cd is '账户签约状态代码';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.create_dt is '创建日期';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.update_dt is '更新日期';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.id_mark is '增删标志';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_bcdl_acct_sign_info.etl_timestamp is 'ETL处理时间戳';
