/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_ami_mdsr_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_ami_mdsr_acct
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_ami_mdsr_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_ami_mdsr_acct(
    stacid number(19) -- 账套
    ,systid varchar2(30) -- 来源系统
    ,datadt varchar2(8) -- 数据日期
    ,bathid varchar2(50) -- 批次号
    ,loanno varchar2(100) -- 单据编号
    ,busitp varchar2(50) -- 业务类型
    ,prducd varchar2(12) -- 产品编号
    ,crcycd varchar2(30) -- 币种
    ,lnctno varchar2(100) -- 合同号
    ,descpt varchar2(240) -- 业务说明
    ,deptcd varchar2(30) -- 账务机构
    ,custcd varchar2(60) -- 客户代码
    ,custna varchar2(150) -- 客户名称
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
    ,amou01 number -- 金额01
    ,amou02 number -- 金额02
    ,amou03 number -- 金额03
    ,amou04 number -- 金额04
    ,amou05 number -- 金额05
    ,amou06 number -- 金额06
    ,amou07 number -- 金额07
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
    ,puprtg varchar2(2) -- 客户类型
    ,tranti timestamp -- 时间
    ,daynum number -- 天数
    ,chrgmd varchar2(10) -- 收费方式
    ,amorfr varchar2(30) -- 摊销频度
    ,fromdt varchar2(8) -- 合同起始日yyyymmdd,收费日期
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
grant select on ${iol_schema}.tgls_ami_mdsr_acct to ${iml_schema};
grant select on ${iol_schema}.tgls_ami_mdsr_acct to ${icl_schema};
grant select on ${iol_schema}.tgls_ami_mdsr_acct to ${idl_schema};
grant select on ${iol_schema}.tgls_ami_mdsr_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_ami_mdsr_acct is '中收业务分户余额接口表';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.stacid is '账套';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.systid is '来源系统';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.datadt is '数据日期';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.bathid is '批次号';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.loanno is '单据编号';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.busitp is '业务类型';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prducd is '产品编号';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.crcycd is '币种';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.lnctno is '合同号';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.descpt is '业务说明';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.deptcd is '账务机构';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.custcd is '客户代码';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.custna is '客户名称';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp1 is '产品属性1';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp2 is '产品属性2';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp3 is '产品属性3';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp4 is '产品属性4';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp5 is '产品属性5';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp6 is '产品属性6';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp7 is '产品属性7';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp8 is '产品属性8';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodp9 is '产品属性9';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.prodpa is '产品属性10';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amotrbdt is '摊销开始日期';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amotrodt is '摊销结束日期';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.normpr is '待摊总金额';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amou01 is '金额01';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amou02 is '金额02';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amou03 is '金额03';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amou04 is '金额04';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amou05 is '金额05';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amou06 is '金额06';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amou07 is '金额07';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra1 is '附加属性1';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra2 is '附加属性2';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra3 is '附加属性3';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra4 is '附加属性4';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra5 is '附加属性5';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra6 is '附加属性6';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra7 is '附加属性7';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra8 is '附加属性8';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attra9 is '附加属性9';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.attraa is '附加属性10';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.puprtg is '客户类型';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.tranti is '时间';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.daynum is '天数';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.chrgmd is '收费方式';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.amorfr is '摊销频度';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.fromdt is '合同起始日yyyymmdd,收费日期';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_ami_mdsr_acct.etl_timestamp is 'ETL处理时间戳';
