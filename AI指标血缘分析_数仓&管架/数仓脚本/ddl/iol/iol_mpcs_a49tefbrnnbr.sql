/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefbrnnbr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefbrnnbr
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefbrnnbr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefbrnnbr(
    brnnbr varchar2(18) -- 行号
    ,swiftnbr varchar2(18) -- swift行号
    ,sysid varchar2(6) -- 系统号
    ,zoneid varchar2(6) -- 地区代码
    ,area varchar2(6) -- 所在区域
    ,acpbrn varchar2(18) -- 集中受理行行号
    ,upbrn varchar2(18) -- 直接清算行行号
    ,clscode varchar2(5) -- 行别代码
    ,bankname varchar2(90) -- 银行名称
    ,shortname varchar2(30) -- 银行简称
    ,chkbrnnbr varchar2(18) -- 二级核算行行号
    ,bankaddr varchar2(383) -- 银行地址
    ,postcode varchar2(9) -- 邮编
    ,phone varchar2(30) -- 联系电话
    ,fax varchar2(30) -- 传真
    ,emailaddr varchar2(45) -- email地址
    ,linkman varchar2(240) -- 联系人
    ,directflag varchar2(2) -- 直接清算行标志
    ,conceflag varchar2(2) -- 集中处理行标志
    ,paybnkflg varchar2(2) -- 支付行号/非支付行号标志
    ,effdate varchar2(12) -- 生效日期
    ,invdate varchar2(12) -- 停用日期
    ,note varchar2(90) -- 备注
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
grant select on ${iol_schema}.mpcs_a49tefbrnnbr to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefbrnnbr to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefbrnnbr to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefbrnnbr to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefbrnnbr is '金融服务平台EFT行号信息表';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.brnnbr is '行号';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.swiftnbr is 'swift行号';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.sysid is '系统号';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.zoneid is '地区代码';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.area is '所在区域';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.acpbrn is '集中受理行行号';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.upbrn is '直接清算行行号';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.clscode is '行别代码';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.bankname is '银行名称';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.shortname is '银行简称';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.chkbrnnbr is '二级核算行行号';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.bankaddr is '银行地址';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.postcode is '邮编';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.phone is '联系电话';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.fax is '传真';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.emailaddr is 'email地址';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.linkman is '联系人';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.directflag is '直接清算行标志';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.conceflag is '集中处理行标志';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.paybnkflg is '支付行号/非支付行号标志';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.effdate is '生效日期';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.invdate is '停用日期';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.note is '备注';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a49tefbrnnbr.etl_timestamp is 'ETL处理时间戳';
