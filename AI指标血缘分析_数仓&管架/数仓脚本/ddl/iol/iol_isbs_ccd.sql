/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ccd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ccd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ccd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ccd(
    inr varchar2(12) -- 光票托收交易id号
    ,ownusr varchar2(12) -- 经办人
    ,ownref varchar2(24) -- 业务参考号
    ,nam varchar2(60) -- 光票托收交易名
    ,corptyinr varchar2(12) -- 汇票受票行的inr
    ,corptainr varchar2(12) -- 汇票受票行地址
    ,cornam varchar2(60) -- 汇票受票行名称
    ,corref varchar2(30) -- 汇票受票行参考号
    ,nobptyinr varchar2(12) -- 清算行的inr
    ,nobptainr varchar2(12) -- 清算行地址
    ,nobnam varchar2(60) -- 清算行名称
    ,nobref varchar2(24) -- 清算行参考号
    ,droptyinr varchar2(12) -- 付款行inr
    ,droptainr varchar2(12) -- 付款行地址
    ,dronam varchar2(60) -- 付款行名称
    ,droref varchar2(24) -- 付款行参考号
    ,preptyinr varchar2(12) -- 托收人/收款人的inr
    ,preptainr varchar2(12) -- 托收人/收款人的地址
    ,prenam varchar2(60) -- 托收人/收款人的名称
    ,preref varchar2(24) -- 托收人/收款人的参考号
    ,chkdat date -- 出票日期
    ,credat date -- 创建日期
    ,clsdat date -- 结束日期
    ,paydat date -- 收款日期
    ,opndat date -- 开始日期
    ,stacty varchar2(3) -- 国家代码
    ,ngrcod varchar2(9) -- 货物代码
    ,infdsp varchar2(2) -- 显示信息标志
    ,ccform varchar2(2) -- 光票托收形式
    ,purflg varchar2(2) -- 付款方式
    ,modset varchar2(2) -- 结算方式
    ,tocsel varchar2(2) -- 票据类型
    ,brchref varchar2(24) -- 支行参考号
    ,chcknum varchar2(24) -- 支票号
    ,colref varchar2(24) -- 代收行参考号
    ,colnam varchar2(60) -- 代收行名称
    ,colptyinr varchar2(12) -- 代收行inr
    ,colptainr varchar2(12) -- 代收行地址
    ,rptbtchno varchar2(24) -- 打包托收的业务参考好
    ,bchkeyinr varchar2(12) -- 业务经办机构inr
    ,branchinr varchar2(12) -- 业务所属机构inr
    ,vercerref varchar2(63) -- 核销单号
    ,decnum varchar2(39) -- 申报单号
    ,pretyp varchar2(30) -- 托收人/收款人类型
    ,prodat date -- 打包托收收款日期
    ,regref varchar2(24) -- 收单行系统业务代号
    ,ver varchar2(6) -- 版本号
    ,frepayflg varchar2(2) -- 自由付款标志
    ,etyextkey varchar2(12) -- 实体组
    ,nraflg varchar2(2) -- 是否nra付款
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
grant select on ${iol_schema}.isbs_ccd to ${iml_schema};
grant select on ${iol_schema}.isbs_ccd to ${icl_schema};
grant select on ${iol_schema}.isbs_ccd to ${idl_schema};
grant select on ${iol_schema}.isbs_ccd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ccd is '光票托收(单笔票据)业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_ccd.inr is '光票托收交易id号';
comment on column ${iol_schema}.isbs_ccd.ownusr is '经办人';
comment on column ${iol_schema}.isbs_ccd.ownref is '业务参考号';
comment on column ${iol_schema}.isbs_ccd.nam is '光票托收交易名';
comment on column ${iol_schema}.isbs_ccd.corptyinr is '汇票受票行的inr';
comment on column ${iol_schema}.isbs_ccd.corptainr is '汇票受票行地址';
comment on column ${iol_schema}.isbs_ccd.cornam is '汇票受票行名称';
comment on column ${iol_schema}.isbs_ccd.corref is '汇票受票行参考号';
comment on column ${iol_schema}.isbs_ccd.nobptyinr is '清算行的inr';
comment on column ${iol_schema}.isbs_ccd.nobptainr is '清算行地址';
comment on column ${iol_schema}.isbs_ccd.nobnam is '清算行名称';
comment on column ${iol_schema}.isbs_ccd.nobref is '清算行参考号';
comment on column ${iol_schema}.isbs_ccd.droptyinr is '付款行inr';
comment on column ${iol_schema}.isbs_ccd.droptainr is '付款行地址';
comment on column ${iol_schema}.isbs_ccd.dronam is '付款行名称';
comment on column ${iol_schema}.isbs_ccd.droref is '付款行参考号';
comment on column ${iol_schema}.isbs_ccd.preptyinr is '托收人/收款人的inr';
comment on column ${iol_schema}.isbs_ccd.preptainr is '托收人/收款人的地址';
comment on column ${iol_schema}.isbs_ccd.prenam is '托收人/收款人的名称';
comment on column ${iol_schema}.isbs_ccd.preref is '托收人/收款人的参考号';
comment on column ${iol_schema}.isbs_ccd.chkdat is '出票日期';
comment on column ${iol_schema}.isbs_ccd.credat is '创建日期';
comment on column ${iol_schema}.isbs_ccd.clsdat is '结束日期';
comment on column ${iol_schema}.isbs_ccd.paydat is '收款日期';
comment on column ${iol_schema}.isbs_ccd.opndat is '开始日期';
comment on column ${iol_schema}.isbs_ccd.stacty is '国家代码';
comment on column ${iol_schema}.isbs_ccd.ngrcod is '货物代码';
comment on column ${iol_schema}.isbs_ccd.infdsp is '显示信息标志';
comment on column ${iol_schema}.isbs_ccd.ccform is '光票托收形式';
comment on column ${iol_schema}.isbs_ccd.purflg is '付款方式';
comment on column ${iol_schema}.isbs_ccd.modset is '结算方式';
comment on column ${iol_schema}.isbs_ccd.tocsel is '票据类型';
comment on column ${iol_schema}.isbs_ccd.brchref is '支行参考号';
comment on column ${iol_schema}.isbs_ccd.chcknum is '支票号';
comment on column ${iol_schema}.isbs_ccd.colref is '代收行参考号';
comment on column ${iol_schema}.isbs_ccd.colnam is '代收行名称';
comment on column ${iol_schema}.isbs_ccd.colptyinr is '代收行inr';
comment on column ${iol_schema}.isbs_ccd.colptainr is '代收行地址';
comment on column ${iol_schema}.isbs_ccd.rptbtchno is '打包托收的业务参考好';
comment on column ${iol_schema}.isbs_ccd.bchkeyinr is '业务经办机构inr';
comment on column ${iol_schema}.isbs_ccd.branchinr is '业务所属机构inr';
comment on column ${iol_schema}.isbs_ccd.vercerref is '核销单号';
comment on column ${iol_schema}.isbs_ccd.decnum is '申报单号';
comment on column ${iol_schema}.isbs_ccd.pretyp is '托收人/收款人类型';
comment on column ${iol_schema}.isbs_ccd.prodat is '打包托收收款日期';
comment on column ${iol_schema}.isbs_ccd.regref is '收单行系统业务代号';
comment on column ${iol_schema}.isbs_ccd.ver is '版本号';
comment on column ${iol_schema}.isbs_ccd.frepayflg is '自由付款标志';
comment on column ${iol_schema}.isbs_ccd.etyextkey is '实体组';
comment on column ${iol_schema}.isbs_ccd.nraflg is '是否nra付款';
comment on column ${iol_schema}.isbs_ccd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ccd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ccd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ccd.etl_timestamp is 'ETL处理时间戳';
