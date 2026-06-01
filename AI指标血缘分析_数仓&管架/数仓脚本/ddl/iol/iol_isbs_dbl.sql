/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbl
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbl(
    inr varchar2(12) -- internal unique id
    ,ver varchar2(6) -- version
    ,objtyp varchar2(9) -- object type
    ,objinr varchar2(12) -- object inr
    ,rptno varchar2(33) -- 申报号码
    ,bassta varchar2(2) -- 基本数据状态
    ,dclsta varchar2(2) -- 申报信息状态
    ,vrfsta varchar2(2) -- 核销信息状态
    ,ownextkey varchar2(12) -- initial entity code
    ,ownusr varchar2(9) -- own user
    ,trninr varchar2(12) -- 对应trninr
    ,credat date -- 创建日期
    ,reldat date -- 授权日期
    ,tmpref varchar2(24) -- 临时申报流水号
    ,trdtyp varchar2(2) -- 贸易类型
    ,acttyp varchar2(6) -- 款项标志
    ,ygasta varchar2(2) -- 
    ,basstarcv varchar2(2) -- 基础信息反馈状态
    ,dclstarcv varchar2(2) -- 申报信息反馈状态
    ,vrfstarcv varchar2(2) -- 管理信息反馈状态
    ,iscor varchar2(2) -- 是否核心获取
    ,refcor varchar2(60) -- 核心流水号
    ,filever varchar2(5) -- 文件版本
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
grant select on ${iol_schema}.isbs_dbl to ${iml_schema};
grant select on ${iol_schema}.isbs_dbl to ${icl_schema};
grant select on ${iol_schema}.isbs_dbl to ${idl_schema};
grant select on ${iol_schema}.isbs_dbl to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbl is '申报信息状态表';
comment on column ${iol_schema}.isbs_dbl.inr is 'internal unique id';
comment on column ${iol_schema}.isbs_dbl.ver is 'version';
comment on column ${iol_schema}.isbs_dbl.objtyp is 'object type';
comment on column ${iol_schema}.isbs_dbl.objinr is 'object inr';
comment on column ${iol_schema}.isbs_dbl.rptno is '申报号码';
comment on column ${iol_schema}.isbs_dbl.bassta is '基本数据状态';
comment on column ${iol_schema}.isbs_dbl.dclsta is '申报信息状态';
comment on column ${iol_schema}.isbs_dbl.vrfsta is '核销信息状态';
comment on column ${iol_schema}.isbs_dbl.ownextkey is 'initial entity code';
comment on column ${iol_schema}.isbs_dbl.ownusr is 'own user';
comment on column ${iol_schema}.isbs_dbl.trninr is '对应trninr';
comment on column ${iol_schema}.isbs_dbl.credat is '创建日期';
comment on column ${iol_schema}.isbs_dbl.reldat is '授权日期';
comment on column ${iol_schema}.isbs_dbl.tmpref is '临时申报流水号';
comment on column ${iol_schema}.isbs_dbl.trdtyp is '贸易类型';
comment on column ${iol_schema}.isbs_dbl.acttyp is '款项标志';
comment on column ${iol_schema}.isbs_dbl.ygasta is '';
comment on column ${iol_schema}.isbs_dbl.basstarcv is '基础信息反馈状态';
comment on column ${iol_schema}.isbs_dbl.dclstarcv is '申报信息反馈状态';
comment on column ${iol_schema}.isbs_dbl.vrfstarcv is '管理信息反馈状态';
comment on column ${iol_schema}.isbs_dbl.iscor is '是否核心获取';
comment on column ${iol_schema}.isbs_dbl.refcor is '核心流水号';
comment on column ${iol_schema}.isbs_dbl.filever is '文件版本';
comment on column ${iol_schema}.isbs_dbl.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbl.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbl.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbl.etl_timestamp is 'ETL处理时间戳';
