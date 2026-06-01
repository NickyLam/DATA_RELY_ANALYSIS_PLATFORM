/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_oper_corp_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_oper_corp_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_oper_corp_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_oper_corp_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,corp_id varchar2(100) -- 企业编号
    ,corp_cert_no varchar2(60) -- 企业证件号码
    ,corp_cert_type_cd varchar2(30) -- 企业证件类型代码
    ,corp_name varchar2(500) -- 企业名称
    ,indv_bus_name varchar2(500) -- 个体工商户名称
    ,rgst_addr varchar2(1000) -- 注册地址
    ,indus_obtain_emply_years varchar2(100) -- 行业从业年限
    ,mang_range_descb varchar2(4000) -- 经营范围描述
    ,asset_tot number(30,2) -- 资产总额
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
grant select on ${iml_schema}.pty_party_oper_corp_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_oper_corp_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_oper_corp_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_oper_corp_h is '当事人经营企业历史';
comment on column ${iml_schema}.pty_party_oper_corp_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_oper_corp_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_oper_corp_h.corp_id is '企业编号';
comment on column ${iml_schema}.pty_party_oper_corp_h.corp_cert_no is '企业证件号码';
comment on column ${iml_schema}.pty_party_oper_corp_h.corp_cert_type_cd is '企业证件类型代码';
comment on column ${iml_schema}.pty_party_oper_corp_h.corp_name is '企业名称';
comment on column ${iml_schema}.pty_party_oper_corp_h.indv_bus_name is '个体工商户名称';
comment on column ${iml_schema}.pty_party_oper_corp_h.rgst_addr is '注册地址';
comment on column ${iml_schema}.pty_party_oper_corp_h.indus_obtain_emply_years is '行业从业年限';
comment on column ${iml_schema}.pty_party_oper_corp_h.mang_range_descb is '经营范围描述';
comment on column ${iml_schema}.pty_party_oper_corp_h.asset_tot is '资产总额';
comment on column ${iml_schema}.pty_party_oper_corp_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_oper_corp_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_oper_corp_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_oper_corp_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_oper_corp_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_oper_corp_h.etl_timestamp is 'ETL处理时间戳';
