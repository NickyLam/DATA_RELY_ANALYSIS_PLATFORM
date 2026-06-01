/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_wdftpmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_wdftpmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_wdftpmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_wdftpmx(
    tjrq number(22,0) -- 统计日期
    ,khjgh varchar2(150) -- 开户机构代号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,jjh varchar2(150) -- 借据号
    ,cpbh varchar2(150) -- 产品编号
    ,cpejfl varchar2(150) -- 产品二级分类
    ,cpsjfl varchar2(150) -- 产品三级分类
    ,cpsijfl varchar2(150) -- 产品四级分类
    ,cpzwmc varchar2(150) -- 产品中文名称
    ,bz varchar2(150) -- 币种
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,ylx number(25,4) -- 月利息
    ,nlx number(25,4) -- 年利息
    ,ftpjg number(25,4) -- ftp价格
    ,dyftpzycb number(25,4) -- 当月ftp转移成本
    ,ljftpzycb number(25,4) -- 累计ftp转移成本
    ,dyftpjsy number(25,4) -- 当月ftp净收益
    ,ljftpjsy number(25,4) -- 累计ftp净收益
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,xwdkbs varchar2(150) -- 小微贷款标识
    ,zhbs varchar2(150) -- 账户标识
    ,khm varchar2(150) -- 客户名称
    ,khh varchar2(150) -- 客户号
    ,bzdm varchar2(15) -- 币种码值
    ,khjldh varchar2(75) -- 客户经理工号
    ,ssjgdh varchar2(75) -- 所属机构号
    ,fpbl number(15,4) -- 分配比例
    ,jrj number(25,4) -- 季日均
    ,jlx number(25,4) -- 季利息
    ,djftpzycb number(25,4) -- 当季ftp转移成本
    ,djftpjsy number(25,4) -- 当季ftp净收益
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
grant select on ${iol_schema}.pams_jxbb_wdftpmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_wdftpmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_wdftpmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_wdftpmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_wdftpmx is '网络贷款明细';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.khjgh is '开户机构代号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.cpsjfl is '产品三级分类';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.cpzwmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.ftpjg is 'ftp价格';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.dyftpzycb is '当月ftp转移成本';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.ljftpzycb is '累计ftp转移成本';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.dyftpjsy is '当月ftp净收益';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.ljftpjsy is '累计ftp净收益';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.khm is '客户名称';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.khjldh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.ssjgdh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.jlx is '季利息';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.djftpzycb is '当季ftp转移成本';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.djftpjsy is '当季ftp净收益';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_wdftpmx.etl_timestamp is 'ETL处理时间戳';
