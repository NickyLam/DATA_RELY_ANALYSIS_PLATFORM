/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_offi_acco_rgst_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_offi_acco_rgst_info
whenever sqlerror continue none;
drop table ${iml_schema}.evt_offi_acco_rgst_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_offi_acco_rgst_info(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,offi_acco_user_idf varchar2(250) -- 公众号用户标识
    ,offi_acco_type_cd varchar2(30) -- 公众号类型代码
    ,bind_status_cd varchar2(30) -- 绑定状态代码
    ,fir_bind_dt date -- 首次绑定日期
    ,bind_chn_cd varchar2(30) -- 绑定渠道代码
    ,repl_dsply_flg varchar2(10) -- 切换显示标志
    ,acct_id varchar2(100) -- 账户编号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,operr_id varchar2(100) -- 操作员编号
    ,operr_name varchar2(500) -- 操作员姓名
    ,operr_tel_num varchar2(60) -- 操作员电话号码
    ,corp_cust_id varchar2(100) -- 企业客户编号
    ,corp_cert_type_cd varchar2(30) -- 企业证件类型代码
    ,corp_cert_no varchar2(60) -- 企业证件号码
    ,final_update_dt date -- 最后更新日期
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.evt_offi_acco_rgst_info to ${icl_schema};
grant select on ${iml_schema}.evt_offi_acco_rgst_info to ${idl_schema};
grant select on ${iml_schema}.evt_offi_acco_rgst_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_offi_acco_rgst_info is '公众号用户注册信息';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.evt_id is '事件编号';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.lp_id is '法人编号';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.offi_acco_user_idf is '公众号用户标识';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.offi_acco_type_cd is '公众号类型代码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.bind_status_cd is '绑定状态代码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.fir_bind_dt is '首次绑定日期';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.bind_chn_cd is '绑定渠道代码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.repl_dsply_flg is '切换显示标志';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.acct_id is '账户编号';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.cert_no is '证件号码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.operr_id is '操作员编号';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.operr_name is '操作员姓名';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.operr_tel_num is '操作员电话号码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.corp_cust_id is '企业客户编号';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.corp_cert_type_cd is '企业证件类型代码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.corp_cert_no is '企业证件号码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.job_cd is '任务编码';
comment on column ${iml_schema}.evt_offi_acco_rgst_info.etl_timestamp is 'ETL处理时间戳';
