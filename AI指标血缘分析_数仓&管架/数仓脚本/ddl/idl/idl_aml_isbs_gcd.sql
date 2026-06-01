/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_gcd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_gcd
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_gcd purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_gcd(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 保函内部ID号
    ,ownref varchar2(16) -- 参考号
    ,pntinr varchar2(8) -- 父保函INR
    ,pnttyp varchar2(6) -- 保函交易类型
    ,nam varchar2(40) -- 交易名称
    ,credat date -- 创建日期
    ,clsdat date -- 结束日期
    ,opndat date -- 有效开始日期
    ,newexpdat date -- 申请日期
    ,ownusr varchar2(8) -- 负责人
    ,ver varchar2(4) -- 版本号
    ,clmtyp varchar2(1) -- 索赔种类
    ,clmctl varchar2(1) -- 索赔类型
    ,clmdat date -- 索赔日期
    ,cannowflg varchar2(1) -- 取消保函下付款
    ,msgdat date -- 拒接报文日期
    ,payrol varchar2(3) -- 付款人
    ,docprbrol varchar2(3) -- 承兑人
    ,etyextkey varchar2(8) -- 实体合同
    ,frepayflg varchar2(1) -- 免费方单标志
    ,bchkeyinr varchar2(8) -- 业务经办行
    ,branchinr varchar2(8) -- 业务所属行
    ,nraflg varchar2(1) -- NRA标志
    ,qsqdbh varchar2(3) -- 清算渠道
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_isbs_gcd to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_gcd is '保函下索赔业务信息(存放短字节)';
comment on column ${idl_schema}.aml_isbs_gcd.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_gcd.inr is '保函内部ID号';
comment on column ${idl_schema}.aml_isbs_gcd.ownref is '参考号';
comment on column ${idl_schema}.aml_isbs_gcd.pntinr is '父保函INR';
comment on column ${idl_schema}.aml_isbs_gcd.pnttyp is '保函交易类型';
comment on column ${idl_schema}.aml_isbs_gcd.nam is '交易名称';
comment on column ${idl_schema}.aml_isbs_gcd.credat is '创建日期';
comment on column ${idl_schema}.aml_isbs_gcd.clsdat is '结束日期';
comment on column ${idl_schema}.aml_isbs_gcd.opndat is '有效开始日期';
comment on column ${idl_schema}.aml_isbs_gcd.newexpdat is '申请日期';
comment on column ${idl_schema}.aml_isbs_gcd.ownusr is '负责人';
comment on column ${idl_schema}.aml_isbs_gcd.ver is '版本号';
comment on column ${idl_schema}.aml_isbs_gcd.clmtyp is '索赔种类';
comment on column ${idl_schema}.aml_isbs_gcd.clmctl is '索赔类型';
comment on column ${idl_schema}.aml_isbs_gcd.clmdat is '索赔日期';
comment on column ${idl_schema}.aml_isbs_gcd.cannowflg is '取消保函下付款';
comment on column ${idl_schema}.aml_isbs_gcd.msgdat is '拒接报文日期';
comment on column ${idl_schema}.aml_isbs_gcd.payrol is '付款人';
comment on column ${idl_schema}.aml_isbs_gcd.docprbrol is '承兑人';
comment on column ${idl_schema}.aml_isbs_gcd.etyextkey is '实体合同';
comment on column ${idl_schema}.aml_isbs_gcd.frepayflg is '免费方单标志';
comment on column ${idl_schema}.aml_isbs_gcd.bchkeyinr is '业务经办行';
comment on column ${idl_schema}.aml_isbs_gcd.branchinr is '业务所属行';
comment on column ${idl_schema}.aml_isbs_gcd.nraflg is 'NRA标志';
comment on column ${idl_schema}.aml_isbs_gcd.qsqdbh is '清算渠道';
comment on column ${idl_schema}.aml_isbs_gcd.etl_timestamp is '数据处理时间';
