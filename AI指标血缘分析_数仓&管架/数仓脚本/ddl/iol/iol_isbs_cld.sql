/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cld
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cld
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cld purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cld(
    inr varchar2(12) -- 唯一id
    ,ownusr varchar2(12) -- 经办人
    ,chktyp varchar2(2) -- 票据类型
    ,colptyinr varchar2(12) -- 代收行inr
    ,colptynam varchar2(60) -- 代收行名称
    ,ownref varchar2(24) -- 打包托收的业务参考号
    ,colptyref varchar2(36) -- 代收行的编号
    ,opndat date -- 开立日期
    ,clsdat date -- 闭卷日期
    ,ver varchar2(6) -- 版本号
    ,credat date -- 创建日期
    ,colptainr varchar2(12) -- 代收行地址inr
    ,nam varchar2(60) -- 打包托收交易名
    ,colflg varchar2(2) -- 付款方式
    ,valdat date -- 起息日
    ,count number(3,0) -- 打包的票据总数
    ,colref varchar2(24) -- 代收行参考号
    ,creact varchar2(2) -- 贷记账号类型
    ,acno varchar2(30) -- 账号
    ,regref varchar2(24) -- 收单行系统业务代号
    ,bchkeyinr varchar2(12) -- 业务经办机构inr
    ,branchinr varchar2(12) -- 业务所属机构inr
    ,etyextkey varchar2(12) -- 实体组
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
grant select on ${iol_schema}.isbs_cld to ${iml_schema};
grant select on ${iol_schema}.isbs_cld to ${icl_schema};
grant select on ${iol_schema}.isbs_cld to ${idl_schema};
grant select on ${iol_schema}.isbs_cld to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cld is '光票托收(打包托收)业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_cld.inr is '唯一id';
comment on column ${iol_schema}.isbs_cld.ownusr is '经办人';
comment on column ${iol_schema}.isbs_cld.chktyp is '票据类型';
comment on column ${iol_schema}.isbs_cld.colptyinr is '代收行inr';
comment on column ${iol_schema}.isbs_cld.colptynam is '代收行名称';
comment on column ${iol_schema}.isbs_cld.ownref is '打包托收的业务参考号';
comment on column ${iol_schema}.isbs_cld.colptyref is '代收行的编号';
comment on column ${iol_schema}.isbs_cld.opndat is '开立日期';
comment on column ${iol_schema}.isbs_cld.clsdat is '闭卷日期';
comment on column ${iol_schema}.isbs_cld.ver is '版本号';
comment on column ${iol_schema}.isbs_cld.credat is '创建日期';
comment on column ${iol_schema}.isbs_cld.colptainr is '代收行地址inr';
comment on column ${iol_schema}.isbs_cld.nam is '打包托收交易名';
comment on column ${iol_schema}.isbs_cld.colflg is '付款方式';
comment on column ${iol_schema}.isbs_cld.valdat is '起息日';
comment on column ${iol_schema}.isbs_cld.count is '打包的票据总数';
comment on column ${iol_schema}.isbs_cld.colref is '代收行参考号';
comment on column ${iol_schema}.isbs_cld.creact is '贷记账号类型';
comment on column ${iol_schema}.isbs_cld.acno is '账号';
comment on column ${iol_schema}.isbs_cld.regref is '收单行系统业务代号';
comment on column ${iol_schema}.isbs_cld.bchkeyinr is '业务经办机构inr';
comment on column ${iol_schema}.isbs_cld.branchinr is '业务所属机构inr';
comment on column ${iol_schema}.isbs_cld.etyextkey is '实体组';
comment on column ${iol_schema}.isbs_cld.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cld.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cld.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cld.etl_timestamp is 'ETL处理时间戳';
