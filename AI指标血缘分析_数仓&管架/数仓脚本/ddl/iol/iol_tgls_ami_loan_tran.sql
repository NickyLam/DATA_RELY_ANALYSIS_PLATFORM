/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ami_loan_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ami_loan_tran
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ami_loan_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ami_loan_tran(
    stacid number(19) -- 账套
    ,systid varchar2(30) -- 来源系统编号
    ,datadt varchar2(8) -- 数据日期
    ,bathid varchar2(50) -- 批次号
    ,loanno varchar2(60) -- 贷款账户编号
    ,transq varchar2(100) -- 交易流水
    ,evensq number(19) -- 交易事件序号
    ,errotg varchar2(1) -- 错误标志
    ,erromg varchar2(4000) -- 错误信息
    ,odlnno varchar2(50) -- 旧贷款账户编号
    ,crcycd varchar2(3) -- 币种
    ,busitp varchar2(50) -- 业务类型
    ,prducd varchar2(12) -- 产品编号
    ,deptcd varchar2(30) -- 贷款网点
    ,flowno varchar2(100) -- 柜员流水
    ,trandt varchar2(8) -- 交易日期
    ,tranbr varchar2(12) -- 交易机构编号
    ,accrtg varchar2(1) -- 应计标识
    ,status varchar2(4) -- 贷款状态,01-正常，02-结清，03-核销
    ,eventp varchar2(30) -- 交易场景
    ,evencd varchar2(30) -- 交易码
    ,normpr number -- 正常本金
    ,ovdupr number -- 逾期本金
    ,dullpr number -- 呆滞本金
    ,reacin number -- 应收应计利息
    ,coacin number -- 催收应计利息
    ,recede number -- 应收欠息
    ,collde number -- 催收欠息
    ,reacpe number -- 应收应计罚息
    ,coacpe number -- 催收应计罚息
    ,recepe number -- 应收罚息
    ,collpe number -- 催收罚息
    ,accoin number -- 应计复息
    ,compin number -- 复息
    ,accuso number -- 应计贴息
    ,receso number -- 应收贴息
    ,prepin number -- 待摊利息
    ,veripr number(20,2) -- 核销本金
    ,veriin number(20,2) -- 核销利息
    ,income number -- 利息收入
    ,overin number -- 催收贴息
    ,hvvein number -- 已核销本金利息
    ,amou01 number -- 金额01
    ,amou02 number -- 金额02
    ,amou03 number -- 金额03
    ,amou04 number -- 金额04
    ,amou05 number -- 金额05
    ,amou06 number -- 金额06
    ,amou07 number -- 金额07
    ,prodp1 varchar2(30) -- 产品属性1
    ,prodp2 varchar2(30) -- 产品属性2
    ,prodp3 varchar2(30) -- 产品属性3
    ,prodp4 varchar2(30) -- 产品属性4
    ,prodp5 varchar2(30) -- 产品属性5
    ,prodp6 varchar2(30) -- 产品属性6
    ,prodp7 varchar2(30) -- 产品属性7
    ,prodp8 varchar2(30) -- 产品属性8
    ,prodp9 varchar2(30) -- 产品属性9
    ,prodpa varchar2(30) -- 产品属性10
    ,attra1 varchar2(6) -- 渠道编号
    ,attra2 varchar2(150) -- 附加属性2
    ,attra3 varchar2(150) -- 附加属性3
    ,attra4 varchar2(150) -- 附加属性4
    ,attra5 varchar2(150) -- 附加属性5
    ,attra6 varchar2(150) -- 附加属性6
    ,attra7 varchar2(150) -- 附加属性7
    ,attra8 varchar2(150) -- 附加属性8
    ,attra9 varchar2(150) -- 附加属性9
    ,attraa varchar2(150) -- 附加属性10
    ,netrsq varchar2(100) -- 新交易流水
    ,tranti timestamp -- 时间
    ,dealtg varchar2(1) -- 处理状态，‘a’-待处理，1-成功，2-失败
    ,evetdn varchar2(30) -- 交易方向
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
grant select on ${iol_schema}.tgls_ami_loan_tran to ${iml_schema};
grant select on ${iol_schema}.tgls_ami_loan_tran to ${icl_schema};
grant select on ${iol_schema}.tgls_ami_loan_tran to ${idl_schema};
grant select on ${iol_schema}.tgls_ami_loan_tran to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ami_loan_tran is '贷款交易明细接口表';
comment on column ${iol_schema}.tgls_ami_loan_tran.stacid is '账套';
comment on column ${iol_schema}.tgls_ami_loan_tran.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ami_loan_tran.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ami_loan_tran.bathid is '批次号';
comment on column ${iol_schema}.tgls_ami_loan_tran.loanno is '贷款账户编号';
comment on column ${iol_schema}.tgls_ami_loan_tran.transq is '交易流水';
comment on column ${iol_schema}.tgls_ami_loan_tran.evensq is '交易事件序号';
comment on column ${iol_schema}.tgls_ami_loan_tran.errotg is '错误标志';
comment on column ${iol_schema}.tgls_ami_loan_tran.erromg is '错误信息';
comment on column ${iol_schema}.tgls_ami_loan_tran.odlnno is '旧贷款账户编号';
comment on column ${iol_schema}.tgls_ami_loan_tran.crcycd is '币种';
comment on column ${iol_schema}.tgls_ami_loan_tran.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ami_loan_tran.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ami_loan_tran.deptcd is '贷款网点';
comment on column ${iol_schema}.tgls_ami_loan_tran.flowno is '柜员流水';
comment on column ${iol_schema}.tgls_ami_loan_tran.trandt is '交易日期';
comment on column ${iol_schema}.tgls_ami_loan_tran.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_ami_loan_tran.accrtg is '应计标识';
comment on column ${iol_schema}.tgls_ami_loan_tran.status is '贷款状态,01-正常，02-结清，03-核销';
comment on column ${iol_schema}.tgls_ami_loan_tran.eventp is '交易场景';
comment on column ${iol_schema}.tgls_ami_loan_tran.evencd is '交易码';
comment on column ${iol_schema}.tgls_ami_loan_tran.normpr is '正常本金';
comment on column ${iol_schema}.tgls_ami_loan_tran.ovdupr is '逾期本金';
comment on column ${iol_schema}.tgls_ami_loan_tran.dullpr is '呆滞本金';
comment on column ${iol_schema}.tgls_ami_loan_tran.reacin is '应收应计利息';
comment on column ${iol_schema}.tgls_ami_loan_tran.coacin is '催收应计利息';
comment on column ${iol_schema}.tgls_ami_loan_tran.recede is '应收欠息';
comment on column ${iol_schema}.tgls_ami_loan_tran.collde is '催收欠息';
comment on column ${iol_schema}.tgls_ami_loan_tran.reacpe is '应收应计罚息';
comment on column ${iol_schema}.tgls_ami_loan_tran.coacpe is '催收应计罚息';
comment on column ${iol_schema}.tgls_ami_loan_tran.recepe is '应收罚息';
comment on column ${iol_schema}.tgls_ami_loan_tran.collpe is '催收罚息';
comment on column ${iol_schema}.tgls_ami_loan_tran.accoin is '应计复息';
comment on column ${iol_schema}.tgls_ami_loan_tran.compin is '复息';
comment on column ${iol_schema}.tgls_ami_loan_tran.accuso is '应计贴息';
comment on column ${iol_schema}.tgls_ami_loan_tran.receso is '应收贴息';
comment on column ${iol_schema}.tgls_ami_loan_tran.prepin is '待摊利息';
comment on column ${iol_schema}.tgls_ami_loan_tran.veripr is '核销本金';
comment on column ${iol_schema}.tgls_ami_loan_tran.veriin is '核销利息';
comment on column ${iol_schema}.tgls_ami_loan_tran.income is '利息收入';
comment on column ${iol_schema}.tgls_ami_loan_tran.overin is '催收贴息';
comment on column ${iol_schema}.tgls_ami_loan_tran.hvvein is '已核销本金利息';
comment on column ${iol_schema}.tgls_ami_loan_tran.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ami_loan_tran.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ami_loan_tran.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ami_loan_tran.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ami_loan_tran.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ami_loan_tran.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ami_loan_tran.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ami_loan_tran.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra1 is '渠道编号';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ami_loan_tran.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ami_loan_tran.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ami_loan_tran.netrsq is '新交易流水';
comment on column ${iol_schema}.tgls_ami_loan_tran.tranti is '时间';
comment on column ${iol_schema}.tgls_ami_loan_tran.dealtg is '处理状态，‘a’-待处理，1-成功，2-失败';
comment on column ${iol_schema}.tgls_ami_loan_tran.evetdn is '交易方向';
comment on column ${iol_schema}.tgls_ami_loan_tran.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ami_loan_tran.etl_timestamp is 'ETL处理时间戳';
