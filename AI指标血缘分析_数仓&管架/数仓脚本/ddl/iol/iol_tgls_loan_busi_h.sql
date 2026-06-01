/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_loan_busi_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_loan_busi_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_loan_busi_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_loan_busi_h(
    stacid number(9) -- 账套
    ,systid varchar2(30) -- 交易来源系统编号
    ,trandt varchar2(8) -- 交易日期
    ,transq varchar2(64) -- 交易流水
    ,bsnssq varchar2(50) -- 业务流水
    ,tranbr varchar2(12) -- 交易机构编号
    ,acctbr varchar2(12) -- 贷款机构
    ,prcscd varchar2(30) -- 处理码
    ,prodcd varchar2(12) -- 产品编号
    ,loanp1 varchar2(25) -- 产品属性1
    ,loanp2 varchar2(25) -- 产品属性2
    ,loanp3 varchar2(25) -- 产品属性3
    ,loanp4 varchar2(25) -- 产品属性4
    ,loanp5 varchar2(25) -- 产品属性5
    ,loanp6 varchar2(25) -- 产品属性6
    ,loanp7 varchar2(25) -- 产品属性7
    ,loanp8 varchar2(25) -- 产品属性8
    ,loanp9 varchar2(25) -- 产品属性9
    ,loanpa varchar2(25) -- 产品属性10
    ,trantp varchar2(9) -- 交易方式(tr:转账，cs:现金)
    ,crcycd varchar2(3) -- 币种代码
    ,custcd varchar2(16) -- 客户编号
    ,status varchar2(1) -- 交易状态(0:未处理1：处理成功2：处理失败3：差错处理中4：差错处理完成)
    ,serino varchar2(30) -- 序号
    ,bathid varchar2(50) -- 批次号
    ,evetdn varchar2(16) -- 交易方向add增加，minus减少
    ,trprcd varchar2(16) -- 余额类型
    ,tranam number(20,2) -- 交易金额
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(64) -- 账户
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
    ,numex0 number(20,2) -- 金额1
    ,numex1 number(20,2) -- 金额2
    ,numex2 number(20,2) -- 金额3
    ,numex3 number(20,2) -- 金额4
    ,numex4 number(20,2) -- 金额5
    ,numex5 number(20,2) -- 金额6
    ,numex6 number(20,2) -- 金额7
    ,numex7 number(20,2) -- 金额8
    ,numex8 number(20,2) -- 金额9
    ,numex9 number(20,2) -- 金额10
    ,numexa number(20,2) -- 金额11
    ,numexb number(20,2) -- 金额12
    ,numexc number(20,2) -- 金额13
    ,numexd number(20,2) -- 金额14
    ,numexe number(20,2) -- 金额15
    ,numexf number(20,2) -- 金额16
    ,numexg number(20,2) -- 金额17
    ,numexh number(20,2) -- 金额18
    ,numexi number(20,2) -- 金额19
    ,numexj number(20,2) -- 金额20
    ,chrex0 varchar2(30) -- 字符串1
    ,chrex1 varchar2(30) -- 字符串2
    ,chrex2 varchar2(30) -- 字符串3
    ,chrex3 varchar2(30) -- 字符串4
    ,chrex4 varchar2(30) -- 字符串5
    ,chrex5 varchar2(30) -- 字符串6
    ,chrex6 varchar2(30) -- 字符串7
    ,chrex7 varchar2(30) -- 字符串8
    ,chrex8 varchar2(30) -- 字符串9
    ,chrex9 varchar2(30) -- 字符串10
    ,chrexa varchar2(30) -- 字符串11
    ,chrexb varchar2(30) -- 字符串12
    ,chrexc varchar2(30) -- 字符串13
    ,chrexd varchar2(30) -- 字符串14
    ,chrexe varchar2(30) -- 字符串15
    ,chrexf varchar2(30) -- 字符串16
    ,chrexg varchar2(30) -- 字符串17
    ,chrexh varchar2(30) -- 字符串18
    ,chrexi varchar2(30) -- 字符串19
    ,chrexj varchar2(30) -- 字符串20
    ,datex0 varchar2(30) -- 日期1
    ,datex1 varchar2(30) -- 日期2
    ,datex2 varchar2(30) -- 日期3
    ,datex3 varchar2(30) -- 日期4
    ,datex4 varchar2(30) -- 日期5
    ,tranti timestamp -- 系统时间
    ,nume21 number(20,2) -- 金额21
    ,nume22 number(20,2) -- 金额22
    ,nume23 number(20,2) -- 金额23
    ,nume24 number(20,2) -- 金额24
    ,nume25 number(20,2) -- 金额25
    ,nume26 number(20,2) -- 金额26
    ,nume27 number(20,2) -- 金额27
    ,nume28 number(20,2) -- 金额28
    ,nume29 number(20,2) -- 金额29
    ,nume30 number(20,2) -- 金额30
    ,nume31 number(20,2) -- 金额31
    ,nume32 number(20,2) -- 金额32
    ,nume33 number(20,2) -- 金额33
    ,nume34 number(20,2) -- 金额34
    ,nume35 number(20,2) -- 金额35
    ,nume36 number(20,2) -- 金额36
    ,nume37 number(20,2) -- 金额37
    ,nume38 number(20,2) -- 金额38
    ,nume39 number(20,2) -- 金额39
    ,nume40 number(20,2) -- 金额40
    ,nume41 number(20,2) -- 金额41
    ,nume42 number(20,2) -- 金额42
    ,nume43 number(20,2) -- 金额43
    ,nume44 number(20,2) -- 金额44
    ,nume45 number(20,2) -- 金额45
    ,nume46 number(20,2) -- 金额46
    ,nume47 number(20,2) -- 金额47
    ,nume48 number(20,2) -- 金额48
    ,nume49 number(20,2) -- 金额49
    ,nume50 number(20,2) -- 金额50
    ,strkst varchar2(1) -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt varchar2(8) -- 被冲正业务交易日期
    ,strksq varchar2(64) -- 被冲正业务交易流水
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
grant select on ${iol_schema}.tgls_loan_busi_h to ${iml_schema};
grant select on ${iol_schema}.tgls_loan_busi_h to ${icl_schema};
grant select on ${iol_schema}.tgls_loan_busi_h to ${idl_schema};
grant select on ${iol_schema}.tgls_loan_busi_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_loan_busi_h is '通用交易明细流水归集表';
comment on column ${iol_schema}.tgls_loan_busi_h.stacid is '账套';
comment on column ${iol_schema}.tgls_loan_busi_h.systid is '交易来源系统编号';
comment on column ${iol_schema}.tgls_loan_busi_h.trandt is '交易日期';
comment on column ${iol_schema}.tgls_loan_busi_h.transq is '交易流水';
comment on column ${iol_schema}.tgls_loan_busi_h.bsnssq is '业务流水';
comment on column ${iol_schema}.tgls_loan_busi_h.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_loan_busi_h.acctbr is '贷款机构';
comment on column ${iol_schema}.tgls_loan_busi_h.prcscd is '处理码';
comment on column ${iol_schema}.tgls_loan_busi_h.prodcd is '产品编号';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp1 is '产品属性1';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp2 is '产品属性2';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp3 is '产品属性3';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp4 is '产品属性4';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp5 is '产品属性5';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp6 is '产品属性6';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp7 is '产品属性7';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp8 is '产品属性8';
comment on column ${iol_schema}.tgls_loan_busi_h.loanp9 is '产品属性9';
comment on column ${iol_schema}.tgls_loan_busi_h.loanpa is '产品属性10';
comment on column ${iol_schema}.tgls_loan_busi_h.trantp is '交易方式(tr:转账，cs:现金)';
comment on column ${iol_schema}.tgls_loan_busi_h.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_loan_busi_h.custcd is '客户编号';
comment on column ${iol_schema}.tgls_loan_busi_h.status is '交易状态(0:未处理1：处理成功2：处理失败3：差错处理中4：差错处理完成)';
comment on column ${iol_schema}.tgls_loan_busi_h.serino is '序号';
comment on column ${iol_schema}.tgls_loan_busi_h.bathid is '批次号';
comment on column ${iol_schema}.tgls_loan_busi_h.evetdn is '交易方向add增加，minus减少';
comment on column ${iol_schema}.tgls_loan_busi_h.trprcd is '余额类型';
comment on column ${iol_schema}.tgls_loan_busi_h.tranam is '交易金额';
comment on column ${iol_schema}.tgls_loan_busi_h.centcd is '责任中心';
comment on column ${iol_schema}.tgls_loan_busi_h.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_loan_busi_h.prlncd is '产品线';
comment on column ${iol_schema}.tgls_loan_busi_h.acctno is '账户';
comment on column ${iol_schema}.tgls_loan_busi_h.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_loan_busi_h.numex0 is '金额1';
comment on column ${iol_schema}.tgls_loan_busi_h.numex1 is '金额2';
comment on column ${iol_schema}.tgls_loan_busi_h.numex2 is '金额3';
comment on column ${iol_schema}.tgls_loan_busi_h.numex3 is '金额4';
comment on column ${iol_schema}.tgls_loan_busi_h.numex4 is '金额5';
comment on column ${iol_schema}.tgls_loan_busi_h.numex5 is '金额6';
comment on column ${iol_schema}.tgls_loan_busi_h.numex6 is '金额7';
comment on column ${iol_schema}.tgls_loan_busi_h.numex7 is '金额8';
comment on column ${iol_schema}.tgls_loan_busi_h.numex8 is '金额9';
comment on column ${iol_schema}.tgls_loan_busi_h.numex9 is '金额10';
comment on column ${iol_schema}.tgls_loan_busi_h.numexa is '金额11';
comment on column ${iol_schema}.tgls_loan_busi_h.numexb is '金额12';
comment on column ${iol_schema}.tgls_loan_busi_h.numexc is '金额13';
comment on column ${iol_schema}.tgls_loan_busi_h.numexd is '金额14';
comment on column ${iol_schema}.tgls_loan_busi_h.numexe is '金额15';
comment on column ${iol_schema}.tgls_loan_busi_h.numexf is '金额16';
comment on column ${iol_schema}.tgls_loan_busi_h.numexg is '金额17';
comment on column ${iol_schema}.tgls_loan_busi_h.numexh is '金额18';
comment on column ${iol_schema}.tgls_loan_busi_h.numexi is '金额19';
comment on column ${iol_schema}.tgls_loan_busi_h.numexj is '金额20';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex0 is '字符串1';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex1 is '字符串2';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex2 is '字符串3';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex3 is '字符串4';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex4 is '字符串5';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex5 is '字符串6';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex6 is '字符串7';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex7 is '字符串8';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex8 is '字符串9';
comment on column ${iol_schema}.tgls_loan_busi_h.chrex9 is '字符串10';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexa is '字符串11';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexb is '字符串12';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexc is '字符串13';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexd is '字符串14';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexe is '字符串15';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexf is '字符串16';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexg is '字符串17';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexh is '字符串18';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexi is '字符串19';
comment on column ${iol_schema}.tgls_loan_busi_h.chrexj is '字符串20';
comment on column ${iol_schema}.tgls_loan_busi_h.datex0 is '日期1';
comment on column ${iol_schema}.tgls_loan_busi_h.datex1 is '日期2';
comment on column ${iol_schema}.tgls_loan_busi_h.datex2 is '日期3';
comment on column ${iol_schema}.tgls_loan_busi_h.datex3 is '日期4';
comment on column ${iol_schema}.tgls_loan_busi_h.datex4 is '日期5';
comment on column ${iol_schema}.tgls_loan_busi_h.tranti is '系统时间';
comment on column ${iol_schema}.tgls_loan_busi_h.nume21 is '金额21';
comment on column ${iol_schema}.tgls_loan_busi_h.nume22 is '金额22';
comment on column ${iol_schema}.tgls_loan_busi_h.nume23 is '金额23';
comment on column ${iol_schema}.tgls_loan_busi_h.nume24 is '金额24';
comment on column ${iol_schema}.tgls_loan_busi_h.nume25 is '金额25';
comment on column ${iol_schema}.tgls_loan_busi_h.nume26 is '金额26';
comment on column ${iol_schema}.tgls_loan_busi_h.nume27 is '金额27';
comment on column ${iol_schema}.tgls_loan_busi_h.nume28 is '金额28';
comment on column ${iol_schema}.tgls_loan_busi_h.nume29 is '金额29';
comment on column ${iol_schema}.tgls_loan_busi_h.nume30 is '金额30';
comment on column ${iol_schema}.tgls_loan_busi_h.nume31 is '金额31';
comment on column ${iol_schema}.tgls_loan_busi_h.nume32 is '金额32';
comment on column ${iol_schema}.tgls_loan_busi_h.nume33 is '金额33';
comment on column ${iol_schema}.tgls_loan_busi_h.nume34 is '金额34';
comment on column ${iol_schema}.tgls_loan_busi_h.nume35 is '金额35';
comment on column ${iol_schema}.tgls_loan_busi_h.nume36 is '金额36';
comment on column ${iol_schema}.tgls_loan_busi_h.nume37 is '金额37';
comment on column ${iol_schema}.tgls_loan_busi_h.nume38 is '金额38';
comment on column ${iol_schema}.tgls_loan_busi_h.nume39 is '金额39';
comment on column ${iol_schema}.tgls_loan_busi_h.nume40 is '金额40';
comment on column ${iol_schema}.tgls_loan_busi_h.nume41 is '金额41';
comment on column ${iol_schema}.tgls_loan_busi_h.nume42 is '金额42';
comment on column ${iol_schema}.tgls_loan_busi_h.nume43 is '金额43';
comment on column ${iol_schema}.tgls_loan_busi_h.nume44 is '金额44';
comment on column ${iol_schema}.tgls_loan_busi_h.nume45 is '金额45';
comment on column ${iol_schema}.tgls_loan_busi_h.nume46 is '金额46';
comment on column ${iol_schema}.tgls_loan_busi_h.nume47 is '金额47';
comment on column ${iol_schema}.tgls_loan_busi_h.nume48 is '金额48';
comment on column ${iol_schema}.tgls_loan_busi_h.nume49 is '金额49';
comment on column ${iol_schema}.tgls_loan_busi_h.nume50 is '金额50';
comment on column ${iol_schema}.tgls_loan_busi_h.strkst is '冲正标识（0：正常业务1：冲正业务）';
comment on column ${iol_schema}.tgls_loan_busi_h.strkdt is '被冲正业务交易日期';
comment on column ${iol_schema}.tgls_loan_busi_h.strksq is '被冲正业务交易流水';
comment on column ${iol_schema}.tgls_loan_busi_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_loan_busi_h.etl_timestamp is 'ETL处理时间戳';
