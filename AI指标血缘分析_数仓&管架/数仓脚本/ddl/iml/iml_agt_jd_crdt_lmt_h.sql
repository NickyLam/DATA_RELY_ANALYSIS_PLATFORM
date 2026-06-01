/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_jd_crdt_lmt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_jd_crdt_lmt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_jd_crdt_lmt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_jd_crdt_lmt_h(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_lmt_id varchar2(60) -- 客户额度编号
    ,jd_cust_id varchar2(60) -- 外部客户编号
    ,prod_cd varchar2(10) -- 产品代码
    ,curr_cd varchar2(10) -- 币种代码
    ,circl_lmt_flg varchar2(10) -- 循环额度标志
    ,crdt_effect_begin_dt date -- 授信生效日期
    ,crdt_exp_dt date -- 授信到期日期
    ,crdt_lmt number(30,2) -- 授信额度
    ,crdt_tenor_days number(10) -- 授信期限天数
    ,temp_lmt_flg varchar2(10) -- 临时额度标志
    ,crdt_status_cd varchar2(10) -- 授信状态代码
    ,prod_id varchar2(60) -- 产品编号
    ,surp_aval_lmt number(30,8) -- 剩余可用额度
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
grant select on ${iml_schema}.agt_jd_crdt_lmt_h to ${icl_schema};
grant select on ${iml_schema}.agt_jd_crdt_lmt_h to ${idl_schema};
grant select on ${iml_schema}.agt_jd_crdt_lmt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_jd_crdt_lmt_h is '京东授信额度历史';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.cust_lmt_id is '客户额度编号';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.jd_cust_id is '外部客户编号';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.prod_cd is '产品代码';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.circl_lmt_flg is '循环额度标志';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.crdt_effect_begin_dt is '授信生效日期';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.crdt_exp_dt is '授信到期日期';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.crdt_lmt is '授信额度';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.crdt_tenor_days is '授信期限天数';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.temp_lmt_flg is '临时额度标志';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.crdt_status_cd is '授信状态代码';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.surp_aval_lmt is '剩余可用额度';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_jd_crdt_lmt_h.etl_timestamp is 'ETL处理时间戳';
