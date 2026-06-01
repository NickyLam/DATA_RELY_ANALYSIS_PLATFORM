/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ami_loan_busi
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ami_loan_busi
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ami_loan_busi purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ami_loan_busi(
    stacid number(9) -- 账套
    ,systid varchar2(8) -- 交易系统代码
    ,trandt varchar2(16) -- 交易日期
    ,transq varchar2(128) -- 交易流水
    ,bsnssq varchar2(66) -- 业务流水号
    ,tranbr varchar2(24) -- 交易机构
    ,acctbr varchar2(24) -- 贷款机构
    ,prcscd varchar2(60) -- 处理码
    ,prodcd varchar2(24) -- 产品编号
    ,loanp1 varchar2(50) -- 产品属性1
    ,loanp2 varchar2(50) -- 产品属性2
    ,loanp3 varchar2(50) -- 产品属性3
    ,loanp4 varchar2(50) -- 产品属性4
    ,loanp5 varchar2(50) -- 产品属性5
    ,loanp6 varchar2(50) -- 产品属性6
    ,loanp7 varchar2(50) -- 产品属性7
    ,loanp8 varchar2(50) -- 产品属性8
    ,loanp9 varchar2(50) -- 产品属性9
    ,loanpa varchar2(50) -- 产品属性10
    ,trantp varchar2(18) -- 交易方式(tr:转账，cs:现金)
    ,crcycd varchar2(6) -- 币种代码
    ,custcd varchar2(60) -- 客户号
    ,status varchar2(2) -- 交易状态(0:未处理1：处理成功2：处理失败)
    ,serino varchar2(60) -- 序号
    ,bathid varchar2(100) -- 批次号
    ,evetdn varchar2(32) -- 交易方向add增加，minus减少
    ,trprcd varchar2(32) -- 余额类型
    ,tranam number(20,2) -- 交易金额
    ,centcd varchar2(32) -- 责任中心
    ,prsncd varchar2(16) -- 职员
    ,prlncd varchar2(32) -- 产品线
    ,acctno varchar2(64) -- 账户
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
    ,chrex0 varchar2(60) -- 字符串1
    ,chrex1 varchar2(60) -- 字符串2
    ,chrex2 varchar2(60) -- 字符串3
    ,chrex3 varchar2(60) -- 字符串4
    ,chrex4 varchar2(60) -- 字符串5
    ,chrex5 varchar2(60) -- 字符串6
    ,chrex6 varchar2(60) -- 字符串7
    ,chrex7 varchar2(60) -- 字符串8
    ,chrex8 varchar2(60) -- 字符串9
    ,chrex9 varchar2(60) -- 字符串10
    ,chrexa varchar2(60) -- 字符串11
    ,chrexb varchar2(60) -- 字符串12
    ,chrexc varchar2(60) -- 字符串13
    ,chrexd varchar2(60) -- 字符串14
    ,chrexe varchar2(60) -- 字符串15
    ,chrexf varchar2(60) -- 字符串16
    ,chrexg varchar2(60) -- 字符串17
    ,chrexh varchar2(60) -- 字符串18
    ,chrexi varchar2(60) -- 字符串19
    ,chrexj varchar2(60) -- 字符串20
    ,datex0 varchar2(60) -- 日期1
    ,datex1 varchar2(60) -- 日期2
    ,datex2 varchar2(60) -- 日期3
    ,datex3 varchar2(60) -- 日期4
    ,datex4 varchar2(60) -- 日期5
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
    ,strkst varchar2(2) -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt varchar2(16) -- 被冲正业务交易日期
    ,strksq varchar2(60) -- 被冲正业务交易流水
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
grant select on ${iol_schema}.tgls_ami_loan_busi to ${iml_schema};
grant select on ${iol_schema}.tgls_ami_loan_busi to ${icl_schema};
grant select on ${iol_schema}.tgls_ami_loan_busi to ${idl_schema};
grant select on ${iol_schema}.tgls_ami_loan_busi to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ami_loan_busi is '计量引擎接口对接表';
comment on column ${iol_schema}.tgls_ami_loan_busi.stacid is '账套';
comment on column ${iol_schema}.tgls_ami_loan_busi.systid is '交易系统代码';
comment on column ${iol_schema}.tgls_ami_loan_busi.trandt is '交易日期';
comment on column ${iol_schema}.tgls_ami_loan_busi.transq is '交易流水';
comment on column ${iol_schema}.tgls_ami_loan_busi.bsnssq is '业务流水号';
comment on column ${iol_schema}.tgls_ami_loan_busi.tranbr is '交易机构';
comment on column ${iol_schema}.tgls_ami_loan_busi.acctbr is '贷款机构';
comment on column ${iol_schema}.tgls_ami_loan_busi.prcscd is '处理码';
comment on column ${iol_schema}.tgls_ami_loan_busi.prodcd is '产品编号';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ami_loan_busi.loanpa is '产品属性10';
comment on column ${iol_schema}.tgls_ami_loan_busi.trantp is '交易方式(tr:转账，cs:现金)';
comment on column ${iol_schema}.tgls_ami_loan_busi.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_ami_loan_busi.custcd is '客户号';
comment on column ${iol_schema}.tgls_ami_loan_busi.status is '交易状态(0:未处理1：处理成功2：处理失败)';
comment on column ${iol_schema}.tgls_ami_loan_busi.serino is '序号';
comment on column ${iol_schema}.tgls_ami_loan_busi.bathid is '批次号';
comment on column ${iol_schema}.tgls_ami_loan_busi.evetdn is '交易方向add增加，minus减少';
comment on column ${iol_schema}.tgls_ami_loan_busi.trprcd is '余额类型';
comment on column ${iol_schema}.tgls_ami_loan_busi.tranam is '交易金额';
comment on column ${iol_schema}.tgls_ami_loan_busi.centcd is '责任中心';
comment on column ${iol_schema}.tgls_ami_loan_busi.prsncd is '职员';
comment on column ${iol_schema}.tgls_ami_loan_busi.prlncd is '产品线';
comment on column ${iol_schema}.tgls_ami_loan_busi.acctno is '账户';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_ami_loan_busi.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex0 is '金额1';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex1 is '金额2';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex2 is '金额3';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex3 is '金额4';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex4 is '金额5';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex5 is '金额6';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex6 is '金额7';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex7 is '金额8';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex8 is '金额9';
comment on column ${iol_schema}.tgls_ami_loan_busi.numex9 is '金额10';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexa is '金额11';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexb is '金额12';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexc is '金额13';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexd is '金额14';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexe is '金额15';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexf is '金额16';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexg is '金额17';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexh is '金额18';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexi is '金额19';
comment on column ${iol_schema}.tgls_ami_loan_busi.numexj is '金额20';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex0 is '字符串1';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex1 is '字符串2';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex2 is '字符串3';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex3 is '字符串4';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex4 is '字符串5';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex5 is '字符串6';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex6 is '字符串7';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex7 is '字符串8';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex8 is '字符串9';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrex9 is '字符串10';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexa is '字符串11';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexb is '字符串12';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexc is '字符串13';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexd is '字符串14';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexe is '字符串15';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexf is '字符串16';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexg is '字符串17';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexh is '字符串18';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexi is '字符串19';
comment on column ${iol_schema}.tgls_ami_loan_busi.chrexj is '字符串20';
comment on column ${iol_schema}.tgls_ami_loan_busi.datex0 is '日期1';
comment on column ${iol_schema}.tgls_ami_loan_busi.datex1 is '日期2';
comment on column ${iol_schema}.tgls_ami_loan_busi.datex2 is '日期3';
comment on column ${iol_schema}.tgls_ami_loan_busi.datex3 is '日期4';
comment on column ${iol_schema}.tgls_ami_loan_busi.datex4 is '日期5';
comment on column ${iol_schema}.tgls_ami_loan_busi.tranti is '系统时间';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume21 is '金额21';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume22 is '金额22';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume23 is '金额23';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume24 is '金额24';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume25 is '金额25';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume26 is '金额26';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume27 is '金额27';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume28 is '金额28';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume29 is '金额29';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume30 is '金额30';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume31 is '金额31';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume32 is '金额32';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume33 is '金额33';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume34 is '金额34';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume35 is '金额35';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume36 is '金额36';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume37 is '金额37';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume38 is '金额38';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume39 is '金额39';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume40 is '金额40';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume41 is '金额41';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume42 is '金额42';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume43 is '金额43';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume44 is '金额44';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume45 is '金额45';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume46 is '金额46';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume47 is '金额47';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume48 is '金额48';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume49 is '金额49';
comment on column ${iol_schema}.tgls_ami_loan_busi.nume50 is '金额50';
comment on column ${iol_schema}.tgls_ami_loan_busi.strkst is '冲正标识（0：正常业务1：冲正业务）';
comment on column ${iol_schema}.tgls_ami_loan_busi.strkdt is '被冲正业务交易日期';
comment on column ${iol_schema}.tgls_ami_loan_busi.strksq is '被冲正业务交易流水';
comment on column ${iol_schema}.tgls_ami_loan_busi.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ami_loan_busi.etl_timestamp is 'ETL处理时间戳';
