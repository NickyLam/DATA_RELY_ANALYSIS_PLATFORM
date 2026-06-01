/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ama_mdsr_acch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ama_mdsr_acch
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ama_mdsr_acch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ama_mdsr_acch(
    stacid number(2) -- 账套
    ,systid varchar2(60) -- 来源系统编号
    ,loanno varchar2(200) -- 单据编号
    ,datadt varchar2(16) -- 数据日期
    ,trandt varchar2(16) -- 交易日期[变动日期]
    ,sortno number(21) -- 序号
    ,transq varchar2(100) -- 交易流水
    ,trancd varchar2(40) -- 子交易
    ,bathid varchar2(100) -- 批次号
    ,busitp varchar2(100) -- 业务类型
    ,prducd varchar2(24) -- 产品编号
    ,bfprducd varchar2(24) -- 调整前产品编号
    ,deptcd varchar2(24) -- 账务机构编号
    ,bfdeptcd varchar2(24) -- 调整前账务机构编号
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
    ,amortst varchar2(2) -- 摊销状态[n:未摊销,i:摊销中,s:摊销完成]
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
    ,tranti timestamp -- 时间
    ,eventp varchar2(40) -- 交易场景
    ,amortamredu number(20,2) -- 剩余摊销金额
    ,daynum number(20,2) -- 摊销天数
    ,amorfr varchar2(60) -- 摊销频度
    ,chrgmd varchar2(20) -- 收费方式
    ,changst varchar2(2) -- 是否需要重新计算 本次摊销金额（每次摊销金额） 默认y n:不需要 y:需要
    ,desccg varchar2(300) -- 分户余额变动说明
    ,bsnssq varchar2(66) -- 全局流水号
    ,tranbr varchar2(128) -- 交易机构
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
grant select on ${iol_schema}.tgls_ama_mdsr_acch to ${iml_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acch to ${icl_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acch to ${idl_schema};
grant select on ${iol_schema}.tgls_ama_mdsr_acch to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ama_mdsr_acch is '中收分户余额历史表';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.stacid is '账套';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.loanno is '单据编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.trandt is '交易日期[变动日期]';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.sortno is '序号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.transq is '交易流水';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.trancd is '子交易';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.bathid is '批次号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.bfprducd is '调整前产品编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.deptcd is '账务机构编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.bfdeptcd is '调整前账务机构编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.crcycd is '币种';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.lnctno is '合同编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.descpt is '业务说明';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.custcd is '客户编号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.custna is '客户名称';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amotrbdt is '摊销开始日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amotrodt is '摊销结束日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.acamotrbdt is '实际摊销开始日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.normpr is '待摊总金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amortam is '本次摊销金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amortisedam is '累计摊销金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amortst is '摊销状态[n:未摊销,i:摊销中,s:摊销完成]';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.islast is '是否交易场景的最后一条，1-是，0-否';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.tranti is '时间';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.eventp is '交易场景';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amortamredu is '剩余摊销金额';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.daynum is '摊销天数';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.chrgmd is '收费方式';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.changst is '是否需要重新计算 本次摊销金额（每次摊销金额） 默认y n:不需要 y:需要';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.desccg is '分户余额变动说明';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.bsnssq is '全局流水号';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.tranbr is '交易机构';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ama_mdsr_acch.etl_timestamp is 'ETL处理时间戳';
