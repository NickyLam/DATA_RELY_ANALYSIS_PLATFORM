/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_vchr_back
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_vchr_back
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_vchr_back purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_vchr_back(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 来源系统编号
    ,trandt varchar2(8) -- 交易日期
    ,transq varchar2(64) -- 交易流水
    ,vchrsq varchar2(20) -- 凭证序号
    ,tranbr varchar2(12) -- 交易机构编号
    ,acctbr varchar2(12) -- 账务机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码
    ,ioflag varchar2(1) -- 表内外标志
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,custcd varchar2(16) -- 客户编号
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(64) -- 账户
    ,trantp varchar2(9) -- 交易类型
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,tranbl number(20,2) -- 交易余额
    ,blncdn varchar2(1) -- 当前科目余额方向
    ,smrytx varchar2(400) -- 摘要
    ,exchcn number(15,8) -- 中间价
    ,exchus number(15,8) -- 折算汇率
    ,usercd varchar2(20) -- 用户代码
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(64) -- 源系统流水号
    ,sourst varchar2(4) -- 源系统标识
    ,srvcsq varchar2(30) -- 源交易流水序号
    ,bearbl number(20,2) -- 承前余额
    ,beardn varchar2(1) -- 承前科目余额方向
    ,toitem varchar2(30) -- 对方科目编号
    ,assis0 varchar2(6) -- 辅助核算0（自定义）
    ,assis1 varchar2(12) -- 辅助核算1（自定义）
    ,assis2 varchar2(30) -- 辅助核算2（自定义）
    ,assis3 varchar2(30) -- 辅助核算3（自定义）
    ,assis4 varchar2(30) -- 辅助核算4（自定义）
    ,assis5 varchar2(30) -- 辅助核算5（自定义）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,tranno number(9) -- 交易流水序号
    ,clertg varchar2(1) -- 清算状态：0未清算，1待清算，2已清算，3不参与清算，4清算传票
    ,clerod varchar2(20) -- 清算批次
    ,centsq varchar2(64) -- 清算行流水
    ,brchsq varchar2(20) -- 帐户行流水
    ,clerdt varchar2(20) -- 清算日期
    ,transt varchar2(1) -- 交易状态，0－未过账，1－过账成功，2－过账失败，8－转存失败，9－待确认
    ,subsac varchar2(20) -- 子户码
    ,sourac number(9) -- 源账套
    ,strkst varchar2(1) -- 冲正状态（0正常交易1该交易已被冲正9该交易为冲正交易）
    ,odbsdt varchar2(8) -- 原业务日期（被冲正业务日期）
    ,odbssq varchar2(33) -- 原业务流水号（被冲正业务日期）
    ,bathid varchar2(50) -- 批次号
    ,tranti timestamp -- 时间戳
    ,smrycd varchar2(200) -- 摘要编码
    ,dcmtno varchar2(32) -- 凭证编号
    ,bsnssq varchar2(33) -- 
    ,foldcn number(20,2) -- 折本位币金额
    ,backtp number(1) -- 回退类型:1日终批量前数据2日终批量后数据
    ,itemna varchar2(200) -- 科目名称
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
grant select on ${iol_schema}.tgls_gla_vchr_back to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_vchr_back to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_vchr_back to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_vchr_back to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_vchr_back is '传票回退备份表';
comment on column ${iol_schema}.tgls_gla_vchr_back.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_vchr_back.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.trandt is '交易日期';
comment on column ${iol_schema}.tgls_gla_vchr_back.transq is '交易流水';
comment on column ${iol_schema}.tgls_gla_vchr_back.vchrsq is '凭证序号';
comment on column ${iol_schema}.tgls_gla_vchr_back.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_vchr_back.ioflag is '表内外标志';
comment on column ${iol_schema}.tgls_gla_vchr_back.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_vchr_back.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gla_vchr_back.acctno is '账户';
comment on column ${iol_schema}.tgls_gla_vchr_back.trantp is '交易类型';
comment on column ${iol_schema}.tgls_gla_vchr_back.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_gla_vchr_back.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gla_vchr_back.tranbl is '交易余额';
comment on column ${iol_schema}.tgls_gla_vchr_back.blncdn is '当前科目余额方向';
comment on column ${iol_schema}.tgls_gla_vchr_back.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gla_vchr_back.exchcn is '中间价';
comment on column ${iol_schema}.tgls_gla_vchr_back.exchus is '折算汇率';
comment on column ${iol_schema}.tgls_gla_vchr_back.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gla_vchr_back.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gla_vchr_back.soursq is '源系统流水号';
comment on column ${iol_schema}.tgls_gla_vchr_back.sourst is '源系统标识';
comment on column ${iol_schema}.tgls_gla_vchr_back.srvcsq is '源交易流水序号';
comment on column ${iol_schema}.tgls_gla_vchr_back.bearbl is '承前余额';
comment on column ${iol_schema}.tgls_gla_vchr_back.beardn is '承前科目余额方向';
comment on column ${iol_schema}.tgls_gla_vchr_back.toitem is '对方科目编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_vchr_back.tranno is '交易流水序号';
comment on column ${iol_schema}.tgls_gla_vchr_back.clertg is '清算状态：0未清算，1待清算，2已清算，3不参与清算，4清算传票';
comment on column ${iol_schema}.tgls_gla_vchr_back.clerod is '清算批次';
comment on column ${iol_schema}.tgls_gla_vchr_back.centsq is '清算行流水';
comment on column ${iol_schema}.tgls_gla_vchr_back.brchsq is '帐户行流水';
comment on column ${iol_schema}.tgls_gla_vchr_back.clerdt is '清算日期';
comment on column ${iol_schema}.tgls_gla_vchr_back.transt is '交易状态，0－未过账，1－过账成功，2－过账失败，8－转存失败，9－待确认';
comment on column ${iol_schema}.tgls_gla_vchr_back.subsac is '子户码';
comment on column ${iol_schema}.tgls_gla_vchr_back.sourac is '源账套';
comment on column ${iol_schema}.tgls_gla_vchr_back.strkst is '冲正状态（0正常交易1该交易已被冲正9该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gla_vchr_back.odbsdt is '原业务日期（被冲正业务日期）';
comment on column ${iol_schema}.tgls_gla_vchr_back.odbssq is '原业务流水号（被冲正业务日期）';
comment on column ${iol_schema}.tgls_gla_vchr_back.bathid is '批次号';
comment on column ${iol_schema}.tgls_gla_vchr_back.tranti is '时间戳';
comment on column ${iol_schema}.tgls_gla_vchr_back.smrycd is '摘要编码';
comment on column ${iol_schema}.tgls_gla_vchr_back.dcmtno is '凭证编号';
comment on column ${iol_schema}.tgls_gla_vchr_back.bsnssq is '';
comment on column ${iol_schema}.tgls_gla_vchr_back.foldcn is '折本位币金额';
comment on column ${iol_schema}.tgls_gla_vchr_back.backtp is '回退类型:1日终批量前数据2日终批量后数据';
comment on column ${iol_schema}.tgls_gla_vchr_back.itemna is '科目名称';
comment on column ${iol_schema}.tgls_gla_vchr_back.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_vchr_back.etl_timestamp is 'ETL处理时间戳';
