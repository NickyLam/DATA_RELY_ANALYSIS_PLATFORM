/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_icms_business_info_total
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_icms_business_info_total
whenever sqlerror continue none;
drop table ${iol_schema}.icms_icms_business_info_total purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_icms_business_info_total(
    txndt date -- 交易日期
    ,txntm varchar2(20) -- 交易时间
    ,blngorgid varchar2(10) -- 所属机构编号
    ,opertellerid varchar2(20) -- 经办柜员编号
    ,opertellername varchar2(40) -- 经办柜员名称
    ,authtellerid varchar2(20) -- 授权柜员编号
    ,authtellername varchar2(200) -- 授权柜员名称
    ,txnnum varchar2(30) -- 交易码
    ,txndesc varchar2(80) -- 交易描述
    ,bizsysevtid varchar2(64) -- 业务系统流水号
    ,bcsevtid varchar2(64) -- 核心系统流水号
    ,datasrccd varchar2(10) -- 系统代码
    ,payagtid varchar2(40) -- 付款账户
    ,rcvagtid varchar2(40) -- 收款账户
    ,txnamt number(20,2) -- 交易金额
    ,etldt date -- 数据日期
    ,menuid varchar2(40) -- 柜面菜单码(智能网点系统必输)
    ,eftflag varchar2(2) -- 金融交易类型(1-金融交易，2-非金融交易)
    ,servflag varchar2(2) -- 业务交易类型(1-个人业务交易，2-对公业务交易，3-其他交易)
    ,acctflag varchar2(2) -- 账户交易类型(1-账户开户交易，2-账户销户交易，3-账户变更交易)
    ,caflag varchar2(2) -- 现金交易类型(1-现金交易，2-非现金交易)
    ,bdflag varchar2(2) -- 存取款交易类型(1-存款交易，2-取款交易)
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
grant select on ${iol_schema}.icms_icms_business_info_total to ${iml_schema};
grant select on ${iol_schema}.icms_icms_business_info_total to ${icl_schema};
grant select on ${iol_schema}.icms_icms_business_info_total to ${idl_schema};
grant select on ${iol_schema}.icms_icms_business_info_total to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_icms_business_info_total is '信贷业务量统计表';
comment on column ${iol_schema}.icms_icms_business_info_total.txndt is '交易日期';
comment on column ${iol_schema}.icms_icms_business_info_total.txntm is '交易时间';
comment on column ${iol_schema}.icms_icms_business_info_total.blngorgid is '所属机构编号';
comment on column ${iol_schema}.icms_icms_business_info_total.opertellerid is '经办柜员编号';
comment on column ${iol_schema}.icms_icms_business_info_total.opertellername is '经办柜员名称';
comment on column ${iol_schema}.icms_icms_business_info_total.authtellerid is '授权柜员编号';
comment on column ${iol_schema}.icms_icms_business_info_total.authtellername is '授权柜员名称';
comment on column ${iol_schema}.icms_icms_business_info_total.txnnum is '交易码';
comment on column ${iol_schema}.icms_icms_business_info_total.txndesc is '交易描述';
comment on column ${iol_schema}.icms_icms_business_info_total.bizsysevtid is '业务系统流水号';
comment on column ${iol_schema}.icms_icms_business_info_total.bcsevtid is '核心系统流水号';
comment on column ${iol_schema}.icms_icms_business_info_total.datasrccd is '系统代码';
comment on column ${iol_schema}.icms_icms_business_info_total.payagtid is '付款账户';
comment on column ${iol_schema}.icms_icms_business_info_total.rcvagtid is '收款账户';
comment on column ${iol_schema}.icms_icms_business_info_total.txnamt is '交易金额';
comment on column ${iol_schema}.icms_icms_business_info_total.etldt is '数据日期';
comment on column ${iol_schema}.icms_icms_business_info_total.menuid is '柜面菜单码(智能网点系统必输)';
comment on column ${iol_schema}.icms_icms_business_info_total.eftflag is '金融交易类型(1-金融交易，2-非金融交易)';
comment on column ${iol_schema}.icms_icms_business_info_total.servflag is '业务交易类型(1-个人业务交易，2-对公业务交易，3-其他交易)';
comment on column ${iol_schema}.icms_icms_business_info_total.acctflag is '账户交易类型(1-账户开户交易，2-账户销户交易，3-账户变更交易)';
comment on column ${iol_schema}.icms_icms_business_info_total.caflag is '现金交易类型(1-现金交易，2-非现金交易)';
comment on column ${iol_schema}.icms_icms_business_info_total.bdflag is '存取款交易类型(1-存款交易，2-取款交易)';
comment on column ${iol_schema}.icms_icms_business_info_total.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_icms_business_info_total.etl_timestamp is 'ETL处理时间戳';
