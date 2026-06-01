/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_syn_cnter_sign_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_syn_cnter_sign_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_syn_cnter_sign_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_syn_cnter_sign_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,sign_agt_cd varchar2(30) -- 签约协议代码
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,chn_id varchar2(100) -- 渠道编号
    ,sign_flow_num varchar2(100) -- 签约流水号
    ,sign_id varchar2(100) -- 签约编号
    ,sign_dt date -- 签约日期
    ,sign_status_cd varchar2(30) -- 签约状态代码
    ,sign_org_id varchar2(100) -- 签约机构编号
    ,sign_teller_id varchar2(100) -- 签约柜员编号
    ,old_sign_dt date -- 原签约日期
    ,rels_dt date -- 解约日期
    ,rels_org_id varchar2(100) -- 解约机构编号
    ,rels_teller_id varchar2(100) -- 解约柜员编号
    ,rels_flow_num varchar2(100) -- 解约流水号
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
grant select on ${iml_schema}.agt_syn_cnter_sign_h to ${icl_schema};
grant select on ${iml_schema}.agt_syn_cnter_sign_h to ${idl_schema};
grant select on ${iml_schema}.agt_syn_cnter_sign_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_syn_cnter_sign_h is '综合柜面签约历史';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.sign_agt_cd is '签约协议代码';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.sign_flow_num is '签约流水号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.sign_id is '签约编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.sign_dt is '签约日期';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.sign_status_cd is '签约状态代码';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.sign_teller_id is '签约柜员编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.old_sign_dt is '原签约日期';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.rels_dt is '解约日期';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.rels_org_id is '解约机构编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.rels_teller_id is '解约柜员编号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.rels_flow_num is '解约流水号';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_syn_cnter_sign_h.etl_timestamp is 'ETL处理时间戳';
