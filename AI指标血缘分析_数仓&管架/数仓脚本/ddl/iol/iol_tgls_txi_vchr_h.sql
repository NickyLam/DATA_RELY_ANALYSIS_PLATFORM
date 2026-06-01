/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_txi_vchr_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_txi_vchr_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_txi_vchr_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_txi_vchr_h(
    stacid number(19) -- 账套标记
    ,sourst varchar2(4) -- 源系统标识
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(64) -- 源系统流水号
    ,vchrsq varchar2(20) -- 传票序号
    ,tranbr varchar2(16) -- 交易机构
    ,acctbr varchar2(16) -- 账务机构
    ,itemcd varchar2(20) -- 科目代码
    ,crcycd varchar2(3) -- 币种代码
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(20) -- 职员
    ,custcd varchar2(16) -- 客户
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(30) -- 账户
    ,trantp varchar2(9) -- 交易类型
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,smrytx varchar2(255) -- 摘要
    ,exchcn number(11,7) -- 中间价
    ,exchus number(11,7) -- 折算率
    ,usercd varchar2(20) -- 用户代码
    ,trandt varchar2(8) -- 总账日期（总账入账日期）
    ,transq varchar2(20) -- 总账流水（总账入账流水）
    ,toitem varchar2(20) -- 对方科目
    ,assis0 varchar2(30) -- 辅助核算0（自定义）
    ,assis1 varchar2(30) -- 辅助核算1（自定义）
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
    ,itemna varchar2(60) -- 科目名称
    ,prcsna varchar2(60) -- 交易码名称
    ,strkst varchar2(1) -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt varchar2(8) -- 被冲正业务交易日期
    ,strksq varchar2(50) -- 被冲正业务交易流水
    ,crcysd varchar2(3) -- 本位币
    ,traneq number(21,2) -- 折算金额（本位币）
    ,taxbst varchar2(1) -- 日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
    ,trannm number -- 交易笔数
    ,transt varchar2(1) -- 处理状态（1：已处理0：未处理）
    ,bsnssq varchar2(33) -- 全局流水号
    ,dealmg varchar2(100) -- 价税分离错误信息
    ,bathid varchar2(64) -- 批次号
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
grant select on ${iol_schema}.tgls_txi_vchr_h to ${iml_schema};
grant select on ${iol_schema}.tgls_txi_vchr_h to ${icl_schema};
grant select on ${iol_schema}.tgls_txi_vchr_h to ${idl_schema};
grant select on ${iol_schema}.tgls_txi_vchr_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_txi_vchr_h is '价税分离传票接口历史表';
comment on column ${iol_schema}.tgls_txi_vchr_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_txi_vchr_h.sourst is '源系统标识';
comment on column ${iol_schema}.tgls_txi_vchr_h.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_txi_vchr_h.soursq is '源系统流水号';
comment on column ${iol_schema}.tgls_txi_vchr_h.vchrsq is '传票序号';
comment on column ${iol_schema}.tgls_txi_vchr_h.tranbr is '交易机构';
comment on column ${iol_schema}.tgls_txi_vchr_h.acctbr is '账务机构';
comment on column ${iol_schema}.tgls_txi_vchr_h.itemcd is '科目代码';
comment on column ${iol_schema}.tgls_txi_vchr_h.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_txi_vchr_h.centcd is '责任中心';
comment on column ${iol_schema}.tgls_txi_vchr_h.prsncd is '职员';
comment on column ${iol_schema}.tgls_txi_vchr_h.custcd is '客户';
comment on column ${iol_schema}.tgls_txi_vchr_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_txi_vchr_h.prlncd is '产品线';
comment on column ${iol_schema}.tgls_txi_vchr_h.acctno is '账户';
comment on column ${iol_schema}.tgls_txi_vchr_h.trantp is '交易类型';
comment on column ${iol_schema}.tgls_txi_vchr_h.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_txi_vchr_h.tranam is '交易金额';
comment on column ${iol_schema}.tgls_txi_vchr_h.smrytx is '摘要';
comment on column ${iol_schema}.tgls_txi_vchr_h.exchcn is '中间价';
comment on column ${iol_schema}.tgls_txi_vchr_h.exchus is '折算率';
comment on column ${iol_schema}.tgls_txi_vchr_h.usercd is '用户代码';
comment on column ${iol_schema}.tgls_txi_vchr_h.trandt is '总账日期（总账入账日期）';
comment on column ${iol_schema}.tgls_txi_vchr_h.transq is '总账流水（总账入账流水）';
comment on column ${iol_schema}.tgls_txi_vchr_h.toitem is '对方科目';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_txi_vchr_h.dealst is '处理状态(0：未处理1:成功2：失败3：价税分离后合并流水成功5：不处理6：已回执)';
comment on column ${iol_schema}.tgls_txi_vchr_h.prcscd is '交易码';
comment on column ${iol_schema}.tgls_txi_vchr_h.itemna is '科目名称';
comment on column ${iol_schema}.tgls_txi_vchr_h.prcsna is '交易码名称';
comment on column ${iol_schema}.tgls_txi_vchr_h.strkst is '冲正标识（0：正常业务1：冲正业务）';
comment on column ${iol_schema}.tgls_txi_vchr_h.strkdt is '被冲正业务交易日期';
comment on column ${iol_schema}.tgls_txi_vchr_h.strksq is '被冲正业务交易流水';
comment on column ${iol_schema}.tgls_txi_vchr_h.crcysd is '本位币';
comment on column ${iol_schema}.tgls_txi_vchr_h.traneq is '折算金额（本位币）';
comment on column ${iol_schema}.tgls_txi_vchr_h.taxbst is '日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)';
comment on column ${iol_schema}.tgls_txi_vchr_h.trannm is '交易笔数';
comment on column ${iol_schema}.tgls_txi_vchr_h.transt is '处理状态（1：已处理0：未处理）';
comment on column ${iol_schema}.tgls_txi_vchr_h.bsnssq is '全局流水号';
comment on column ${iol_schema}.tgls_txi_vchr_h.dealmg is '价税分离错误信息';
comment on column ${iol_schema}.tgls_txi_vchr_h.bathid is '批次号';
comment on column ${iol_schema}.tgls_txi_vchr_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_txi_vchr_h.etl_timestamp is 'ETL处理时间戳';
