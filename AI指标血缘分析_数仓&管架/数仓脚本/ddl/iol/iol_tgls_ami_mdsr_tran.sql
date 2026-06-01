/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ami_mdsr_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ami_mdsr_tran
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ami_mdsr_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ami_mdsr_tran(
    stacid number(19) -- 账套
    ,systid varchar2(30) -- 来源系统编号
    ,datadt varchar2(8) -- 数据日期
    ,bathid varchar2(50) -- 批次号
    ,loanno varchar2(100) -- 单据编号
    ,transq varchar2(100) -- 交易流水
    ,evensq number(19) -- 交易事件序号
    ,errotg varchar2(1) -- 错误标志
    ,erromg varchar2(4000) -- 错误信息
    ,crcycd varchar2(3) -- 币种
    ,busitp varchar2(50) -- 业务类型
    ,prducd varchar2(12) -- 产品编号
    ,bfprducd varchar2(30) -- 调整前产品
    ,deptcd varchar2(30) -- 财务机构
    ,bfdeptcd varchar2(12) -- 调整前账务机构编号
    ,flowno varchar2(100) -- 柜员流水
    ,trandt varchar2(8) -- 交易日期
    ,tranbr varchar2(12) -- 交易机构编号
    ,eventp varchar2(30) -- 交易场景
    ,evencd varchar2(30) -- 交易码
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
    ,normpr number -- 待摊总金额
    ,attra1 varchar2(150) -- 附加属性1
    ,attra2 varchar2(150) -- 附加属性2
    ,attra3 varchar2(150) -- 附加属性3
    ,attra4 varchar2(150) -- 附加属性4
    ,attra5 varchar2(150) -- 附加属性5
    ,attra6 varchar2(150) -- 附加属性6
    ,attra7 varchar2(150) -- 附加属性7
    ,attra8 varchar2(150) -- 附加属性8
    ,attra9 varchar2(150) -- 附加属性9
    ,attraa varchar2(150) -- 附加属性10
    ,amou01 number -- 金额01
    ,amou02 number -- 金额02
    ,amou03 number -- 金额03
    ,amou04 number -- 金额04
    ,amou05 number -- 金额05
    ,amou06 number -- 金额06
    ,amou07 number -- 金额07
    ,netrsq varchar2(100) -- 新交易流水
    ,tranti timestamp -- 时间
    ,dealtg varchar2(1) -- 处理状态，‘a’-待处理，1-成功，2-失败
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
grant select on ${iol_schema}.tgls_ami_mdsr_tran to ${iml_schema};
grant select on ${iol_schema}.tgls_ami_mdsr_tran to ${icl_schema};
grant select on ${iol_schema}.tgls_ami_mdsr_tran to ${idl_schema};
grant select on ${iol_schema}.tgls_ami_mdsr_tran to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ami_mdsr_tran is '中收业务交易明细接口表';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.stacid is '账套';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.bathid is '批次号';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.loanno is '单据编号';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.transq is '交易流水';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.evensq is '交易事件序号';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.errotg is '错误标志';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.erromg is '错误信息';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.crcycd is '币种';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.bfprducd is '调整前产品';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.deptcd is '财务机构';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.bfdeptcd is '调整前账务机构编号';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.flowno is '柜员流水';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.trandt is '交易日期';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.eventp is '交易场景';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.evencd is '交易码';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amotrbdt is '摊销开始日期';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amotrodt is '摊销结束日期';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.normpr is '待摊总金额';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.netrsq is '新交易流水';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.tranti is '时间';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.dealtg is '处理状态，‘a’-待处理，1-成功，2-失败';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.bsnssq is '全局流水号';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ami_mdsr_tran.etl_timestamp is 'ETL处理时间戳';
