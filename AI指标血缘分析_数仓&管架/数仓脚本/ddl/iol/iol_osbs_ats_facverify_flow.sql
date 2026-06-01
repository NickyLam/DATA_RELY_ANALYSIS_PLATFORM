/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_ats_facverify_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_ats_facverify_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_ats_facverify_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_facverify_flow(
    aff_flowno varchar2(64) -- 验证流水号：FAC+时间yyyymmddHHmmssSSS+12位序列号ATS_VERIFY_SEQ_NO
    ,aff_ecifno varchar2(32) -- 客户号
    ,aff_state varchar2(1) -- 流水状态 0：生效 ；1：失效 ; 2:已通过验证
    ,aff_verifycount number(2,0) -- 验证次数
    ,aff_createtime varchar2(20) -- 流水创建时间
    ,aff_updatetime varchar2(20) -- 上次更新时间
    ,aff_channel varchar2(3) -- 验证渠道
    ,aff_trantype varchar2(100) -- 交易类型
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_ats_facverify_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_ats_facverify_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_ats_facverify_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_ats_facverify_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_ats_facverify_flow is '密码验证流水表';
comment on column ${iol_schema}.osbs_ats_facverify_flow.aff_flowno is '验证流水号：FAC+时间yyyymmddHHmmssSSS+12位序列号ATS_VERIFY_SEQ_NO';
comment on column ${iol_schema}.osbs_ats_facverify_flow.aff_ecifno is '客户号';
comment on column ${iol_schema}.osbs_ats_facverify_flow.aff_state is '流水状态 0：生效 ；1：失效 ; 2:已通过验证';
comment on column ${iol_schema}.osbs_ats_facverify_flow.aff_verifycount is '验证次数';
comment on column ${iol_schema}.osbs_ats_facverify_flow.aff_createtime is '流水创建时间';
comment on column ${iol_schema}.osbs_ats_facverify_flow.aff_updatetime is '上次更新时间';
comment on column ${iol_schema}.osbs_ats_facverify_flow.aff_channel is '验证渠道';
comment on column ${iol_schema}.osbs_ats_facverify_flow.aff_trantype is '交易类型';
comment on column ${iol_schema}.osbs_ats_facverify_flow.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_ats_facverify_flow.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_ats_facverify_flow.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_ats_facverify_flow.etl_timestamp is 'ETL处理时间戳';
