/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_agreement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_agreement
whenever sqlerror continue none;
drop table ${iml_schema}.agt_agreement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_agreement(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_agt_id varchar2(250) -- 源协议编号
    ,agt_name varchar2(750) -- 协议名称
    ,agt_type_cd varchar2(10) -- 协议类型代码
    ,agt_effect_dt date -- 协议生效日期
    ,agt_invalid_dt date -- 协议失效日期
    ,sign_teller_id varchar2(60) -- 签约柜员编号
    ,sign_org_id varchar2(60) -- 签约机构编号
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
grant select on ${iml_schema}.agt_agreement to ${icl_schema};
grant select on ${iml_schema}.agt_agreement to ${idl_schema};
grant select on ${iml_schema}.agt_agreement to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_agreement is '协议';
comment on column ${iml_schema}.agt_agreement.agt_id is '协议编号';
comment on column ${iml_schema}.agt_agreement.lp_id is '法人编号';
comment on column ${iml_schema}.agt_agreement.src_agt_id is '源协议编号';
comment on column ${iml_schema}.agt_agreement.agt_name is '协议名称';
comment on column ${iml_schema}.agt_agreement.agt_type_cd is '协议类型代码';
comment on column ${iml_schema}.agt_agreement.agt_effect_dt is '协议生效日期';
comment on column ${iml_schema}.agt_agreement.agt_invalid_dt is '协议失效日期';
comment on column ${iml_schema}.agt_agreement.sign_teller_id is '签约柜员编号';
comment on column ${iml_schema}.agt_agreement.sign_org_id is '签约机构编号';
comment on column ${iml_schema}.agt_agreement.create_dt is '创建日期';
comment on column ${iml_schema}.agt_agreement.update_dt is '更新日期';
comment on column ${iml_schema}.agt_agreement.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_agreement.id_mark is '增删标志';
comment on column ${iml_schema}.agt_agreement.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_agreement.job_cd is '任务编码';
comment on column ${iml_schema}.agt_agreement.etl_timestamp is 'ETL处理时间戳';
