/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cci
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cci
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cci purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cci(
    objtyp varchar2(9) -- 关联对象类型
    ,objinr varchar2(12) -- 关联对象inr
    ,ownref varchar2(24) -- 业务编号
    ,nam varchar2(60) -- 名称
    ,ownusr varchar2(12) -- 经办用户
    ,credat date -- 创建日期
    ,opndat date -- 开立时间
    ,clsdat date -- 闭卷日期
    ,amedat date -- 上次修改日期
    ,expdat date -- 到期日
    ,ccibanrol varchar2(5) -- 银行角色
    ,ccibanptainr varchar2(12) -- 银行pta表inr
    ,ccicusrol varchar2(5) -- 客户角色
    ,ccicusptainr varchar2(12) -- 客户pta表inr
    ,ver varchar2(6) -- 版本号
    ,etyextkey varchar2(12) -- 实体关键字
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_cci to ${iml_schema};
grant select on ${iol_schema}.isbs_cci to ${icl_schema};
grant select on ${iol_schema}.isbs_cci to ${idl_schema};
grant select on ${iol_schema}.isbs_cci to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cci is '公共合约信息';
comment on column ${iol_schema}.isbs_cci.objtyp is '关联对象类型';
comment on column ${iol_schema}.isbs_cci.objinr is '关联对象inr';
comment on column ${iol_schema}.isbs_cci.ownref is '业务编号';
comment on column ${iol_schema}.isbs_cci.nam is '名称';
comment on column ${iol_schema}.isbs_cci.ownusr is '经办用户';
comment on column ${iol_schema}.isbs_cci.credat is '创建日期';
comment on column ${iol_schema}.isbs_cci.opndat is '开立时间';
comment on column ${iol_schema}.isbs_cci.clsdat is '闭卷日期';
comment on column ${iol_schema}.isbs_cci.amedat is '上次修改日期';
comment on column ${iol_schema}.isbs_cci.expdat is '到期日';
comment on column ${iol_schema}.isbs_cci.ccibanrol is '银行角色';
comment on column ${iol_schema}.isbs_cci.ccibanptainr is '银行pta表inr';
comment on column ${iol_schema}.isbs_cci.ccicusrol is '客户角色';
comment on column ${iol_schema}.isbs_cci.ccicusptainr is '客户pta表inr';
comment on column ${iol_schema}.isbs_cci.ver is '版本号';
comment on column ${iol_schema}.isbs_cci.etyextkey is '实体关键字';
comment on column ${iol_schema}.isbs_cci.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_cci.etl_timestamp is 'ETL处理时间戳';
