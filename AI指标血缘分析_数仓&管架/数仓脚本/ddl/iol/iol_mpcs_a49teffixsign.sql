/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49teffixsign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49teffixsign
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49teffixsign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49teffixsign(
    signdt varchar2(12) -- 签约日期
    ,cntrsq varchar2(12) -- 合同顺序号
    ,signtm varchar2(9) -- 签约时间
    ,custtp varchar2(2) -- 客户类型
    ,unitcd varchar2(15) -- 组织机构代码
    ,citycd varchar2(6) -- 城市代码
    ,cntrtp varchar2(2) -- 合同(协议)类型
    ,busitp varchar2(8) -- 业务种类
    ,cntrno varchar2(90) -- 合同(协议)号
    ,iotype varchar2(2) -- 来往标志
    ,recvbk varchar2(18) -- 收款行号
    ,rebkna varchar2(75) -- 收款行名
    ,recvac varchar2(48) -- 收款账号
    ,recvna varchar2(75) -- 收款户名
    ,pyerbk varchar2(18) -- 付款行行号
    ,pybkna varchar2(75) -- 付款行名
    ,pyerac varchar2(48) -- 付款人账号
    ,pyerna varchar2(75) -- 付款人名称
    ,cncldt varchar2(12) -- 合同撤销日期
    ,userid varchar2(15) -- 登记柜员
    ,brchno varchar2(15) -- 登记部门
    ,ckbrus varchar2(15) -- 复核柜员
    ,cntrst varchar2(2) -- 协议状态
    ,modidt varchar2(12) -- 维护日期
    ,moditm varchar2(9) -- 维护时间
    ,modius varchar2(15) -- 维护柜员
    ,modibr varchar2(15) -- 维护部门
    ,clckus varchar2(15) -- 维护授权柜员
    ,remark varchar2(90) -- 附言
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
grant select on ${iol_schema}.mpcs_a49teffixsign to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49teffixsign to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49teffixsign to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49teffixsign to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49teffixsign is '金融服务平台EFT定期借贷记签约表';
comment on column ${iol_schema}.mpcs_a49teffixsign.signdt is '签约日期';
comment on column ${iol_schema}.mpcs_a49teffixsign.cntrsq is '合同顺序号';
comment on column ${iol_schema}.mpcs_a49teffixsign.signtm is '签约时间';
comment on column ${iol_schema}.mpcs_a49teffixsign.custtp is '客户类型';
comment on column ${iol_schema}.mpcs_a49teffixsign.unitcd is '组织机构代码';
comment on column ${iol_schema}.mpcs_a49teffixsign.citycd is '城市代码';
comment on column ${iol_schema}.mpcs_a49teffixsign.cntrtp is '合同(协议)类型';
comment on column ${iol_schema}.mpcs_a49teffixsign.busitp is '业务种类';
comment on column ${iol_schema}.mpcs_a49teffixsign.cntrno is '合同(协议)号';
comment on column ${iol_schema}.mpcs_a49teffixsign.iotype is '来往标志';
comment on column ${iol_schema}.mpcs_a49teffixsign.recvbk is '收款行号';
comment on column ${iol_schema}.mpcs_a49teffixsign.rebkna is '收款行名';
comment on column ${iol_schema}.mpcs_a49teffixsign.recvac is '收款账号';
comment on column ${iol_schema}.mpcs_a49teffixsign.recvna is '收款户名';
comment on column ${iol_schema}.mpcs_a49teffixsign.pyerbk is '付款行行号';
comment on column ${iol_schema}.mpcs_a49teffixsign.pybkna is '付款行名';
comment on column ${iol_schema}.mpcs_a49teffixsign.pyerac is '付款人账号';
comment on column ${iol_schema}.mpcs_a49teffixsign.pyerna is '付款人名称';
comment on column ${iol_schema}.mpcs_a49teffixsign.cncldt is '合同撤销日期';
comment on column ${iol_schema}.mpcs_a49teffixsign.userid is '登记柜员';
comment on column ${iol_schema}.mpcs_a49teffixsign.brchno is '登记部门';
comment on column ${iol_schema}.mpcs_a49teffixsign.ckbrus is '复核柜员';
comment on column ${iol_schema}.mpcs_a49teffixsign.cntrst is '协议状态';
comment on column ${iol_schema}.mpcs_a49teffixsign.modidt is '维护日期';
comment on column ${iol_schema}.mpcs_a49teffixsign.moditm is '维护时间';
comment on column ${iol_schema}.mpcs_a49teffixsign.modius is '维护柜员';
comment on column ${iol_schema}.mpcs_a49teffixsign.modibr is '维护部门';
comment on column ${iol_schema}.mpcs_a49teffixsign.clckus is '维护授权柜员';
comment on column ${iol_schema}.mpcs_a49teffixsign.remark is '附言';
comment on column ${iol_schema}.mpcs_a49teffixsign.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49teffixsign.etl_timestamp is 'ETL处理时间戳';
