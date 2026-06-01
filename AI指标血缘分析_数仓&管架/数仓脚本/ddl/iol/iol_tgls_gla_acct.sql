/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_acct
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_acct(
    acctcd varchar2(40) -- 账户表唯一标识
    ,acctna varchar2(150) -- 名称
    ,systid varchar2(4) -- 系统识别号(01-总账02-核心03-财务)
    ,brchno varchar2(12) -- 核算机构编号
    ,crcycd varchar2(3) -- 币种
    ,itemcd varchar2(30) -- 核算科目编号
    ,acctcl varchar2(1) -- 账户类别(1手工账户2基准账户3专用账户)
    ,subscd varchar2(10) -- 子目号
    ,openbr varchar2(12) -- 开户机构编号
    ,opendt varchar2(8) -- 开户日期
    ,optrsq varchar2(30) -- 开户流水号
    ,lstrdt varchar2(8) -- 最后交易日期
    ,lstrsq varchar2(50) -- 最后交易流水
    ,closdt varchar2(8) -- 销户日期
    ,cltrsq varchar2(30) -- 销户流水号
    ,ioflag varchar2(1) -- 表内外标志（i表内o表外）
    ,blncdn varchar2(1) -- 联机科目余额方向
    ,onlnbl number(20,2) -- 联机余额
    ,lastdn varchar2(1) -- 上日科目余额方向
    ,lastbl number(20,2) -- 上日余额
    ,lastdt varchar2(8) -- 上日余额日期
    ,acmlbl number(20,2) -- 积数
    ,acmldt varchar2(8) -- 积数日期
    ,acctst varchar2(1) -- 账户状态(0-关闭1-正常)
    ,drhdbk varchar2(1) -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,crhdbk varchar2(1) -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,openus varchar2(20) -- 开户柜员
    ,closus varchar2(20) -- 销户柜员
    ,pmodtg varchar2(1) -- 透支标志（0：不允许，1：允许）
    ,stacid number(19) -- 账套标识
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,custcd varchar2(16) -- 客户编号
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
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tgls_gla_acct to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_acct to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_acct to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_acct is '总账账户表';
comment on column ${iol_schema}.tgls_gla_acct.acctcd is '账户表唯一标识';
comment on column ${iol_schema}.tgls_gla_acct.acctna is '名称';
comment on column ${iol_schema}.tgls_gla_acct.systid is '系统识别号(01-总账02-核心03-财务)';
comment on column ${iol_schema}.tgls_gla_acct.brchno is '核算机构编号';
comment on column ${iol_schema}.tgls_gla_acct.crcycd is '币种';
comment on column ${iol_schema}.tgls_gla_acct.itemcd is '核算科目编号';
comment on column ${iol_schema}.tgls_gla_acct.acctcl is '账户类别(1手工账户2基准账户3专用账户)';
comment on column ${iol_schema}.tgls_gla_acct.subscd is '子目号';
comment on column ${iol_schema}.tgls_gla_acct.openbr is '开户机构编号';
comment on column ${iol_schema}.tgls_gla_acct.opendt is '开户日期';
comment on column ${iol_schema}.tgls_gla_acct.optrsq is '开户流水号';
comment on column ${iol_schema}.tgls_gla_acct.lstrdt is '最后交易日期';
comment on column ${iol_schema}.tgls_gla_acct.lstrsq is '最后交易流水';
comment on column ${iol_schema}.tgls_gla_acct.closdt is '销户日期';
comment on column ${iol_schema}.tgls_gla_acct.cltrsq is '销户流水号';
comment on column ${iol_schema}.tgls_gla_acct.ioflag is '表内外标志（i表内o表外）';
comment on column ${iol_schema}.tgls_gla_acct.blncdn is '联机科目余额方向';
comment on column ${iol_schema}.tgls_gla_acct.onlnbl is '联机余额';
comment on column ${iol_schema}.tgls_gla_acct.lastdn is '上日科目余额方向';
comment on column ${iol_schema}.tgls_gla_acct.lastbl is '上日余额';
comment on column ${iol_schema}.tgls_gla_acct.lastdt is '上日余额日期';
comment on column ${iol_schema}.tgls_gla_acct.acmlbl is '积数';
comment on column ${iol_schema}.tgls_gla_acct.acmldt is '积数日期';
comment on column ${iol_schema}.tgls_gla_acct.acctst is '账户状态(0-关闭1-正常)';
comment on column ${iol_schema}.tgls_gla_acct.drhdbk is '借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)';
comment on column ${iol_schema}.tgls_gla_acct.crhdbk is '贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)';
comment on column ${iol_schema}.tgls_gla_acct.openus is '开户柜员';
comment on column ${iol_schema}.tgls_gla_acct.closus is '销户柜员';
comment on column ${iol_schema}.tgls_gla_acct.pmodtg is '透支标志（0：不允许，1：允许）';
comment on column ${iol_schema}.tgls_gla_acct.stacid is '账套标识';
comment on column ${iol_schema}.tgls_gla_acct.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_acct.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gla_acct.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gla_acct.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_acct.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gla_acct.acctno is '账户-多维';
comment on column ${iol_schema}.tgls_gla_acct.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_acct.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gla_acct.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gla_acct.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gla_acct.etl_timestamp is 'ETL处理时间戳';
