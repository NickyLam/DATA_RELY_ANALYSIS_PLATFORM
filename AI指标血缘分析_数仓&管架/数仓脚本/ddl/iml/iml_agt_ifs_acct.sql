/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ifs_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ifs_acct
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ifs_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ifs_acct(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_name varchar2(150) -- 账户名称
    ,cust_id varchar2(60) -- 客户编号
    ,acct_type_cd varchar2(10) -- 账户类型代码
    ,open_acct_chn_cd varchar2(10) -- 开户渠道代码
    ,open_acct_dt date -- 开户日期
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,froz_status_cd varchar2(10) -- 冻结状态代码
    ,stop_pay_status_cd varchar2(10) -- 止付状态代码
    ,acpt_pay_flg_cd varchar2(10) -- 收付标志代码
    ,sleep_acct_flg varchar2(10) -- 睡眠户标志
    ,dormt_acct_flg varchar2(10) -- 不动户标志
    ,acct_usage_cd varchar2(30) -- 账户用途代码
    ,open_acct_flow_id varchar2(60) -- 开户流水编号
    ,acct_kind_cd varchar2(10) -- 账户种类代码
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_tm timestamp -- 销户时间
    ,clos_acct_flow_num varchar2(60) -- 销户流水号
    ,final_sub_acct_seq_num varchar2(10) -- 最后子户序号
    ,bind_we_acct_id varchar2(100) -- 绑定微众账户编号
    ,final_activ_acct_dt date -- 最后动户日期
    ,open_acct_cmplt_tm timestamp -- 开户完成时间
    ,sync_status_cd varchar2(10) -- 同步状态代码
    ,sav_type_cd varchar2(30) -- 储种代码
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
grant select on ${iml_schema}.agt_ifs_acct to ${icl_schema};
grant select on ${iml_schema}.agt_ifs_acct to ${idl_schema};
grant select on ${iml_schema}.agt_ifs_acct to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ifs_acct is '联合存款账户';
comment on column ${iml_schema}.agt_ifs_acct.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ifs_acct.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ifs_acct.acct_id is '账户编号';
comment on column ${iml_schema}.agt_ifs_acct.acct_name is '账户名称';
comment on column ${iml_schema}.agt_ifs_acct.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ifs_acct.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_ifs_acct.open_acct_chn_cd is '开户渠道代码';
comment on column ${iml_schema}.agt_ifs_acct.open_acct_dt is '开户日期';
comment on column ${iml_schema}.agt_ifs_acct.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_ifs_acct.froz_status_cd is '冻结状态代码';
comment on column ${iml_schema}.agt_ifs_acct.stop_pay_status_cd is '止付状态代码';
comment on column ${iml_schema}.agt_ifs_acct.acpt_pay_flg_cd is '收付标志代码';
comment on column ${iml_schema}.agt_ifs_acct.sleep_acct_flg is '睡眠户标志';
comment on column ${iml_schema}.agt_ifs_acct.dormt_acct_flg is '不动户标志';
comment on column ${iml_schema}.agt_ifs_acct.acct_usage_cd is '账户用途代码';
comment on column ${iml_schema}.agt_ifs_acct.open_acct_flow_id is '开户流水编号';
comment on column ${iml_schema}.agt_ifs_acct.acct_kind_cd is '账户种类代码';
comment on column ${iml_schema}.agt_ifs_acct.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.agt_ifs_acct.clos_acct_dt is '销户日期';
comment on column ${iml_schema}.agt_ifs_acct.clos_acct_tm is '销户时间';
comment on column ${iml_schema}.agt_ifs_acct.clos_acct_flow_num is '销户流水号';
comment on column ${iml_schema}.agt_ifs_acct.final_sub_acct_seq_num is '最后子户序号';
comment on column ${iml_schema}.agt_ifs_acct.bind_we_acct_id is '绑定微众账户编号';
comment on column ${iml_schema}.agt_ifs_acct.final_activ_acct_dt is '最后动户日期';
comment on column ${iml_schema}.agt_ifs_acct.open_acct_cmplt_tm is '开户完成时间';
comment on column ${iml_schema}.agt_ifs_acct.sync_status_cd is '同步状态代码';
comment on column ${iml_schema}.agt_ifs_acct.sav_type_cd is '储种代码';
comment on column ${iml_schema}.agt_ifs_acct.create_dt is '创建日期';
comment on column ${iml_schema}.agt_ifs_acct.update_dt is '更新日期';
comment on column ${iml_schema}.agt_ifs_acct.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_ifs_acct.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ifs_acct.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ifs_acct.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ifs_acct.etl_timestamp is 'ETL处理时间戳';
