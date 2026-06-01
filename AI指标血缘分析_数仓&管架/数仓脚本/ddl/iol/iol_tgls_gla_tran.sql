/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_tran
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_tran(
    stacid number(19) -- 账套标记
    ,trandt varchar2(8) -- 交易日期
    ,transq varchar2(20) -- 交易流水
    ,tranti timestamp -- 交易时间
    ,tranbr varchar2(12) -- 交易机构编号
    ,usercd varchar2(20) -- 用户代码
    ,acctbr varchar2(12) -- 账务机构编号
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(64) -- 源系统流水号
    ,trantp varchar2(9) -- 交易类型(1手工账2系统账9非账务类)
    ,crcycd varchar2(3) -- 币种代码
    ,dcmtno varchar2(30) -- 凭证号码
    ,dcmttp varchar2(10) -- 凭证类型
    ,prcscd varchar2(12) -- 处理码
    ,tranam number(20,2) -- 交易金额
    ,itemcd varchar2(30) -- 科目编号（交易主科目）
    ,psauus varchar2(20) -- 复核用户
    ,strkst varchar2(1) -- 冲正状态（0、正常1、该交易已被冲正9、该交易为冲正交易）
    ,odtrdt varchar2(8) -- 原交易日期（被冲正交易日期）
    ,odtrsq varchar2(20) -- 原交易流水（被冲正交流流水）
    ,acsrnm number -- 附件张数
    ,systid varchar2(4) -- 系统识别号
    ,menuid varchar2(10) -- 前台菜单码
    ,authus varchar2(10) -- 授权柜员
    ,mainbd varchar2(40) -- 受理主体
    ,pckgsq varchar2(20) -- 报文流水
    ,bookno varchar2(20) -- 记账处理号
    ,clertg varchar2(1) -- 清算标志(0待清算1已清算)
    ,clerno varchar2(20) -- 清算处理号
    ,remark varchar2(255) -- 备注
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
grant select on ${iol_schema}.tgls_gla_tran to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_tran to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_tran to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_tran to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_tran is '交易流水';
comment on column ${iol_schema}.tgls_gla_tran.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_tran.trandt is '交易日期';
comment on column ${iol_schema}.tgls_gla_tran.transq is '交易流水';
comment on column ${iol_schema}.tgls_gla_tran.tranti is '交易时间';
comment on column ${iol_schema}.tgls_gla_tran.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gla_tran.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gla_tran.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gla_tran.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gla_tran.soursq is '源系统流水号';
comment on column ${iol_schema}.tgls_gla_tran.trantp is '交易类型(1手工账2系统账9非账务类)';
comment on column ${iol_schema}.tgls_gla_tran.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_tran.dcmtno is '凭证号码';
comment on column ${iol_schema}.tgls_gla_tran.dcmttp is '凭证类型';
comment on column ${iol_schema}.tgls_gla_tran.prcscd is '处理码';
comment on column ${iol_schema}.tgls_gla_tran.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gla_tran.itemcd is '科目编号（交易主科目）';
comment on column ${iol_schema}.tgls_gla_tran.psauus is '复核用户';
comment on column ${iol_schema}.tgls_gla_tran.strkst is '冲正状态（0、正常1、该交易已被冲正9、该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gla_tran.odtrdt is '原交易日期（被冲正交易日期）';
comment on column ${iol_schema}.tgls_gla_tran.odtrsq is '原交易流水（被冲正交流流水）';
comment on column ${iol_schema}.tgls_gla_tran.acsrnm is '附件张数';
comment on column ${iol_schema}.tgls_gla_tran.systid is '系统识别号';
comment on column ${iol_schema}.tgls_gla_tran.menuid is '前台菜单码';
comment on column ${iol_schema}.tgls_gla_tran.authus is '授权柜员';
comment on column ${iol_schema}.tgls_gla_tran.mainbd is '受理主体';
comment on column ${iol_schema}.tgls_gla_tran.pckgsq is '报文流水';
comment on column ${iol_schema}.tgls_gla_tran.bookno is '记账处理号';
comment on column ${iol_schema}.tgls_gla_tran.clertg is '清算标志(0待清算1已清算)';
comment on column ${iol_schema}.tgls_gla_tran.clerno is '清算处理号';
comment on column ${iol_schema}.tgls_gla_tran.remark is '备注';
comment on column ${iol_schema}.tgls_gla_tran.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_tran.etl_timestamp is 'ETL处理时间戳';
