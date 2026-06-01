/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_intstl_party
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_intstl_party
whenever sqlerror continue none;
drop table ${iml_schema}.pty_intstl_party purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_intstl_party(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_name varchar2(375) -- 客户名称
    ,cn_name varchar2(375) -- 中文名称
    ,intstl_cust_type_cd_comb varchar2(30) -- 国结客户类型代码组合
    ,hq_party_id varchar2(60) -- 总行当事人编号
    ,nation_crdt_level_cd varchar2(30) -- 国家的信用等级代码
    ,risk_level_cd varchar2(30) -- 风险等级代码
    ,risk_cty_cd varchar2(30) -- 风险国家代码
    ,trans_lang_cd varchar2(30) -- 传输语言代码
    ,edit_id varchar2(60) -- 版本编号
    ,serv_level_cd varchar2(30) -- 服务等级代码
    ,enty_group_id varchar2(60) -- 实体组编号
    ,orgnz_cd varchar2(30) -- 组织机构代码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,resdnt_type_cd varchar2(30) -- 居民类型代码
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,tran_main_cd varchar2(30) -- 交易主体代码
    ,src_party_id varchar2(60) -- 源当事人编号
    ,cbec_flg varchar2(10) -- 跨境电商标志
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
grant select on ${iml_schema}.pty_intstl_party to ${icl_schema};
grant select on ${iml_schema}.pty_intstl_party to ${idl_schema};
grant select on ${iml_schema}.pty_intstl_party to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_intstl_party is '国结当事人';
comment on column ${iml_schema}.pty_intstl_party.party_id is '当事人编号';
comment on column ${iml_schema}.pty_intstl_party.lp_id is '法人编号';
comment on column ${iml_schema}.pty_intstl_party.cust_id is '客户编号';
comment on column ${iml_schema}.pty_intstl_party.cust_name is '客户名称';
comment on column ${iml_schema}.pty_intstl_party.cn_name is '中文名称';
comment on column ${iml_schema}.pty_intstl_party.intstl_cust_type_cd_comb is '国结客户类型代码组合';
comment on column ${iml_schema}.pty_intstl_party.hq_party_id is '总行当事人编号';
comment on column ${iml_schema}.pty_intstl_party.nation_crdt_level_cd is '国家的信用等级代码';
comment on column ${iml_schema}.pty_intstl_party.risk_level_cd is '风险等级代码';
comment on column ${iml_schema}.pty_intstl_party.risk_cty_cd is '风险国家代码';
comment on column ${iml_schema}.pty_intstl_party.trans_lang_cd is '传输语言代码';
comment on column ${iml_schema}.pty_intstl_party.edit_id is '版本编号';
comment on column ${iml_schema}.pty_intstl_party.serv_level_cd is '服务等级代码';
comment on column ${iml_schema}.pty_intstl_party.enty_group_id is '实体组编号';
comment on column ${iml_schema}.pty_intstl_party.orgnz_cd is '组织机构代码';
comment on column ${iml_schema}.pty_intstl_party.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_intstl_party.cert_no is '证件号码';
comment on column ${iml_schema}.pty_intstl_party.resdnt_type_cd is '居民类型代码';
comment on column ${iml_schema}.pty_intstl_party.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.pty_intstl_party.tran_main_cd is '交易主体代码';
comment on column ${iml_schema}.pty_intstl_party.src_party_id is '源当事人编号';
comment on column ${iml_schema}.pty_intstl_party.cbec_flg is '跨境电商标志';
comment on column ${iml_schema}.pty_intstl_party.create_dt is '创建日期';
comment on column ${iml_schema}.pty_intstl_party.update_dt is '更新日期';
comment on column ${iml_schema}.pty_intstl_party.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_intstl_party.id_mark is '增删标志';
comment on column ${iml_schema}.pty_intstl_party.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_intstl_party.job_cd is '任务编码';
comment on column ${iml_schema}.pty_intstl_party.etl_timestamp is 'ETL处理时间戳';
