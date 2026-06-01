/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_vchr_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_vchr_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_vchr_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_vchr_h(
    stacid number(19) -- 账套标记
    ,systid varchar2(60) -- 来源系统编号
    ,trandt varchar2(16) -- 交易日期
    ,transq varchar2(128) -- 交易流水
    ,vchrsq varchar2(40) -- 凭证序号
    ,tranbr varchar2(24) -- 交易机构编号
    ,acctbr varchar2(24) -- 账务机构编号
    ,itemcd varchar2(60) -- 科目编号
    ,crcycd varchar2(6) -- 币种代码
    ,ioflag varchar2(2) -- 表内外标志
    ,centcd varchar2(32) -- 责任中心
    ,prsncd varchar2(16) -- 员工编号
    ,custcd varchar2(32) -- 客户编号
    ,prducd varchar2(24) -- 产品编号
    ,prlncd varchar2(32) -- 产品线
    ,acctno varchar2(64) -- 账户
    ,trantp varchar2(18) -- 交易类型
    ,amntcd varchar2(18) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,tranbl number(20,2) -- 交易余额
    ,blncdn varchar2(2) -- 当前科目余额方向
    ,smrytx varchar2(800) -- 摘要
    ,exchcn number(15,8) -- 中间价
    ,exchus number(15,8) -- 折算汇率
    ,usercd varchar2(40) -- 用户代码
    ,sourdt varchar2(16) -- 源系统日期
    ,soursq varchar2(128) -- 源系统流水
    ,sourst varchar2(8) -- 源系统标识
    ,srvcsq varchar2(60) -- 源交易流水序号
    ,bearbl number(20,2) -- 承前余额
    ,beardn varchar2(2) -- 承前科目余额方向
    ,toitem varchar2(60) -- 对方科目编号
    ,assis0 varchar2(12) -- 渠道编号
    ,assis1 varchar2(24) -- 产品编号
    ,assis2 varchar2(60) -- 辅助核算2（自定义）
    ,assis3 varchar2(60) -- 辅助核算3（自定义）
    ,assis4 varchar2(60) -- 辅助核算4（自定义）
    ,assis5 varchar2(60) -- 辅助核算5（自定义）
    ,assis6 varchar2(60) -- 辅助核算6（自定义）
    ,assis7 varchar2(60) -- 辅助核算7（自定义）
    ,assis8 varchar2(60) -- 辅助核算8（自定义）
    ,assis9 varchar2(60) -- 辅助核算9（自定义）
    ,tranno number(9) -- 交易流水序号
    ,clertg varchar2(2) -- 清算状态：0未清算，1待清算，2已清算，3不参与清算，4清算传票
    ,clerod varchar2(40) -- 清算批次
    ,centsq varchar2(128) -- 清算行流水
    ,brchsq varchar2(40) -- 账户行流水
    ,clerdt varchar2(40) -- 清算日期
    ,transt varchar2(2) -- 交易状态
    ,subsac varchar2(40) -- 子户码
    ,sourac number(9) -- 源账套
    ,strkst varchar2(2) -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,odbsdt varchar2(16) -- 原业务日期（被冲正业务日期）
    ,odbssq varchar2(66) -- 原业务流水（被冲正业务流水）
    ,bathid varchar2(100) -- 批次号
    ,tranti timestamp -- 时间戳
    ,smrycd varchar2(200) -- 摘要编码
    ,dcmtno varchar2(64) -- 凭证编号
    ,bsnssq varchar2(66) -- 
    ,foldcn number(20,2) -- 
    ,itemna varchar2(400) -- 科目名称
    ,istbgz varchar2(2) -- 是否已同步关账0未同步1同步
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
grant select on ${iol_schema}.tgls_gla_vchr_h to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_vchr_h to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_vchr_h to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_vchr_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_vchr_h is '传票信息历史表';
comment on column ${iol_schema}.tgls_gla_vchr_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_vchr_h.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.trandt is '交易日期';
comment on column ${iol_schema}.tgls_gla_vchr_h.transq is '交易流水';
comment on column ${iol_schema}.tgls_gla_vchr_h.vchrsq is '凭证序号';
comment on column ${iol_schema}.tgls_gla_vchr_h.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_vchr_h.ioflag is '表内外标志';
comment on column ${iol_schema}.tgls_gla_vchr_h.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_vchr_h.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gla_vchr_h.acctno is '账户';
comment on column ${iol_schema}.tgls_gla_vchr_h.trantp is '交易类型';
comment on column ${iol_schema}.tgls_gla_vchr_h.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_gla_vchr_h.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gla_vchr_h.tranbl is '交易余额';
comment on column ${iol_schema}.tgls_gla_vchr_h.blncdn is '当前科目余额方向';
comment on column ${iol_schema}.tgls_gla_vchr_h.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gla_vchr_h.exchcn is '中间价';
comment on column ${iol_schema}.tgls_gla_vchr_h.exchus is '折算汇率';
comment on column ${iol_schema}.tgls_gla_vchr_h.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gla_vchr_h.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gla_vchr_h.soursq is '源系统流水';
comment on column ${iol_schema}.tgls_gla_vchr_h.sourst is '源系统标识';
comment on column ${iol_schema}.tgls_gla_vchr_h.srvcsq is '源交易流水序号';
comment on column ${iol_schema}.tgls_gla_vchr_h.bearbl is '承前余额';
comment on column ${iol_schema}.tgls_gla_vchr_h.beardn is '承前科目余额方向';
comment on column ${iol_schema}.tgls_gla_vchr_h.toitem is '对方科目编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_h.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_h.tranno is '交易流水序号';
comment on column ${iol_schema}.tgls_gla_vchr_h.clertg is '清算状态：0未清算，1待清算，2已清算，3不参与清算，4清算传票';
comment on column ${iol_schema}.tgls_gla_vchr_h.clerod is '清算批次';
comment on column ${iol_schema}.tgls_gla_vchr_h.centsq is '清算行流水';
comment on column ${iol_schema}.tgls_gla_vchr_h.brchsq is '账户行流水';
comment on column ${iol_schema}.tgls_gla_vchr_h.clerdt is '清算日期';
comment on column ${iol_schema}.tgls_gla_vchr_h.transt is '交易状态';
comment on column ${iol_schema}.tgls_gla_vchr_h.subsac is '子户码';
comment on column ${iol_schema}.tgls_gla_vchr_h.sourac is '源账套';
comment on column ${iol_schema}.tgls_gla_vchr_h.strkst is '冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gla_vchr_h.odbsdt is '原业务日期（被冲正业务日期）';
comment on column ${iol_schema}.tgls_gla_vchr_h.odbssq is '原业务流水（被冲正业务流水）';
comment on column ${iol_schema}.tgls_gla_vchr_h.bathid is '批次号';
comment on column ${iol_schema}.tgls_gla_vchr_h.tranti is '时间戳';
comment on column ${iol_schema}.tgls_gla_vchr_h.smrycd is '摘要编码';
comment on column ${iol_schema}.tgls_gla_vchr_h.dcmtno is '凭证编号';
comment on column ${iol_schema}.tgls_gla_vchr_h.bsnssq is '';
comment on column ${iol_schema}.tgls_gla_vchr_h.foldcn is '';
comment on column ${iol_schema}.tgls_gla_vchr_h.itemna is '科目名称';
comment on column ${iol_schema}.tgls_gla_vchr_h.istbgz is '是否已同步关账0未同步1同步';
comment on column ${iol_schema}.tgls_gla_vchr_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_vchr_h.etl_timestamp is 'ETL处理时间戳';
