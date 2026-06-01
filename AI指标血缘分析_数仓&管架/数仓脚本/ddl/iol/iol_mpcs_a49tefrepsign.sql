/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefrepsign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefrepsign
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefrepsign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefrepsign(
    signdt varchar2(12) -- 
    ,signsq varchar2(12) -- 
    ,signtm varchar2(12) -- 
    ,iotype varchar2(2) -- 来往标记(i/o)
    ,deptcd varchar2(18) -- 组织机构代码
    ,deptnm varchar2(90) -- 组织机构名称
    ,protocolno varchar2(90) -- 协议号
    ,userno varchar2(27) -- 用户编号
    ,username varchar2(90) -- 用户名称
    ,contactusername varchar2(90) -- 联系人姓名
    ,contactuseraddr varchar2(90) -- 联系人地址
    ,postcode varchar2(15) -- 联系人地址邮编
    ,contactusertel varchar2(38) -- 联系人电话
    ,trantype varchar2(8) -- 业务种类
    ,openbrch varchar2(18) -- 付款人开户机构
    ,payerbank varchar2(18) -- 付款行行号
    ,openbrno varchar2(18) -- 付款人开户行行号
    ,payeracc varchar2(48) -- 付款人账号
    ,payername varchar2(90) -- 付款人户名
    ,payeridtype varchar2(6) -- 付款人证件类型
    ,payerid varchar2(27) -- 付款人证件号码
    ,payermobile varchar2(24) -- 付款人电话
    ,payeremail varchar2(45) -- 付款人信箱
    ,payeename varchar2(90) -- 收款人名称
    ,msgid varchar2(30) -- 
    ,ormsgid varchar2(30) -- 
    ,remark varchar2(450) -- 
    ,brchno varchar2(18) -- 
    ,userid varchar2(15) -- 
    ,ckbkus varchar2(15) -- 
    ,frsgdt varchar2(12) -- 
    ,frsgsq varchar2(12) -- 
    ,upsgdt varchar2(12) -- 
    ,upsgsq varchar2(12) -- 
    ,upbrch varchar2(18) -- 
    ,upurid varchar2(15) -- 
    ,upckus varchar2(15) -- 
    ,signst varchar2(3) -- 00 签约成功 01发送失败 02发送成功 03已撤销 04撤销发送成功 05签约失败
    ,updttm varchar2(12) -- 
    ,prtnum number(22) -- 
    ,retcd varchar2(12) -- 人行返回码
    ,errmsg varchar2(450) -- 人行返回详细信息
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
grant select on ${iol_schema}.mpcs_a49tefrepsign to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefrepsign to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefrepsign to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefrepsign to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefrepsign is '代收付集中代扣费签约信息表';
comment on column ${iol_schema}.mpcs_a49tefrepsign.signdt is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.signsq is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.signtm is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.iotype is '来往标记(i/o)';
comment on column ${iol_schema}.mpcs_a49tefrepsign.deptcd is '组织机构代码';
comment on column ${iol_schema}.mpcs_a49tefrepsign.deptnm is '组织机构名称';
comment on column ${iol_schema}.mpcs_a49tefrepsign.protocolno is '协议号';
comment on column ${iol_schema}.mpcs_a49tefrepsign.userno is '用户编号';
comment on column ${iol_schema}.mpcs_a49tefrepsign.username is '用户名称';
comment on column ${iol_schema}.mpcs_a49tefrepsign.contactusername is '联系人姓名';
comment on column ${iol_schema}.mpcs_a49tefrepsign.contactuseraddr is '联系人地址';
comment on column ${iol_schema}.mpcs_a49tefrepsign.postcode is '联系人地址邮编';
comment on column ${iol_schema}.mpcs_a49tefrepsign.contactusertel is '联系人电话';
comment on column ${iol_schema}.mpcs_a49tefrepsign.trantype is '业务种类';
comment on column ${iol_schema}.mpcs_a49tefrepsign.openbrch is '付款人开户机构';
comment on column ${iol_schema}.mpcs_a49tefrepsign.payerbank is '付款行行号';
comment on column ${iol_schema}.mpcs_a49tefrepsign.openbrno is '付款人开户行行号';
comment on column ${iol_schema}.mpcs_a49tefrepsign.payeracc is '付款人账号';
comment on column ${iol_schema}.mpcs_a49tefrepsign.payername is '付款人户名';
comment on column ${iol_schema}.mpcs_a49tefrepsign.payeridtype is '付款人证件类型';
comment on column ${iol_schema}.mpcs_a49tefrepsign.payerid is '付款人证件号码';
comment on column ${iol_schema}.mpcs_a49tefrepsign.payermobile is '付款人电话';
comment on column ${iol_schema}.mpcs_a49tefrepsign.payeremail is '付款人信箱';
comment on column ${iol_schema}.mpcs_a49tefrepsign.payeename is '收款人名称';
comment on column ${iol_schema}.mpcs_a49tefrepsign.msgid is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.ormsgid is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.remark is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.brchno is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.userid is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.ckbkus is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.frsgdt is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.frsgsq is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.upsgdt is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.upsgsq is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.upbrch is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.upurid is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.upckus is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.signst is '00 签约成功 01发送失败 02发送成功 03已撤销 04撤销发送成功 05签约失败';
comment on column ${iol_schema}.mpcs_a49tefrepsign.updttm is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.prtnum is '';
comment on column ${iol_schema}.mpcs_a49tefrepsign.retcd is '人行返回码';
comment on column ${iol_schema}.mpcs_a49tefrepsign.errmsg is '人行返回详细信息';
comment on column ${iol_schema}.mpcs_a49tefrepsign.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefrepsign.etl_timestamp is 'ETL处理时间戳';
