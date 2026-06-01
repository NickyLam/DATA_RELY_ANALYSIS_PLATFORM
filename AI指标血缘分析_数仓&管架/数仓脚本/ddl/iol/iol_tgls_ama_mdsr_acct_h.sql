/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ama_mdsr_acct_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ama_mdsr_acct_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ama_mdsr_acct_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ama_mdsr_acct_h(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 来源系统编号
    ,datadt varchar2(8) -- 数据日期
    ,transq varchar2(50) -- 交易流水
    ,trancd varchar2(20) -- 子交易
    ,bathid varchar2(50) -- 批次号
    ,loanno varchar2(100) -- 单据编号
    ,busitp varchar2(50) -- 业务类型
    ,prducd varchar2(12) -- 产品编号
    ,bfprducd varchar2(12) -- 调整前产品编号
    ,deptcd varchar2(12) -- 账务机构编号
    ,bfdeptcd varchar2(12) -- 调整前账务机构编号
    ,crcycd varchar2(3) -- 币种
    ,lnctno varchar2(30) -- 合同编号
    ,descpt varchar2(240) -- 业务说明
    ,custcd varchar2(16) -- 客户编号
    ,custna varchar2(200) -- 客户名称
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
    ,amotrbdt varchar2(8) -- 摊销开始日期
    ,amotrodt varchar2(8) -- 摊销结束日期
    ,acamotrbdt varchar2(8) -- 实际摊销开始日期
    ,normpr number(20,2) -- 待摊总金额
    ,amortam number(20,2) -- 本次摊销金额
    ,amortisedam number(20,2) -- 累计摊销金额
    ,amortamredu number(20,2) -- 剩余摊销金额
    ,daynum number -- 摊销天数
    ,amorfr varchar2(30) -- 摊销频度
    ,amortst varchar2(1) -- 摊销状态[n:未摊销,i:摊销中,s:摊销完成]
    ,amou01 number(20,2) -- 金额01
    ,amou02 number(20,2) -- 金额02
    ,amou03 number(20,2) -- 金额03
    ,amou04 number(20,2) -- 金额04
    ,amou05 number(20,2) -- 金额05
    ,amou06 number(20,2) -- 金额06
    ,amou07 number(20,2) -- 金额07
    ,attra1 varchar2(150) -- 附加属性1
    ,attra2 varchar2(150) -- 附加属性2
    ,attra3 varchar2(150) -- 附加属性3
    ,attra4 varchar2(150) -- 附加属性4
    ,attra5 varchar2(150) -- 附加属性5
    ,attra6 varchar2(150) -- 附加属性6
    ,attra7 varchar2(150) -- 附加属性7
    ,attra8 number(19,0) -- 附加属性8
    ,attra9 varchar2(150) -- 附加属性9
    ,attraa varchar2(150) -- 附加属性10
    ,puprtg varchar2(2) -- 客户类型
    ,islast varchar2(1) -- 是否交易场景的最后一条，1-是，0-否
    ,eventp varchar2(20) -- 交易场景
    ,tranti timestamp -- 时间
    ,chrgmd varchar2(10) -- 收费方式
    ,changst varchar2(1) -- 是否需要重新计算本次摊销金额（每次摊销金额）默认yn:不需要y:需要
    ,oridatadt varchar2(8) -- 原表数据日期
    ,remark varchar2(64) -- 历史备份说明
    ,tranbr varchar2(12) -- 交易机构编号
    ,bsnssq varchar2(33) -- 全局流水号
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
grant select on ${iol_schema}.tgls_ama_mdsr_acct_h to ${iml_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acct_h to ${icl_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acct_h to ${idl_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acct_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ama_mdsr_acct_h is '中收计量后分户余额历史表';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.transq is '交易流水';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.trancd is '子交易';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.bathid is '批次号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.loanno is '单据编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.bfprducd is '调整前产品编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.deptcd is '账务机构编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.bfdeptcd is '调整前账务机构编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.crcycd is '币种';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.lnctno is '合同编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.descpt is '业务说明';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.custcd is '客户编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.custna is '客户名称';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amotrbdt is '摊销开始日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amotrodt is '摊销结束日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.acamotrbdt is '实际摊销开始日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.normpr is '待摊总金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amortam is '本次摊销金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amortisedam is '累计摊销金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amortamredu is '剩余摊销金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.daynum is '摊销天数';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amortst is '摊销状态[n:未摊销,i:摊销中,s:摊销完成]';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.islast is '是否交易场景的最后一条，1-是，0-否';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.eventp is '交易场景';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.tranti is '时间';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.chrgmd is '收费方式';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.changst is '是否需要重新计算本次摊销金额（每次摊销金额）默认yn:不需要y:需要';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.oridatadt is '原表数据日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.remark is '历史备份说明';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.bsnssq is '全局流水号';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acct_h.etl_timestamp is 'ETL处理时间戳';
