/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_gcd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_gcd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_gcd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gcd(
    inr varchar2(12) -- 保函内部id号
    ,ownref varchar2(24) -- 参考号
    ,pntinr varchar2(12) -- 父保函inr
    ,pnttyp varchar2(9) -- 保函交易类型
    ,nam varchar2(60) -- 交易名称
    ,credat date -- 创建日期
    ,clsdat date -- 结束日期
    ,opndat date -- 有效开始日期
    ,newexpdat date -- 申请日期
    ,ownusr varchar2(12) -- 负责人
    ,ver varchar2(6) -- 版本号
    ,clmtyp varchar2(2) -- 索赔种类
    ,clmctl varchar2(2) -- 索赔类型
    ,clmdat date -- 索赔日期
    ,cannowflg varchar2(2) -- 取消保函下付款
    ,msgdat date -- 拒接报文日期
    ,payrol varchar2(5) -- 付款人
    ,docprbrol varchar2(5) -- 承兑人
    ,etyextkey varchar2(12) -- 实体合同
    ,frepayflg varchar2(2) -- 免费方单标志
    ,bchkeyinr varchar2(12) -- 业务经办行
    ,branchinr varchar2(12) -- 业务所属行
    ,nraflg varchar2(2) -- nra标志
    ,qsqdbh varchar2(5) -- 清算渠道
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
grant select on ${iol_schema}.isbs_gcd to ${iml_schema};
grant select on ${iol_schema}.isbs_gcd to ${icl_schema};
grant select on ${iol_schema}.isbs_gcd to ${idl_schema};
grant select on ${iol_schema}.isbs_gcd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_gcd is '保函辖索赔业务信息表';
comment on column ${iol_schema}.isbs_gcd.inr is '保函内部id号';
comment on column ${iol_schema}.isbs_gcd.ownref is '参考号';
comment on column ${iol_schema}.isbs_gcd.pntinr is '父保函inr';
comment on column ${iol_schema}.isbs_gcd.pnttyp is '保函交易类型';
comment on column ${iol_schema}.isbs_gcd.nam is '交易名称';
comment on column ${iol_schema}.isbs_gcd.credat is '创建日期';
comment on column ${iol_schema}.isbs_gcd.clsdat is '结束日期';
comment on column ${iol_schema}.isbs_gcd.opndat is '有效开始日期';
comment on column ${iol_schema}.isbs_gcd.newexpdat is '申请日期';
comment on column ${iol_schema}.isbs_gcd.ownusr is '负责人';
comment on column ${iol_schema}.isbs_gcd.ver is '版本号';
comment on column ${iol_schema}.isbs_gcd.clmtyp is '索赔种类';
comment on column ${iol_schema}.isbs_gcd.clmctl is '索赔类型';
comment on column ${iol_schema}.isbs_gcd.clmdat is '索赔日期';
comment on column ${iol_schema}.isbs_gcd.cannowflg is '取消保函下付款';
comment on column ${iol_schema}.isbs_gcd.msgdat is '拒接报文日期';
comment on column ${iol_schema}.isbs_gcd.payrol is '付款人';
comment on column ${iol_schema}.isbs_gcd.docprbrol is '承兑人';
comment on column ${iol_schema}.isbs_gcd.etyextkey is '实体合同';
comment on column ${iol_schema}.isbs_gcd.frepayflg is '免费方单标志';
comment on column ${iol_schema}.isbs_gcd.bchkeyinr is '业务经办行';
comment on column ${iol_schema}.isbs_gcd.branchinr is '业务所属行';
comment on column ${iol_schema}.isbs_gcd.nraflg is 'nra标志';
comment on column ${iol_schema}.isbs_gcd.qsqdbh is '清算渠道';
comment on column ${iol_schema}.isbs_gcd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_gcd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_gcd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_gcd.etl_timestamp is 'ETL处理时间戳';
