/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_dep_acct_chn_lmt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_dep_acct_chn_lmt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_dep_acct_chn_lmt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_chn_lmt_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,ctrl_id varchar2(100) -- 控制编号
    ,ctrl_type_cd varchar2(30) -- 控制类型代码
    ,ctrl_status_cd varchar2(30) -- 控制状态代码
    ,cust_acct_num varchar2(60) -- 客户账号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,lmt_lev_cd varchar2(30) -- 限制级别代码
    ,tran_id varchar2(100) -- 交易编号
    ,tran_timestamp date -- 交易时间
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,lmt_acct_range_cd varchar2(30) -- 限制账户范围代码
    ,chn_id varchar2(100) -- 渠道编号
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,final_modif_dt date -- 最后修改日期
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,unloss_tm timestamp -- 解挂时间
    ,unloss_teller_id varchar2(100) -- 解挂柜员编号
    ,memo_descb varchar2(500) -- 摘要描述
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
grant select on ${iml_schema}.agt_dep_acct_chn_lmt_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_dep_acct_chn_lmt_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_dep_acct_chn_lmt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_dep_acct_chn_lmt_info_h is '存款账户渠道限制信息历史';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.ctrl_id is '控制编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.ctrl_type_cd is '控制类型代码';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.ctrl_status_cd is '控制状态代码';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.lmt_lev_cd is '限制级别代码';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.tran_id is '交易编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.tran_timestamp is '交易时间';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.lmt_acct_range_cd is '限制账户范围代码';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.unloss_tm is '解挂时间';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.unloss_teller_id is '解挂柜员编号';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.memo_descb is '摘要描述';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_dep_acct_chn_lmt_info_h.etl_timestamp is 'ETL处理时间戳';
