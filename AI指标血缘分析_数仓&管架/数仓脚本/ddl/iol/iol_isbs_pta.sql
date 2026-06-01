/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_pta
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_pta
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_pta purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_pta(
    inr varchar2(12) -- 内部唯一id号
    ,ptyinr varchar2(12) -- 联系实体inr
    ,nam varchar2(60) -- 地址名
    ,pri varchar2(2) -- 优先权
    ,eno varchar2(5) -- 用户的外部id
    ,objtyp varchar2(9) -- 关联地址种类
    ,objinr varchar2(12) -- 关联地址inr
    ,objkey varchar2(36) -- 关联地址关键值
    ,usg varchar2(5) -- 地址使用代码
    ,ver varchar2(6) -- 版本号
    ,bic varchar2(17) -- 地址bic
    ,adrsta varchar2(2) -- 地址状态
    ,ptytyp varchar2(23) -- 客户类型
    ,ptyextkey varchar2(36) -- 客户唯一键值
    ,tid varchar2(35) -- 与tc通信时客户地址的唯一id
    ,etgextkey varchar2(12) -- 实体组唯一键值
    ,branchinr varchar2(12) -- 所属机构号
    ,bchkeyinr varchar2(12) -- 经办机构号
    ,nam1 varchar2(60) -- 中文名称
    ,issbchinf varchar2(60) -- 
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
grant select on ${iol_schema}.isbs_pta to ${iml_schema};
grant select on ${iol_schema}.isbs_pta to ${icl_schema};
grant select on ${iol_schema}.isbs_pta to ${idl_schema};
grant select on ${iol_schema}.isbs_pta to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_pta is 'pty和adr的连接表';
comment on column ${iol_schema}.isbs_pta.inr is '内部唯一id号';
comment on column ${iol_schema}.isbs_pta.ptyinr is '联系实体inr';
comment on column ${iol_schema}.isbs_pta.nam is '地址名';
comment on column ${iol_schema}.isbs_pta.pri is '优先权';
comment on column ${iol_schema}.isbs_pta.eno is '用户的外部id';
comment on column ${iol_schema}.isbs_pta.objtyp is '关联地址种类';
comment on column ${iol_schema}.isbs_pta.objinr is '关联地址inr';
comment on column ${iol_schema}.isbs_pta.objkey is '关联地址关键值';
comment on column ${iol_schema}.isbs_pta.usg is '地址使用代码';
comment on column ${iol_schema}.isbs_pta.ver is '版本号';
comment on column ${iol_schema}.isbs_pta.bic is '地址bic';
comment on column ${iol_schema}.isbs_pta.adrsta is '地址状态';
comment on column ${iol_schema}.isbs_pta.ptytyp is '客户类型';
comment on column ${iol_schema}.isbs_pta.ptyextkey is '客户唯一键值';
comment on column ${iol_schema}.isbs_pta.tid is '与tc通信时客户地址的唯一id';
comment on column ${iol_schema}.isbs_pta.etgextkey is '实体组唯一键值';
comment on column ${iol_schema}.isbs_pta.branchinr is '所属机构号';
comment on column ${iol_schema}.isbs_pta.bchkeyinr is '经办机构号';
comment on column ${iol_schema}.isbs_pta.nam1 is '中文名称';
comment on column ${iol_schema}.isbs_pta.issbchinf is '';
comment on column ${iol_schema}.isbs_pta.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_pta.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_pta.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_pta.etl_timestamp is 'ETL处理时间戳';
