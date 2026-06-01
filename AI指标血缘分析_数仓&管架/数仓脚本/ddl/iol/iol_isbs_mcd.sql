/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_mcd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_mcd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_mcd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_mcd(
    inr varchar2(12) -- 唯一id
    ,ownref varchar2(24) -- 交易参考号
    ,nam varchar2(60) -- 交易名称
    ,ownusr varchar2(12) -- 责任人
    ,credat date -- 创建时间
    ,opndat date -- 激活时间
    ,clsdat date -- 关闭时间
    ,expdat date -- 到期时间
    ,orddat date -- 定但时间
    ,aderef varchar2(24) -- 收件人参考号
    ,aplref varchar2(24) -- 申请人参考号
    ,ver varchar2(6) -- 版本号
    ,stacty varchar2(3) -- 国家代码
    ,etyextkey varchar2(12) -- 实体标志
    ,branchinr varchar2(12) -- 所属机构号
    ,bchkeyinr varchar2(12) -- 经办机构号
    ,mcttyp varchar2(3) -- 手工交易类型
    ,subref varchar2(24) -- 子参考号
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
grant select on ${iol_schema}.isbs_mcd to ${iml_schema};
grant select on ${iol_schema}.isbs_mcd to ${icl_schema};
grant select on ${iol_schema}.isbs_mcd to ${idl_schema};
grant select on ${iol_schema}.isbs_mcd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_mcd is '手动交易信息';
comment on column ${iol_schema}.isbs_mcd.inr is '唯一id';
comment on column ${iol_schema}.isbs_mcd.ownref is '交易参考号';
comment on column ${iol_schema}.isbs_mcd.nam is '交易名称';
comment on column ${iol_schema}.isbs_mcd.ownusr is '责任人';
comment on column ${iol_schema}.isbs_mcd.credat is '创建时间';
comment on column ${iol_schema}.isbs_mcd.opndat is '激活时间';
comment on column ${iol_schema}.isbs_mcd.clsdat is '关闭时间';
comment on column ${iol_schema}.isbs_mcd.expdat is '到期时间';
comment on column ${iol_schema}.isbs_mcd.orddat is '定但时间';
comment on column ${iol_schema}.isbs_mcd.aderef is '收件人参考号';
comment on column ${iol_schema}.isbs_mcd.aplref is '申请人参考号';
comment on column ${iol_schema}.isbs_mcd.ver is '版本号';
comment on column ${iol_schema}.isbs_mcd.stacty is '国家代码';
comment on column ${iol_schema}.isbs_mcd.etyextkey is '实体标志';
comment on column ${iol_schema}.isbs_mcd.branchinr is '所属机构号';
comment on column ${iol_schema}.isbs_mcd.bchkeyinr is '经办机构号';
comment on column ${iol_schema}.isbs_mcd.mcttyp is '手工交易类型';
comment on column ${iol_schema}.isbs_mcd.subref is '子参考号';
comment on column ${iol_schema}.isbs_mcd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_mcd.etl_timestamp is 'ETL处理时间戳';
