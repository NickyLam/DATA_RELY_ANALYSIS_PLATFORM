/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49teffree
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49teffree
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49teffree purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49teffree(
    unotnbr varchar2(15) -- 前置流水号
    ,unotdate varchar2(12) -- 前置日期
    ,msgseq varchar2(30) -- 信息序号
    ,nsgdate varchar2(12) -- 委托日期
    ,opmsgseq varchar2(30) -- 对方信息序号
    ,tlrnbr varchar2(15) -- 柜员号
    ,magbrn varchar2(18) -- 管理机构
    ,sendbank varchar2(18) -- 发起行行号/机构号
    ,recvbank varchar2(18) -- 接收行行号/机构号
    ,oprchl varchar2(6) -- 业务渠道
    ,recvaccbank varchar2(18) -- 接收账户行
    ,origcode varchar2(18) -- 委托方代码
    ,linkid number(22) -- 链路id
    ,content varchar2(1499) -- 信息内容
    ,iotype varchar2(2) -- 来往标志
    ,status varchar2(3) -- 状态
    ,errcode varchar2(12) -- 错误代码
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
grant select on ${iol_schema}.mpcs_a49teffree to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49teffree to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49teffree to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49teffree to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49teffree is '金融服务平台EFT自由格式表';
comment on column ${iol_schema}.mpcs_a49teffree.unotnbr is '前置流水号';
comment on column ${iol_schema}.mpcs_a49teffree.unotdate is '前置日期';
comment on column ${iol_schema}.mpcs_a49teffree.msgseq is '信息序号';
comment on column ${iol_schema}.mpcs_a49teffree.nsgdate is '委托日期';
comment on column ${iol_schema}.mpcs_a49teffree.opmsgseq is '对方信息序号';
comment on column ${iol_schema}.mpcs_a49teffree.tlrnbr is '柜员号';
comment on column ${iol_schema}.mpcs_a49teffree.magbrn is '管理机构';
comment on column ${iol_schema}.mpcs_a49teffree.sendbank is '发起行行号/机构号';
comment on column ${iol_schema}.mpcs_a49teffree.recvbank is '接收行行号/机构号';
comment on column ${iol_schema}.mpcs_a49teffree.oprchl is '业务渠道';
comment on column ${iol_schema}.mpcs_a49teffree.recvaccbank is '接收账户行';
comment on column ${iol_schema}.mpcs_a49teffree.origcode is '委托方代码';
comment on column ${iol_schema}.mpcs_a49teffree.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a49teffree.content is '信息内容';
comment on column ${iol_schema}.mpcs_a49teffree.iotype is '来往标志';
comment on column ${iol_schema}.mpcs_a49teffree.status is '状态';
comment on column ${iol_schema}.mpcs_a49teffree.errcode is '错误代码';
comment on column ${iol_schema}.mpcs_a49teffree.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49teffree.etl_timestamp is 'ETL处理时间戳';
