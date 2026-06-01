/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ckftpmx_bak
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ckftpmx_bak
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ckftpmx_bak purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ckftpmx_bak(
    tjrq number(22,0) -- 
    ,jxdxdh number(22,0) -- 
    ,khdxdh number(22,0) -- 
    ,zhhm varchar2(500) -- 
    ,zhdh varchar2(50) -- 
    ,zzh varchar2(50) -- 
    ,zhbs varchar2(2) -- 
    ,kh varchar2(100) -- 
    ,khh varchar2(100) -- 
    ,khjgdh varchar2(50) -- 
    ,khjgmc varchar2(100) -- 
    ,gsjgdh varchar2(50) -- 
    ,gsjgmc varchar2(100) -- 
    ,khjlgh varchar2(100) -- 
    ,khjlxm varchar2(100) -- 
    ,fpbl number(19,5) -- 
    ,kmh varchar2(50) -- 
    ,kmmc varchar2(100) -- 
    ,qxmc varchar2(100) -- 
    ,cph varchar2(50) -- 
    ,cpejfl varchar2(50) -- 
    ,cpsjfl varchar2(50) -- 
    ,cpsijfl varchar2(50) -- 
    ,cpmc varchar2(100) -- 
    ,zxll number(15,7) -- 
    ,sjll number(15,7) -- 
    ,qxrq number(22,0) -- 
    ,dqrq number(22,0) -- 
    ,xhrq number(22,0) -- 
    ,zzkzqr varchar2(20) -- 
    ,sfzy varchar2(10) -- 
    ,sfhx varchar2(200) -- 
    ,bz varchar2(30) -- 
    ,zhye number(25,4) -- 
    ,zhyrjye number(25,4) -- 
    ,zhnrjye number(25,4) -- 
    ,ftplxzcylj number(25,4) -- 
    ,ftplxzcnlj number(25,4) -- 
    ,zyjg number(25,4) -- 
    ,ftpsrylj number(25,4) -- 
    ,ftpsrnlj number(25,4) -- 
    ,ftpsyylj number(25,4) -- 
    ,ftpsynlj number(25,4) -- 
    ,zjywsr number(25,4) -- 
    ,ftplxzc number(25,4) -- 
    ,ftpsr number(25,4) -- 
    ,ftpsy number(25,4) -- 
    ,lxkm varchar2(50) -- 
    ,lxkmmc varchar2(100) -- 
    ,bzdm varchar2(10) -- 币种码值
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
grant select on ${iol_schema}.pams_jxbb_ckftpmx_bak to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx_bak to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx_bak to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ckftpmx_bak to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ckftpmx_bak is '客户存款ftp结果表_重算';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.tjrq is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.jxdxdh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.khdxdh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zhhm is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zhdh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zzh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zhbs is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.kh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.khh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.khjgdh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.khjgmc is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.gsjgdh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.gsjgmc is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.khjlgh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.khjlxm is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.fpbl is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.kmh is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.kmmc is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.qxmc is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.cph is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.cpejfl is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.cpsjfl is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.cpsijfl is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.cpmc is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zxll is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.sjll is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.qxrq is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.dqrq is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.xhrq is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zzkzqr is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.sfzy is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.sfhx is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.bz is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zhye is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zhyrjye is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zhnrjye is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftplxzcylj is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftplxzcnlj is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zyjg is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftpsrylj is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftpsrnlj is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftpsyylj is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftpsynlj is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.zjywsr is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftplxzc is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftpsr is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.ftpsy is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.lxkm is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.lxkmmc is '';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.bzdm is '币种码值';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ckftpmx_bak.etl_timestamp is 'ETL处理时间戳';
