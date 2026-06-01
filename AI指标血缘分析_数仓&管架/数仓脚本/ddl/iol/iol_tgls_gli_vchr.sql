/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gli_vchr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gli_vchr
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gli_vchr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gli_vchr(
    stacid number(19) -- 账套标记
    ,sourst varchar2(4) -- 源系统标识
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(64) -- 源系统流水号
    ,vchrsq varchar2(20) -- 传票序号
    ,tranbr varchar2(12) -- 交易机构编号
    ,acctbr varchar2(12) -- 账务机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,custcd varchar2(16) -- 客户编号
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(30) -- 账户
    ,trantp varchar2(9) -- 交易类型
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,smrytx varchar2(400) -- 摘要
    ,exchcn number(15,8) -- 中间价
    ,exchus number(15,8) -- 折算汇率
    ,usercd varchar2(20) -- 用户代码
    ,trandt varchar2(8) -- 总账会计日期（总账入账日期）
    ,transq varchar2(20) -- 总账流水（总账入账流水）
    ,toitem varchar2(30) -- 对方科目编号
    ,assis0 varchar2(6) -- 渠道编号
    ,assis1 varchar2(12) -- 产品编号
    ,assis2 varchar2(30) -- 辅助核算2（自定义）
    ,assis3 varchar2(30) -- 辅助核算3（自定义）
    ,assis4 varchar2(30) -- 辅助核算4（自定义）
    ,assis5 varchar2(30) -- 辅助核算5（自定义）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,dealst varchar2(1) -- 处理状态(0：未处理1:成功2：失败3：价税分离后合并流水成功5：不处理6：已回执)
    ,prcscd varchar2(20) -- 交易码
    ,itemna varchar2(200) -- 科目名称
    ,prcsna varchar2(60) -- 交易码名称
    ,strkst varchar2(1) -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt varchar2(8) -- 被冲正业务交易日期
    ,strksq varchar2(50) -- 被冲正业务交易流水
    ,crcysd varchar2(3) -- 本位币种
    ,traneq number(21,2) -- 折算金额（本位币）
    ,taxbst varchar2(1) -- 日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
    ,trannm number -- 交易笔数
    ,transt varchar2(1) -- 处理状态（1：已处理0：未处理）
    ,bsnssq varchar2(33) -- 全局流水号
    ,dealmg varchar2(400) -- 价税分离错误信息
    ,bathid varchar2(64) -- 文件批次号
    ,taxam  number(20,2) -- 税额
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
grant select on ${iol_schema}.tgls_gli_vchr to ${iml_schema};
grant select on ${iol_schema}.tgls_gli_vchr to ${icl_schema};
grant select on ${iol_schema}.tgls_gli_vchr to ${idl_schema};
grant select on ${iol_schema}.tgls_gli_vchr to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gli_vchr is '传票信息';
comment on column ${iol_schema}.tgls_gli_vchr.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gli_vchr.sourst is '源系统标识';
comment on column ${iol_schema}.tgls_gli_vchr.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gli_vchr.soursq is '源系统流水号';
comment on column ${iol_schema}.tgls_gli_vchr.vchrsq is '传票序号';
comment on column ${iol_schema}.tgls_gli_vchr.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gli_vchr.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gli_vchr.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gli_vchr.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gli_vchr.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gli_vchr.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gli_vchr.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gli_vchr.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gli_vchr.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gli_vchr.acctno is '账户';
comment on column ${iol_schema}.tgls_gli_vchr.trantp is '交易类型';
comment on column ${iol_schema}.tgls_gli_vchr.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_gli_vchr.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gli_vchr.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gli_vchr.exchcn is '中间价';
comment on column ${iol_schema}.tgls_gli_vchr.exchus is '折算汇率';
comment on column ${iol_schema}.tgls_gli_vchr.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gli_vchr.trandt is '总账会计日期（总账入账日期）';
comment on column ${iol_schema}.tgls_gli_vchr.transq is '总账流水（总账入账流水）';
comment on column ${iol_schema}.tgls_gli_vchr.toitem is '对方科目编号';
comment on column ${iol_schema}.tgls_gli_vchr.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gli_vchr.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gli_vchr.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr.dealst is '处理状态(0：未处理1:成功2：失败3：价税分离后合并流水成功5：不处理6：已回执)';
comment on column ${iol_schema}.tgls_gli_vchr.prcscd is '交易码';
comment on column ${iol_schema}.tgls_gli_vchr.itemna is '科目名称';
comment on column ${iol_schema}.tgls_gli_vchr.prcsna is '交易码名称';
comment on column ${iol_schema}.tgls_gli_vchr.strkst is '冲正标识（0：正常业务1：冲正业务）';
comment on column ${iol_schema}.tgls_gli_vchr.strkdt is '被冲正业务交易日期';
comment on column ${iol_schema}.tgls_gli_vchr.strksq is '被冲正业务交易流水';
comment on column ${iol_schema}.tgls_gli_vchr.crcysd is '本位币种';
comment on column ${iol_schema}.tgls_gli_vchr.traneq is '折算金额（本位币）';
comment on column ${iol_schema}.tgls_gli_vchr.taxbst is '日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)';
comment on column ${iol_schema}.tgls_gli_vchr.trannm is '交易笔数';
comment on column ${iol_schema}.tgls_gli_vchr.transt is '处理状态（1：已处理0：未处理）';
comment on column ${iol_schema}.tgls_gli_vchr.bsnssq is '全局流水号';
comment on column ${iol_schema}.tgls_gli_vchr.dealmg is '价税分离错误信息';
comment on column ${iol_schema}.tgls_gli_vchr.bathid is '文件批次号';
comment on column ${iol_schema}.tgls_gli_vchr.taxam  is '税额';
comment on column ${iol_schema}.tgls_gli_vchr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gli_vchr.etl_timestamp is 'ETL处理时间戳';
