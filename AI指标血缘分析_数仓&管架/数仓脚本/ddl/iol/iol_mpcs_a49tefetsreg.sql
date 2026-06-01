/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefetsreg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefetsreg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefetsreg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefetsreg(
    signdt varchar2(12) -- 签约日期
    ,signsq varchar2(12) -- 签约流水
    ,signtm varchar2(12) -- 签约时间
    ,cntrno varchar2(90) -- 签约协议号
    ,txpycd varchar2(30) -- 纳税人编码
    ,txbrch varchar2(2) -- 机关类别
    ,origcd varchar2(18) -- 征收机关代码
    ,custtp varchar2(2) -- 客户类型
    ,acctno varchar2(53) -- 账号
    ,acctna varchar2(240) -- 户名
    ,openbr varchar2(15) -- 开户行
    ,idtftp varchar2(6) -- 证件类型
    ,idtfno varchar2(30) -- 证件号码
    ,brchno varchar2(18) -- 签约网点
    ,userid varchar2(15) -- 操作柜员
    ,ckbkus varchar2(15) -- 复核柜员
    ,mainbr varchar2(15) -- 维护网点号
    ,mainus varchar2(15) -- 维护柜员号
    ,clckus varchar2(15) -- 维护授权柜员
    ,maindt varchar2(12) -- 维护日期
    ,maintm varchar2(12) -- 维护时间
    ,signst varchar2(2) -- 签约状态
    ,remark varchar2(450) -- 备注
    ,etsflg varchar2(2) -- 省市ets标识
    ,origna varchar2(180) -- 征收机关名称
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
grant select on ${iol_schema}.mpcs_a49tefetsreg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefetsreg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefetsreg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefetsreg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefetsreg is '财税扣缴协议签约登记簿';
comment on column ${iol_schema}.mpcs_a49tefetsreg.signdt is '签约日期';
comment on column ${iol_schema}.mpcs_a49tefetsreg.signsq is '签约流水';
comment on column ${iol_schema}.mpcs_a49tefetsreg.signtm is '签约时间';
comment on column ${iol_schema}.mpcs_a49tefetsreg.cntrno is '签约协议号';
comment on column ${iol_schema}.mpcs_a49tefetsreg.txpycd is '纳税人编码';
comment on column ${iol_schema}.mpcs_a49tefetsreg.txbrch is '机关类别';
comment on column ${iol_schema}.mpcs_a49tefetsreg.origcd is '征收机关代码';
comment on column ${iol_schema}.mpcs_a49tefetsreg.custtp is '客户类型';
comment on column ${iol_schema}.mpcs_a49tefetsreg.acctno is '账号';
comment on column ${iol_schema}.mpcs_a49tefetsreg.acctna is '户名';
comment on column ${iol_schema}.mpcs_a49tefetsreg.openbr is '开户行';
comment on column ${iol_schema}.mpcs_a49tefetsreg.idtftp is '证件类型';
comment on column ${iol_schema}.mpcs_a49tefetsreg.idtfno is '证件号码';
comment on column ${iol_schema}.mpcs_a49tefetsreg.brchno is '签约网点';
comment on column ${iol_schema}.mpcs_a49tefetsreg.userid is '操作柜员';
comment on column ${iol_schema}.mpcs_a49tefetsreg.ckbkus is '复核柜员';
comment on column ${iol_schema}.mpcs_a49tefetsreg.mainbr is '维护网点号';
comment on column ${iol_schema}.mpcs_a49tefetsreg.mainus is '维护柜员号';
comment on column ${iol_schema}.mpcs_a49tefetsreg.clckus is '维护授权柜员';
comment on column ${iol_schema}.mpcs_a49tefetsreg.maindt is '维护日期';
comment on column ${iol_schema}.mpcs_a49tefetsreg.maintm is '维护时间';
comment on column ${iol_schema}.mpcs_a49tefetsreg.signst is '签约状态';
comment on column ${iol_schema}.mpcs_a49tefetsreg.remark is '备注';
comment on column ${iol_schema}.mpcs_a49tefetsreg.etsflg is '省市ets标识';
comment on column ${iol_schema}.mpcs_a49tefetsreg.origna is '征收机关名称';
comment on column ${iol_schema}.mpcs_a49tefetsreg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefetsreg.etl_timestamp is 'ETL处理时间戳';
