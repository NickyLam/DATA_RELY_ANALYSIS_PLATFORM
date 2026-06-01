/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_wdftpmx_xy_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_wdftpmx_xy_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_wdftpmx_xy_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_wdftpmx_xy_recal(
    tjrq number(22) -- 统计日期
    ,khjgh varchar2(300) -- 开户机构号
    ,khjgmc varchar2(300) -- 开户机构名称
    ,jjh varchar2(300) -- 借据号
    ,cpbh varchar2(300) -- 产品编号
    ,cpejfl varchar2(300) -- 产品二级分类
    ,cpsjfl varchar2(300) -- 产品四级分类
    ,cpsijfl varchar2(300) -- 产品四级分类
    ,cpzwmc varchar2(300) -- 产品中文名称
    ,bz varchar2(300) -- 币种
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,nrj number(25,4) -- 年日均
    ,ylx number(25,4) -- 月利息
    ,nlx number(25,4) -- 年利息
    ,ftpjg number(25,4) -- FTP价格
    ,dyftpzycb number(25,4) -- 当月FTP转移成本
    ,ljftpzycb number(25,4) -- 累计FTP转移成本
    ,dyftpjsy number(25,4) -- 当月FTP净收益
    ,ljftpjsy number(25,4) -- 累计FTP净收益
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,xwdkbs varchar2(300) -- 小微贷款标识
    ,zhbs varchar2(300) -- 账户标识
    ,khm varchar2(300) -- 客户名
    ,khh varchar2(300) -- 客户号
    ,bzdm varchar2(30) -- 币种代码
    ,khjldh varchar2(150) -- 客户经理工号
    ,ssjgdh varchar2(150) -- 所属机构代号
    ,fpbl number(15,4) -- 分配比例
    ,fptx varchar2(30) -- 分配条线
    ,rlx number(25,4) -- 日利息
    ,drftpzycb number(25,4) -- 当日FTP转移成本
    ,drftpjsy number(25,4) -- 当日FTP净收益
    ,jrj number(25,4) -- 季日均
    ,jlx number(25,4) -- 季利息
    ,djftpzycb number(25,4) -- 当季FTP转移成本
    ,djftpjsy number(25,4) -- 当季FTP净收益
    ,dbgsbh varchar2(300) -- 担保公司编号
    ,dbmc varchar2(300) -- 担保名称
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_wdftpmx_xy_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_wdftpmx_xy_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_wdftpmx_xy_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_wdftpmx_xy_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_wdftpmx_xy_recal is '网络存款_重算';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.khjgh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.jjh is '借据号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.cpbh is '产品编号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.cpzwmc is '产品中文名称';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.ylx is '月利息';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.nlx is '年利息';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.ftpjg is 'FTP价格';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.dyftpzycb is '当月FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.ljftpzycb is '累计FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.dyftpjsy is '当月FTP净收益';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.ljftpjsy is '累计FTP净收益';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.xwdkbs is '小微贷款标识';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.khm is '客户名';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.bzdm is '币种代码';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.khjldh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.ssjgdh is '所属机构代号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.fptx is '分配条线';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.rlx is '日利息';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.drftpzycb is '当日FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.drftpjsy is '当日FTP净收益';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.jlx is '季利息';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.djftpzycb is '当季FTP转移成本';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.djftpjsy is '当季FTP净收益';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.dbgsbh is '担保公司编号';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.dbmc is '担保名称';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_wdftpmx_xy_recal.etl_timestamp is 'ETL处理时间戳';
