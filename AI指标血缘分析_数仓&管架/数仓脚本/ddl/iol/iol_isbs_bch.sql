/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bch
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bch(
    inr varchar2(12) -- 内部唯一id
    ,etyexkey varchar2(12) -- 实体关键字
    ,branch varchar2(27) -- 机构编码
    ,bchkey varchar2(12) -- 经办机构编码
    ,bchname varchar2(450) -- 机构名称
    ,lev varchar2(2) -- 机构层次
    ,upbranch varchar2(12) -- 上级机构编码
    ,bchtyp varchar2(2) -- 机构类型
    ,bchflg varchar2(3) -- 机构参考号标志
    ,decnum varchar2(60) -- 金融机构编码
    ,tel varchar2(45) -- 电话
    ,fax varchar2(24) -- 传真
    ,adr varchar2(600) -- 地址
    ,swfcod varchar2(18) -- bic码
    ,adr2 varchar2(600) -- 地址
    ,ver varchar2(6) -- 版本号
    ,namen varchar2(60) -- 英文名称
    ,adren varchar2(60) -- 英文地址
    ,adren2 varchar2(60) -- 英文地址
    ,ydjcod varchar2(9) -- 外汇管理局印单局代码
    ,tid varchar2(12) -- 收单行系统机构代号
    ,upbchkey varchar2(12) -- 替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码
    ,accbch varchar2(9) -- 核心机构号
    ,bchref varchar2(6) -- 该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。
    ,bchusr varchar2(12) -- 核心虚拟柜员
    ,bchlst varchar2(2700) -- 包含的分支机构inr
    ,sta varchar2(2) -- 状态
    ,ptyinr varchar2(12) -- 与pty表inr对应
    ,stpflg varchar2(9) -- 是否停用
    ,rmbrpt varchar2(18) -- 金融机构识别码
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
grant select on ${iol_schema}.isbs_bch to ${iml_schema};
grant select on ${iol_schema}.isbs_bch to ${icl_schema};
grant select on ${iol_schema}.isbs_bch to ${idl_schema};
grant select on ${iol_schema}.isbs_bch to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bch is '机构信息表';
comment on column ${iol_schema}.isbs_bch.inr is '内部唯一id';
comment on column ${iol_schema}.isbs_bch.etyexkey is '实体关键字';
comment on column ${iol_schema}.isbs_bch.branch is '机构编码';
comment on column ${iol_schema}.isbs_bch.bchkey is '经办机构编码';
comment on column ${iol_schema}.isbs_bch.bchname is '机构名称';
comment on column ${iol_schema}.isbs_bch.lev is '机构层次';
comment on column ${iol_schema}.isbs_bch.upbranch is '上级机构编码';
comment on column ${iol_schema}.isbs_bch.bchtyp is '机构类型';
comment on column ${iol_schema}.isbs_bch.bchflg is '机构参考号标志';
comment on column ${iol_schema}.isbs_bch.decnum is '金融机构编码';
comment on column ${iol_schema}.isbs_bch.tel is '电话';
comment on column ${iol_schema}.isbs_bch.fax is '传真';
comment on column ${iol_schema}.isbs_bch.adr is '地址';
comment on column ${iol_schema}.isbs_bch.swfcod is 'bic码';
comment on column ${iol_schema}.isbs_bch.adr2 is '地址';
comment on column ${iol_schema}.isbs_bch.ver is '版本号';
comment on column ${iol_schema}.isbs_bch.namen is '英文名称';
comment on column ${iol_schema}.isbs_bch.adren is '英文地址';
comment on column ${iol_schema}.isbs_bch.adren2 is '英文地址';
comment on column ${iol_schema}.isbs_bch.ydjcod is '外汇管理局印单局代码';
comment on column ${iol_schema}.isbs_bch.tid is '收单行系统机构代号';
comment on column ${iol_schema}.isbs_bch.upbchkey is '替该机构经办业务的押汇中心对应的国结系统机构编码，未上收的银行此处是其国结系统分行机构编码';
comment on column ${iol_schema}.isbs_bch.accbch is '核心机构号';
comment on column ${iol_schema}.isbs_bch.bchref is '该机构项下的业务，生成参考号时用到的4位机构号码（由业务人员指定）。';
comment on column ${iol_schema}.isbs_bch.bchusr is '核心虚拟柜员';
comment on column ${iol_schema}.isbs_bch.bchlst is '包含的分支机构inr';
comment on column ${iol_schema}.isbs_bch.sta is '状态';
comment on column ${iol_schema}.isbs_bch.ptyinr is '与pty表inr对应';
comment on column ${iol_schema}.isbs_bch.stpflg is '是否停用';
comment on column ${iol_schema}.isbs_bch.rmbrpt is '金融机构识别码';
comment on column ${iol_schema}.isbs_bch.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bch.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bch.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bch.etl_timestamp is 'ETL处理时间戳';
