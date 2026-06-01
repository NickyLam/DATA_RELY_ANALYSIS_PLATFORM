/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_acct_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_acct_h(
    acctdt varchar2(8) -- 账户日期
    ,acctcd varchar2(40) -- 账户表唯一标识
    ,acctna varchar2(300) -- 名称
    ,systid varchar2(4) -- 系统识别号(01-总账02-核心03-财务)
    ,brchno varchar2(10) -- 核算机构
    ,crcycd varchar2(3) -- 币种
    ,itemcd varchar2(20) -- 核算科目
    ,acctcl varchar2(1) -- 账户类别(1手工账户2基准账户3专用账户)
    ,subscd varchar2(10) -- 子目号
    ,openbr varchar2(10) -- 开户机构
    ,opendt varchar2(8) -- 开户日期
    ,optrsq varchar2(20) -- 开户流水号
    ,lstrdt varchar2(8) -- 最后交易日期
    ,lstrsq varchar2(30) -- 最后交易流水
    ,closdt varchar2(8) -- 销户日期
    ,cltrsq varchar2(20) -- 销户流水号
    ,ioflag varchar2(1) -- 表内外标志（i表内o表外）
    ,blncdn varchar2(9) -- 联机余额方向(d:借方c:贷方p:付方r:收方)
    ,onlnbl number(20,2) -- 联机余额
    ,lastdn varchar2(9) -- 上日余额方向(d:借方c:贷方p:付方r:收方)
    ,lastbl number(20,2) -- 上日余额
    ,lastdt varchar2(8) -- 上日余额日期
    ,acmlbl number(20,2) -- 积数
    ,acmldt varchar2(8) -- 积数日期
    ,acctst varchar2(1) -- 账户状态(0-关闭1-正常)
    ,drhdbk varchar2(1) -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,crhdbk varchar2(1) -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,openus varchar2(20) -- 开户柜员
    ,closus varchar2(20) -- 销户柜员
    ,pmodtg varchar2(1) -- 透支标识（0：不允许，1：允许）
    ,stacid number(19) -- 账套标识
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(16) -- 职员
    ,custcd varchar2(16) -- 客户
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(30) -- 账户-多维
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
grant select on ${iol_schema}.tgls_gla_acct_h to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_acct_h to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_acct_h to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_acct_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_acct_h is '总账账户历史表';
comment on column ${iol_schema}.tgls_gla_acct_h.acctdt is '账户日期';
comment on column ${iol_schema}.tgls_gla_acct_h.acctcd is '账户表唯一标识';
comment on column ${iol_schema}.tgls_gla_acct_h.acctna is '名称';
comment on column ${iol_schema}.tgls_gla_acct_h.systid is '系统识别号(01-总账02-核心03-财务)';
comment on column ${iol_schema}.tgls_gla_acct_h.brchno is '核算机构';
comment on column ${iol_schema}.tgls_gla_acct_h.crcycd is '币种';
comment on column ${iol_schema}.tgls_gla_acct_h.itemcd is '核算科目';
comment on column ${iol_schema}.tgls_gla_acct_h.acctcl is '账户类别(1手工账户2基准账户3专用账户)';
comment on column ${iol_schema}.tgls_gla_acct_h.subscd is '子目号';
comment on column ${iol_schema}.tgls_gla_acct_h.openbr is '开户机构';
comment on column ${iol_schema}.tgls_gla_acct_h.opendt is '开户日期';
comment on column ${iol_schema}.tgls_gla_acct_h.optrsq is '开户流水号';
comment on column ${iol_schema}.tgls_gla_acct_h.lstrdt is '最后交易日期';
comment on column ${iol_schema}.tgls_gla_acct_h.lstrsq is '最后交易流水';
comment on column ${iol_schema}.tgls_gla_acct_h.closdt is '销户日期';
comment on column ${iol_schema}.tgls_gla_acct_h.cltrsq is '销户流水号';
comment on column ${iol_schema}.tgls_gla_acct_h.ioflag is '表内外标志（i表内o表外）';
comment on column ${iol_schema}.tgls_gla_acct_h.blncdn is '联机余额方向(d:借方c:贷方p:付方r:收方)';
comment on column ${iol_schema}.tgls_gla_acct_h.onlnbl is '联机余额';
comment on column ${iol_schema}.tgls_gla_acct_h.lastdn is '上日余额方向(d:借方c:贷方p:付方r:收方)';
comment on column ${iol_schema}.tgls_gla_acct_h.lastbl is '上日余额';
comment on column ${iol_schema}.tgls_gla_acct_h.lastdt is '上日余额日期';
comment on column ${iol_schema}.tgls_gla_acct_h.acmlbl is '积数';
comment on column ${iol_schema}.tgls_gla_acct_h.acmldt is '积数日期';
comment on column ${iol_schema}.tgls_gla_acct_h.acctst is '账户状态(0-关闭1-正常)';
comment on column ${iol_schema}.tgls_gla_acct_h.drhdbk is '借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)';
comment on column ${iol_schema}.tgls_gla_acct_h.crhdbk is '贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)';
comment on column ${iol_schema}.tgls_gla_acct_h.openus is '开户柜员';
comment on column ${iol_schema}.tgls_gla_acct_h.closus is '销户柜员';
comment on column ${iol_schema}.tgls_gla_acct_h.pmodtg is '透支标识（0：不允许，1：允许）';
comment on column ${iol_schema}.tgls_gla_acct_h.stacid is '账套标识';
comment on column ${iol_schema}.tgls_gla_acct_h.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_acct_h.prsncd is '职员';
comment on column ${iol_schema}.tgls_gla_acct_h.custcd is '客户';
comment on column ${iol_schema}.tgls_gla_acct_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_acct_h.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gla_acct_h.acctno is '账户-多维';
comment on column ${iol_schema}.tgls_gla_acct_h.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_acct_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_acct_h.etl_timestamp is 'ETL处理时间戳';
