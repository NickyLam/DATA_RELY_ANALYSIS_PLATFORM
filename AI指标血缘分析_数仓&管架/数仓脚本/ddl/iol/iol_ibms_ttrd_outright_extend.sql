/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_outright_extend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_outright_extend
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_outright_extend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_outright_extend(
    i_code varchar2(75) -- 合约金融工具
    ,a_type varchar2(30) -- 合约a_type
    ,m_type varchar2(30) -- 合约m_type
    ,grp_id varchar2(30) -- 组合号
    ,u_i_code varchar2(75) -- 标的产品金融工具
    ,u_a_type varchar2(30) -- 标的产品a_type
    ,u_m_type varchar2(30) -- 标的产品m_type
    ,u_secu_acc_id varchar2(45) -- 标的产品内部证券账户
    ,u_secu_ext_acc_id varchar2(30) -- 标的产品外部证券账户
    ,amount number(31,4) -- 标的产品券面总额
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
grant select on ${iol_schema}.ibms_ttrd_outright_extend to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_outright_extend to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_outright_extend to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_outright_extend to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_outright_extend is '买断式回购标的产品拓展表';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.i_code is '合约金融工具';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.a_type is '合约a_type';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.m_type is '合约m_type';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.grp_id is '组合号';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.u_i_code is '标的产品金融工具';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.u_a_type is '标的产品a_type';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.u_m_type is '标的产品m_type';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.u_secu_acc_id is '标的产品内部证券账户';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.u_secu_ext_acc_id is '标的产品外部证券账户';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.amount is '标的产品券面总额';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_outright_extend.etl_timestamp is 'ETL处理时间戳';
