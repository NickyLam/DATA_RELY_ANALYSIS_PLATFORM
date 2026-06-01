/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ama_mdsr_acch_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ama_mdsr_acch_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ama_mdsr_acch_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ama_mdsr_acch_h(
    stacid number(2) -- 账套标记
    ,systid varchar2(60) -- 来源系统编号
    ,datadt varchar2(16) -- 数据日期
    ,transq varchar2(100) -- 交易流水
    ,trancd varchar2(40) -- 子交易
    ,bathid varchar2(100) -- 批次号
    ,loanno varchar2(200) -- 单据编号
    ,busitp varchar2(100) -- 业务类型
    ,prducd varchar2(24) -- 产品编号
    ,bfprducd varchar2(24) -- 调整前产品
    ,deptcd varchar2(24) -- 账务机构编号
    ,bfdeptcd varchar2(24) -- 调整前账务机构
    ,crcycd varchar2(6) -- 币种
    ,lnctno varchar2(60) -- 合同编号
    ,descpt varchar2(480) -- 业务说明
    ,custcd varchar2(32) -- 客户编号
    ,custna varchar2(400) -- 客户名称
    ,prodp1 varchar2(60) -- 产品属性1
    ,prodp2 varchar2(60) -- 产品属性2
    ,prodp3 varchar2(60) -- 产品属性3
    ,prodp4 varchar2(60) -- 产品属性4
    ,prodp5 varchar2(60) -- 产品属性5
    ,prodp6 varchar2(60) -- 产品属性6
    ,prodp7 varchar2(60) -- 产品属性7
    ,prodp8 varchar2(60) -- 产品属性8
    ,prodp9 varchar2(60) -- 产品属性9
    ,prodpa varchar2(60) -- 产品属性10
    ,amotrbdt varchar2(16) -- 摊销开始日期
    ,amotrodt varchar2(16) -- 摊销结束日期
    ,acamotrbdt varchar2(16) -- 实际摊销开始日期
    ,normpr number(20,2) -- 待摊总金额
    ,amortam number(20,2) -- 本次摊销金额
    ,amortisedam number(20,2) -- 累计摊销金额
    ,amortst varchar2(2) -- 摊销状态
    ,amou01 number(20,2) -- 金额01
    ,amou02 number(20,2) -- 金额02
    ,amou03 number(20,2) -- 金额03
    ,amou04 number(20,2) -- 金额04
    ,amou05 number(20,2) -- 金额05
    ,amou06 number(20,2) -- 金额06
    ,amou07 number(20,2) -- 金额07
    ,attra1 varchar2(300) -- 附加属性1
    ,attra2 varchar2(300) -- 附加属性2
    ,attra3 varchar2(300) -- 附加属性3
    ,attra4 varchar2(300) -- 附加属性4
    ,attra5 varchar2(300) -- 附加属性5
    ,attra6 varchar2(300) -- 附加属性6
    ,attra7 varchar2(300) -- 附加属性7
    ,attra8 varchar2(300) -- 附加属性8
    ,attra9 varchar2(300) -- 附加属性9
    ,attraa varchar2(300) -- 附加属性10
    ,puprtg varchar2(4) -- 客户类型
    ,islast varchar2(2) -- 是否交易场景的最后一条，1-是，0-否
    ,tranti timestamp -- 时间_x0013_
    ,sortno number(21) -- 序号
    ,eventp varchar2(40) -- 交易场景
    ,bsnssq varchar2(66) -- 全局流水号
    ,tranbr varchar2(128) -- 交易机构编号
    ,amortamredu number(20,2) -- 
    ,changst varchar2(1) -- 
    ,chrgmd varchar2(10) -- 
    ,daynum number(20,2) -- 
    ,desccg varchar2(150) -- 
    ,trandt varchar2(8) -- 
    ,amorfr varchar2(30) -- 
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
grant select on ${iol_schema}.tgls_ama_mdsr_acch_h to ${iml_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acch_h to ${icl_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acch_h to ${idl_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acch_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ama_mdsr_acch_h is '中收分户余额历史表';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.transq is '交易流水';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.trancd is '子交易';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.bathid is '批次号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.loanno is '单据编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.bfprducd is '调整前产品';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.deptcd is '账务机构编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.bfdeptcd is '调整前账务机构';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.crcycd is '币种';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.lnctno is '合同编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.descpt is '业务说明';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.custcd is '客户编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.custna is '客户名称';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amotrbdt is '摊销开始日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amotrodt is '摊销结束日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.acamotrbdt is '实际摊销开始日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.normpr is '待摊总金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amortam is '本次摊销金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amortisedam is '累计摊销金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amortst is '摊销状态';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.islast is '是否交易场景的最后一条，1-是，0-否';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.tranti is '时间_x0013_';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.sortno is '序号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.eventp is '交易场景';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.bsnssq is '全局流水号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amortamredu is '';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.changst is '';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.chrgmd is '';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.daynum is '';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.desccg is '';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.trandt is '';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.amorfr is '';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch_h.etl_timestamp is 'ETL处理时间戳';
