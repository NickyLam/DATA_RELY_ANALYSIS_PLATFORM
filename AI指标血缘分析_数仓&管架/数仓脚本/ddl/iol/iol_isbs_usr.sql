/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_usr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_usr
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_usr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_usr(
    inr varchar2(12) -- 内部唯一id
    ,extkey varchar2(12) -- 用户id
    ,nam varchar2(60) -- 用户名字
    ,lgiflg varchar2(2) -- 禁止登录
    ,ssnbegdattim timestamp -- 最近登录时间
    ,ssninr varchar2(12) -- ssn id
    ,ver varchar2(6) -- 版本号
    ,pri varchar2(2) -- 实体标志
    ,ety varchar2(12) -- 实体
    ,usg varchar2(9) -- 用户组
    ,lstdiadat date -- 最近dia查看时间
    ,relcur varchar2(5) -- 授权币种
    ,relamt number(18,3) -- 授权金额
    ,relamt2nd number(18,3) -- 授权金额
    ,relgrp varchar2(2) -- 授权组
    ,tel varchar2(45) -- 电话
    ,fax varchar2(45) -- 传真
    ,eml varchar2(120) -- 电子信箱
    ,quepow number(6,2) -- 可用时间
    ,etyextkey varchar2(12) -- 实体名称
    ,oenr varchar2(6) -- 组织
    ,etaextkey varchar2(12) -- 实体地址
    ,resusrflg varchar2(2) -- 客户经理
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
grant select on ${iol_schema}.isbs_usr to ${iml_schema};
grant select on ${iol_schema}.isbs_usr to ${icl_schema};
grant select on ${iol_schema}.isbs_usr to ${idl_schema};
grant select on ${iol_schema}.isbs_usr to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_usr is '用户信息';
comment on column ${iol_schema}.isbs_usr.inr is '内部唯一id';
comment on column ${iol_schema}.isbs_usr.extkey is '用户id';
comment on column ${iol_schema}.isbs_usr.nam is '用户名字';
comment on column ${iol_schema}.isbs_usr.lgiflg is '禁止登录';
comment on column ${iol_schema}.isbs_usr.ssnbegdattim is '最近登录时间';
comment on column ${iol_schema}.isbs_usr.ssninr is 'ssn id';
comment on column ${iol_schema}.isbs_usr.ver is '版本号';
comment on column ${iol_schema}.isbs_usr.pri is '实体标志';
comment on column ${iol_schema}.isbs_usr.ety is '实体';
comment on column ${iol_schema}.isbs_usr.usg is '用户组';
comment on column ${iol_schema}.isbs_usr.lstdiadat is '最近dia查看时间';
comment on column ${iol_schema}.isbs_usr.relcur is '授权币种';
comment on column ${iol_schema}.isbs_usr.relamt is '授权金额';
comment on column ${iol_schema}.isbs_usr.relamt2nd is '授权金额';
comment on column ${iol_schema}.isbs_usr.relgrp is '授权组';
comment on column ${iol_schema}.isbs_usr.tel is '电话';
comment on column ${iol_schema}.isbs_usr.fax is '传真';
comment on column ${iol_schema}.isbs_usr.eml is '电子信箱';
comment on column ${iol_schema}.isbs_usr.quepow is '可用时间';
comment on column ${iol_schema}.isbs_usr.etyextkey is '实体名称';
comment on column ${iol_schema}.isbs_usr.oenr is '组织';
comment on column ${iol_schema}.isbs_usr.etaextkey is '实体地址';
comment on column ${iol_schema}.isbs_usr.resusrflg is '客户经理';
comment on column ${iol_schema}.isbs_usr.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_usr.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_usr.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_usr.etl_timestamp is 'ETL处理时间戳';
