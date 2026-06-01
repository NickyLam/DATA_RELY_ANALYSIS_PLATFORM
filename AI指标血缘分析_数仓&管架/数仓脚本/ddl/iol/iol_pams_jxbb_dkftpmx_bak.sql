/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_dkftpmx_bak
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_dkftpmx_bak
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_dkftpmx_bak purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dkftpmx_bak(
    tjrq number(22,0) -- 
    ,khm varchar2(200) -- 
    ,khh varchar2(100) -- 
    ,khjgkhdxdh number(22,0) -- 
    ,khjgh varchar2(100) -- 
    ,khjgmc varchar2(100) -- 
    ,ssjgkhdxdh number(22,0) -- 
    ,ssjgh varchar2(100) -- 
    ,ssjgmc varchar2(100) -- 
    ,khjlgh varchar2(100) -- 
    ,khjlxm varchar2(100) -- 
    ,fpbl number(19,5) -- 
    ,zhbs varchar2(100) -- 
    ,xwdkbs varchar2(100) -- 
    ,jjh varchar2(100) -- 
    ,jjzt varchar2(100) -- 
    ,dqzxll number(38,8) -- 
    ,jzll number(38,8) -- 
    ,fdbl number(25,4) -- 
    ,fdfs varchar2(100) -- 
    ,kmh varchar2(100) -- 
    ,kmmc varchar2(100) -- 
    ,cpbh varchar2(100) -- 
    ,cpejfl varchar2(100) -- 
    ,cpsjfl varchar2(100) -- 
    ,cpsijfl varchar2(100) -- 
    ,cpzwmc varchar2(100) -- 
    ,sfxw varchar2(100) -- 
    ,qx varchar2(100) -- 
    ,fkr number(22,0) -- 
    ,dqr number(22,0) -- 
    ,bz varchar2(100) -- 
    ,ye number(25,4) -- 
    ,yrj number(25,4) -- 
    ,nrj number(25,4) -- 
    ,ylx number(25,4) -- 
    ,nlx number(25,4) -- 
    ,ftpjg number(25,4) -- 
    ,dyftpzycb number(25,4) -- 
    ,ljftpzycb number(25,4) -- 
    ,dyftpjsy number(25,4) -- 
    ,ljftpjsy number(25,4) -- 
    ,ftplxsr number(25,4) -- 
    ,ftpzycb number(25,4) -- 
    ,ftpsy number(25,4) -- 
    ,lxkm varchar2(50) -- 
    ,lxkmmc varchar2(100) -- 
    ,pjh varchar2(40) -- 
    ,wjfl varchar2(5) -- 
    ,yqxyss number(26,5) -- 
    ,fxjqzcje number(25,4) -- 风险加权资产金额
    ,bzdm varchar2(10) -- 币种码值
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
grant select on ${iol_schema}.pams_jxbb_dkftpmx_bak to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_bak to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_bak to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_dkftpmx_bak to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_dkftpmx_bak is '客户贷款ftp结果表_重算';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.tjrq is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.khm is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.khh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.khjgkhdxdh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.khjgh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.khjgmc is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ssjgkhdxdh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ssjgh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ssjgmc is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.khjlgh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.khjlxm is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.fpbl is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.zhbs is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.xwdkbs is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.jjh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.jjzt is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.dqzxll is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.jzll is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.fdbl is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.fdfs is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.kmh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.kmmc is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.cpbh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.cpejfl is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.cpsjfl is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.cpsijfl is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.cpzwmc is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.sfxw is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.qx is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.fkr is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.dqr is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.bz is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ye is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.yrj is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.nrj is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ylx is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.nlx is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ftpjg is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.dyftpzycb is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ljftpzycb is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.dyftpjsy is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ljftpjsy is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ftplxsr is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ftpzycb is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.ftpsy is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.lxkm is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.lxkmmc is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.pjh is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.wjfl is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.yqxyss is '';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.fxjqzcje is '风险加权资产金额';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.jlx is '季利息';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.djftpzycb is '当季ftp转移成本';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.djftpjsy is '当季ftp净收益';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_dkftpmx_bak.etl_timestamp is 'ETL处理时间戳';
