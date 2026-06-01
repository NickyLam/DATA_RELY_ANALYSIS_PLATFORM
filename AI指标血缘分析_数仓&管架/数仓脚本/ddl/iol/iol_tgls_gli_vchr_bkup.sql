/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gli_vchr_bkup
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gli_vchr_bkup
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gli_vchr_bkup purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gli_vchr_bkup(
    stacid number(19) -- 账套标记
    ,trandt varchar2(8) -- 总账日期（总账入账日期）
    ,transq varchar2(20) -- 总账流水（总账入账流水）
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
    ,exchus number(11,7) -- 折算率
    ,usercd varchar2(20) -- 用户代码
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(64) -- 源系统流水号
    ,sourst varchar2(4) -- 源系统标识
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
    ,dealst varchar2(1) -- 处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
    ,prcscd varchar2(20) -- 交易码
    ,itemna varchar2(200) -- 科目名称
    ,prcsna varchar2(60) -- 交易码名称
    ,strkst varchar2(1) -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt varchar2(8) -- 被冲正业务交易日期
    ,strksq varchar2(50) -- 被冲正业务交易流水
    ,crcysd varchar2(3) -- 本位币
    ,traneq number(21,2) -- 折算金额（本位币）
    ,taxbst varchar2(1) -- 日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
    ,dealmg varchar2(100) -- 价税分离错误信息
    ,opracd varchar2(20) -- 修改用户
    ,oprati timestamp -- 修改时间
    ,ordrsq number -- 序号
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
grant select on ${iol_schema}.tgls_gli_vchr_bkup to ${iml_schema};
grant select on ${iol_schema}.tgls_gli_vchr_bkup to ${icl_schema};
grant select on ${iol_schema}.tgls_gli_vchr_bkup to ${idl_schema};
grant select on ${iol_schema}.tgls_gli_vchr_bkup to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gli_vchr_bkup is '传票信息备份信息';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.trandt is '总账日期（总账入账日期）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.transq is '总账流水（总账入账流水）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.vchrsq is '传票序号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.acctno is '账户';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.trantp is '交易类型';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.exchcn is '中间价';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.exchus is '折算率';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.soursq is '源系统流水号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.sourst is '源系统标识';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.toitem is '对方科目编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.dealst is '处理状态(0：未处理1:成功2：失败5：不处理6：已回执)';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.prcscd is '交易码';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.itemna is '科目名称';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.prcsna is '交易码名称';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.strkst is '冲正标识（0：正常业务1：冲正业务）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.strkdt is '被冲正业务交易日期';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.strksq is '被冲正业务交易流水';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.crcysd is '本位币';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.traneq is '折算金额（本位币）';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.taxbst is '日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.dealmg is '价税分离错误信息';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.opracd is '修改用户';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.oprati is '修改时间';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.ordrsq is '序号';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gli_vchr_bkup.etl_timestamp is 'ETL处理时间戳';
