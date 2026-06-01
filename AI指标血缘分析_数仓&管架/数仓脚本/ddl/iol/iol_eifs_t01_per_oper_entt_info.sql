/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_per_oper_entt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_per_oper_entt_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_per_oper_entt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_oper_entt_info(
    oper_entt_id varchar2(45) -- 经营实体ID:信息ID
    ,party_id varchar2(45) -- 参与人ID:ECIF内部使用的记录ID。
    ,oper_pers_pty_name varchar2(300) -- 经营者客户名称:
    ,oper_pers_cert_typ varchar2(6) -- 经营者证件类型:个人证件类型
    ,oper_pers_cert_num varchar2(90) -- 经营者证件号:个人证件号
    ,brwer_and_oper_entt_rela varchar2(15) -- 借款人与经营实体的关系:
    ,oper_entt_pty_id varchar2(24) -- 经营实体客户号:
    ,oper_entt_pty_name varchar2(300) -- 经营实体客户名称:
    ,oper_entt_doc_typ varchar2(6) -- 经营实体证件类型:
    ,oper_entt_doc_num varchar2(90) -- 经营实体证件号码:
    ,oper_entt_doc_due_date varchar2(12) -- 经营实体证件到期日:YYYYMMDD
    ,corp_loc varchar2(750) -- 企业地址:
    ,legal_rep_name varchar2(300) -- 法定代表人姓名:
    ,corp_found_dt varchar2(12) -- 成立日期:YYYYMMDD
    ,corp_emply_person_cnt number(22,0) -- 职工人数(人):
    ,corp_year_in number(24,6) -- 营业收入(年):请按字符串格式传输，如”RATE”:”0.56987”
    ,corp_totl_asset number(24,6) -- 资产总额:请按字符串格式传输，如”RATE”:”0.56987”
    ,belong_indus_cd varchar2(30) -- 所属行业类型:
    ,blng_indus_name varchar2(600) -- 所属行业中文名称:
    ,corp_size_cd varchar2(30) -- 企业规模:
    ,create_te varchar2(12) -- 开户柜员编号:描述客户开户的柜员编号。
    ,create_org varchar2(15) -- 创建机构号:描述客户开户的机构。
    ,last_updated_te varchar2(45) -- 最新更新柜员:描述最新更新客户信息的银行柜员、经理编号。
    ,last_updated_org varchar2(30) -- 最新更新机构号:描述最新更新客户信息的银行机构编号。
    ,created_ts timestamp -- 进入ECIF的时间:记录进入ECIF的创建时间，保持不变。
    ,updated_ts timestamp -- 在ECIF中失效的时间:99991231，逻辑删除，则置为当前日期，否则不变。
    ,init_system_id varchar2(15) -- 创建渠道编号:200100-ECIF，记录首次创建源系统号，保持不变。
    ,init_created_ts timestamp -- 源系统创建时间:记录首次在源系统的创建时间，保持不变。
    ,last_system_id varchar2(15) -- 最新更新渠道编号:200100-ECIF，记录更新系统号，每次更新修改为最新的系统号。
    ,last_updated_ts timestamp -- 最新更新时间:记录最后更新时间，每次更新为最新的系统时间。
    ,src_sys_num varchar2(45) -- 来源系统编号:
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号:
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
grant select on ${iol_schema}.eifs_t01_per_oper_entt_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_per_oper_entt_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_per_oper_entt_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_per_oper_entt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_per_oper_entt_info is '对私客户经营实体信息';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_entt_id is '经营实体ID:信息ID';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.party_id is '参与人ID:ECIF内部使用的记录ID。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_pers_pty_name is '经营者客户名称:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_pers_cert_typ is '经营者证件类型:个人证件类型';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_pers_cert_num is '经营者证件号:个人证件号';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.brwer_and_oper_entt_rela is '借款人与经营实体的关系:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_entt_pty_id is '经营实体客户号:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_entt_pty_name is '经营实体客户名称:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_entt_doc_typ is '经营实体证件类型:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_entt_doc_num is '经营实体证件号码:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.oper_entt_doc_due_date is '经营实体证件到期日:YYYYMMDD';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.corp_loc is '企业地址:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.legal_rep_name is '法定代表人姓名:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.corp_found_dt is '成立日期:YYYYMMDD';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.corp_emply_person_cnt is '职工人数(人):';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.corp_year_in is '营业收入(年):请按字符串格式传输，如”RATE”:”0.56987”';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.corp_totl_asset is '资产总额:请按字符串格式传输，如”RATE”:”0.56987”';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.belong_indus_cd is '所属行业类型:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.blng_indus_name is '所属行业中文名称:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.corp_size_cd is '企业规模:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.create_te is '开户柜员编号:描述客户开户的柜员编号。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.create_org is '创建机构号:描述客户开户的机构。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.last_updated_te is '最新更新柜员:描述最新更新客户信息的银行柜员、经理编号。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.last_updated_org is '最新更新机构号:描述最新更新客户信息的银行机构编号。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.created_ts is '进入ECIF的时间:记录进入ECIF的创建时间，保持不变。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.updated_ts is '在ECIF中失效的时间:99991231，逻辑删除，则置为当前日期，否则不变。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.init_system_id is '创建渠道编号:200100-ECIF，记录首次创建源系统号，保持不变。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.init_created_ts is '源系统创建时间:记录首次在源系统的创建时间，保持不变。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.last_system_id is '最新更新渠道编号:200100-ECIF，记录更新系统号，每次更新修改为最新的系统号。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.last_updated_ts is '最新更新时间:记录最后更新时间，每次更新为最新的系统时间。';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.src_sys_num is '来源系统编号:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.last_updated_src_sys_num is '最新更新源系统编号:';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_per_oper_entt_info.etl_timestamp is 'ETL处理时间戳';
